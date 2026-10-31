import 'package:flutter_test/flutter_test.dart';
import 'package:parkzumi/data/pilot_seed.dart';
import 'package:parkzumi/data/server/parking_service.dart';
import 'package:parkzumi/data/session_service.dart';
import 'package:parkzumi/domain/assessment.dart';
import 'package:parkzumi/domain/engine.dart';
import 'package:parkzumi/domain/models.dart';
import 'package:parkzumi/domain/time_ist.dart';

import '../support/harness.dart';

void main() {
  late Harness h;
  // 31 Oct 2026, 11:30 IST — an odd date, so the east side is the parking side.
  setUp(() async => h = await Harness.open(clock: TestClock(istInstant(2026, 10, 31, 11, 30))));
  tearDown(() async => h.dispose());

  Assessment assess(Duration stay) => const AssessmentEngine().evaluate(
        AssessmentRequest(spotId: 'somani-e', vehicle: VehicleClass.twoWheeler, start: h.clock.now, stay: stay),
        pilotSeed(),
        now: h.clock.now,
      );

  Spot spot() => pilotSeed().spot('somani-e')!;

  test('a session survives a kill and reminders are reconciled without duplicates', () async {
    final a = assess(const Duration(hours: 2));
    expect(a.verdict, Verdict.conditional);
    final id = await h.sessions.start(assessment: a, spot: spot());
    expect(h.reminders.scheduled.length, 2);
    expect(h.reminders.scheduled[SessionService.reminderId(id, 0)]!.$1, istInstant(2026, 10, 31, 13, 15));

    // The OS lost one reminder and kept a stale one from an old session.
    h.reminders.scheduled.remove(SessionService.reminderId(id, 0));
    h.reminders.scheduled[424242] = (h.clock.now, 'stale');

    h = await h.killAndRelaunch();
    final active = await h.sessions.watchActive().first;
    expect(active?.id, id);

    final first = await h.sessions.reconcileReminders();
    expect(first.cancelled, 1);
    expect(h.reminders.scheduled.keys.toSet(), {SessionService.reminderId(id, 0), SessionService.reminderId(id, 1)});
    final again = await h.sessions.reconcileReminders();
    expect((again.scheduled, again.cancelled), (0, 0));
  });

  test('a temporary order published after parking moves the deadline and the reminders', () async {
    final id = await h.sessions.start(assessment: assess(const Duration(hours: 4)), spot: spot());

    await h.server.publishTemporaryOrder(
      TemporaryOrderInput(
        spotId: 'somani-e',
        summary: 'Procession: no parking 1 pm–6 pm',
        from: istInstant(2026, 10, 31, 13),
        until: istInstant(2026, 10, 31, 18),
      ),
      reviewerId: 'reviewer-1',
    );
    await h.sync.sync();

    final s = (await h.sessions.watchActive().first)!;
    expect(s.id, id);
    expect(s.deadlineAt.toUtc(), istInstant(2026, 10, 31, 13));
    expect(s.changeNote, contains('Procession'));
    expect(s.evidenceVersion, 2);
    expect(h.reminders.scheduled[SessionService.reminderId(id, 1)]!.$1, istInstant(2026, 10, 31, 13));
    expect(await h.eventTypes(), contains('session.conditions_changed'));
  });

  test('an order already in force means "move it now", and withdrawing it restores the plan', () async {
    final id = await h.sessions.start(assessment: assess(const Duration(hours: 4)), spot: spot());
    final orderVersion = await h.server.publishTemporaryOrder(
      TemporaryOrderInput(
        spotId: 'somani-e',
        summary: 'Roadworks: no parking',
        from: h.clock.now.subtract(const Duration(minutes: 5)),
        until: istInstant(2026, 10, 31, 20),
      ),
      reviewerId: 'reviewer-1',
    );
    await h.sync.sync();
    var s = (await h.sessions.watchActive().first)!;
    expect(s.verdict, Verdict.prohibited.name);
    expect(s.deadlineAt.toUtc(), h.clock.now);
    expect(s.changeNote, startsWith('Now:'));
    expect(h.reminders.scheduled.containsKey(SessionService.reminderId(id, 2)), isTrue, reason: 'alerted');

    final evidence = await h.server.currentEvidence();
    final order = evidence.rules.firstWhere((r) => r.temporary);
    expect(evidence.version, orderVersion);
    await h.server.withdrawRule(order.id, reviewerId: 'reviewer-1');
    await h.sync.sync();
    s = (await h.sessions.watchActive().first)!;
    expect(s.verdict, Verdict.conditional.name);
    expect(s.deadlineAt.toUtc(), istInstant(2026, 10, 31, 15, 30));
    expect(s.changeNote, startsWith('Update:'));
    expect(h.reminders.scheduled[SessionService.reminderId(id, 1)]!.$1.toUtc(), istInstant(2026, 10, 31, 15, 30));
  });

  test('"Found it" brings the reminders back', () async {
    final id = await h.sessions.start(assessment: assess(const Duration(hours: 1)), spot: spot());
    await h.sessions.reportMissing(id, MissingStatus.searching);
    expect(h.reminders.scheduled, isEmpty);
    await h.sessions.reportMissing(id, MissingStatus.found);
    expect(h.reminders.scheduled.keys, containsAll([SessionService.reminderId(id, 0), SessionService.reminderId(id, 1)]));
  });

  test('missing vehicle states stay distinct and stop reminders', () async {
    final id = await h.sessions.start(assessment: assess(const Duration(hours: 1)), spot: spot());
    await h.sessions.reportMissing(id, MissingStatus.reportedTowed);
    final s = (await h.sessions.watchActive().first)!;
    expect(s.state, SessionState.missing.name);
    expect(s.missingStatus, MissingStatus.reportedTowed.name);
    expect(h.reminders.scheduled, isEmpty);
  });
}
