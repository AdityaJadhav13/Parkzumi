import 'dart:typed_data';

import '../../domain/models.dart';

/// Errors a client can observe. [retryable] decides whether the outbox retries.
sealed class ServiceException implements Exception {
  const ServiceException(this.message);

  final String message;
  bool get retryable;
  String get code;

  @override
  String toString() => '$code: $message';
}

final class NetworkUnavailable extends ServiceException {
  const NetworkUnavailable() : super('No connection');
  @override
  bool get retryable => true;
  @override
  String get code => 'offline';
}

/// The client waited and got nothing back. It cannot tell whether the server
/// applied the request, which is why every write carries an operation id.
final class RequestTimedOut extends ServiceException {
  const RequestTimedOut() : super('No response from the server');
  @override
  bool get retryable => true;
  @override
  String get code => 'timeout';
}

final class ServerUnavailable extends ServiceException {
  const ServerUnavailable() : super('Server unavailable (503)');
  @override
  bool get retryable => true;
  @override
  String get code => '503';
}

/// Something this request depends on has not arrived yet (e.g. its photo).
final class PreconditionPending extends ServiceException {
  const PreconditionPending(super.message);
  @override
  bool get retryable => true;
  @override
  String get code => '425';
}

final class ValidationFailed extends ServiceException {
  const ValidationFailed(super.message);
  @override
  bool get retryable => false;
  @override
  String get code => '422';
}

/// The record changed since the caller read it (optimistic concurrency).
final class StaleVersion extends ServiceException {
  const StaleVersion(super.message);
  @override
  bool get retryable => false;
  @override
  String get code => '409';
}

final class NotFound extends ServiceException {
  const NotFound(super.message);
  @override
  bool get retryable => false;
  @override
  String get code => '404';
}

/// Lifecycle of a rider's tip. `queued` and `sending` exist only on the device;
/// the rest are decided by the server.
enum TipStatus {
  queued('Saved on your phone'),
  sending('Sending'),
  received('Waiting for review'),
  accepted('Accepted'),
  rejected('Not accepted'),
  failed('Couldn’t send');

  const TipStatus(this.label);
  final String label;
  bool get isFinal => this == accepted || this == rejected || this == failed;
}

class TipSubmission {
  const TipSubmission({required this.observation, required this.authorId, this.photoId});

  final Observation observation;
  final String authorId;
  final String? photoId;

  String get tipId => observation.id;

  Json toJson() => {'observation': observation.toJson(), 'authorId': authorId, 'photoId': photoId};

  factory TipSubmission.fromJson(Json j) => TipSubmission(
        observation: Observation.fromJson(asJson(j['observation'])),
        authorId: j['authorId']! as String,
        photoId: j['photoId'] as String?,
      );
}

class TipReceipt {
  const TipReceipt({required this.tipId, required this.status, required this.version, required this.deduplicated});

  final String tipId;
  final TipStatus status;
  final int version;

  /// True when the server had already applied this operation or tip.
  final bool deduplicated;

  Json toJson() => {'tipId': tipId, 'status': status.name, 'version': version};

  factory TipReceipt.fromJson(Json j, {bool deduplicated = false}) => TipReceipt(
        tipId: j['tipId']! as String,
        status: TipStatus.values.byName(j['status']! as String),
        version: j['version']! as int,
        deduplicated: deduplicated,
      );
}

class TipState {
  const TipState({
    required this.tipId,
    required this.status,
    required this.version,
    this.reviewNote,
    this.points = 0,
    this.reviewedAt,
  });

  final String tipId;
  final TipStatus status;
  final int version;
  final String? reviewNote;
  final int points;
  final DateTime? reviewedAt;
}

class ReviewItem {
  const ReviewItem({
    required this.tipId,
    required this.version,
    required this.status,
    required this.observation,
    required this.authorId,
    required this.submittedAt,
    this.photoPath,
    this.reviewNote,
  });

  final String tipId;
  final int version;
  final TipStatus status;
  final Observation observation;
  final String authorId;
  final DateTime submittedAt;
  final String? photoPath;
  final String? reviewNote;
}

class EvidenceEnvelope {
  const EvidenceEnvelope({required this.version, this.snapshot});

  final int version;

  /// Null when the client already has [version].
  final EvidenceSnapshot? snapshot;
}

class TemporaryOrderInput {
  const TemporaryOrderInput({
    required this.spotId,
    required this.summary,
    required this.from,
    required this.until,
    this.vehicles = const {},
  });

  final String spotId;
  final String summary;
  final DateTime from;
  final DateTime until;
  final Set<VehicleClass> vehicles;
}

/// What the rider app may ask of the server.
abstract interface class ParkingService {
  Future<EvidenceEnvelope> fetchEvidence({int? knownVersion});
  Future<void> uploadPhoto({required String opId, required String photoId, required Uint8List bytes});
  Future<TipReceipt> submitTip({required String opId, required TipSubmission tip});
  Future<List<TipState>> tipStates(List<String> tipIds);
  Future<int> pointsBalance(String userId);
}

/// What a community reviewer may do. A separate client in production.
abstract interface class ReviewService {
  Future<List<ReviewItem>> reviewQueue();
  Future<List<ReviewItem>> recentlyReviewed();
  Future<TipState> reviewTip({
    required String tipId,
    required int expectedVersion,
    required bool accept,
    required String reviewerId,
    String? note,
  });
  Future<int> publishTemporaryOrder(TemporaryOrderInput input, {required String reviewerId});
  Future<int> withdrawRule(String ruleId, {required String reviewerId});
  Future<EvidenceSnapshot> currentEvidence();
}

/// Where components write diagnostic events.
abstract interface class DiagnosticsSink {
  Future<void> record(String type, {String origin, String? correlationId, Map<String, Object?> attrs});
}
