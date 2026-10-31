import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../domain/models.dart';
import 'device_db.dart';
import 'event_logger.dart';
import 'ids.dart';
import 'server/parking_service.dart';

class TipDraft {
  const TipDraft({
    required this.spotId,
    required this.vehicle,
    required this.eventTime,
    required this.stayMinutes,
    required this.outcome,
    this.leftPremises = Tri.unknown,
    this.staffCheck = StaffCheck.unknown,
    this.note,
    this.photoSourcePath,
  });

  final String spotId;
  final VehicleClass vehicle;
  final DateTime eventTime;
  final int stayMinutes;
  final TipOutcome outcome;
  final Tri leftPremises;
  final StaffCheck staffCheck;
  final String? note;
  final String? photoSourcePath;
}

abstract final class OpKind {
  static const uploadPhoto = 'uploadPhoto';
  static const submitTip = 'submitTip';
}

abstract final class OpState {
  static const pending = 'pending';
  static const inFlight = 'inFlight';
  static const done = 'done';
  static const failed = 'failed';
}

/// Rider contributions. A tip is written locally together with its outbox
/// operations in one transaction, so it is never half-saved.
class TipsService {
  TipsService({
    required this.db,
    required this.log,
    required this.photosDir,
    required this.authorId,
    required this.onQueued,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DeviceDb db;
  final EventLogger log;
  final String photosDir;
  final String authorId;
  final void Function() onQueued;
  final DateTime Function() _clock;

  Future<String> submit(TipDraft d) async {
    final tipId = newId('tip');
    final now = _clock();
    final note = d.note?.trim();
    String? photoId;
    String? photoPath;
    final source = d.photoSourcePath;
    if (source != null) {
      photoId = newId('photo');
      await Directory(photosDir).create(recursive: true);
      photoPath = p.join(photosDir, '$photoId.jpg');
      await File(source).copy(photoPath);
    }
    final observation = Observation(
      id: tipId,
      spotId: d.spotId,
      vehicle: d.vehicle,
      eventTime: d.eventTime,
      submittedAt: now,
      stayMinutes: d.stayMinutes,
      outcome: d.outcome,
      leftPremises: d.leftPremises,
      staffCheck: d.staffCheck,
      note: note == null || note.isEmpty ? null : note,
    );
    final submission = TipSubmission(observation: observation, authorId: authorId, photoId: photoId);
    final photoOp = photoId == null ? null : newId('op');
    final tipOp = newId('op');

    await db.transaction(() async {
      await db.into(db.tips).insert(TipsCompanion.insert(
            id: tipId,
            spotId: d.spotId,
            payload: jsonEncode(observation.toJson()),
            photoId: Value(photoId),
            photoPath: Value(photoPath),
            status: TipStatus.queued.name,
            createdAt: now,
            updatedAt: now,
          ));
      if (photoOp != null) {
        await db.into(db.outboxOps).insert(OutboxOpsCompanion.insert(
              opId: photoOp,
              kind: OpKind.uploadPhoto,
              payload: jsonEncode({'photoId': photoId, 'path': photoPath}),
              correlationId: tipId,
              state: OpState.pending,
              nextAttemptAt: now,
              createdAt: now,
            ));
      }
      await db.into(db.outboxOps).insert(OutboxOpsCompanion.insert(
            opId: tipOp,
            kind: OpKind.submitTip,
            payload: jsonEncode(submission.toJson()),
            correlationId: tipId,
            dependsOn: Value(photoOp),
            state: OpState.pending,
            nextAttemptAt: now,
            createdAt: now,
          ));
    });
    await log.record('tip.queued', correlationId: tipId, attrs: {
      'spotId': d.spotId,
      'ops': [?photoOp, tipOp],
      'withPhoto': photoId != null,
    });
    onQueued();
    return tipId;
  }

  Stream<List<Tip>> watchTips() =>
      (db.select(db.tips)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  /// Re-queue a tip the server rejected as invalid is not possible; only
  /// transient failures retry automatically. This discards a failed draft.
  Future<void> discard(String tipId) async {
    await db.transaction(() async {
      await (db.delete(db.outboxOps)..where((t) => t.correlationId.equals(tipId))).go();
      await (db.delete(db.tips)..where((t) => t.id.equals(tipId))).go();
    });
    await log.record('tip.discarded', correlationId: tipId);
  }
}
