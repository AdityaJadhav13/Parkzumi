import 'models.dart';
import 'photo_findings.dart';

/// The permission answer, decided only from reviewed official or operator
/// evidence. Community reports and AI observations sit beside it as findings.
enum Verdict {
  permitted('Permitted'),
  conditional('Allowed with conditions'),
  prohibited('Restriction found'),
  unknown('Can’t verify');

  const Verdict(this.label);
  final String label;
}

/// Assessment dimensions are kept separate; they are never merged into a score.
enum Dimension {
  restrictions('Rules'),
  access('Property access'),
  community('Rider experiences'),
  leaveReturn('Leaving & returning'),
  physical('At the spot'),
  evidence('Evidence quality');

  const Dimension(this.label);
  final String label;
}

enum Level { good, info, caution, blocker, unknown }

class Finding {
  const Finding({
    required this.dimension,
    required this.level,
    required this.title,
    this.detail,
    this.source,
    this.url,
    this.evidenceIds = const [],
  });

  final Dimension dimension;
  final Level level;
  final String title;
  final String? detail;
  final SourceClass? source;
  final String? url;
  final List<String> evidenceIds;

  Json toJson() => {
        'dimension': dimension.name,
        'level': level.name,
        'title': title,
        'detail': detail,
        'source': source?.name,
        'url': url,
        'evidenceIds': evidenceIds,
      };
}

class AssessmentRequest {
  const AssessmentRequest({
    required this.spotId,
    required this.vehicle,
    required this.start,
    required this.stay,
    this.photo,
    this.locationAccuracyM,
    this.distanceToSpotM,
  });

  final String spotId;
  final VehicleClass vehicle;
  final DateTime start;
  final Duration stay;
  final PhotoFindings? photo;
  final double? locationAccuracyM;
  final double? distanceToSpotM;

  DateTime get end => start.add(stay);

  Json toJson() => {
        'spotId': spotId,
        'vehicle': vehicle.name,
        'start': start.toUtc().toIso8601String(),
        'stayMinutes': stay.inMinutes,
        'photo': photo?.toJson(),
        'locationAccuracyM': locationAccuracyM,
        'distanceToSpotM': distanceToSpotM,
      };
}

class Assessment {
  const Assessment({
    required this.request,
    required this.verdict,
    required this.headline,
    required this.reason,
    required this.conditions,
    required this.blockers,
    required this.findings,
    required this.unknowns,
    required this.evaluatedAt,
    required this.evidenceVersion,
    required this.deadline,
    required this.deadlineReason,
    required this.appliedEvidenceIds,
    required this.communitySupport,
    this.restrictionFrom,
  });

  final AssessmentRequest request;
  final Verdict verdict;
  final String headline;
  final String reason;

  /// What the rider must do or accept for the verdict to hold.
  final List<String> conditions;

  /// Concrete problems with the rider's plan (gate closes before return, …).
  final List<Finding> blockers;
  final List<Finding> findings;

  /// What remains unknown. Shown, never hidden behind a score.
  final List<String> unknowns;
  final DateTime evaluatedAt;
  final int evidenceVersion;

  /// Earliest moment the rider should be back (return time, restriction start,
  /// gate closing, maximum stay).
  final DateTime deadline;
  final String deadlineReason;
  final List<String> appliedEvidenceIds;

  /// Reviewed rider reports of successful stays at least as long as this one.
  final bool communitySupport;

  /// When the first restriction applies during the stay (null if none does).
  final DateTime? restrictionFrom;

  bool get fitsStay => verdict != Verdict.prohibited && blockers.isEmpty;

  /// A restriction already applies when the stay begins.
  bool get restrictedAtStart => restrictionFrom != null && !restrictionFrom!.isAfter(request.start);

  Iterable<Finding> inDimension(Dimension d) => findings.where((f) => f.dimension == d);

  Json toJson() => {
        'request': request.toJson(),
        'verdict': verdict.name,
        'headline': headline,
        'reason': reason,
        'conditions': conditions,
        'blockers': [for (final b in blockers) b.toJson()],
        'findings': [for (final f in findings) f.toJson()],
        'unknowns': unknowns,
        'evaluatedAt': evaluatedAt.toUtc().toIso8601String(),
        'evidenceVersion': evidenceVersion,
        'deadline': deadline.toUtc().toIso8601String(),
        'restrictionFrom': restrictionFrom?.toUtc().toIso8601String(),
        'deadlineReason': deadlineReason,
        'appliedEvidenceIds': appliedEvidenceIds,
        'communitySupport': communitySupport,
      };
}
