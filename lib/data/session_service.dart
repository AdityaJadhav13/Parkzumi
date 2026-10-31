import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/assessment.dart';
import '../domain/engine.dart';
import '../domain/models.dart';
import '../domain/time_ist.dart';
import 'device_db.dart';
import 'event_logger.dart';
import 'ids.dart';

/// Schedules local reminders. Scheduling is local and durable; whether the
/// operating system shows them on time is a separate, weaker guarantee.
abstract interface class ReminderScheduler {
  Future<void> schedule({required int id, required DateTime at, required String title, required String body});
  Future<void> cancel(int id);
  Future<Set<int>> pendingIds();

  /// False when exact timing isn't permitted (Android 12+); reminders may be late.
  Future<bool> exactAllowed();
}

enum SessionState { active, ended, missing }

enum MissingStatus {
  searching('Still looking for it'),
  reportedTowed('I think it was towed'),
  confirmedTowed('Confirmed towed (I have proof)'),
  theftReported('Reported to police as stolen'),
  found('Found it');

  const MissingStatus(this.label);
  final String label;
}

/// One active parking session at a time, owned by the device.
class SessionService {
  SessionService({
    required this.db,
    required this.log,
    required this.reminders,
    required this.walkBackMinutes,
    this.engine = const AssessmentEngine(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DeviceDb db;
  final EventLogger log;
  final ReminderScheduler reminders;
  final Future<int> Function() walkBackMinutes;
  final AssessmentEngine engine;
  final DateTime Function() _clock;

  static const _headsUpSlot = 0;
  static const _deadlineSlot = 1;

  /// One-off "conditions changed" alert; not reconciled at launch.
  static const _alertSlot = 2;

  static int reminderId(String sessionId, int slot) => (stableHash(sessionId) % 200000) * 10 + slot;

  Stream<Session?> watchActive() => (db.select(db.sessions)
        ..where((t) => t.state.isIn([SessionState.active.name, SessionState.missing.name]))
        ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
        ..limit(1))
      .watchSingleOrNull();

  Stream<List<Session>> watchHistory() => (db.select(db.sessions)
        ..where((t) => t.state.equals(SessionState.ended.name))
        ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
        ..limit(20))
      .watch();

  Future<String> start({required Assessment assessment, required Spot spot}) async {
    final id = newId('session');
    final assessmentId = newId('assessment');
    final now = _clock();
    final a = assessment;
    await db.transaction(() async {
      final previous = await (db.select(db.sessions)..where((t) => t.state.equals(SessionState.active.name))).get();
      for (final s in previous) {
        await _cancelReminders(s.id);
        await (db.update(db.sessions)..where((t) => t.id.equals(s.id)))
            .write(SessionsCompanion(state: Value(SessionState.ended.name), endedAt: Value(now)));
      }
      await db.into(db.assessmentLog).insert(AssessmentLogCompanion.insert(
            id: assessmentId,
            spotId: spot.id,
            verdict: a.verdict.name,
            evidenceVersion: a.evidenceVersion,
            json: jsonEncode(a.toJson()),
            createdAt: now,
          ));
      await db.into(db.sessions).insert(SessionsCompanion.insert(
            id: id,
            spotId: spot.id,
            spotName: spot.name,
            lat: spot.location.lat,
            lng: spot.location.lng,
            vehicle: a.request.vehicle.name,
            startedAt: a.request.start,
            plannedEndAt: a.request.end,
            deadlineAt: a.deadline,
            deadlineReason: a.deadlineReason,
            verdict: a.verdict.name,
            headline: a.headline,
            evidenceVersion: a.evidenceVersion,
            assessmentId: assessmentId,
            state: SessionState.active.name,
          ));
    });
    await _scheduleReminders(id, spot.name, a.deadline, a.deadlineReason);
    await log.record('session.started', correlationId: id, attrs: {
      'spotId': spot.id,
      'verdict': a.verdict.name,
      'evidenceVersion': a.evidenceVersion,
      'deadline': a.deadline.toUtc().toIso8601String(),
      'assessmentId': assessmentId,
    });
    return id;
  }

  Future<void> end(String id) async {
    await _cancelReminders(id);
    await (db.update(db.sessions)..where((t) => t.id.equals(id)))
        .write(SessionsCompanion(state: Value(SessionState.ended.name), endedAt: Value(_clock())));
    await log.record('session.ended', correlationId: id);
  }

  /// "Missing", "reported towed" and "confirmed towed" stay distinct states.
  Future<void> reportMissing(String id, MissingStatus status) async {
    if (status == MissingStatus.found) {
      await (db.update(db.sessions)..where((t) => t.id.equals(id))).write(
          SessionsCompanion(state: Value(SessionState.active.name), missingStatus: Value(status.name)));
      // Reminders were cancelled while it was missing; put them back.
      final s = await (db.select(db.sessions)..where((t) => t.id.equals(id))).getSingle();
      await _scheduleReminders(s.id, s.spotName, s.deadlineAt, s.deadlineReason);
    } else {
      await _cancelReminders(id);
      await (db.update(db.sessions)..where((t) => t.id.equals(id))).write(
          SessionsCompanion(state: Value(SessionState.missing.name), missingStatus: Value(status.name)));
    }
    await log.record('session.missing_status', correlationId: id, attrs: {'status': status.name});
  }

  /// At startup: make the OS reminders match the active session exactly —
  /// nothing duplicated, nothing orphaned.
  Future<({int scheduled, int cancelled})> reconcileReminders() async {
    final active = await (db.select(db.sessions)..where((t) => t.state.equals(SessionState.active.name))).get();
    final wanted = <int>{};
    for (final s in active) {
      wanted.addAll([reminderId(s.id, _headsUpSlot), reminderId(s.id, _deadlineSlot)]);
    }
    final pending = await reminders.pendingIds();
    var cancelled = 0;
    for (final id in pending.difference(wanted)) {
      await reminders.cancel(id);
      cancelled++;
    }
    var scheduled = 0;
    for (final s in active) {
      final ids = {reminderId(s.id, _headsUpSlot), reminderId(s.id, _deadlineSlot)};
      if (!pending.containsAll(ids)) {
        scheduled += await _scheduleReminders(s.id, s.spotName, s.deadlineAt, s.deadlineReason);
      }
    }
    await log.record('reminders.reconciled', attrs: {'active': active.length, 'scheduled': scheduled, 'cancelled': cancelled});
    return (scheduled: scheduled, cancelled: cancelled);
  }

  /// Newer evidence arrived: re-check the remaining stay. Any change to the
  /// verdict or deadline — tighter (a new order) or looser (an order withdrawn)
  /// — updates the session and its reminders; tighter changes also alert.
  Future<String?> recheck(EvidenceSnapshot snapshot) async {
    final active = await (db.select(db.sessions)..where((t) => t.state.equals(SessionState.active.name))).getSingleOrNull();
    if (active == null || active.evidenceVersion >= snapshot.version) return null;
    final now = _clock();
    final start = now.isAfter(active.startedAt) ? now : active.startedAt;
    if (!active.plannedEndAt.isAfter(start)) return null;
    final a = engine.evaluate(
      AssessmentRequest(
        spotId: active.spotId,
        vehicle: VehicleClass.values.byName(active.vehicle),
        start: start,
        stay: active.plannedEndAt.difference(start),
      ),
      snapshot,
      now: now,
    );
    // A restriction already in force means "move it now", not "by your planned return".
    final deadline = a.restrictedAtStart ? now : a.deadline;
    final reason = a.restrictedAtStart ? 'Restriction in force' : a.deadlineReason;
    final tighter = deadline.isBefore(active.deadlineAt.subtract(const Duration(minutes: 1))) ||
        (a.verdict == Verdict.prohibited && active.verdict != Verdict.prohibited.name);
    final changed = tighter ||
        a.verdict.name != active.verdict ||
        deadline.difference(active.deadlineAt).abs() >= const Duration(minutes: 1);
    if (!changed) {
      await (db.update(db.sessions)..where((t) => t.id.equals(active.id)))
          .write(SessionsCompanion(evidenceVersion: Value(snapshot.version)));
      return null;
    }
    final note = a.restrictedAtStart
        ? 'Now: ${a.reason}'
        : tighter
            ? '$reason at ${formatIstTime(deadline)}: ${a.reason}'
            : 'Update: ${a.headline} — be back by ${formatIstTime(deadline)}';
    await _cancelReminders(active.id);
    await (db.update(db.sessions)..where((t) => t.id.equals(active.id))).write(SessionsCompanion(
          deadlineAt: Value(deadline),
          deadlineReason: Value(reason),
          verdict: Value(a.verdict.name),
          headline: Value(a.headline),
          changeNote: Value(note),
          evidenceVersion: Value(snapshot.version),
        ));
    await _scheduleReminders(active.id, active.spotName, deadline, reason);
    if (tighter) {
      try {
        await reminders.schedule(
          id: reminderId(active.id, _alertSlot),
          at: now.add(const Duration(seconds: 5)),
          title: 'Conditions changed at ${active.spotName}',
          body: note,
        );
      } catch (e) {
        await log.record('reminders.failed', correlationId: active.id, attrs: {'error': '$e'});
      }
    }
    await log.record('session.conditions_changed', correlationId: active.id, attrs: {
      'fromVersion': active.evidenceVersion,
      'toVersion': snapshot.version,
      'verdict': a.verdict.name,
      'direction': tighter ? 'tighter' : 'looser',
      'deadline': deadline.toUtc().toIso8601String(),
    });
    return note;
  }

  Future<int> _scheduleReminders(String sessionId, String spotName, DateTime deadline, String reason) async {
    final now = _clock();
    final walk = await walkBackMinutes();
    final headsUp = deadline.subtract(Duration(minutes: walk + 5));
    var n = 0;
    try {
      if (headsUp.isAfter(now)) {
        await reminders.schedule(
          id: reminderId(sessionId, _headsUpSlot),
          at: headsUp,
          title: 'Time to head back',
          body: '$reason at ${formatIstTime(deadline)} · $spotName · about $walk min walk',
        );
        n++;
      }
      if (deadline.isAfter(now)) {
        await reminders.schedule(
          id: reminderId(sessionId, _deadlineSlot),
          at: deadline,
          title: reason,
          body: '$spotName · ${formatIstTime(deadline)}',
        );
        n++;
      }
      await log.record('reminders.scheduled', correlationId: sessionId,
          attrs: {'count': n, 'exact': await reminders.exactAllowed()});
    } catch (e) {
      // The session is saved either way; say so instead of failing the park.
      await log.record('reminders.failed', correlationId: sessionId, attrs: {'error': '$e'});
    }
    return n;
  }

  Future<void> _cancelReminders(String sessionId) async {
    try {
      for (final slot in [_headsUpSlot, _deadlineSlot, _alertSlot]) {
        await reminders.cancel(reminderId(sessionId, slot));
      }
    } catch (e) {
      await log.record('reminders.failed', correlationId: sessionId, attrs: {'error': '$e'});
    }
  }
}
