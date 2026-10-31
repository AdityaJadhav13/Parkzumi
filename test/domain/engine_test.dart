import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:parkzumi/data/pilot_seed.dart';
import 'package:parkzumi/domain/assessment.dart';
import 'package:parkzumi/domain/engine.dart';
import 'package:parkzumi/domain/models.dart';
import 'package:parkzumi/domain/photo_findings.dart';
import 'package:parkzumi/domain/schedule.dart';
import 'package:parkzumi/domain/time_ist.dart';

const engine = AssessmentEngine();
final now = istInstant(2026, 10, 31, 12); // Saturday, an odd date

Assessment check(
  String spotId,
  DateTime start,
  Duration stay, {
  VehicleClass vehicle = VehicleClass.twoWheeler,
  EvidenceSnapshot? evidence,
  PhotoFindings? photo,
  DateTime? fetchedAt,
}) =>
    engine.evaluate(
      AssessmentRequest(spotId: spotId, vehicle: vehicle, start: start, stay: stay, photo: photo),
      evidence ?? pilotSeed(),
      now: now,
      evidenceFetchedAt: fetchedAt,
    );

PhotoFindings photoWith({List<SignFinding> signs = const [], List<SceneObject> objects = const []}) =>
    PhotoFindings(signs: signs, objects: objects, uncertainties: const [], model: 'test', analysedAt: now);

ParkingRule festivalOrder({DateTime? until, ReviewStatus review = ReviewStatus.reviewed}) => ParkingRule(
      id: 'temp-festival',
      spotIds: const ['somani-e'],
      effect: RuleEffect.prohibits,
      summary: 'Festival procession: no parking 4 pm–11 pm',
      source: const EvidenceSource(id: 'src-temp', cls: SourceClass.official, title: 'Temporary order (test)'),
      schedule: const Schedule(windows: [TimeWindow(16 * 60, 23 * 60)]),
      effectiveFrom: istInstant(2026, 11, 1),
      effectiveUntil: until ?? istInstant(2026, 11, 2),
      temporary: true,
      review: review,
      lastVerifiedAt: now,
    );

void main() {
  group('odd–even order (real notification No. 64/2026)', () {
    test('west side on an odd date is a restriction', () {
      final a = check('somani-w', istInstant(2026, 10, 31, 10), const Duration(hours: 2));
      expect(a.verdict, Verdict.prohibited);
      expect(a.headline, 'Don’t park here');
      expect(a.appliedEvidenceIds, contains('mtp64-west-odd'));
      expect(a.fitsStay, isFalse);
    });

    test('west side on an even date is allowed with the date condition, never plain Permitted', () {
      final a = check('somani-w', istInstant(2026, 10, 30, 10), const Duration(hours: 2));
      expect(a.verdict, Verdict.conditional);
      expect(a.conditions, contains('Even dates only'));
      expect(a.fitsStay, isTrue);
    });

    test('a stay crossing midnight into an odd date hits the restriction at 12 am', () {
      final a = check('somani-w', istInstant(2026, 10, 30, 22), const Duration(hours: 4));
      expect(a.verdict, Verdict.prohibited);
      expect(a.headline, 'Restriction starts at 12 am');
      expect(a.deadline, istInstant(2026, 10, 31));
      expect(a.deadlineReason, 'Restriction starts');
    });

    test('east side flips the other way', () {
      expect(check('somani-e', istInstant(2026, 11, 1, 10), const Duration(hours: 1)).verdict, Verdict.conditional);
      expect(check('somani-e', istInstant(2026, 11, 2, 10), const Duration(hours: 1)).verdict, Verdict.prohibited);
    });
  });

  group('business rule: only reviewed official/operator evidence can permit', () {
    test('community reports alone never make a spot Permitted', () {
      final a = check('bank-compound', istInstant(2026, 10, 31, 11), const Duration(hours: 1));
      expect(a.verdict, Verdict.unknown);
      expect(a.findings.map((f) => f.title), contains('Locals have parked here'));
      expect(a.communitySupport, isTrue);
      expect(a.unknowns, contains('Whether outsiders may park here (no reviewed policy)'));
    });

    test('a stay longer than any report is flagged, and the refusal is surfaced', () {
      final a = check('bank-compound', istInstant(2026, 10, 31, 11), const Duration(hours: 3));
      expect(a.verdict, Verdict.unknown);
      expect(a.communitySupport, isFalse);
      final titles = a.findings.map((f) => f.title).toList();
      expect(titles, contains('No reports of stays as long as yours'));
      expect(titles.any((t) => t.startsWith('Asked to move it')), isTrue);
      expect(titles, contains('1 older report not counted'));
    });

    test('a car sees the car refusal, not the bike successes', () {
      final a = check('bank-compound', istInstant(2026, 10, 31, 11), const Duration(hours: 1), vehicle: VehicleClass.car);
      final titles = a.findings.map((f) => f.title).toList();
      expect(titles.any((t) => t.startsWith('Wasn’t let in')), isTrue);
      expect(titles, isNot(contains('Locals have parked here')));
      expect(a.communitySupport, isFalse);
    });

    test('an unreviewed (pending) restriction is not applied', () {
      final seed = pilotSeed();
      final evidence = seed.copyWith(rules: [...seed.rules, festivalOrder(review: ReviewStatus.pending)]);
      final a = check('somani-e', istInstant(2026, 11, 1, 17), const Duration(hours: 1), evidence: evidence);
      expect(a.verdict, Verdict.conditional);
      expect(a.findings.map((f) => f.title), contains('1 source is waiting for review'));
    });

    test('the only plain Permitted is a reviewed bay with no conditions', () {
      expect(check('bike-bay', istInstant(2026, 10, 31, 11), const Duration(hours: 2)).verdict, Verdict.permitted);
      final car = check('bike-bay', istInstant(2026, 10, 31, 11), const Duration(hours: 2), vehicle: VehicleClass.car);
      expect(car.verdict, Verdict.unknown);
      expect(car.findings.any((f) => f.title.contains('for bike / scooter only')), isTrue);
    });

    test('a reviewed permission from a community or AI source still cannot permit', () {
      final seed = pilotSeed();
      for (final cls in [SourceClass.community, SourceClass.ai]) {
        final evidence = seed.copyWith(rules: [
          ...seed.rules,
          ParkingRule(
            id: 'not-authoritative-${cls.name}',
            spotIds: const ['market-lane'],
            effect: RuleEffect.permits,
            summary: 'Everyone parks here',
            source: EvidenceSource(id: 'src-${cls.name}', cls: cls, title: 'Not an authority'),
            effectiveFrom: istInstant(2026, 1, 1),
            lastVerifiedAt: now,
          ),
        ]);
        expect(check('market-lane', istInstant(2026, 10, 31, 10), const Duration(hours: 1), evidence: evidence).verdict,
            Verdict.unknown, reason: cls.name);
      }
    });

    test('a record with no review status is treated as pending (fails closed)', () {
      final json = pilotSeed().rules.firstWhere((r) => r.id == 'sample-bike-bay').toJson()..remove('review');
      expect(ParkingRule.fromJson(json).review, ReviewStatus.pending);
    });

    test('no known restriction during the stay is still not permission', () {
      final sunday = check('station-lane', istInstant(2026, 11, 1, 10), const Duration(hours: 2));
      expect(sunday.verdict, Verdict.unknown);
      expect(sunday.findings.map((f) => f.title), contains('Known restrictions don’t cover your time'));
      final saturday = check('station-lane', istInstant(2026, 10, 31, 10), const Duration(hours: 2));
      expect(saturday.verdict, Verdict.prohibited);
    });
  });

  group('the whole stay is checked', () {
    test('gate closing before return is a blocker with a deadline', () {
      final a = check('mall-basement', istInstant(2026, 10, 31, 21), const Duration(hours: 4));
      expect(a.verdict, Verdict.conditional);
      expect(a.headline, 'Allowed until 11:30 pm');
      expect(a.fitsStay, isFalse);
      expect(a.deadline, istInstant(2026, 10, 31, 23, 30));
      expect(a.deadlineReason, 'Gate closes at 11:30 pm');
    });

    test('maximum stay is enforced', () {
      final a = check('paypark-lot', istInstant(2026, 10, 31, 8), const Duration(hours: 13));
      expect(a.blockers.any((b) => b.title.startsWith('Max stay is 12 h')), isTrue);
    });

    test('a vehicle the place does not take is a restriction', () {
      final a = check('station-stand', istInstant(2026, 10, 31, 9), const Duration(hours: 3), vehicle: VehicleClass.car);
      expect(a.verdict, Verdict.prohibited);
      expect(a.headline, 'Not for your vehicle');
    });

    test('a temporary order applies from its start time within the stay', () {
      final seed = pilotSeed();
      final evidence = seed.copyWith(rules: [...seed.rules, festivalOrder()]);
      final a = check('somani-e', istInstant(2026, 11, 1, 15), const Duration(hours: 2), evidence: evidence);
      expect(a.verdict, Verdict.prohibited);
      expect(a.headline, 'Restriction starts at 4 pm');
      expect(a.deadline, istInstant(2026, 11, 1, 16));
    });

    test('an expired temporary order is ignored', () {
      final seed = pilotSeed();
      final evidence = seed.copyWith(rules: [...seed.rules, festivalOrder(until: istInstant(2026, 11, 1, 12))]);
      final a = check('somani-e', istInstant(2026, 11, 1, 17), const Duration(hours: 1), evidence: evidence);
      expect(a.verdict, Verdict.conditional);
    });
  });

  group('AI photo observations can raise doubts but never grant permission', () {
    test('a restriction sign in the photo downgrades an allowed spot to unknown', () {
      final a = check('somani-e', istInstant(2026, 11, 1, 10), const Duration(hours: 1),
          photo: photoWith(signs: const [SignFinding(kind: SignKind.noParking, text: 'NO PARKING', confidence: 0.8)]));
      expect(a.verdict, Verdict.unknown);
      expect(a.headline, 'Photo doesn’t match our records');
    });

    test('a parking-allowed sign does not upgrade an unknown spot', () {
      final a = check('market-lane', istInstant(2026, 10, 31, 10), const Duration(hours: 1),
          photo: photoWith(signs: const [SignFinding(kind: SignKind.parkingAllowed, text: 'P', confidence: 0.9)]));
      expect(a.verdict, Verdict.unknown);
    });

    test('no sign in the photo is not permission', () {
      final a = check('market-lane', istInstant(2026, 10, 31, 10), const Duration(hours: 1), photo: photoWith());
      expect(a.verdict, Verdict.unknown);
      expect(a.findings.map((f) => f.title), contains('No sign spotted'));
    });

    test('a possible obstruction becomes a blocker', () {
      final a = check('bike-bay', istInstant(2026, 10, 31, 11), const Duration(hours: 1),
          photo: photoWith(objects: const [
            SceneObject(kind: SceneObjectKind.gate, label: 'Building gate', nearSpot: true, possibleObstruction: true, confidence: 0.7),
          ]));
      expect(a.verdict, Verdict.conditional);
      expect(a.fitsStay, isFalse);
      expect(a.blockers.single.title, 'You might block a gate');
    });

    test('low-confidence readings are ignored', () {
      final a = check('somani-e', istInstant(2026, 11, 1, 10), const Duration(hours: 1),
          photo: photoWith(signs: const [SignFinding(kind: SignKind.noParking, text: '', confidence: 0.3)]));
      expect(a.verdict, Verdict.conditional);
    });
  });

  group('evidence quality', () {
    test('stale cached evidence is called out', () {
      final a = check('somani-e', istInstant(2026, 11, 1, 10), const Duration(hours: 1),
          fetchedAt: now.subtract(const Duration(days: 3)));
      expect(a.findings.any((f) => f.title == 'Using rules saved 3 days ago'), isTrue);
    });

    test('a real official source is shown as official, samples as samples', () {
      final real = check('somani-e', istInstant(2026, 11, 1, 10), const Duration(hours: 1));
      expect(real.findings.any((f) => f.title == 'Official source' && f.url != null), isTrue);
      final sample = check('mall-basement', istInstant(2026, 10, 31, 12), const Duration(hours: 1));
      expect(sample.findings.map((f) => f.title), contains('Sample pilot data'));
    });

    test('an unknown spot id is an honest unknown', () {
      final a = check('nowhere', istInstant(2026, 10, 31, 10), const Duration(hours: 1));
      expect(a.verdict, Verdict.unknown);
    });
  });

  test('alternatives: workable first, restrictions dropped, nearest within a group', () {
    final start = istInstant(2026, 10, 31, 11);
    final seed = pilotSeed();
    final all = [for (final s in seed.spots) check(s.id, start, const Duration(hours: 1))];
    final distances = {for (final s in seed.spots) s.id: s.location.distanceTo(pilotCentre)};
    final ranked = engine.rankAlternatives(all, distances, excluding: 'somani-w');
    expect(ranked.first.verdict, Verdict.permitted);
    expect(ranked.any((a) => a.verdict == Verdict.prohibited), isFalse);
    expect(ranked.any((a) => a.request.spotId == 'somani-w'), isFalse);
  });

  test('evidence survives a JSON round trip unchanged in effect', () {
    final seed = pilotSeed();
    final copy = EvidenceSnapshot.fromJson(jsonDecode(jsonEncode(seed.toJson())) as Map<String, Object?>);
    for (final s in seed.spots) {
      final start = istInstant(2026, 10, 30, 21);
      final a = check(s.id, start, const Duration(hours: 4));
      final b = check(s.id, start, const Duration(hours: 4), evidence: copy);
      expect(b.verdict, a.verdict, reason: s.id);
      expect(b.headline, a.headline, reason: s.id);
    }
  });

  group('schedule', () {
    test('a window crossing midnight', () {
      const w = TimeWindow(22 * 60, 6 * 60);
      expect(w.contains(23 * 60), isTrue);
      expect(w.contains(5 * 60), isTrue);
      expect(w.contains(12 * 60), isFalse);
    });

    test('boundaries include midnight and window edges inside the interval only', () {
      const s = Schedule(windows: [TimeWindow(8 * 60, 22 * 60)]);
      final b = s.boundaries(istInstant(2026, 10, 31, 7), istInstant(2026, 11, 1, 9)).toList();
      expect(b, [istInstant(2026, 10, 31, 8), istInstant(2026, 10, 31, 22), istInstant(2026, 11, 1), istInstant(2026, 11, 1, 8)]);
    });
  });
}
