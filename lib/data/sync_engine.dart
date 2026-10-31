import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'device_db.dart';
import 'event_logger.dart';
import 'evidence_repository.dart';
import 'server/parking_service.dart';
import 'tips_service.dart';

/// Delivers the outbox and pulls server state.
///
/// Guarantees: operations are retried with the same id until the server
/// answers, so a lost response never creates a duplicate; an operation waits
/// for the one it depends on; a transient failure keeps it pending with
/// backoff; a permanent rejection is surfaced to the rider, not retried.
class SyncEngine {
  SyncEngine({
    required this.db,
    required this.service,
    required this.evidence,
    required this.log,
    required this.userId,
    this.onEvidenceUpdated,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DeviceDb db;
  final ParkingService service;
  final EvidenceRepository evidence;
  final EventLogger log;
  final String userId;
  final Future<void> Function(EvidenceSnapshot snapshot)? onEvidenceUpdated;
  final DateTime Function() _clock;

  Future<void>? _running;

  /// After a crash or kill, an operation left in flight may or may not have
  /// reached the server. Making it pending again is safe because the server
  /// deduplicates by operation id.
  Future<int> recoverInterrupted() async {
    final n = await (db.update(db.outboxOps)..where((t) => t.state.equals(OpState.inFlight)))
        .write(OutboxOpsCompanion(state: const Value(OpState.pending), nextAttemptAt: Value(_clock())));
    final queued = await (db.select(db.outboxOps)..where((t) => t.state.equals(OpState.pending))).get();
    await (db.update(db.tips)..where((t) => t.status.equals(TipStatus.sending.name)))
        .write(const TipsCompanion(status: Value('queued')));
    await log.record('outbox.recovered', attrs: {'resetInFlight': n, 'pending': queued.length});
    return n;
  }

  /// Single-flight: concurrent callers share the running pass.
  Future<void> sync() => _running ??= _run().whenComplete(() => _running = null);

  /// The rider (or reconnecting) asks to try now: skip any backoff wait.
  Future<void> retryNow() async {
    final n = await (db.update(db.outboxOps)..where((t) => t.state.equals(OpState.pending)))
        .write(OutboxOpsCompanion(nextAttemptAt: Value(_clock())));
    if (n > 0) await log.record('outbox.retry_now', attrs: {'ops': n});
    await sync();
  }

  /// Completes when no sync pass is running.
  Future<void> idle() => _running ?? Future<void>.value();

  Future<bool> hasDueWork() async {
    final due = await (db.select(db.outboxOps)
          ..where((t) => t.state.equals(OpState.pending) & t.nextAttemptAt.isSmallerOrEqualValue(_clock()))
          ..limit(1))
        .get();
    return due.isNotEmpty;
  }

  Future<void> _run() async {
    final reachable = await _drain();
    if (reachable) await _pull();
  }

  /// Returns false if the server could not be reached.
  Future<bool> _drain() async {
    while (true) {
      final due = await (db.select(db.outboxOps)
            ..where((t) => t.state.equals(OpState.pending) & t.nextAttemptAt.isSmallerOrEqualValue(_clock()))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt), (t) => OrderingTerm.asc(t.opId)]))
          .get();
      var progressed = false;
      for (final op in due) {
        final dep = op.dependsOn;
        if (dep != null) {
          final depState = await _stateOf(dep);
          if (depState == OpState.failed) {
            await _fail(op, 'A step this depends on failed');
            continue;
          }
          if (depState != OpState.done) continue;
        }
        final outcome = await _attempt(op);
        if (outcome == _Outcome.unreachable) return false;
        if (outcome == _Outcome.done) progressed = true;
      }
      if (!progressed) return true;
    }
  }

  Future<_Outcome> _attempt(OutboxOp op) async {
    final attempt = op.attempts + 1;
    await (db.update(db.outboxOps)..where((t) => t.opId.equals(op.opId)))
        .write(OutboxOpsCompanion(state: const Value(OpState.inFlight), attempts: Value(attempt)));
    if (op.kind == OpKind.submitTip) await _setTip(op.correlationId, TipStatus.sending);
    await log.record('outbox.attempt', correlationId: op.correlationId, attrs: {'opId': op.opId, 'kind': op.kind, 'attempt': attempt});
    final started = _clock();
    try {
      final payload = asJson(jsonDecode(op.payload));
      switch (op.kind) {
        case OpKind.uploadPhoto:
          final List<int> bytes;
          try {
            bytes = await File(payload['path']! as String).readAsBytes();
          } on FileSystemException catch (e) {
            await _fail(op, 'Photo file is missing (${e.message})', code: 'file_missing');
            return _Outcome.deferred;
          }
          await service.uploadPhoto(opId: op.opId, photoId: payload['photoId']! as String, bytes: Uint8List.fromList(bytes));
          await _finish(op, () async {});
          await log.record('outbox.acked', correlationId: op.correlationId,
              attrs: {'opId': op.opId, 'kind': op.kind, 'ms': _clock().difference(started).inMilliseconds});
        case OpKind.submitTip:
          final receipt = await service.submitTip(opId: op.opId, tip: TipSubmission.fromJson(payload));
          await _finish(op, () async {
            await (db.update(db.tips)..where((t) => t.id.equals(op.correlationId))).write(TipsCompanion(
                  status: Value(receipt.status.name),
                  serverVersion: Value(receipt.version),
                  failure: const Value(null),
                  updatedAt: Value(_clock()),
                ));
          });
          await log.record('outbox.acked', correlationId: op.correlationId, attrs: {
            'opId': op.opId,
            'kind': op.kind,
            'deduplicated': receipt.deduplicated,
            'ms': _clock().difference(started).inMilliseconds,
          });
        default:
          throw ValidationFailed('Unknown operation ${op.kind}');
      }
      return _Outcome.done;
    } on ServiceException catch (e) {
      if (e.retryable) {
        final wait = backoff(attempt);
        await (db.update(db.outboxOps)..where((t) => t.opId.equals(op.opId))).write(OutboxOpsCompanion(
              state: const Value(OpState.pending),
              nextAttemptAt: Value(_clock().add(wait)),
              lastError: Value(e.toString()),
            ));
        if (op.kind == OpKind.submitTip) await _setTip(op.correlationId, TipStatus.queued);
        await log.record('outbox.retry_scheduled', correlationId: op.correlationId,
            attrs: {'opId': op.opId, 'error': e.code, 'attempt': attempt, 'retryInS': wait.inSeconds});
        return e is NetworkUnavailable || e is RequestTimedOut || e is ServerUnavailable
            ? _Outcome.unreachable
            : _Outcome.deferred;
      }
      await _fail(op, e.message, code: e.code);
      return _Outcome.deferred;
    } catch (e) {
      // Unexpected error: keep the operation (and its dependents) alive.
      final wait = backoff(attempt);
      await (db.update(db.outboxOps)..where((t) => t.opId.equals(op.opId))).write(OutboxOpsCompanion(
            state: const Value(OpState.pending),
            nextAttemptAt: Value(_clock().add(wait)),
            lastError: Value('unexpected: $e'),
          ));
      if (op.kind == OpKind.submitTip) await _setTip(op.correlationId, TipStatus.queued);
      await log.record('outbox.retry_scheduled', correlationId: op.correlationId,
          attrs: {'opId': op.opId, 'error': 'unexpected', 'attempt': attempt, 'retryInS': wait.inSeconds});
      return _Outcome.deferred;
    }
  }

  /// Permanent failure: stop retrying and tell the rider why.
  Future<void> _fail(OutboxOp op, String message, {String code = 'failed'}) async {
    await db.transaction(() async {
      await (db.update(db.outboxOps)..where((t) => t.opId.equals(op.opId)))
          .write(OutboxOpsCompanion(state: const Value(OpState.failed), lastError: Value(message)));
      await (db.update(db.tips)..where((t) => t.id.equals(op.correlationId))).write(TipsCompanion(
            status: Value(TipStatus.failed.name),
            failure: Value(message),
            updatedAt: Value(_clock()),
          ));
    });
    await log.record('outbox.rejected', correlationId: op.correlationId, attrs: {'opId': op.opId, 'error': code});
  }

  Future<void> _finish(OutboxOp op, Future<void> Function() apply) => db.transaction(() async {
        await (db.update(db.outboxOps)..where((t) => t.opId.equals(op.opId)))
            .write(const OutboxOpsCompanion(state: Value(OpState.done), lastError: Value(null)));
        await apply();
      });

  Future<void> _pull() async {
    try {
      final cached = await evidence.current();
      final envelope = await service.fetchEvidence(knownVersion: cached?.snapshot.version);
      final now = _clock();
      final snapshot = envelope.snapshot;
      if (snapshot != null) {
        await evidence.save(snapshot, now);
        await log.record('evidence.updated', attrs: {'from': cached?.snapshot.version, 'to': snapshot.version});
      } else {
        await evidence.touch(now);
      }
      final latest = snapshot ?? cached?.snapshot;
      if (latest != null) {
        try {
          await onEvidenceUpdated?.call(latest);
        } catch (e) {
          await log.record('session.recheck_failed', attrs: {'error': '$e'});
        }
      }

      final open = await (db.select(db.tips)
            ..where((t) => t.status.isIn([TipStatus.received.name, TipStatus.accepted.name])))
          .get();
      if (open.isNotEmpty) {
        final states = await service.tipStates([for (final t in open) t.id]);
        for (final s in states) {
          final local = open.firstWhere((t) => t.id == s.tipId);
          if (local.status != s.status.name || local.points != s.points) {
            await (db.update(db.tips)..where((t) => t.id.equals(s.tipId))).write(TipsCompanion(
                  status: Value(s.status.name),
                  serverVersion: Value(s.version),
                  reviewNote: Value(s.reviewNote),
                  points: Value(s.points),
                  updatedAt: Value(now),
                ));
            await log.record('tip.status_changed', correlationId: s.tipId, attrs: {'from': local.status, 'to': s.status.name});
          }
        }
      }
      await db.setKv('points', '${await service.pointsBalance(userId)}');
    } on ServiceException catch (e) {
      await log.record('sync.pull_failed', attrs: {'error': e.code});
    }
  }

  Future<String?> _stateOf(String opId) async =>
      (await (db.select(db.outboxOps)..where((t) => t.opId.equals(opId))).getSingleOrNull())?.state;

  Future<void> _setTip(String tipId, TipStatus status) => (db.update(db.tips)
        ..where((t) => t.id.equals(tipId) & t.status.isIn([TipStatus.queued.name, TipStatus.sending.name])))
      .write(TipsCompanion(status: Value(status.name), updatedAt: Value(_clock())));

  static Duration backoff(int attempt) => Duration(seconds: min(60, 1 << min(attempt, 6)));
}

enum _Outcome { done, deferred, unreachable }
