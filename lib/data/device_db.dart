import 'package:drift/drift.dart';

part 'device_db.g.dart';

/// On-device store. Source of truth for drafts, pending operations, parking
/// sessions and the cached copy of published evidence.

class KvEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// The latest evidence snapshot this device has, and when it was fetched.
class EvidenceCache extends Table {
  IntColumn get slot => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {slot};
}

class Tips extends Table {
  TextColumn get id => text()();
  TextColumn get spotId => text()();
  TextColumn get payload => text()();
  TextColumn get photoId => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get status => text()();
  IntColumn get serverVersion => integer().nullable()();
  TextColumn get reviewNote => text().nullable()();
  TextColumn get failure => text().nullable()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Operations waiting to reach the server. Each has a stable id so a retry is
/// recognised by the server instead of creating a duplicate.
class OutboxOps extends Table {
  TextColumn get opId => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  TextColumn get correlationId => text()();
  TextColumn get dependsOn => text().nullable()();
  TextColumn get state => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {opId};
}

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get spotId => text()();
  TextColumn get spotName => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  TextColumn get vehicle => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get plannedEndAt => dateTime()();
  DateTimeColumn get deadlineAt => dateTime()();
  TextColumn get deadlineReason => text()();
  TextColumn get verdict => text()();
  TextColumn get headline => text()();
  IntColumn get evidenceVersion => integer()();
  TextColumn get assessmentId => text()();
  TextColumn get state => text()();
  TextColumn get missingStatus => text().nullable()();

  /// Set when newer evidence changed the conditions after parking.
  TextColumn get changeNote => text().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Every assessment shown, with its inputs and evidence version, so a result
/// can be reconstructed later.
class AssessmentLog extends Table {
  TextColumn get id => text()();
  TextColumn get spotId => text()();
  TextColumn get verdict => text()();
  IntColumn get evidenceVersion => integer()();
  TextColumn get json => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EventLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  TextColumn get origin => text()();
  TextColumn get type => text()();
  TextColumn get correlationId => text().nullable()();
  TextColumn get attrs => text()();
}

@DriftDatabase(tables: [KvEntries, EvidenceCache, Tips, OutboxOps, Sessions, AssessmentLog, EventLog])
class DeviceDb extends _$DeviceDb {
  DeviceDb(super.e);

  @override
  int get schemaVersion => 1;

  Future<String?> getKv(String key) async =>
      (await (select(kvEntries)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setKv(String key, String value) =>
      into(kvEntries).insertOnConflictUpdate(KvEntriesCompanion.insert(key: key, value: value));

  Stream<String?> watchKv(String key) =>
      (select(kvEntries)..where((t) => t.key.equals(key))).watchSingleOrNull().map((r) => r?.value);
}
