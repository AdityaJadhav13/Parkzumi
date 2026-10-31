import 'dart:math' as math;

import 'assessment.dart';
import 'models.dart';
import 'photo_findings.dart';
import 'schedule.dart';
import 'time_ist.dart';

/// Deterministic parking assessment.
///
/// Business rule (the one we defend): a spot is **Permitted** only when a
/// reviewed official or operator source permits this vehicle for the whole
/// planned stay. Missing signs, popularity, community reports and AI photo
/// readings can never produce Permitted. They can only add concerns.
class AssessmentEngine {
  const AssessmentEngine();

  static const observationHorizon = Duration(days: 180);
  static const staleCacheAfter = Duration(hours: 24);
  static const staleVerificationAfter = Duration(days: 180);
  static const poorAccuracyMetres = 50.0;
  static const farFromSpotMetres = 150.0;

  Assessment evaluate(
    AssessmentRequest req,
    EvidenceSnapshot ev, {
    required DateTime now,
    DateTime? evidenceFetchedAt,
  }) {
    final acc = _Acc(req);
    final spot = ev.spot(req.spotId);
    if (spot == null) {
      acc.unknown('This place isn’t in our pilot data yet');
      return acc.build(
        verdict: Verdict.unknown,
        headline: 'Can’t verify this spot yet',
        reason: 'This place isn’t in our pilot data.',
        evidenceVersion: ev.version,
        now: now,
      );
    }

    // --- Collect evidence for this spot and vehicle --------------------------
    final policies = ev.policies.where((p) => p.spotId == spot.id).toList();
    final policy = _firstOrNull(policies.where((p) => p.review == ReviewStatus.reviewed && _canPermit(p.source)));
    final spotRules = ev.rules.where((r) => r.spotIds.contains(spot.id)).toList();
    // Any reviewed restriction counts (erring towards caution); a permission
    // counts only from an official or operator source.
    final reviewed = <ParkingRule>[
      ...spotRules.where((r) =>
          r.review == ReviewStatus.reviewed &&
          r.appliesTo(req.vehicle) &&
          (r.effect == RuleEffect.prohibits || _canPermit(r.source))),
      if (policy != null && policy.accepts(req.vehicle)) _policyAsRule(policy),
    ];
    final pendingCount = spotRules.where((r) => r.review == ReviewStatus.pending).length +
        policies.where((p) => p.review == ReviewStatus.pending).length;
    for (final r in spotRules.where((r) => r.review == ReviewStatus.reviewed && !r.appliesTo(req.vehicle))) {
      acc.add(Dimension.restrictions, Level.info, 'A ${r.effect == RuleEffect.permits ? 'permission' : 'restriction'} here is for ${_vehicles(r.vehicles)} only',
          detail: r.summary, source: r.source.cls, ids: [r.id]);
    }

    // --- Rules over the whole stay ------------------------------------------
    // Rule activity only changes at schedule/effective-date boundaries, so one
    // probe per segment between boundaries evaluates the stay exactly.
    final cuts = <DateTime>{req.start, req.end, for (final r in reviewed) ...r.boundaries(req.start, req.end)}.toList()
      ..sort();
    ParkingRule? prohibition;
    DateTime? prohibitionAt;
    var conflict = false;
    final permitsUsed = <ParkingRule>[];
    DateTime? gapAt;
    var coveredAtStart = false;
    for (var i = 0; i < cuts.length - 1; i++) {
      final at = cuts[i];
      final prohibits = reviewed.where((r) => r.effect == RuleEffect.prohibits && r.activeAt(at)).toList();
      final permits = reviewed.where((r) => r.effect == RuleEffect.permits && r.activeAt(at)).toList();
      if (prohibits.isNotEmpty && prohibition == null) {
        prohibits.sort((a, b) => (b.temporary ? 1 : 0) - (a.temporary ? 1 : 0));
        prohibition = prohibits.first;
        prohibitionAt = at;
        conflict = permits.isNotEmpty;
      }
      if (permits.isNotEmpty) {
        for (final p in permits) {
          if (!permitsUsed.contains(p)) permitsUsed.add(p);
        }
        if (at.isAtSameMomentAs(req.start)) coveredAtStart = true;
      } else {
        gapAt ??= at;
      }
    }

    late Verdict verdict;
    late String headline;
    late String reason;

    if (policy != null && !policy.accepts(req.vehicle)) {
      verdict = Verdict.prohibited;
      headline = 'Not for your vehicle';
      reason = '${spot.name} takes ${_vehicles(policy.vehicles)} only.';
      acc.blocker(Dimension.access, 'Doesn’t take ${req.vehicle.label.toLowerCase()}',
          detail: policy.summary, source: policy.source.cls, ids: [policy.id]);
      acc.use(policy.source, policy.id, policy.lastVerifiedAt);
      acc.restrictionFrom = req.start;
    } else if (prohibition != null) {
      final at = prohibitionAt!;
      final later = at.isAfter(req.start);
      verdict = Verdict.prohibited;
      headline = later ? 'Restriction starts at ${formatIstTime(at)}' : 'Don’t park here';
      reason = prohibition.summary;
      acc.blocker(
        Dimension.restrictions,
        later ? 'From ${formatIstDateTime(at)}: ${prohibition.summary}' : prohibition.summary,
        detail: '${prohibition.schedule.describe()}${prohibition.temporary ? ' · temporary order' : ''}',
        source: prohibition.source.cls,
        url: prohibition.source.url,
        ids: [prohibition.id],
      );
      acc.use(prohibition.source, prohibition.id, prohibition.lastVerifiedAt);
      acc.restrictionFrom = at;
      if (later) acc.deadlineAt(at, 'Restriction starts');
      if (conflict) {
        acc.add(Dimension.evidence, Level.caution, 'Sources disagree',
            detail: 'A reviewed source also permits parking then. We show the restriction until a reviewer resolves it.');
      }
    } else if (permitsUsed.isNotEmpty) {
      for (final p in permitsUsed) {
        acc.use(p.source, p.id, p.lastVerifiedAt);
        final fromPolicy = p.id.startsWith(_policyPrefix);
        acc.add(fromPolicy ? Dimension.access : Dimension.restrictions, Level.good, p.summary,
            detail: p.schedule.isAlways ? p.source.title : '${p.schedule.describe()} · ${p.source.title}',
            source: p.source.cls,
            url: p.source.url,
            ids: [p.id]);
        if (!p.schedule.isAlways && !fromPolicy) acc.condition('${p.schedule.describe()} only');
        for (final c in p.conditions) {
          acc.condition(c);
        }
        if (p.fee != null) acc.condition('Fee: ${p.fee}');
        final max = p.maxStayMinutes;
        if (max != null) {
          acc.condition('Max stay ${formatDuration(Duration(minutes: max))}');
          if (req.stay.inMinutes > max) {
            acc.blocker(Dimension.leaveReturn, 'Max stay is ${formatDuration(Duration(minutes: max))} — your plan is ${formatDuration(req.stay)}',
                source: p.source.cls, ids: [p.id]);
            acc.deadlineAt(req.start.add(Duration(minutes: max)), 'Maximum stay ends');
          }
        }
      }
      if (gapAt != null) {
        final gap = gapAt;
        if (coveredAtStart) {
          final ending = _firstOrNull(permitsUsed.where((p) => p.activeAt(gap.subtract(const Duration(minutes: 1)))));
          final why = ending != null && ending.id.startsWith(_policyPrefix)
              ? 'Gate closes at ${formatIstTime(gap)}'
              : 'Parking here ends at ${formatIstTime(gap)}';
          acc.blocker(Dimension.leaveReturn, '$why — before your return at ${formatIstTime(req.end)}',
              source: ending?.source.cls, ids: [if (ending != null) ending.id]);
          acc.deadlineAt(gap, why);
        } else {
          acc.blocker(Dimension.leaveReturn, 'Not allowed yet when you arrive at ${formatIstTime(req.start)}');
        }
      }
      // Permitted vs conditional is settled after property access adds its conditions.
      verdict = Verdict.permitted;
      headline = 'Parking permitted for your stay';
      reason = permitsUsed.first.summary;
    } else {
      verdict = Verdict.unknown;
      headline = 'Can’t verify this spot yet';
      reason = spot.kind == SpotKind.curbSide
          ? 'We have no reviewed rule for this side of the road.'
          : 'No reviewed rule or visitor policy covers this place.';
      acc.unknown(spot.kind == SpotKind.curbSide
          ? 'Whether parking is allowed on this side (no reviewed rule)'
          : 'Whether outsiders may park here (no reviewed policy)');
      final next = _nextProhibitionAfter(reviewed, req.end, const Duration(hours: 12));
      if (next != null) {
        acc.add(Dimension.restrictions, Level.info, 'A restriction starts ${formatIstDateTime(next.$1)}',
            detail: next.$2.summary, source: next.$2.source.cls, ids: [next.$2.id]);
      }
      if (reviewed.any((r) => r.effect == RuleEffect.prohibits)) {
        acc.add(Dimension.restrictions, Level.info, 'Known restrictions don’t cover your time',
            detail: 'That isn’t the same as permission.');
      }
    }

    // --- Property access ----------------------------------------------------
    if (spot.kind != SpotKind.curbSide) {
      if (policy == null) {
        acc.add(Dimension.access, Level.unknown, 'No published visitor policy',
            detail: 'Whether outsiders may park here isn’t known.');
      } else {
        acc.use(policy.source, policy.id, policy.lastVerifiedAt);
        switch (policy.offsiteAllowed) {
          case Tri.yes:
            acc.add(Dimension.leaveReturn, Level.good, 'You may leave the premises while parked',
                source: policy.source.cls, ids: [policy.id]);
          case Tri.no:
            acc.condition('Stay at this place while parked');
            acc.add(Dimension.leaveReturn, Level.caution, 'Only while you’re visiting this place',
                detail: policy.summary, source: policy.source.cls, ids: [policy.id]);
          case Tri.unknown:
            acc.unknown('Whether you can leave the premises while parked');
        }
        if (policy.fee == null) acc.unknown('The price (not published)');
      }
    }
    if (verdict == Verdict.permitted && (acc.conditions.isNotEmpty || acc.blockers.isNotEmpty)) {
      verdict = Verdict.conditional;
      headline = acc.blockers.isEmpty
          ? 'Allowed with conditions'
          : (coveredAtStart && gapAt != null ? 'Allowed until ${formatIstTime(gapAt)}' : 'Allowed, but not for your full plan');
    }

    // --- Rider experiences --------------------------------------------------
    var communitySupport = false;
    final horizonStart = now.subtract(observationHorizon);
    final atSpot = ev.observations.where((o) => o.spotId == spot.id).toList();
    final mine = atSpot.where((o) => o.vehicle == req.vehicle).toList();
    final current = mine.where((o) => !o.eventTime.isBefore(horizonStart)).toList()
      ..sort((a, b) => b.eventTime.compareTo(a.eventTime));
    final successes = current.where((o) => o.outcome == TipOutcome.parkedAndRetrieved).toList();
    if (current.isEmpty) {
      acc.add(Dimension.community, Level.unknown, 'No rider reports for ${req.vehicle.short}s yet',
          detail: 'No reports isn’t a no — nobody has told us yet.');
    } else {
      if (successes.isNotEmpty) {
        final longest = successes.map((o) => o.stayMinutes).reduce(math.max);
        communitySupport = longest >= req.stay.inMinutes;
        acc.add(Dimension.community, Level.info, 'Locals have parked here',
            detail: '${successes.length} reviewed ${successes.length == 1 ? 'report' : 'reports'} · longest stay '
                '${formatDuration(Duration(minutes: longest))} · latest ${formatIstDate(successes.first.eventTime)}',
            source: SourceClass.community,
            ids: [for (final o in successes) o.id]);
        if (!communitySupport) {
          acc.add(Dimension.community, Level.caution, 'No reports of stays as long as yours',
              detail: 'Longest reported stay is ${formatDuration(Duration(minutes: longest))}; you plan ${formatDuration(req.stay)}.',
              source: SourceClass.community);
        }
        final left = successes.where((o) => o.leftPremises == Tri.yes).toList();
        if (left.isNotEmpty && spot.kind != SpotKind.curbSide) {
          final unchecked = left.where((o) => o.staffCheck == StaffCheck.none).length;
          acc.add(Dimension.leaveReturn, Level.info,
              '${left.length} ${left.length == 1 ? 'rider' : 'riders'} left the premises during their stay',
              detail: unchecked > 0 ? '$unchecked reported no check by staff. That’s an experience, not a permission.' : null,
              source: SourceClass.community,
              ids: [for (final o in left) o.id]);
        }
      }
      for (final o in current.where((o) => o.outcome.isNegative).take(3)) {
        acc.add(Dimension.community, Level.caution, '${o.outcome.label} · ${formatIstDate(o.eventTime)}',
            detail: 'Stayed ${formatDuration(Duration(minutes: o.stayMinutes))}${o.note == null ? '' : ' · “${o.note}”'}',
            source: SourceClass.community,
            ids: [o.id]);
      }
    }
    final old = mine.length - current.length;
    if (old > 0) {
      acc.add(Dimension.community, Level.info, '$old older ${old == 1 ? 'report' : 'reports'} not counted',
          detail: 'Reports older than 6 months may no longer apply.');
    }
    final others = atSpot.where((o) => o.vehicle != req.vehicle && o.outcome.isNegative && !o.eventTime.isBefore(horizonStart));
    for (final o in others.take(2)) {
      acc.add(Dimension.community, Level.info, '${o.vehicle.label}: ${o.outcome.label.toLowerCase()} · ${formatIstDate(o.eventTime)}',
          source: SourceClass.community, ids: [o.id]);
    }

    // --- At the spot (photo) -----------------------------------------------
    final photo = req.photo;
    if (photo == null) {
      acc.add(Dimension.physical, Level.unknown, 'Surroundings not checked',
          detail: 'Add a photo to look for signs, gates or anything you might block.');
    } else {
      final restrictive = photo.confidentSigns.where((s) => s.kind.prohibits).toList();
      for (final s in restrictive) {
        acc.add(Dimension.physical, Level.caution, 'Photo shows what looks like a “${s.kind.label}” sign',
            detail: s.text.isEmpty ? null : 'Reads: “${s.text}”', source: SourceClass.ai);
      }
      for (final s in photo.confidentSigns.where((s) => !s.kind.prohibits)) {
        acc.add(Dimension.physical, Level.info, 'Photo shows a “${s.kind.label}” sign',
            detail: 'Read by AI, not verified. It doesn’t change the result on its own.', source: SourceClass.ai);
      }
      if (photo.confidentSigns.isEmpty) {
        acc.add(Dimension.physical, Level.info, 'No sign spotted',
            detail: 'That isn’t permission — rules can apply without a sign.', source: SourceClass.ai);
      }
      final obstructions =
          photo.objects.where((o) => o.nearSpot && o.possibleObstruction && o.confidence >= PhotoFindings.minConfidence);
      for (final o in obstructions) {
        acc.blocker(Dimension.physical, 'You might block a ${o.kind.label.toLowerCase()}',
            detail: o.label.isEmpty ? 'Move a few metres away from it.' : '${o.label}. Move a few metres away from it.',
            source: SourceClass.ai);
      }
      if (obstructions.isNotEmpty && (verdict == Verdict.permitted || verdict == Verdict.conditional)) {
        verdict = Verdict.conditional;
        headline = 'Allowed — but check the spot first';
      }
      for (final u in photo.uncertainties) {
        acc.unknown('Photo: $u');
      }
      // AI can raise doubts; it can never grant permission.
      if (restrictive.isNotEmpty && (verdict == Verdict.permitted || verdict == Verdict.conditional)) {
        verdict = Verdict.unknown;
        headline = 'Photo doesn’t match our records';
        reason = 'Our sources allow parking here, but the photo seems to show a restriction sign. Check the sign before you leave.';
        acc.add(Dimension.evidence, Level.caution, 'Photo conflicts with reviewed sources',
            detail: 'A reviewer will need to check this spot.');
      } else if (restrictive.isNotEmpty && verdict == Verdict.unknown) {
        headline = 'Looks like a restriction sign here';
        reason = 'We have no reviewed rule for this spot, and the photo seems to show a “${restrictive.first.kind.label}” sign.';
      }
    }

    // --- Evidence quality ---------------------------------------------------
    for (final s in acc.sources.values) {
      if (s.sample) {
        acc.add(Dimension.evidence, Level.info, 'Sample pilot data', detail: '${s.title}. Demo record — not verified on the ground.', source: s.cls);
      } else {
        acc.add(Dimension.evidence, Level.good, '${s.cls.label} source',
            detail: '${s.title}${s.issuedOn == null ? '' : ' · issued ${formatIstDate(s.issuedOn!)}'}', source: s.cls, url: s.url);
      }
    }
    for (final e in acc.verifiedAt.entries) {
      if (now.difference(e.value) > staleVerificationAfter) {
        acc.add(Dimension.evidence, Level.caution, 'Not re-checked since ${formatIstDate(e.value)}', ids: [e.key]);
      }
    }
    if (evidenceFetchedAt != null && now.difference(evidenceFetchedAt) > staleCacheAfter) {
      acc.add(Dimension.evidence, Level.caution, 'Using rules saved ${formatAge(now.difference(evidenceFetchedAt))}',
          detail: 'You may be offline. Newer changes might not be included.');
    }
    if (pendingCount > 0) {
      acc.add(Dimension.evidence, Level.info, '$pendingCount ${pendingCount == 1 ? 'source is' : 'sources are'} waiting for review',
          detail: 'Not used until a reviewer approves.');
    }
    final accuracy = req.locationAccuracyM;
    if (accuracy != null && accuracy > poorAccuracyMetres) {
      acc.add(Dimension.evidence, Level.caution, 'Your location is approximate (±${accuracy.round()} m)',
          detail: 'Results are for the spot you picked, not where the phone thinks you are.');
    }
    final distance = req.distanceToSpotM;
    if (distance != null && distance > farFromSpotMetres) {
      acc.add(Dimension.evidence, Level.info, 'You’re about ${distance.round()} m from this spot');
    }
    if (spot.approximateGeometry) {
      acc.add(Dimension.evidence, Level.info, 'Road-side position is approximate',
          detail: 'Check you’re on the ${spot.side?.toLowerCase() ?? 'right side'} of ${spot.name.split(' · ').first}.');
    }

    return acc.build(
      verdict: verdict,
      headline: headline,
      reason: reason,
      evidenceVersion: ev.version,
      now: now,
      communitySupport: communitySupport,
    );
  }

  /// Ranks other spots as alternatives: workable verdicts first, then
  /// community-supported unknowns, then the rest; nearest first within a group.
  List<Assessment> rankAlternatives(List<Assessment> all, Map<String, double> distanceBySpot, {String? excluding}) {
    int group(Assessment a) {
      if (a.verdict == Verdict.prohibited) return 9;
      if (a.fitsStay && a.verdict == Verdict.permitted) return 0;
      if (a.fitsStay && a.verdict == Verdict.conditional) return 1;
      if (a.verdict == Verdict.unknown && a.communitySupport && a.blockers.isEmpty) return 2;
      if (a.verdict == Verdict.unknown) return 3;
      return 4;
    }

    final list = all.where((a) => a.request.spotId != excluding && group(a) < 9).toList()
      ..sort((a, b) {
        final g = group(a).compareTo(group(b));
        if (g != 0) return g;
        return (distanceBySpot[a.request.spotId] ?? double.infinity)
            .compareTo(distanceBySpot[b.request.spotId] ?? double.infinity);
      });
    return list;
  }

  static const _policyPrefix = 'policy:';

  /// A reviewed access policy permits its accepted vehicles during gate hours.
  ParkingRule _policyAsRule(AccessPolicy p) => ParkingRule(
        id: '$_policyPrefix${p.id}',
        spotIds: [p.spotId],
        effect: RuleEffect.permits,
        summary: p.summary,
        source: p.source,
        effectiveFrom: DateTime.utc(2000),
        lastVerifiedAt: p.lastVerifiedAt,
        vehicles: p.vehicles,
        schedule: p.openMinute == null || p.closeMinute == null
            ? Schedule.always
            : Schedule(windows: [TimeWindow(p.openMinute!, p.closeMinute!)]),
        maxStayMinutes: p.maxStayMinutes,
        fee: p.fee,
        conditions: [
          if (p.eligibility != Eligibility.public) p.eligibility.label,
          if (p.openMinute != null && p.closeMinute != null)
            'Gate hours ${formatMinuteOfDay(p.openMinute!)}–${formatMinuteOfDay(p.closeMinute!)}',
        ],
      );

  (DateTime, ParkingRule)? _nextProhibitionAfter(List<ParkingRule> rules, DateTime from, Duration window) {
    final to = from.add(window);
    (DateTime, ParkingRule)? best;
    for (final r in rules.where((r) => r.effect == RuleEffect.prohibits)) {
      for (final t in [from, ...r.boundaries(from, to)]) {
        if (r.activeAt(t) && (best == null || t.isBefore(best.$1))) {
          best = (t, r);
          break;
        }
      }
    }
    return best;
  }

  static T? _firstOrNull<T>(Iterable<T> it) => it.isEmpty ? null : it.first;

  static bool _canPermit(EvidenceSource s) => s.cls == SourceClass.official || s.cls == SourceClass.operator;

  static String _vehicles(Set<VehicleClass> v) =>
      v.isEmpty ? 'all vehicles' : v.map((e) => e.label.toLowerCase()).join(' and ');
}

class _Acc {
  _Acc(this.req)
      : deadline = req.end,
        deadlineReason = 'Your planned return';

  final AssessmentRequest req;
  final findings = <Finding>[];
  final blockers = <Finding>[];
  final conditions = <String>[];
  final unknowns = <String>[];
  final sources = <String, EvidenceSource>{};
  final verifiedAt = <String, DateTime>{};
  final ids = <String>[];
  DateTime deadline;
  String deadlineReason;
  DateTime? restrictionFrom;

  void add(Dimension d, Level l, String title, {String? detail, SourceClass? source, String? url, List<String> ids = const []}) =>
      findings.add(Finding(dimension: d, level: l, title: title, detail: detail, source: source, url: url, evidenceIds: ids));

  void blocker(Dimension d, String title, {String? detail, SourceClass? source, String? url, List<String> ids = const []}) {
    final f = Finding(dimension: d, level: Level.blocker, title: title, detail: detail, source: source, url: url, evidenceIds: ids);
    blockers.add(f);
    findings.add(f);
  }

  void condition(String c) {
    if (!conditions.contains(c)) conditions.add(c);
  }

  void unknown(String u) {
    if (!unknowns.contains(u)) unknowns.add(u);
  }

  void use(EvidenceSource s, String id, DateTime verified) {
    sources[s.id] = s;
    verifiedAt[id] = verified;
    if (!ids.contains(id)) ids.add(id);
  }

  void deadlineAt(DateTime t, String why) {
    if (t.isBefore(deadline)) {
      deadline = t;
      deadlineReason = why;
    }
  }

  Assessment build({
    required Verdict verdict,
    required String headline,
    required String reason,
    required int evidenceVersion,
    required DateTime now,
    bool communitySupport = false,
  }) =>
      Assessment(
        request: req,
        verdict: verdict,
        headline: headline,
        reason: reason,
        conditions: List.unmodifiable(conditions),
        blockers: List.unmodifiable(blockers),
        findings: List.unmodifiable(findings),
        unknowns: List.unmodifiable(unknowns),
        evaluatedAt: now,
        evidenceVersion: evidenceVersion,
        deadline: deadline,
        deadlineReason: deadlineReason,
        appliedEvidenceIds: List.unmodifiable(ids),
        communitySupport: communitySupport,
        restrictionFrom: restrictionFrom,
      );
}
