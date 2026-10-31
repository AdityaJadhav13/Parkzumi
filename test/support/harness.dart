import 'dart:io';

import 'package:drift/native.dart';
import 'package:parkzumi/data/device_db.dart';
import 'package:parkzumi/data/event_logger.dart';
import 'package:parkzumi/data/evidence_repository.dart';
import 'package:parkzumi/data/pilot_seed.dart';
import 'package:parkzumi/data/server/network_conditions.dart';
import 'package:parkzumi/data/server/server_db.dart';
import 'package:parkzumi/data/server/simulated_server.dart';
import 'package:parkzumi/data/session_service.dart';
import 'package:parkzumi/data/sync_engine.dart';
import 'package:parkzumi/data/tips_service.dart';
import 'package:parkzumi/domain/models.dart';

/// A controllable clock shared by the app and the simulated server.
class TestClock {
  TestClock(this.now);
  DateTime now;
  DateTime call() => now;
  void advance(Duration d) => now = now.add(d);
}

class FakeReminders implements ReminderScheduler {
  final scheduled = <int, (DateTime, String)>{};

  @override
  Future<void> schedule({required int id, required DateTime at, required String title, required String body}) async =>
      scheduled[id] = (at, title);

  @override
  Future<void> cancel(int id) async => scheduled.remove(id);

  @override
  Future<Set<int>> pendingIds() async => scheduled.keys.toSet();

  @override
  Future<bool> exactAllowed() async => true;
}

/// The app's data layer wired to file-backed databases, so a test can close
/// everything (a "kill") and open it again (a "relaunch").
class Harness {
  Harness._(this.dir, this.clock, this.net, this.reminders);

  final Directory dir;
  final TestClock clock;
  final NetworkConditions net;
  final FakeReminders reminders;
  late DeviceDb device;
  late ServerDb serverDb;
  late EventLogger log;
  late SimulatedServer server;
  late EvidenceRepository evidence;
  late TipsService tips;
  late SyncEngine sync;
  late SessionService sessions;

  static Future<Harness> open({Directory? dir, TestClock? clock, NetworkConditions? net, FakeReminders? reminders}) async {
    final h = Harness._(
      dir ?? await Directory.systemTemp.createTemp('parkzumi_test'),
      clock ?? TestClock(DateTime.utc(2026, 10, 31, 6)),
      net ?? NetworkConditions(latency: Duration.zero),
      reminders ?? FakeReminders(),
    );
    h.device = DeviceDb(NativeDatabase(File('${h.dir.path}/device.sqlite')));
    h.serverDb = ServerDb(NativeDatabase(File('${h.dir.path}/server.sqlite')));
    h.log = EventLogger(h.device, clock: h.clock.call);
    h.server = SimulatedServer(db: h.serverDb, net: h.net, photoDir: '${h.dir.path}/server_photos', log: h.log, clock: h.clock.call);
    await h.server.ensureSeeded(pilotSeed());
    h.evidence = EvidenceRepository(h.device);
    await h.evidence.ensureBundled(pilotSeed(), h.clock.now);
    h.tips = TipsService(
      db: h.device,
      log: h.log,
      photosDir: '${h.dir.path}/photos',
      authorId: 'rider-1',
      onQueued: () {},
      clock: h.clock.call,
    );
    h.sessions = SessionService(
      db: h.device,
      log: h.log,
      reminders: h.reminders,
      walkBackMinutes: () async => 10,
      clock: h.clock.call,
    );
    h.sync = SyncEngine(
      db: h.device,
      service: h.server,
      evidence: h.evidence,
      log: h.log,
      userId: 'rider-1',
      onEvidenceUpdated: h.sessions.recheck,
      clock: h.clock.call,
    );
    return h;
  }

  /// Simulates the process dying: nothing in memory survives.
  Future<Harness> killAndRelaunch() async {
    await device.close();
    await serverDb.close();
    return Harness.open(dir: dir, clock: clock, net: net, reminders: reminders);
  }

  Future<void> dispose() async {
    await device.close();
    await serverDb.close();
    await dir.delete(recursive: true);
  }

  Future<int> serverTipCount() async => (await serverDb.select(serverDb.srvTips).get()).length;
  Future<int> rewardCount() async => (await serverDb.select(serverDb.srvRewards).get()).length;
  Future<Tip> localTip(String id) => (device.select(device.tips)..where((t) => t.id.equals(id))).getSingle();
  Future<List<OutboxOp>> ops(String tipId) =>
      (device.select(device.outboxOps)..where((t) => t.correlationId.equals(tipId))).get();
  Future<List<String>> eventTypes() async => [for (final e in await device.select(device.eventLog).get()) e.type];

  TipDraft draft({String spotId = 'bank-compound', int stayMinutes = 90, String? photoPath}) => TipDraft(
        spotId: spotId,
        vehicle: VehicleClass.twoWheeler,
        eventTime: clock.now.subtract(const Duration(hours: 1)),
        stayMinutes: stayMinutes,
        outcome: TipOutcome.parkedAndRetrieved,
        leftPremises: Tri.yes,
        staffCheck: StaffCheck.none,
        photoSourcePath: photoPath,
      );

  Future<String> fakePhoto() async {
    final f = File('${dir.path}/camera_${clock.now.microsecondsSinceEpoch}.jpg');
    await f.writeAsBytes(List.filled(2048, 7));
    return f.path;
  }
}
