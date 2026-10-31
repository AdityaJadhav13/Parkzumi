import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../domain/models.dart';
import '../../domain/schedule.dart';
import 'network_conditions.dart';
import 'parking_service.dart';
import 'server_db.dart';

/// An in-app stand-in for the backend, with its own database file.
///
/// Simulated: transport, auth and multi-user access. Real: idempotency by
/// operation id, the tip state machine, version checks, one reward per tip and
/// versioned evidence. Swapping in an HTTP client keeps the same interfaces.
class SimulatedServer implements ParkingService, ReviewService {
  SimulatedServer({
    required this.db,
    required this.net,
    required this.photoDir,
    required this.log,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final ServerDb db;
  final NetworkConditions net;
  final String photoDir;
  final DiagnosticsSink log;
  final DateTime Function() _clock;

  static const pointsPerAcceptedTip = 10;

  Future<void> ensureSeeded(EvidenceSnapshot seed) async {
    final existing = await (db.select(db.srvEvidence)..where((t) => t.slot.equals(0))).getSingleOrNull();
    if (existing != null) return;
    await _writeEvidence(seed, actor: 'system', action: 'evidence.seeded');
  }

  // --- Rider endpoints (subject to network conditions) -----------------------

  @override
  Future<EvidenceEnvelope> fetchEvidence({int? knownVersion}) => _rider('fetchEvidence', null, () async {
        final current = await _evidence();
        if (knownVersion != null && current.version <= knownVersion) {
          return EvidenceEnvelope(version: current.version);
        }
        return EvidenceEnvelope(version: current.version, snapshot: current);
      });

  @override
  Future<void> uploadPhoto({required String opId, required String photoId, required Uint8List bytes}) =>
      _rider('uploadPhoto', photoId, () async {
        await db.transaction(() async {
          if (await _seen(opId) != null) return;
          final existing = await (db.select(db.srvPhotos)..where((t) => t.id.equals(photoId))).getSingleOrNull();
          if (existing == null) {
            await Directory(photoDir).create(recursive: true);
            final path = p.join(photoDir, '$photoId.jpg');
            await File(path).writeAsBytes(bytes, flush: true);
            await db.into(db.srvPhotos).insert(
                SrvPhotosCompanion.insert(id: photoId, path: path, sizeBytes: bytes.length, uploadedAt: _clock()));
          }
          await _remember(opId, 'uploadPhoto', {'photoId': photoId});
        });
        await log.record('server.photo_stored', origin: 'server', correlationId: photoId, attrs: {'opId': opId, 'bytes': bytes.length});
      });

  @override
  Future<TipReceipt> submitTip({required String opId, required TipSubmission tip}) =>
      _rider('submitTip', tip.tipId, () async {
        final receipt = await db.transaction(() async {
          final seen = await _seen(opId);
          if (seen != null) return TipReceipt.fromJson(seen, deduplicated: true);

          final existing = await _tip(tip.tipId);
          if (existing != null) {
            final r = TipReceipt(tipId: existing.id, status: TipStatus.values.byName(existing.status), version: existing.version, deduplicated: true);
            await _remember(opId, 'submitTip', r.toJson());
            return r;
          }

          await _validate(tip);
          final now = _clock();
          await db.into(db.srvTips).insert(SrvTipsCompanion.insert(
                id: tip.tipId,
                spotId: tip.observation.spotId,
                authorId: tip.authorId,
                payload: jsonEncode(tip.observation.toJson()),
                photoId: Value(tip.photoId),
                status: TipStatus.received.name,
                version: 1,
                submittedAt: now,
              ));
          final r = TipReceipt(tipId: tip.tipId, status: TipStatus.received, version: 1, deduplicated: false);
          await _remember(opId, 'submitTip', r.toJson());
          await _audit(tip.authorId, 'tip.received', tip.tipId, {'opId': opId});
          return r;
        });
        await log.record(receipt.deduplicated ? 'server.duplicate_ignored' : 'server.tip_committed',
            origin: 'server', correlationId: tip.tipId, attrs: {'opId': opId});
        return receipt;
      }, losable: true);

  @override
  Future<List<TipState>> tipStates(List<String> tipIds) => _rider('tipStates', null, () async {
        if (tipIds.isEmpty) return const <TipState>[];
        final rows = await (db.select(db.srvTips)..where((t) => t.id.isIn(tipIds))).get();
        final rewards = await (db.select(db.srvRewards)..where((t) => t.tipId.isIn(tipIds))).get();
        final points = {for (final r in rewards) r.tipId: r.points};
        return [
          for (final t in rows)
            TipState(
              tipId: t.id,
              status: TipStatus.values.byName(t.status),
              version: t.version,
              reviewNote: t.reviewNote,
              points: points[t.id] ?? 0,
              reviewedAt: t.reviewedAt,
            ),
        ];
      });

  @override
  Future<int> pointsBalance(String userId) => _rider('pointsBalance', null, () async {
        final sum = db.srvRewards.points.sum();
        final q = db.selectOnly(db.srvRewards)
          ..addColumns([sum])
          ..where(db.srvRewards.userId.equals(userId));
        return (await q.getSingle()).read(sum) ?? 0;
      });

  // --- Reviewer endpoints (a different client; rider faults don't apply) -----

  @override
  Future<List<ReviewItem>> reviewQueue() async {
    final rows = await (db.select(db.srvTips)
          ..where((t) => t.status.equals(TipStatus.received.name))
          ..orderBy([(t) => OrderingTerm.asc(t.submittedAt)]))
        .get();
    return [for (final t in rows) await _reviewItem(t)];
  }

  @override
  Future<List<ReviewItem>> recentlyReviewed() async {
    final rows = await (db.select(db.srvTips)
          ..where((t) => t.status.isIn([TipStatus.accepted.name, TipStatus.rejected.name]))
          ..orderBy([(t) => OrderingTerm.desc(t.reviewedAt)])
          ..limit(20))
        .get();
    return [for (final t in rows) await _reviewItem(t)];
  }

  @override
  Future<TipState> reviewTip({
    required String tipId,
    required int expectedVersion,
    required bool accept,
    required String reviewerId,
    String? note,
  }) async {
    if (!accept && (note == null || note.trim().isEmpty)) {
      throw const ValidationFailed('Give the rider a reason when a tip isn’t accepted.');
    }
    final state = await db.transaction(() async {
      final tip = await _tip(tipId);
      if (tip == null) throw NotFound('Tip $tipId not found');
      if (tip.status != TipStatus.received.name) {
        throw StaleVersion('Already ${tip.status} by ${tip.reviewerId ?? 'another reviewer'}. Reopening is a separate action.');
      }
      if (tip.version != expectedVersion) {
        throw const StaleVersion('This tip changed since you opened it. Refresh and review again.');
      }
      final now = _clock();
      final status = accept ? TipStatus.accepted : TipStatus.rejected;
      await (db.update(db.srvTips)..where((t) => t.id.equals(tipId))).write(SrvTipsCompanion(
        status: Value(status.name),
        version: Value(tip.version + 1),
        reviewedAt: Value(now),
        reviewerId: Value(reviewerId),
        reviewNote: Value(note?.trim().isEmpty ?? true ? null : note!.trim()),
      ));
      var points = 0;
      if (accept) {
        final obs = Observation.fromJson(asJson(jsonDecode(tip.payload)));
        final reviewed = Observation(
          id: obs.id,
          spotId: obs.spotId,
          vehicle: obs.vehicle,
          eventTime: obs.eventTime,
          submittedAt: obs.submittedAt,
          stayMinutes: obs.stayMinutes,
          outcome: obs.outcome,
          leftPremises: obs.leftPremises,
          staffCheck: obs.staffCheck,
          note: obs.note,
          reviewedAt: now,
        );
        final current = await _evidence();
        await _writeEvidence(
          current.copyWith(observations: [...current.observations.where((o) => o.id != obs.id), reviewed]),
          actor: reviewerId,
          action: 'evidence.observation_added',
          target: tipId,
        );
        // Primary key on tipId: a second grant for the same tip is impossible.
        final inserted = await db.into(db.srvRewards).insert(
              SrvRewardsCompanion.insert(tipId: tipId, userId: tip.authorId, points: pointsPerAcceptedTip, grantedAt: now),
              mode: InsertMode.insertOrIgnore,
            );
        points = inserted > 0 ? pointsPerAcceptedTip : 0;
      }
      await _audit(reviewerId, accept ? 'tip.accepted' : 'tip.rejected', tipId, {'note': note});
      return TipState(tipId: tipId, status: status, version: tip.version + 1, reviewNote: note, points: points, reviewedAt: now);
    });
    await log.record('server.tip_reviewed', origin: 'server', correlationId: tipId, attrs: {'status': state.status.name});
    return state;
  }

  @override
  Future<int> publishTemporaryOrder(TemporaryOrderInput input, {required String reviewerId}) async {
    if (!input.until.isAfter(input.from)) throw const ValidationFailed('The order must end after it starts.');
    final now = _clock();
    final rule = ParkingRule(
      id: 'temp-${now.millisecondsSinceEpoch}',
      spotIds: [input.spotId],
      effect: RuleEffect.prohibits,
      summary: input.summary,
      source: EvidenceSource(
        id: 'src-temp-${now.millisecondsSinceEpoch}',
        cls: SourceClass.official,
        title: 'Temporary order entered by reviewer $reviewerId (demo data)',
        sample: true,
        issuedOn: now,
      ),
      vehicles: input.vehicles,
      schedule: Schedule.always,
      effectiveFrom: input.from,
      effectiveUntil: input.until,
      temporary: true,
      lastVerifiedAt: now,
    );
    // Read-modify-write in one transaction so a concurrent accept isn't overwritten.
    final next = await db.transaction(() async {
      final current = await _evidence();
      if (current.spot(input.spotId) == null) throw NotFound('Unknown spot ${input.spotId}');
      return _writeEvidence(current.copyWith(rules: [...current.rules, rule]),
          actor: reviewerId, action: 'evidence.temporary_order', target: rule.id);
    });
    await log.record('server.evidence_published', origin: 'server', correlationId: rule.id, attrs: {'version': next});
    return next;
  }

  @override
  Future<int> withdrawRule(String ruleId, {required String reviewerId}) async {
    final now = _clock();
    final next = await db.transaction(() async {
      final current = await _evidence();
      final rules = [
        for (final r in current.rules) r.id == ruleId ? r.copyWith(effectiveUntil: now) : r,
      ];
      return _writeEvidence(current.copyWith(rules: rules), actor: reviewerId, action: 'evidence.rule_withdrawn', target: ruleId);
    });
    await log.record('server.evidence_published', origin: 'server', correlationId: ruleId, attrs: {'version': next});
    return next;
  }

  @override
  Future<EvidenceSnapshot> currentEvidence() => _evidence();

  // --- Internals -------------------------------------------------------------

  Future<T> _rider<T>(String endpoint, String? correlationId, Future<T> Function() handler, {bool losable = false}) async {
    if (net.latency > Duration.zero) await Future<void>.delayed(net.latency);
    if (!net.online) throw const NetworkUnavailable();
    if (net.failNextRequests > 0) {
      net.update((n) => n.failNextRequests--);
      await log.record('server.unavailable', origin: 'server', correlationId: correlationId, attrs: {'endpoint': endpoint});
      throw const ServerUnavailable();
    }
    final result = await handler();
    if (losable && net.dropNextResponse) {
      net.update((n) => n.dropNextResponse = false);
      await log.record('network.response_lost', origin: 'network', correlationId: correlationId, attrs: {'endpoint': endpoint});
      throw const RequestTimedOut();
    }
    return result;
  }

  Future<void> _validate(TipSubmission tip) async {
    final o = tip.observation;
    final evidence = await _evidence();
    if (evidence.spot(o.spotId) == null) throw ValidationFailed('Unknown place ${o.spotId}');
    if (o.eventTime.isAfter(_clock().add(const Duration(minutes: 5)))) {
      throw const ValidationFailed('The visit time is in the future.');
    }
    if (o.stayMinutes < 0 || o.stayMinutes > 24 * 60) throw const ValidationFailed('Stay must be between 0 and 24 hours.');
    if ((o.note?.length ?? 0) > 280) throw const ValidationFailed('Keep the note under 280 characters.');
    final photoId = tip.photoId;
    if (photoId != null) {
      final photo = await (db.select(db.srvPhotos)..where((t) => t.id.equals(photoId))).getSingleOrNull();
      if (photo == null) throw const PreconditionPending('Photo not uploaded yet');
    }
  }

  Future<Json?> _seen(String opId) async {
    final row = await (db.select(db.srvOperations)..where((t) => t.opId.equals(opId))).getSingleOrNull();
    return row == null ? null : asJson(jsonDecode(row.resultJson));
  }

  Future<void> _remember(String opId, String kind, Json result) => db.into(db.srvOperations).insert(
      SrvOperationsCompanion.insert(opId: opId, kind: kind, resultJson: jsonEncode(result), committedAt: _clock()));

  Future<SrvTip?> _tip(String id) => (db.select(db.srvTips)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ReviewItem> _reviewItem(SrvTip t) async {
    String? photoPath;
    final photoId = t.photoId;
    if (photoId != null) {
      photoPath = (await (db.select(db.srvPhotos)..where((p) => p.id.equals(photoId))).getSingleOrNull())?.path;
    }
    return ReviewItem(
      tipId: t.id,
      version: t.version,
      status: TipStatus.values.byName(t.status),
      observation: Observation.fromJson(asJson(jsonDecode(t.payload))),
      authorId: t.authorId,
      submittedAt: t.submittedAt,
      photoPath: photoPath,
      reviewNote: t.reviewNote,
    );
  }

  Future<EvidenceSnapshot> _evidence() async {
    final row = await (db.select(db.srvEvidence)..where((t) => t.slot.equals(0))).getSingle();
    return EvidenceSnapshot.fromJson(asJson(jsonDecode(row.json)));
  }

  Future<int> _writeEvidence(EvidenceSnapshot s, {required String actor, required String action, String target = 'evidence'}) async {
    final now = _clock();
    final current = await (db.select(db.srvEvidence)..where((t) => t.slot.equals(0))).getSingleOrNull();
    final version = current == null ? s.version : current.version + 1;
    final next = s.copyWith(version: version, publishedAt: current == null ? s.publishedAt : now);
    await db.into(db.srvEvidence).insertOnConflictUpdate(
        SrvEvidenceCompanion.insert(slot: const Value(0), version: version, json: jsonEncode(next.toJson()), publishedAt: next.publishedAt));
    await _audit(actor, action, target, {'version': version});
    return version;
  }

  Future<void> _audit(String actor, String action, String target, Json details) => db.into(db.srvAudit).insert(
      SrvAuditCompanion.insert(at: _clock(), actor: actor, action: action, target: target, details: jsonEncode(details)));
}
