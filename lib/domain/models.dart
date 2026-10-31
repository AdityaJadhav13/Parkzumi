import 'dart:math' as math;

import 'schedule.dart';

typedef Json = Map<String, Object?>;

Json asJson(Object? o) => (o! as Map).cast<String, Object?>();
List<Json> asJsonList(Object? o) => [for (final e in (o as List? ?? const [])) asJson(e)];
DateTime? parseTime(Object? o) => o == null ? null : DateTime.parse(o as String);

enum VehicleClass {
  twoWheeler('Bike / scooter', 'bike'),
  car('Car', 'car');

  const VehicleClass(this.label, this.short);
  final String label;
  final String short;
}

/// Where a piece of evidence comes from. Never collapsed into one "verified" badge.
enum SourceClass {
  official('Official'),
  operator('Operator'),
  community('Community'),
  ai('AI · unverified');

  const SourceClass(this.label);
  final String label;
}

enum ReviewStatus { reviewed, pending }

enum Tri { yes, no, unknown }

class EvidenceSource {
  const EvidenceSource({
    required this.id,
    required this.cls,
    required this.title,
    this.url,
    this.issuedOn,
    this.sample = false,
  });

  final String id;
  final SourceClass cls;
  final String title;
  final String? url;
  final DateTime? issuedOn;

  /// Demo data that has not been verified against the real world.
  final bool sample;

  Json toJson() => {
        'id': id,
        'cls': cls.name,
        'title': title,
        'url': url,
        'issuedOn': issuedOn?.toUtc().toIso8601String(),
        'sample': sample,
      };

  factory EvidenceSource.fromJson(Json j) => EvidenceSource(
        id: j['id']! as String,
        cls: SourceClass.values.byName(j['cls']! as String),
        title: j['title']! as String,
        url: j['url'] as String?,
        issuedOn: parseTime(j['issuedOn']),
        sample: j['sample'] as bool? ?? false,
      );
}

class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;

  /// Haversine distance in metres.
  double distanceTo(GeoPoint o) {
    const r = 6371000.0;
    final dLat = _rad(o.lat - lat);
    final dLng = _rad(o.lng - lng);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(lat)) * math.cos(_rad(o.lat)) * math.pow(math.sin(dLng / 2), 2);
    return 2 * r * math.asin(math.sqrt(a));
  }

  static double _rad(double d) => d * math.pi / 180;

  List<double> toJson() => [lat, lng];
  factory GeoPoint.fromJson(Object? o) {
    final l = (o! as List).cast<num>();
    return GeoPoint(l[0].toDouble(), l[1].toDouble());
  }
}

enum SpotKind {
  curbSide('Roadside'),
  premises('Premises'),
  facility('Parking facility');

  const SpotKind(this.label);
  final String label;
}

/// A place a vehicle can be left: one side of a road stretch, a compound, or a lot.
/// Each road side is its own spot so a rule never silently covers the wrong side.
class Spot {
  const Spot({
    required this.id,
    required this.name,
    required this.area,
    required this.kind,
    required this.location,
    this.line = const [],
    this.side,
    this.approximateGeometry = false,
    this.note,
  });

  final String id;
  final String name;
  final String area;
  final SpotKind kind;

  /// Entrance for premises/facilities, midpoint for a road side.
  final GeoPoint location;

  /// Kerb geometry for road sides.
  final List<GeoPoint> line;
  final String? side;
  final bool approximateGeometry;
  final String? note;

  Json toJson() => {
        'id': id,
        'name': name,
        'area': area,
        'kind': kind.name,
        'location': location.toJson(),
        'line': [for (final p in line) p.toJson()],
        'side': side,
        'approximateGeometry': approximateGeometry,
        'note': note,
      };

  factory Spot.fromJson(Json j) => Spot(
        id: j['id']! as String,
        name: j['name']! as String,
        area: j['area']! as String,
        kind: SpotKind.values.byName(j['kind']! as String),
        location: GeoPoint.fromJson(j['location']),
        line: [for (final p in (j['line'] as List? ?? const [])) GeoPoint.fromJson(p)],
        side: j['side'] as String?,
        approximateGeometry: j['approximateGeometry'] as bool? ?? false,
        note: j['note'] as String?,
      );
}

enum RuleEffect { permits, prohibits }

/// A normalised parking rule from an official order, a sign, or an operator.
class ParkingRule {
  const ParkingRule({
    required this.id,
    required this.spotIds,
    required this.effect,
    required this.summary,
    required this.source,
    required this.effectiveFrom,
    required this.lastVerifiedAt,
    this.vehicles = const {},
    this.schedule = Schedule.always,
    this.effectiveUntil,
    this.maxStayMinutes,
    this.fee,
    this.conditions = const [],
    this.temporary = false,
    this.review = ReviewStatus.reviewed,
  });

  final String id;
  final List<String> spotIds;
  final RuleEffect effect;

  /// Plain-language statement of the rule, shown as the reason.
  final String summary;
  final EvidenceSource source;

  /// Empty means all vehicle classes.
  final Set<VehicleClass> vehicles;
  final Schedule schedule;
  final DateTime effectiveFrom;
  final DateTime? effectiveUntil;
  final int? maxStayMinutes;

  /// Display text. Null means the price is unknown, never free.
  final String? fee;
  final List<String> conditions;
  final bool temporary;
  final ReviewStatus review;
  final DateTime lastVerifiedAt;

  bool appliesTo(VehicleClass v) => vehicles.isEmpty || vehicles.contains(v);

  bool inForceAt(DateTime t) =>
      !t.isBefore(effectiveFrom) && (effectiveUntil == null || t.isBefore(effectiveUntil!));

  bool activeAt(DateTime t) => inForceAt(t) && schedule.isActiveAt(t);

  Iterable<DateTime> boundaries(DateTime from, DateTime to) sync* {
    yield* schedule.boundaries(from, to);
    for (final b in [effectiveFrom, effectiveUntil]) {
      if (b != null && b.isAfter(from) && b.isBefore(to)) yield b;
    }
  }

  ParkingRule copyWith({ReviewStatus? review, DateTime? effectiveUntil}) => ParkingRule(
        id: id,
        spotIds: spotIds,
        effect: effect,
        summary: summary,
        source: source,
        effectiveFrom: effectiveFrom,
        lastVerifiedAt: lastVerifiedAt,
        vehicles: vehicles,
        schedule: schedule,
        effectiveUntil: effectiveUntil ?? this.effectiveUntil,
        maxStayMinutes: maxStayMinutes,
        fee: fee,
        conditions: conditions,
        temporary: temporary,
        review: review ?? this.review,
      );

  Json toJson() => {
        'id': id,
        'spotIds': spotIds,
        'effect': effect.name,
        'summary': summary,
        'source': source.toJson(),
        'vehicles': [for (final v in vehicles) v.name],
        'schedule': schedule.toJson(),
        'effectiveFrom': effectiveFrom.toUtc().toIso8601String(),
        'effectiveUntil': effectiveUntil?.toUtc().toIso8601String(),
        'maxStayMinutes': maxStayMinutes,
        'fee': fee,
        'conditions': conditions,
        'temporary': temporary,
        'review': review.name,
        'lastVerifiedAt': lastVerifiedAt.toUtc().toIso8601String(),
      };

  factory ParkingRule.fromJson(Json j) => ParkingRule(
        id: j['id']! as String,
        spotIds: (j['spotIds']! as List).cast<String>(),
        effect: RuleEffect.values.byName(j['effect']! as String),
        summary: j['summary']! as String,
        source: EvidenceSource.fromJson(asJson(j['source'])),
        vehicles: {for (final v in (j['vehicles'] as List? ?? const [])) VehicleClass.values.byName(v as String)},
        schedule: Schedule.fromJson(asJson(j['schedule'])),
        effectiveFrom: DateTime.parse(j['effectiveFrom']! as String),
        effectiveUntil: parseTime(j['effectiveUntil']),
        maxStayMinutes: j['maxStayMinutes'] as int?,
        fee: j['fee'] as String?,
        conditions: (j['conditions'] as List? ?? const []).cast<String>(),
        temporary: j['temporary'] as bool? ?? false,
        review: ReviewStatus.values.byName(j['review'] as String? ?? 'pending'),
        lastVerifiedAt: DateTime.parse(j['lastVerifiedAt']! as String),
      );
}

enum Eligibility {
  public('Open to the public'),
  customersOnly('Customers only'),
  guestsOnly('Guests of residents only'),
  hostApproval('Needs a host to approve you');

  const Eligibility(this.label);
  final String label;
}

/// Who may use a premises or facility, and on what terms. Absence of a policy
/// means the visitor policy is unknown — not that visitors are welcome.
class AccessPolicy {
  const AccessPolicy({
    required this.id,
    required this.spotId,
    required this.eligibility,
    required this.summary,
    required this.source,
    required this.lastVerifiedAt,
    this.vehicles = const {},
    this.openMinute,
    this.closeMinute,
    this.offsiteAllowed = Tri.unknown,
    this.fee,
    this.maxStayMinutes,
    this.review = ReviewStatus.reviewed,
  });

  final String id;
  final String spotId;
  final Eligibility eligibility;
  final String summary;
  final EvidenceSource source;

  /// Vehicles accepted. Empty means all.
  final Set<VehicleClass> vehicles;

  /// Gate hours in IST minutes; null means open around the clock.
  final int? openMinute;
  final int? closeMinute;
  final Tri offsiteAllowed;
  final String? fee;
  final int? maxStayMinutes;
  final ReviewStatus review;
  final DateTime lastVerifiedAt;

  bool accepts(VehicleClass v) => vehicles.isEmpty || vehicles.contains(v);

  Json toJson() => {
        'id': id,
        'spotId': spotId,
        'eligibility': eligibility.name,
        'summary': summary,
        'source': source.toJson(),
        'vehicles': [for (final v in vehicles) v.name],
        'openMinute': openMinute,
        'closeMinute': closeMinute,
        'offsiteAllowed': offsiteAllowed.name,
        'fee': fee,
        'maxStayMinutes': maxStayMinutes,
        'review': review.name,
        'lastVerifiedAt': lastVerifiedAt.toUtc().toIso8601String(),
      };

  factory AccessPolicy.fromJson(Json j) => AccessPolicy(
        id: j['id']! as String,
        spotId: j['spotId']! as String,
        eligibility: Eligibility.values.byName(j['eligibility']! as String),
        summary: j['summary']! as String,
        source: EvidenceSource.fromJson(asJson(j['source'])),
        vehicles: {for (final v in (j['vehicles'] as List? ?? const [])) VehicleClass.values.byName(v as String)},
        openMinute: j['openMinute'] as int?,
        closeMinute: j['closeMinute'] as int?,
        offsiteAllowed: Tri.values.byName(j['offsiteAllowed'] as String? ?? 'unknown'),
        fee: j['fee'] as String?,
        maxStayMinutes: j['maxStayMinutes'] as int?,
        review: ReviewStatus.values.byName(j['review'] as String? ?? 'pending'),
        lastVerifiedAt: DateTime.parse(j['lastVerifiedAt']! as String),
      );
}

enum TipOutcome {
  parkedAndRetrieved('Parked and got it back'),
  refusedEntry('Wasn’t let in'),
  askedToMove('Asked to move it'),
  vehicleRemoved('Vehicle was removed');

  const TipOutcome(this.label);
  final String label;
  bool get isNegative => this != parkedAndRetrieved;
}

enum StaffCheck {
  none('No one checked'),
  askedPurpose('Asked where I was going'),
  tokenOrPurchase('Needed a token or purchase'),
  paid('Paid a fee'),
  unknown('Not sure');

  const StaffCheck(this.label);
  final String label;
}

/// A rider's dated, first-hand experience. Event time and submission time are
/// kept apart: an old visit reported today is still an old observation.
class Observation {
  const Observation({
    required this.id,
    required this.spotId,
    required this.vehicle,
    required this.eventTime,
    required this.submittedAt,
    required this.stayMinutes,
    required this.outcome,
    this.leftPremises = Tri.unknown,
    this.staffCheck = StaffCheck.unknown,
    this.note,
    this.reviewedAt,
  });

  final String id;
  final String spotId;
  final VehicleClass vehicle;
  final DateTime eventTime;
  final DateTime submittedAt;
  final int stayMinutes;
  final TipOutcome outcome;
  final Tri leftPremises;
  final StaffCheck staffCheck;
  final String? note;
  final DateTime? reviewedAt;

  Json toJson() => {
        'id': id,
        'spotId': spotId,
        'vehicle': vehicle.name,
        'eventTime': eventTime.toUtc().toIso8601String(),
        'submittedAt': submittedAt.toUtc().toIso8601String(),
        'stayMinutes': stayMinutes,
        'outcome': outcome.name,
        'leftPremises': leftPremises.name,
        'staffCheck': staffCheck.name,
        'note': note,
        'reviewedAt': reviewedAt?.toUtc().toIso8601String(),
      };

  factory Observation.fromJson(Json j) => Observation(
        id: j['id']! as String,
        spotId: j['spotId']! as String,
        vehicle: VehicleClass.values.byName(j['vehicle']! as String),
        eventTime: DateTime.parse(j['eventTime']! as String),
        submittedAt: DateTime.parse(j['submittedAt']! as String),
        stayMinutes: j['stayMinutes']! as int,
        outcome: TipOutcome.values.byName(j['outcome']! as String),
        leftPremises: Tri.values.byName(j['leftPremises'] as String? ?? 'unknown'),
        staffCheck: StaffCheck.values.byName(j['staffCheck'] as String? ?? 'unknown'),
        note: j['note'] as String?,
        reviewedAt: parseTime(j['reviewedAt']),
      );
}

/// Everything the app knows about the pilot area at one published version.
class EvidenceSnapshot {
  const EvidenceSnapshot({
    required this.version,
    required this.publishedAt,
    required this.spots,
    required this.rules,
    required this.policies,
    required this.observations,
  });

  final int version;
  final DateTime publishedAt;
  final List<Spot> spots;
  final List<ParkingRule> rules;
  final List<AccessPolicy> policies;
  final List<Observation> observations;

  Spot? spot(String id) {
    for (final s in spots) {
      if (s.id == id) return s;
    }
    return null;
  }

  EvidenceSnapshot copyWith({
    int? version,
    DateTime? publishedAt,
    List<Spot>? spots,
    List<ParkingRule>? rules,
    List<AccessPolicy>? policies,
    List<Observation>? observations,
  }) =>
      EvidenceSnapshot(
        version: version ?? this.version,
        publishedAt: publishedAt ?? this.publishedAt,
        spots: spots ?? this.spots,
        rules: rules ?? this.rules,
        policies: policies ?? this.policies,
        observations: observations ?? this.observations,
      );

  Json toJson() => {
        'version': version,
        'publishedAt': publishedAt.toUtc().toIso8601String(),
        'spots': [for (final s in spots) s.toJson()],
        'rules': [for (final r in rules) r.toJson()],
        'policies': [for (final p in policies) p.toJson()],
        'observations': [for (final o in observations) o.toJson()],
      };

  factory EvidenceSnapshot.fromJson(Json j) => EvidenceSnapshot(
        version: j['version']! as int,
        publishedAt: DateTime.parse(j['publishedAt']! as String),
        spots: [for (final s in asJsonList(j['spots'])) Spot.fromJson(s)],
        rules: [for (final r in asJsonList(j['rules'])) ParkingRule.fromJson(r)],
        policies: [for (final p in asJsonList(j['policies'])) AccessPolicy.fromJson(p)],
        observations: [for (final o in asJsonList(j['observations'])) Observation.fromJson(o)],
      );
}
