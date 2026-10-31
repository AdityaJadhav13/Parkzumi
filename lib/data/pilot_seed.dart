import '../domain/models.dart';
import '../domain/schedule.dart';
import '../domain/time_ist.dart';

/// Pilot area: around Ram Mandir station, Goregaon West, Mumbai.
///
/// Only the odd–even order (Mumbai Traffic Police Permanent Notification
/// No. 64/2026) is a real, checked source. Every other record is clearly
/// labelled sample data with invented place names, so the demo never attaches
/// a made-up rule to a real road or business.
const pilotArea = 'Ram Mandir, Goregaon West';
const pilotCentre = GeoPoint(19.15080, 72.84760);

final _verified = istInstant(2026, 10, 31, 10);
final _seededAt = istInstant(2026, 10, 31, 10);

final _mtp64Issued = istInstant(2026, 2, 23);

/// Checked on 31 Oct 2026 against the published scan.
final mtp64Source = EvidenceSource(
  id: 'src-mtp-64-2026',
  cls: SourceClass.official,
  title: 'Mumbai Traffic Police · Permanent Notification No. 64/2026 (odd–even parking, Somani Gram Road)',
  url: 'https://mumbaipolice.gov.in/files/PressRelease/3524.pdf',
  issuedOn: _mtp64Issued,
);

const _sampleSigns = EvidenceSource(
  id: 'src-sample-signs',
  cls: SourceClass.official,
  title: 'Sample sign survey (demo data)',
  sample: true,
);
const _sampleMunicipal = EvidenceSource(
  id: 'src-sample-municipal',
  cls: SourceClass.official,
  title: 'Sample municipal pay-and-park record (demo data)',
  sample: true,
);
const _sampleMall = EvidenceSource(
  id: 'src-sample-mall',
  cls: SourceClass.operator,
  title: 'Sample mall parking terms (demo data)',
  sample: true,
);
const _sampleStand = EvidenceSource(
  id: 'src-sample-stand',
  cls: SourceClass.operator,
  title: 'Sample station stand operator notice (demo data)',
  sample: true,
);
const _sampleOffice = EvidenceSource(
  id: 'src-sample-office',
  cls: SourceClass.operator,
  title: 'Sample office front-desk policy (demo data)',
  sample: true,
);
const _sampleSociety = EvidenceSource(
  id: 'src-sample-society',
  cls: SourceClass.operator,
  title: 'Sample society committee notice (demo data)',
  sample: true,
);

EvidenceSnapshot pilotSeed() {
  final spots = <Spot>[
    const Spot(
      id: 'somani-w',
      name: 'Somani Gram Rd · West side',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'West side',
      location: GeoPoint(19.15125, 72.84571),
      line: [GeoPoint(19.15160, 72.84567), GeoPoint(19.15010, 72.84582)],
      approximateGeometry: true,
      note: 'Order covers the stretch from Vishal Sweets to Rajnigandha Building.',
    ),
    const Spot(
      id: 'somani-e',
      name: 'Somani Gram Rd · East side',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'East side',
      location: GeoPoint(19.15045, 72.84594),
      line: [GeoPoint(19.15160, 72.84583), GeoPoint(19.15010, 72.84598)],
      approximateGeometry: true,
      note: 'Order covers the stretch from Vishal Sweets to Rajnigandha Building.',
    ),
    const Spot(
      id: 'bike-bay',
      name: 'Two-wheeler bay, Ram Mandir Rd (sample)',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'North side',
      location: GeoPoint(19.15128, 72.84668),
      line: [GeoPoint(19.15131, 72.84645), GeoPoint(19.15125, 72.84690)],
    ),
    const Spot(
      id: 'station-lane',
      name: 'Station Approach Lane (sample)',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'North side',
      location: GeoPoint(19.15135, 72.84935),
      line: [GeoPoint(19.15138, 72.84900), GeoPoint(19.15132, 72.84970)],
    ),
    const Spot(
      id: 'clinic-lane',
      name: 'Clinic entrance lane (sample)',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'South side',
      location: GeoPoint(19.15000, 72.84800),
      line: [GeoPoint(19.15002, 72.84780), GeoPoint(19.14998, 72.84820)],
    ),
    const Spot(
      id: 'market-lane',
      name: 'Market Lane (sample)',
      area: pilotArea,
      kind: SpotKind.curbSide,
      side: 'Both sides',
      location: GeoPoint(19.14975, 72.84690),
      line: [GeoPoint(19.14990, 72.84670), GeoPoint(19.14960, 72.84710)],
    ),
    const Spot(
      id: 'bank-compound',
      name: 'Co-op bank compound (sample)',
      area: pilotArea,
      kind: SpotKind.premises,
      location: GeoPoint(19.15045, 72.84660),
    ),
    const Spot(
      id: 'office-visitor',
      name: 'Office visitor parking (sample)',
      area: pilotArea,
      kind: SpotKind.premises,
      location: GeoPoint(19.15255, 72.84720),
    ),
    const Spot(
      id: 'society-guest',
      name: 'Housing society guest bays (sample)',
      area: pilotArea,
      kind: SpotKind.premises,
      location: GeoPoint(19.14925, 72.84610),
    ),
    const Spot(
      id: 'mall-basement',
      name: 'Mall basement parking (sample)',
      area: pilotArea,
      kind: SpotKind.facility,
      location: GeoPoint(19.15225, 72.84550),
    ),
    const Spot(
      id: 'paypark-lot',
      name: 'Municipal pay-and-park lot (sample)',
      area: pilotArea,
      kind: SpotKind.facility,
      location: GeoPoint(19.14960, 72.84865),
    ),
    const Spot(
      id: 'station-stand',
      name: 'Station two-wheeler stand (sample)',
      area: pilotArea,
      kind: SpotKind.facility,
      location: GeoPoint(19.15062, 72.84985),
    ),
  ];

  final rules = <ParkingRule>[
    ParkingRule(
      id: 'mtp64-west-even',
      spotIds: const ['somani-w'],
      effect: RuleEffect.permits,
      summary: 'Odd–even order: the west side is for even dates',
      source: mtp64Source,
      schedule: const Schedule(parity: DateParity.even),
      conditions: const ['Switch to the east side on odd dates'],
      effectiveFrom: _mtp64Issued,
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'mtp64-west-odd',
      spotIds: const ['somani-w'],
      effect: RuleEffect.prohibits,
      summary: 'Odd date: the west side isn’t a parking side today (odd–even order)',
      source: mtp64Source,
      schedule: const Schedule(parity: DateParity.odd),
      effectiveFrom: _mtp64Issued,
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'mtp64-east-odd',
      spotIds: const ['somani-e'],
      effect: RuleEffect.permits,
      summary: 'Odd–even order: the east side is for odd dates',
      source: mtp64Source,
      schedule: const Schedule(parity: DateParity.odd),
      conditions: const ['Switch to the west side on even dates'],
      effectiveFrom: _mtp64Issued,
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'mtp64-east-even',
      spotIds: const ['somani-e'],
      effect: RuleEffect.prohibits,
      summary: 'Even date: the east side isn’t a parking side today (odd–even order)',
      source: mtp64Source,
      schedule: const Schedule(parity: DateParity.even),
      effectiveFrom: _mtp64Issued,
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'sample-bike-bay',
      spotIds: const ['bike-bay'],
      effect: RuleEffect.permits,
      summary: 'Marked two-wheeler bay',
      source: _sampleSigns,
      vehicles: const {VehicleClass.twoWheeler},
      effectiveFrom: istInstant(2026, 1, 1),
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'sample-station-lane',
      spotIds: const ['station-lane'],
      effect: RuleEffect.prohibits,
      summary: 'No parking, Mon–Sat 8 am–10 pm',
      source: _sampleSigns,
      schedule: const Schedule(weekdays: {1, 2, 3, 4, 5, 6}, windows: [TimeWindow(8 * 60, 22 * 60)]),
      effectiveFrom: istInstant(2026, 1, 1),
      lastVerifiedAt: _verified,
    ),
    ParkingRule(
      id: 'sample-clinic-lane',
      spotIds: const ['clinic-lane'],
      effect: RuleEffect.prohibits,
      summary: 'No parking in front of the ambulance entrance',
      source: _sampleSigns,
      effectiveFrom: istInstant(2026, 1, 1),
      lastVerifiedAt: _verified,
    ),
  ];

  final policies = <AccessPolicy>[
    AccessPolicy(
      id: 'sample-mall',
      spotId: 'mall-basement',
      eligibility: Eligibility.public,
      summary: 'Public pay parking in the mall basement',
      source: _sampleMall,
      openMinute: 10 * 60,
      closeMinute: 23 * 60 + 30,
      offsiteAllowed: Tri.yes,
      fee: '₹30 for 4 h (bike) · ₹60 for 4 h (car)',
      lastVerifiedAt: _verified,
    ),
    AccessPolicy(
      id: 'sample-paypark',
      spotId: 'paypark-lot',
      eligibility: Eligibility.public,
      summary: 'Municipal pay-and-park lot',
      source: _sampleMunicipal,
      openMinute: 8 * 60,
      closeMinute: 22 * 60,
      offsiteAllowed: Tri.yes,
      fee: '₹15 per 2 h (bike) · ₹40 per 2 h (car)',
      maxStayMinutes: 12 * 60,
      lastVerifiedAt: _verified,
    ),
    AccessPolicy(
      id: 'sample-stand',
      spotId: 'station-stand',
      eligibility: Eligibility.public,
      summary: 'Two-wheeler stand next to the station',
      source: _sampleStand,
      vehicles: const {VehicleClass.twoWheeler},
      offsiteAllowed: Tri.yes,
      fee: '₹20 per day',
      lastVerifiedAt: _verified,
    ),
    AccessPolicy(
      id: 'sample-office',
      spotId: 'office-visitor',
      eligibility: Eligibility.hostApproval,
      summary: 'Visitor bays for people meeting someone in the building',
      source: _sampleOffice,
      openMinute: 9 * 60,
      closeMinute: 19 * 60,
      offsiteAllowed: Tri.no,
      fee: 'Free for visitors',
      lastVerifiedAt: _verified,
    ),
    AccessPolicy(
      id: 'sample-society',
      spotId: 'society-guest',
      eligibility: Eligibility.guestsOnly,
      summary: 'Guest bays for visitors of residents',
      source: _sampleSociety,
      offsiteAllowed: Tri.no,
      fee: 'Free',
      lastVerifiedAt: _verified,
    ),
  ];

  final observations = <Observation>[
    Observation(
      id: 'obs-bank-1',
      spotId: 'bank-compound',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 29, 11),
      submittedAt: istInstant(2026, 10, 29, 13),
      stayMinutes: 90,
      outcome: TipOutcome.parkedAndRetrieved,
      leftPremises: Tri.yes,
      staffCheck: StaffCheck.none,
      reviewedAt: istInstant(2026, 10, 29, 18),
    ),
    Observation(
      id: 'obs-bank-2',
      spotId: 'bank-compound',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 24, 18, 30),
      submittedAt: istInstant(2026, 10, 24, 20),
      stayMinutes: 60,
      outcome: TipOutcome.parkedAndRetrieved,
      leftPremises: Tri.yes,
      staffCheck: StaffCheck.none,
      reviewedAt: istInstant(2026, 10, 25, 9),
    ),
    Observation(
      id: 'obs-bank-3',
      spotId: 'bank-compound',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 18, 10),
      submittedAt: istInstant(2026, 10, 19, 9),
      stayMinutes: 240,
      outcome: TipOutcome.askedToMove,
      leftPremises: Tri.yes,
      staffCheck: StaffCheck.askedPurpose,
      note: 'Guard asked me to move it after about 2 hours',
      reviewedAt: istInstant(2026, 10, 19, 12),
    ),
    Observation(
      id: 'obs-bank-4',
      spotId: 'bank-compound',
      vehicle: VehicleClass.car,
      eventTime: istInstant(2026, 10, 20, 12),
      submittedAt: istInstant(2026, 10, 20, 12, 30),
      stayMinutes: 0,
      outcome: TipOutcome.refusedEntry,
      note: 'Guard said bikes only',
      reviewedAt: istInstant(2026, 10, 20, 16),
    ),
    Observation(
      id: 'obs-bank-old',
      spotId: 'bank-compound',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 3, 2, 10),
      submittedAt: istInstant(2026, 3, 2, 14),
      stayMinutes: 120,
      outcome: TipOutcome.parkedAndRetrieved,
      leftPremises: Tri.yes,
      staffCheck: StaffCheck.none,
      reviewedAt: istInstant(2026, 3, 3, 9),
    ),
    Observation(
      id: 'obs-office-1',
      spotId: 'office-visitor',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 27, 10),
      submittedAt: istInstant(2026, 10, 27, 13),
      stayMinutes: 120,
      outcome: TipOutcome.parkedAndRetrieved,
      leftPremises: Tri.no,
      staffCheck: StaffCheck.askedPurpose,
      reviewedAt: istInstant(2026, 10, 27, 17),
    ),
    Observation(
      id: 'obs-office-2',
      spotId: 'office-visitor',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 22, 15),
      submittedAt: istInstant(2026, 10, 22, 19),
      stayMinutes: 180,
      outcome: TipOutcome.askedToMove,
      leftPremises: Tri.yes,
      staffCheck: StaffCheck.askedPurpose,
      note: 'Wasn’t visiting anyone inside',
      reviewedAt: istInstant(2026, 10, 23, 10),
    ),
    Observation(
      id: 'obs-clinic-1',
      spotId: 'clinic-lane',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 26, 17),
      submittedAt: istInstant(2026, 10, 26, 19),
      stayMinutes: 60,
      outcome: TipOutcome.vehicleRemoved,
      note: 'Bike was gone; a towing van was nearby',
      reviewedAt: istInstant(2026, 10, 27, 9),
    ),
    Observation(
      id: 'obs-somani-1',
      spotId: 'somani-e',
      vehicle: VehicleClass.twoWheeler,
      eventTime: istInstant(2026, 10, 29, 19),
      submittedAt: istInstant(2026, 10, 29, 21),
      stayMinutes: 45,
      outcome: TipOutcome.parkedAndRetrieved,
      reviewedAt: istInstant(2026, 10, 30, 9),
    ),
  ];

  return EvidenceSnapshot(
    version: 1,
    publishedAt: _seededAt,
    spots: spots,
    rules: rules,
    policies: policies,
    observations: observations,
  );
}
