import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'device_db.dart';

class CachedEvidence {
  const CachedEvidence(this.snapshot, this.fetchedAt);

  final EvidenceSnapshot snapshot;

  /// When this device last received it. Age is shown, never hidden.
  final DateTime fetchedAt;
}

/// The device's copy of published evidence. The server owns the evidence;
/// this cache lets the app answer offline, with its age attached.
class EvidenceRepository {
  EvidenceRepository(this.db);

  final DeviceDb db;

  Stream<CachedEvidence?> watch() =>
      (db.select(db.evidenceCache)..where((t) => t.slot.equals(0))).watchSingleOrNull().map(_parse);

  Future<CachedEvidence?> current() async =>
      _parse(await (db.select(db.evidenceCache)..where((t) => t.slot.equals(0))).getSingleOrNull());

  /// First launch: start from the evidence bundled with the app.
  Future<void> ensureBundled(EvidenceSnapshot bundled, DateTime bundledAt) async {
    if (await current() == null) await save(bundled, bundledAt);
  }

  Future<void> save(EvidenceSnapshot s, DateTime fetchedAt) => db.into(db.evidenceCache).insertOnConflictUpdate(
      EvidenceCacheCompanion.insert(slot: const Value(0), version: s.version, json: jsonEncode(s.toJson()), fetchedAt: fetchedAt));

  Future<void> touch(DateTime fetchedAt) => (db.update(db.evidenceCache)..where((t) => t.slot.equals(0)))
      .write(EvidenceCacheCompanion(fetchedAt: Value(fetchedAt)));

  static CachedEvidence? _parse(EvidenceCacheData? row) =>
      row == null ? null : CachedEvidence(EvidenceSnapshot.fromJson(asJson(jsonDecode(row.json))), row.fetchedAt);
}
