import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show TableInfo;
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../ai/photo_interpreter.dart';
import '../data/device_db.dart';
import '../data/event_logger.dart';
import '../data/evidence_repository.dart';
import '../data/ids.dart';
import '../data/pilot_seed.dart';
import '../data/server/network_conditions.dart';
import '../data/server/server_db.dart';
import '../data/server/simulated_server.dart';
import '../data/session_service.dart';
import '../data/sync_engine.dart';
import '../data/tips_service.dart';
import '../domain/engine.dart';
import '../domain/models.dart';
import '../platform/companion.dart';
import '../platform/local_reminders.dart';
import '../platform/location.dart';

/// Composition root: every long-lived service, created once at launch.
class AppServices {
  AppServices._({
    required this.db,
    required this.serverDb,
    required this.log,
    required this.net,
    required this.server,
    required this.evidence,
    required this.tips,
    required this.sync,
    required this.sessions,
    required this.reminders,
    required this.location,
    required this.ai,
    required this.companion,
    required this.userId,
  });

  final DeviceDb db;
  final ServerDb serverDb;
  final EventLogger log;
  final NetworkConditions net;
  final SimulatedServer server;
  final EvidenceRepository evidence;
  final TipsService tips;
  final SyncEngine sync;
  final SessionService sessions;
  final LocalReminders reminders;
  final LocationService location;
  final PhotoInterpreter ai;
  final CompanionChannel companion;
  final String userId;
  final engine = const AssessmentEngine();

  static const reviewerId = 'reviewer-zumi-desk';
  static const _geminiKey = String.fromEnvironment('GEMINI_API_KEY');

  Timer? _loop;
  var _ticks = 0;

  static Future<AppServices> start() async {
    final support = await getApplicationSupportDirectory();
    final db = DeviceDb(driftDatabase(name: 'parkzumi_device'));
    // The simulated server keeps its own database file, like a separate system.
    final serverDb = ServerDb(driftDatabase(name: 'parkzumi_server'));
    final log = EventLogger(db);

    final net = NetworkConditions();
    final savedNet = await db.getKv('net');
    if (savedNet != null) net.restore(asJson(jsonDecode(savedNet)));
    net.onChanged = (n) => db.setKv('net', jsonEncode(n.toJson()));

    final server = SimulatedServer(db: serverDb, net: net, photoDir: p.join(support.path, 'server_photos'), log: log);
    final seed = pilotSeed();
    await server.ensureSeeded(seed);
    final evidence = EvidenceRepository(db);
    await evidence.ensureBundled(seed, seed.publishedAt);

    var userId = await db.getKv('userId');
    if (userId == null) {
      userId = newId('rider');
      await db.setKv('userId', userId);
    }

    final reminders = LocalReminders();
    await reminders.init();
    final sessions = SessionService(
      db: db,
      log: log,
      reminders: reminders,
      walkBackMinutes: () async => int.tryParse(await db.getKv('walkBack') ?? '') ?? 10,
    );

    late final SyncEngine sync;
    final tips = TipsService(
      db: db,
      log: log,
      photosDir: p.join(support.path, 'tip_photos'),
      authorId: userId,
      onQueued: () => unawaited(sync.sync()),
    );
    sync = SyncEngine(db: db, service: server, evidence: evidence, log: log, userId: userId, onEvidenceUpdated: sessions.recheck);

    final PhotoInterpreter ai = FaultInjectingInterpreter(
      _geminiKey.isEmpty ? const UnconfiguredPhotoInterpreter() : GeminiPhotoInterpreter(apiKey: _geminiKey),
      net,
    );

    await log.record('app.launched', attrs: {'aiConfigured': _geminiKey.isNotEmpty, 'online': net.online});
    await sync.recoverInterrupted();
    await sessions.reconcileReminders();

    return AppServices._(
      db: db,
      serverDb: serverDb,
      log: log,
      net: net,
      server: server,
      evidence: evidence,
      tips: tips,
      sync: sync,
      sessions: sessions,
      reminders: reminders,
      location: LocationService(),
      ai: ai,
      companion: CompanionChannel(),
      userId: userId,
    );
  }

  bool get aiConfigured => _geminiKey.isNotEmpty;

  /// Keeps the outbox moving while the app is open: due work every 5 s, a
  /// pull of server state every 30 s.
  void startSyncLoop() {
    _loop?.cancel();
    unawaited(sync.sync());
    _loop = Timer.periodic(const Duration(seconds: 5), (_) async {
      _ticks++;
      if (_ticks % 6 == 0 || await sync.hasDueWork()) await sync.sync();
    });
  }

  void stopSyncLoop() => _loop?.cancel();

  /// Rehearsal helper: wipes local and simulated-server state, then re-seeds.
  Future<void> resetDemo() async {
    stopSyncLoop();
    await sync.idle();
    for (final s in await (db.select(db.sessions)).get()) {
      await sessions.end(s.id);
    }
    await db.transaction(() async {
      for (final table in <TableInfo>[db.tips, db.outboxOps, db.sessions, db.assessmentLog, db.eventLog, db.evidenceCache]) {
        await db.delete(table).go();
      }
      await db.setKv('points', '0');
    });
    await serverDb.transaction(() async {
      for (final table in <TableInfo>[serverDb.srvOperations, serverDb.srvTips, serverDb.srvPhotos, serverDb.srvRewards, serverDb.srvEvidence, serverDb.srvAudit]) {
        await serverDb.delete(table).go();
      }
    });
    net.update((n) => n.restore(const {}));
    final seed = pilotSeed();
    await server.ensureSeeded(seed);
    await evidence.ensureBundled(seed, seed.publishedAt);
    await log.record('demo.reset');
    startSyncLoop();
  }
}
