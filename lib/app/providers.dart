import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/device_db.dart';
import '../data/evidence_repository.dart';
import '../data/pilot_seed.dart';
import '../data/server/network_conditions.dart';
import '../data/server/parking_service.dart';
import '../domain/assessment.dart';
import '../domain/models.dart';
import '../domain/photo_findings.dart';
import '../platform/companion.dart';
import '../platform/location.dart';
import 'services.dart';

final servicesProvider = Provider<AppServices>((ref) => throw UnimplementedError('Overridden in main()'));

final evidenceProvider = StreamProvider<CachedEvidence?>((ref) => ref.watch(servicesProvider).evidence.watch());

enum Role { rider, reviewer }

final roleProvider = StreamProvider<Role>(
    (ref) => ref.watch(servicesProvider).db.watchKv('role').map((v) => v == 'reviewer' ? Role.reviewer : Role.rider));

/// What the rider is planning: vehicle, arrival (null = now) and stay.
class CheckContext {
  const CheckContext({required this.vehicle, required this.stay, this.arrival});
  final VehicleClass vehicle;
  final DateTime? arrival;
  final Duration stay;

  CheckContext copyWith({VehicleClass? vehicle, Duration? stay, DateTime? arrival, bool arriveNow = false}) => CheckContext(
        vehicle: vehicle ?? this.vehicle,
        stay: stay ?? this.stay,
        arrival: arriveNow ? null : (arrival ?? this.arrival),
      );
}

class CheckContextNotifier extends Notifier<CheckContext> {
  @override
  CheckContext build() => const CheckContext(vehicle: VehicleClass.twoWheeler, stay: Duration(hours: 2));

  void set(CheckContext next) => state = next;
}

final checkContextProvider = NotifierProvider<CheckContextNotifier, CheckContext>(CheckContextNotifier.new);

/// "Now" for assessments, refreshed every 30 s so results never go stale on screen.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

class LocationNotifier extends AsyncNotifier<LocationResult> {
  @override
  Future<LocationResult> build() => ref.read(servicesProvider).location.current(request: false);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await ref.read(servicesProvider).location.current());
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, LocationResult>(LocationNotifier.new);

/// Photo findings the rider attached to a spot during this check.
class PhotoFindingsNotifier extends Notifier<Map<String, PhotoFindings>> {
  @override
  Map<String, PhotoFindings> build() => const {};

  void attach(String spotId, PhotoFindings f) => state = {...state, spotId: f};
  void clear(String spotId) => state = {...state}..remove(spotId);
}

final photoFindingsProvider = NotifierProvider<PhotoFindingsNotifier, Map<String, PhotoFindings>>(PhotoFindingsNotifier.new);

class AssessmentsView {
  const AssessmentsView({
    required this.snapshot,
    required this.fetchedAt,
    required this.byspot,
    required this.distances,
    required this.here,
    required this.inPilotArea,
  });

  final EvidenceSnapshot snapshot;
  final DateTime fetchedAt;
  final Map<String, Assessment> byspot;

  /// From the rider when inside the pilot area, otherwise from the pilot centre.
  final Map<String, double> distances;
  final Located? here;
  final bool inPilotArea;

  List<Assessment> get all => byspot.values.toList();
}

final assessmentsProvider = Provider<AssessmentsView?>((ref) {
  final cached = ref.watch(evidenceProvider).value;
  if (cached == null) return null;
  final services = ref.watch(servicesProvider);
  final ctx = ref.watch(checkContextProvider);
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  final location = ref.watch(locationProvider).value;
  final photos = ref.watch(photoFindingsProvider);
  final here = location is Located ? location : null;
  final inPilot = here != null && here.point.distanceTo(pilotCentre) < 2000;
  final origin = inPilot ? here.point : pilotCentre;
  final start = ctx.arrival ?? now;
  final snapshot = cached.snapshot;
  return AssessmentsView(
    snapshot: snapshot,
    fetchedAt: cached.fetchedAt,
    here: here,
    inPilotArea: inPilot,
    distances: {for (final s in snapshot.spots) s.id: s.location.distanceTo(origin)},
    byspot: {
      for (final s in snapshot.spots)
        s.id: services.engine.evaluate(
          AssessmentRequest(
            spotId: s.id,
            vehicle: ctx.vehicle,
            start: start,
            stay: ctx.stay,
            photo: photos[s.id],
            locationAccuracyM: inPilot ? here.accuracyM : null,
            distanceToSpotM: inPilot ? s.location.distanceTo(here.point) : null,
          ),
          snapshot,
          now: now,
          evidenceFetchedAt: cached.fetchedAt,
        ),
    },
  );
});

final tipsProvider = StreamProvider<List<Tip>>((ref) => ref.watch(servicesProvider).tips.watchTips());

final outboxProvider = StreamProvider<List<OutboxOp>>((ref) {
  final db = ref.watch(servicesProvider).db;
  return (db.select(db.outboxOps)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
});

final pointsProvider =
    StreamProvider<int>((ref) => ref.watch(servicesProvider).db.watchKv('points').map((v) => int.tryParse(v ?? '') ?? 0));

final walkBackProvider =
    StreamProvider<int>((ref) => ref.watch(servicesProvider).db.watchKv('walkBack').map((v) => int.tryParse(v ?? '') ?? 10));

final activeSessionProvider = StreamProvider<Session?>((ref) => ref.watch(servicesProvider).sessions.watchActive());

final sessionHistoryProvider = StreamProvider<List<Session>>((ref) => ref.watch(servicesProvider).sessions.watchHistory());

final eventsProvider = StreamProvider<List<EventLogData>>((ref) => ref.watch(servicesProvider).log.watch());

final networkProvider = StreamProvider<NetworkConditions>((ref) async* {
  final net = ref.watch(servicesProvider).net;
  yield net;
  yield* net.changes.map((_) => net);
});

final reviewQueueProvider = FutureProvider.autoDispose<List<ReviewItem>>((ref) => ref.watch(servicesProvider).server.reviewQueue());

final reviewedProvider = FutureProvider.autoDispose<List<ReviewItem>>((ref) => ref.watch(servicesProvider).server.recentlyReviewed());

final serverEvidenceProvider =
    FutureProvider.autoDispose<EvidenceSnapshot>((ref) => ref.watch(servicesProvider).server.currentEvidence());

final companionStatusProvider =
    FutureProvider.autoDispose<CompanionStatus>((ref) => ref.watch(servicesProvider).companion.status());

/// Which rider tab is showing; lets flows jump tabs (e.g. after "Park here").
class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void go(int index) => state = index;
}

final tabProvider = NotifierProvider<TabNotifier, int>(TabNotifier.new);

/// A place shared from Google Maps, waiting to be shown on the Check tab.
class SharedPlaceNotifier extends Notifier<SharedPlaceIntent?> {
  @override
  SharedPlaceIntent? build() => null;
  void set(SharedPlaceIntent? v) => state = v;
}

final sharedPlaceProvider = NotifierProvider<SharedPlaceNotifier, SharedPlaceIntent?>(SharedPlaceNotifier.new);

abstract final class RiderTab {
  static const check = 0;
  static const parked = 1;
  static const tips = 2;
  static const more = 3;
}
