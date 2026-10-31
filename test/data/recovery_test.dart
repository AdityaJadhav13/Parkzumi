import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:parkzumi/data/device_db.dart';
import 'package:parkzumi/data/server/parking_service.dart';
import 'package:parkzumi/data/tips_service.dart';
import 'package:parkzumi/domain/models.dart';

import '../support/harness.dart';

void main() {
  late Harness h;

  setUp(() async => h = await Harness.open());
  tearDown(() async => h.dispose());

  test('lost acknowledgement + app kill: the retry is recognised, one tip, one reward', () async {
    h.net.dropNextResponse = true;
    final tipId = await h.tips.submit(h.draft(photoPath: await h.fakePhoto()));
    await h.sync.sync();

    // The server applied the tip, but the rider's phone never heard back.
    expect(await h.serverTipCount(), 1);
    expect((await h.localTip(tipId)).status, TipStatus.queued.name);
    final submitOp = (await h.ops(tipId)).firstWhere((o) => o.kind == OpKind.submitTip);
    expect(submitOp.state, OpState.pending);
    expect(submitOp.attempts, 1);

    // Kill the app, come back later.
    h = await h.killAndRelaunch();
    h.clock.advance(const Duration(minutes: 5));
    await h.sync.recoverInterrupted();
    await h.sync.sync();

    expect(await h.serverTipCount(), 1, reason: 'retry must not duplicate the tip');
    expect((await h.localTip(tipId)).status, TipStatus.received.name);
    expect(await h.eventTypes(), containsAll(['network.response_lost', 'server.duplicate_ignored']));

    // A reviewer accepts it; a second, stale accept is refused.
    await h.server.reviewTip(tipId: tipId, expectedVersion: 1, accept: true, reviewerId: 'reviewer-1');
    await expectLater(
      h.server.reviewTip(tipId: tipId, expectedVersion: 1, accept: true, reviewerId: 'reviewer-2'),
      throwsA(isA<StaleVersion>()),
    );
    await h.sync.sync();

    expect(await h.rewardCount(), 1, reason: 'exactly one reward per accepted tip');
    final tip = await h.localTip(tipId);
    expect(tip.status, TipStatus.accepted.name);
    expect(tip.points, 10);
    expect(await h.device.getKv('points'), '10');
    final cached = await h.evidence.current();
    expect(cached!.snapshot.version, 2);
    expect(cached.snapshot.observations.any((o) => o.id == tipId), isTrue);
  });

  test('killed mid-request: an in-flight operation is safely retried after relaunch', () async {
    final tipId = await h.tips.submit(h.draft());
    final op = (await h.ops(tipId)).single;
    // The server receives it, then the process dies before recording the answer.
    await h.server.submitTip(opId: op.opId, tip: TipSubmission.fromJson(asJson(jsonDecode(op.payload))));
    await (h.device.update(h.device.outboxOps)..where((t) => t.opId.equals(op.opId)))
        .write(const OutboxOpsCompanion(state: Value(OpState.inFlight)));

    h = await h.killAndRelaunch();
    expect(await h.sync.recoverInterrupted(), 1);
    await h.sync.sync();

    expect(await h.serverTipCount(), 1);
    expect((await h.localTip(tipId)).status, TipStatus.received.name);
  });

  test('offline: the tip waits on the phone, then sends once connected', () async {
    h.net.online = false;
    final tipId = await h.tips.submit(h.draft());
    await h.sync.sync();
    expect((await h.localTip(tipId)).status, TipStatus.queued.name);
    expect(await h.serverTipCount(), 0);
    expect(await h.eventTypes(), contains('outbox.retry_scheduled'));

    h.net.online = true;
    h.clock.advance(const Duration(minutes: 1));
    await h.sync.sync();
    expect((await h.localTip(tipId)).status, TipStatus.received.name);
    expect(await h.serverTipCount(), 1);
  });

  test('"Retry now" skips the backoff wait', () async {
    h.net.online = false;
    final tipId = await h.tips.submit(h.draft());
    for (var i = 0; i < 4; i++) {
      h.clock.advance(const Duration(minutes: 2));
      await h.sync.sync();
    }
    final op = (await h.ops(tipId)).single;
    expect(op.nextAttemptAt.isAfter(h.clock.now), isTrue, reason: 'backed off');

    h.net.online = true;
    await h.sync.sync();
    expect((await h.localTip(tipId)).status, TipStatus.queued.name, reason: 'still waiting out the backoff');
    await h.sync.retryNow();
    expect((await h.localTip(tipId)).status, TipStatus.received.name);
  });

  test('a tip waits for its photo; a failed photo upload holds the tip back', () async {
    h.net.failNextRequests = 1;
    final tipId = await h.tips.submit(h.draft(photoPath: await h.fakePhoto()));
    await h.sync.sync();
    expect(await h.serverTipCount(), 0);
    final ops = await h.ops(tipId);
    expect(ops.firstWhere((o) => o.kind == OpKind.uploadPhoto).state, OpState.pending);
    expect(ops.firstWhere((o) => o.kind == OpKind.submitTip).attempts, 0);

    h.clock.advance(const Duration(minutes: 1));
    await h.sync.sync();
    expect(await h.serverTipCount(), 1);
    final queue = await h.server.reviewQueue();
    expect(queue.single.photoPath, isNotNull);
  });

  test('an invalid tip is rejected for good and the reason is kept', () async {
    final tipId = await h.tips.submit(h.draft(stayMinutes: 2000));
    await h.sync.sync();
    final tip = await h.localTip(tipId);
    expect(tip.status, TipStatus.failed.name);
    expect(tip.failure, contains('24 hours'));
    h.clock.advance(const Duration(minutes: 10));
    await h.sync.sync();
    expect((await h.ops(tipId)).single.attempts, 1, reason: 'permanent failures are not retried');
  });

  test('a rejection needs a reason and grants no reward', () async {
    final tipId = await h.tips.submit(h.draft());
    await h.sync.sync();
    await expectLater(
      h.server.reviewTip(tipId: tipId, expectedVersion: 1, accept: false, reviewerId: 'reviewer-1'),
      throwsA(isA<ValidationFailed>()),
    );
    await h.server.reviewTip(tipId: tipId, expectedVersion: 1, accept: false, reviewerId: 'reviewer-1', note: 'Duplicate of an existing report');
    await h.sync.sync();
    expect((await h.localTip(tipId)).status, TipStatus.rejected.name);
    expect(await h.rewardCount(), 0);
  });
}
