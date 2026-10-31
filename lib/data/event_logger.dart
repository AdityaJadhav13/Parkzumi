import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'device_db.dart';
import 'server/parking_service.dart';

/// Structured diagnostic events, persisted so an assessment, retry, conflict
/// or delivery failure can be reconstructed after the fact.
///
/// Never log photos, free-text notes or exact coordinates.
class EventLogger implements DiagnosticsSink {
  EventLogger(this.db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DeviceDb db;
  final DateTime Function() _clock;
  static const keep = 2000;
  var _writes = 0;

  /// Optional sink for an external monitoring tool (set at the composition root).
  void Function(String type, String origin, String? correlationId, Map<String, Object?> attrs)? forward;

  @override
  Future<void> record(
    String type, {
    String origin = 'app',
    String? correlationId,
    Map<String, Object?> attrs = const {},
  }) async {
    final encoded = jsonEncode(attrs);
    debugPrint('[parkzumi] $origin $type${correlationId == null ? '' : ' $correlationId'} $encoded');
    try {
      await db.into(db.eventLog).insert(EventLogCompanion.insert(
            at: _clock(),
            origin: origin,
            type: type,
            correlationId: Value(correlationId),
            attrs: encoded,
          ));
      if (++_writes % 200 == 0) await _prune();
      forward?.call(type, origin, correlationId, attrs);
    } catch (e) {
      // Diagnostics must never break the flow being diagnosed.
      debugPrint('[parkzumi] event log write failed: $e');
    }
  }

  Stream<List<EventLogData>> watch({int limit = 300}) => (db.select(db.eventLog)
        ..orderBy([(t) => OrderingTerm.desc(t.id)])
        ..limit(limit))
      .watch();

  Future<String> exportJson() async {
    final rows = await (db.select(db.eventLog)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return const JsonEncoder.withIndent('  ').convert([
      for (final r in rows)
        {
          'at': r.at.toUtc().toIso8601String(),
          'origin': r.origin,
          'type': r.type,
          'correlationId': r.correlationId,
          'attrs': jsonDecode(r.attrs),
        },
    ]);
  }

  Future<void> _prune() async {
    final cutoff = await (db.selectOnly(db.eventLog)..addColumns([db.eventLog.id.max()])).getSingle();
    final maxId = cutoff.read(db.eventLog.id.max()) ?? 0;
    await (db.delete(db.eventLog)..where((t) => t.id.isSmallerOrEqualValue(maxId - keep))).go();
  }
}
