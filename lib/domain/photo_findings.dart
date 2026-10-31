import 'models.dart';

enum SignKind {
  noParking('No parking'),
  noStopping('No stopping'),
  towAway('Tow-away zone'),
  parkingAllowed('Parking allowed'),
  timeLimit('Time limit'),
  other('Other sign');

  const SignKind(this.label);
  final String label;
  bool get prohibits => this == noParking || this == noStopping || this == towAway;
}

enum SceneObjectKind {
  entrance('Entrance'),
  gate('Gate'),
  driveway('Driveway'),
  fireEquipment('Fire equipment'),
  hydrant('Hydrant'),
  pillar('Pillar'),
  pedestrianCrossing('Pedestrian crossing'),
  busStop('Bus stop'),
  footpath('Footpath'),
  roadEdge('Road edge'),
  other('Object');

  const SceneObjectKind(this.label);
  final String label;
}

class SignFinding {
  const SignFinding({required this.kind, required this.text, required this.confidence});

  final SignKind kind;
  final String text;
  final double confidence;

  Json toJson() => {'kind': kind.name, 'text': text, 'confidence': confidence};
  factory SignFinding.fromJson(Json j) => SignFinding(
        kind: SignKind.values.byName(j['kind']! as String),
        text: j['text'] as String? ?? '',
        confidence: (j['confidence']! as num).toDouble(),
      );
}

class SceneObject {
  const SceneObject({
    required this.kind,
    required this.label,
    required this.nearSpot,
    required this.possibleObstruction,
    required this.confidence,
  });

  final SceneObjectKind kind;
  final String label;
  final bool nearSpot;
  final bool possibleObstruction;
  final double confidence;

  Json toJson() => {
        'kind': kind.name,
        'label': label,
        'nearSpot': nearSpot,
        'possibleObstruction': possibleObstruction,
        'confidence': confidence,
      };
  factory SceneObject.fromJson(Json j) => SceneObject(
        kind: SceneObjectKind.values.byName(j['kind']! as String),
        label: j['label'] as String? ?? '',
        nearSpot: j['nearSpot'] as bool? ?? false,
        possibleObstruction: j['possibleObstruction'] as bool? ?? false,
        confidence: (j['confidence']! as num).toDouble(),
      );
}

/// Structured observations from a surroundings photo. Observations only:
/// a model never grants permission, and its output is not a source of law.
class PhotoFindings {
  const PhotoFindings({
    required this.signs,
    required this.objects,
    required this.uncertainties,
    required this.model,
    required this.analysedAt,
  });

  final List<SignFinding> signs;
  final List<SceneObject> objects;
  final List<String> uncertainties;
  final String model;
  final DateTime analysedAt;

  static const minConfidence = 0.5;

  Iterable<SignFinding> get confidentSigns => signs.where((s) => s.confidence >= minConfidence);

  Json toJson() => {
        'signs': [for (final s in signs) s.toJson()],
        'objects': [for (final o in objects) o.toJson()],
        'uncertainties': uncertainties,
        'model': model,
        'analysedAt': analysedAt.toUtc().toIso8601String(),
      };

  factory PhotoFindings.fromJson(Json j) => PhotoFindings(
        signs: [for (final s in asJsonList(j['signs'])) SignFinding.fromJson(s)],
        objects: [for (final o in asJsonList(j['objects'])) SceneObject.fromJson(o)],
        uncertainties: (j['uncertainties'] as List? ?? const []).cast<String>(),
        model: j['model']! as String,
        analysedAt: DateTime.parse(j['analysedAt']! as String),
      );
}
