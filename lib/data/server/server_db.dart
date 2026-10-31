import 'package:drift/drift.dart';

part 'server_db.g.dart';

/// Store of the simulated server. Kept in its own database file so it behaves
/// like a separate authority: the app only reaches it through ParkingService.

/// Results of operations already applied, keyed by the client's operation id.
class SrvOperations extends Table {
  TextColumn get opId => text()();
  TextColumn get kind => text()();
  TextColumn get resultJson => text()();
  DateTimeColumn get committedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {opId};
}

class SrvTips extends Table {
  TextColumn get id => text()();
  TextColumn get spotId => text()();
  TextColumn get authorId => text()();
  TextColumn get payload => text()();
  TextColumn get photoId => text().nullable()();
  TextColumn get status => text()();
  IntColumn get version => integer()();
  DateTimeColumn get submittedAt => dateTime()();
  DateTimeColumn get reviewedAt => dateTime().nullable()();
  TextColumn get reviewerId => text().nullable()();
  TextColumn get reviewNote => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SrvPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get path => text()();
  IntColumn get sizeBytes => integer()();
  DateTimeColumn get uploadedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One reward per accepted tip: the primary key makes a second grant impossible.
class SrvRewards extends Table {
  TextColumn get tipId => text()();
  TextColumn get userId => text()();
  IntColumn get points => integer()();
  DateTimeColumn get grantedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {tipId};
}

class SrvEvidence extends Table {
  IntColumn get slot => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text()();
  DateTimeColumn get publishedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {slot};
}

class SrvAudit extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  TextColumn get actor => text()();
  TextColumn get action => text()();
  TextColumn get target => text()();
  TextColumn get details => text()();
}

@DriftDatabase(tables: [SrvOperations, SrvTips, SrvPhotos, SrvRewards, SrvEvidence, SrvAudit])
class ServerDb extends _$ServerDb {
  ServerDb(super.e);

  @override
  int get schemaVersion => 1;
}
