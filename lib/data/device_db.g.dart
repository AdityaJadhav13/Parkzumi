// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_db.dart';

// ignore_for_file: type=lint
class $KvEntriesTable extends KvEntries
    with TableInfo<$KvEntriesTable, KvEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KvEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kv_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KvEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KvEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KvEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $KvEntriesTable createAlias(String alias) {
    return $KvEntriesTable(attachedDatabase, alias);
  }
}

class KvEntry extends DataClass implements Insertable<KvEntry> {
  final String key;
  final String value;
  const KvEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KvEntriesCompanion toCompanion(bool nullToAbsent) {
    return KvEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory KvEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KvEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KvEntry copyWith({String? key, String? value}) =>
      KvEntry(key: key ?? this.key, value: value ?? this.value);
  KvEntry copyWithCompanion(KvEntriesCompanion data) {
    return KvEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KvEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KvEntry && other.key == this.key && other.value == this.value);
}

class KvEntriesCompanion extends UpdateCompanion<KvEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KvEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KvEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<KvEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KvEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return KvEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KvEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceCacheTable extends EvidenceCache
    with TableInfo<$EvidenceCacheTable, EvidenceCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, version, json, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  EvidenceCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceCacheData(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $EvidenceCacheTable createAlias(String alias) {
    return $EvidenceCacheTable(attachedDatabase, alias);
  }
}

class EvidenceCacheData extends DataClass
    implements Insertable<EvidenceCacheData> {
  final int slot;
  final int version;
  final String json;
  final DateTime fetchedAt;
  const EvidenceCacheData({
    required this.slot,
    required this.version,
    required this.json,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['version'] = Variable<int>(version);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  EvidenceCacheCompanion toCompanion(bool nullToAbsent) {
    return EvidenceCacheCompanion(
      slot: Value(slot),
      version: Value(version),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory EvidenceCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceCacheData(
      slot: serializer.fromJson<int>(json['slot']),
      version: serializer.fromJson<int>(json['version']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'version': serializer.toJson<int>(version),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  EvidenceCacheData copyWith({
    int? slot,
    int? version,
    String? json,
    DateTime? fetchedAt,
  }) => EvidenceCacheData(
    slot: slot ?? this.slot,
    version: version ?? this.version,
    json: json ?? this.json,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  EvidenceCacheData copyWithCompanion(EvidenceCacheCompanion data) {
    return EvidenceCacheData(
      slot: data.slot.present ? data.slot.value : this.slot,
      version: data.version.present ? data.version.value : this.version,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceCacheData(')
          ..write('slot: $slot, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, version, json, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceCacheData &&
          other.slot == this.slot &&
          other.version == this.version &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt);
}

class EvidenceCacheCompanion extends UpdateCompanion<EvidenceCacheData> {
  final Value<int> slot;
  final Value<int> version;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  const EvidenceCacheCompanion({
    this.slot = const Value.absent(),
    this.version = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  EvidenceCacheCompanion.insert({
    this.slot = const Value.absent(),
    required int version,
    required String json,
    required DateTime fetchedAt,
  }) : version = Value(version),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<EvidenceCacheData> custom({
    Expression<int>? slot,
    Expression<int>? version,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (version != null) 'version': version,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  EvidenceCacheCompanion copyWith({
    Value<int>? slot,
    Value<int>? version,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
  }) {
    return EvidenceCacheCompanion(
      slot: slot ?? this.slot,
      version: version ?? this.version,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceCacheCompanion(')
          ..write('slot: $slot, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $TipsTable extends Tips with TableInfo<$TipsTable, Tip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spotIdMeta = const VerificationMeta('spotId');
  @override
  late final GeneratedColumn<String> spotId = GeneratedColumn<String>(
    'spot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoIdMeta = const VerificationMeta(
    'photoId',
  );
  @override
  late final GeneratedColumn<String> photoId = GeneratedColumn<String>(
    'photo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewNoteMeta = const VerificationMeta(
    'reviewNote',
  );
  @override
  late final GeneratedColumn<String> reviewNote = GeneratedColumn<String>(
    'review_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _failureMeta = const VerificationMeta(
    'failure',
  );
  @override
  late final GeneratedColumn<String> failure = GeneratedColumn<String>(
    'failure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spotId,
    payload,
    photoId,
    photoPath,
    status,
    serverVersion,
    reviewNote,
    failure,
    points,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('spot_id')) {
      context.handle(
        _spotIdMeta,
        spotId.isAcceptableOrUnknown(data['spot_id']!, _spotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('photo_id')) {
      context.handle(
        _photoIdMeta,
        photoId.isAcceptableOrUnknown(data['photo_id']!, _photoIdMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('review_note')) {
      context.handle(
        _reviewNoteMeta,
        reviewNote.isAcceptableOrUnknown(data['review_note']!, _reviewNoteMeta),
      );
    }
    if (data.containsKey('failure')) {
      context.handle(
        _failureMeta,
        failure.isAcceptableOrUnknown(data['failure']!, _failureMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      photoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_id'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      ),
      reviewNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_note'],
      ),
      failure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TipsTable createAlias(String alias) {
    return $TipsTable(attachedDatabase, alias);
  }
}

class Tip extends DataClass implements Insertable<Tip> {
  final String id;
  final String spotId;
  final String payload;
  final String? photoId;
  final String? photoPath;
  final String status;
  final int? serverVersion;
  final String? reviewNote;
  final String? failure;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Tip({
    required this.id,
    required this.spotId,
    required this.payload,
    this.photoId,
    this.photoPath,
    required this.status,
    this.serverVersion,
    this.reviewNote,
    this.failure,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['spot_id'] = Variable<String>(spotId);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || photoId != null) {
      map['photo_id'] = Variable<String>(photoId);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || reviewNote != null) {
      map['review_note'] = Variable<String>(reviewNote);
    }
    if (!nullToAbsent || failure != null) {
      map['failure'] = Variable<String>(failure);
    }
    map['points'] = Variable<int>(points);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TipsCompanion toCompanion(bool nullToAbsent) {
    return TipsCompanion(
      id: Value(id),
      spotId: Value(spotId),
      payload: Value(payload),
      photoId: photoId == null && nullToAbsent
          ? const Value.absent()
          : Value(photoId),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      status: Value(status),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      reviewNote: reviewNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewNote),
      failure: failure == null && nullToAbsent
          ? const Value.absent()
          : Value(failure),
      points: Value(points),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Tip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tip(
      id: serializer.fromJson<String>(json['id']),
      spotId: serializer.fromJson<String>(json['spotId']),
      payload: serializer.fromJson<String>(json['payload']),
      photoId: serializer.fromJson<String?>(json['photoId']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      status: serializer.fromJson<String>(json['status']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      reviewNote: serializer.fromJson<String?>(json['reviewNote']),
      failure: serializer.fromJson<String?>(json['failure']),
      points: serializer.fromJson<int>(json['points']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spotId': serializer.toJson<String>(spotId),
      'payload': serializer.toJson<String>(payload),
      'photoId': serializer.toJson<String?>(photoId),
      'photoPath': serializer.toJson<String?>(photoPath),
      'status': serializer.toJson<String>(status),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'reviewNote': serializer.toJson<String?>(reviewNote),
      'failure': serializer.toJson<String?>(failure),
      'points': serializer.toJson<int>(points),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Tip copyWith({
    String? id,
    String? spotId,
    String? payload,
    Value<String?> photoId = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    String? status,
    Value<int?> serverVersion = const Value.absent(),
    Value<String?> reviewNote = const Value.absent(),
    Value<String?> failure = const Value.absent(),
    int? points,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Tip(
    id: id ?? this.id,
    spotId: spotId ?? this.spotId,
    payload: payload ?? this.payload,
    photoId: photoId.present ? photoId.value : this.photoId,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    status: status ?? this.status,
    serverVersion: serverVersion.present
        ? serverVersion.value
        : this.serverVersion,
    reviewNote: reviewNote.present ? reviewNote.value : this.reviewNote,
    failure: failure.present ? failure.value : this.failure,
    points: points ?? this.points,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Tip copyWithCompanion(TipsCompanion data) {
    return Tip(
      id: data.id.present ? data.id.value : this.id,
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      payload: data.payload.present ? data.payload.value : this.payload,
      photoId: data.photoId.present ? data.photoId.value : this.photoId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      status: data.status.present ? data.status.value : this.status,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      reviewNote: data.reviewNote.present
          ? data.reviewNote.value
          : this.reviewNote,
      failure: data.failure.present ? data.failure.value : this.failure,
      points: data.points.present ? data.points.value : this.points,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tip(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('payload: $payload, ')
          ..write('photoId: $photoId, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('failure: $failure, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spotId,
    payload,
    photoId,
    photoPath,
    status,
    serverVersion,
    reviewNote,
    failure,
    points,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tip &&
          other.id == this.id &&
          other.spotId == this.spotId &&
          other.payload == this.payload &&
          other.photoId == this.photoId &&
          other.photoPath == this.photoPath &&
          other.status == this.status &&
          other.serverVersion == this.serverVersion &&
          other.reviewNote == this.reviewNote &&
          other.failure == this.failure &&
          other.points == this.points &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TipsCompanion extends UpdateCompanion<Tip> {
  final Value<String> id;
  final Value<String> spotId;
  final Value<String> payload;
  final Value<String?> photoId;
  final Value<String?> photoPath;
  final Value<String> status;
  final Value<int?> serverVersion;
  final Value<String?> reviewNote;
  final Value<String?> failure;
  final Value<int> points;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TipsCompanion({
    this.id = const Value.absent(),
    this.spotId = const Value.absent(),
    this.payload = const Value.absent(),
    this.photoId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.failure = const Value.absent(),
    this.points = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TipsCompanion.insert({
    required String id,
    required String spotId,
    required String payload,
    this.photoId = const Value.absent(),
    this.photoPath = const Value.absent(),
    required String status,
    this.serverVersion = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.failure = const Value.absent(),
    this.points = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spotId = Value(spotId),
       payload = Value(payload),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Tip> custom({
    Expression<String>? id,
    Expression<String>? spotId,
    Expression<String>? payload,
    Expression<String>? photoId,
    Expression<String>? photoPath,
    Expression<String>? status,
    Expression<int>? serverVersion,
    Expression<String>? reviewNote,
    Expression<String>? failure,
    Expression<int>? points,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spotId != null) 'spot_id': spotId,
      if (payload != null) 'payload': payload,
      if (photoId != null) 'photo_id': photoId,
      if (photoPath != null) 'photo_path': photoPath,
      if (status != null) 'status': status,
      if (serverVersion != null) 'server_version': serverVersion,
      if (reviewNote != null) 'review_note': reviewNote,
      if (failure != null) 'failure': failure,
      if (points != null) 'points': points,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TipsCompanion copyWith({
    Value<String>? id,
    Value<String>? spotId,
    Value<String>? payload,
    Value<String?>? photoId,
    Value<String?>? photoPath,
    Value<String>? status,
    Value<int?>? serverVersion,
    Value<String?>? reviewNote,
    Value<String?>? failure,
    Value<int>? points,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TipsCompanion(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      payload: payload ?? this.payload,
      photoId: photoId ?? this.photoId,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      serverVersion: serverVersion ?? this.serverVersion,
      reviewNote: reviewNote ?? this.reviewNote,
      failure: failure ?? this.failure,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spotId.present) {
      map['spot_id'] = Variable<String>(spotId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (photoId.present) {
      map['photo_id'] = Variable<String>(photoId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (failure.present) {
      map['failure'] = Variable<String>(failure.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipsCompanion(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('payload: $payload, ')
          ..write('photoId: $photoId, ')
          ..write('photoPath: $photoPath, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('failure: $failure, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxOpsTable extends OutboxOps
    with TableInfo<$OutboxOpsTable, OutboxOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correlationIdMeta = const VerificationMeta(
    'correlationId',
  );
  @override
  late final GeneratedColumn<String> correlationId = GeneratedColumn<String>(
    'correlation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dependsOnMeta = const VerificationMeta(
    'dependsOn',
  );
  @override
  late final GeneratedColumn<String> dependsOn = GeneratedColumn<String>(
    'depends_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opId,
    kind,
    payload,
    correlationId,
    dependsOn,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('correlation_id')) {
      context.handle(
        _correlationIdMeta,
        correlationId.isAcceptableOrUnknown(
          data['correlation_id']!,
          _correlationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correlationIdMeta);
    }
    if (data.containsKey('depends_on')) {
      context.handle(
        _dependsOnMeta,
        dependsOn.isAcceptableOrUnknown(data['depends_on']!, _dependsOnMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  OutboxOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxOp(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      correlationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correlation_id'],
      )!,
      dependsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}depends_on'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxOpsTable createAlias(String alias) {
    return $OutboxOpsTable(attachedDatabase, alias);
  }
}

class OutboxOp extends DataClass implements Insertable<OutboxOp> {
  final String opId;
  final String kind;
  final String payload;
  final String correlationId;
  final String? dependsOn;
  final String state;
  final int attempts;
  final DateTime nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  const OutboxOp({
    required this.opId,
    required this.kind,
    required this.payload,
    required this.correlationId,
    this.dependsOn,
    required this.state,
    required this.attempts,
    required this.nextAttemptAt,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    map['correlation_id'] = Variable<String>(correlationId);
    if (!nullToAbsent || dependsOn != null) {
      map['depends_on'] = Variable<String>(dependsOn);
    }
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxOpsCompanion toCompanion(bool nullToAbsent) {
    return OutboxOpsCompanion(
      opId: Value(opId),
      kind: Value(kind),
      payload: Value(payload),
      correlationId: Value(correlationId),
      dependsOn: dependsOn == null && nullToAbsent
          ? const Value.absent()
          : Value(dependsOn),
      state: Value(state),
      attempts: Value(attempts),
      nextAttemptAt: Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxOp(
      opId: serializer.fromJson<String>(json['opId']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
      correlationId: serializer.fromJson<String>(json['correlationId']),
      dependsOn: serializer.fromJson<String?>(json['dependsOn']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
      'correlationId': serializer.toJson<String>(correlationId),
      'dependsOn': serializer.toJson<String?>(dependsOn),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxOp copyWith({
    String? opId,
    String? kind,
    String? payload,
    String? correlationId,
    Value<String?> dependsOn = const Value.absent(),
    String? state,
    int? attempts,
    DateTime? nextAttemptAt,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => OutboxOp(
    opId: opId ?? this.opId,
    kind: kind ?? this.kind,
    payload: payload ?? this.payload,
    correlationId: correlationId ?? this.correlationId,
    dependsOn: dependsOn.present ? dependsOn.value : this.dependsOn,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxOp copyWithCompanion(OutboxOpsCompanion data) {
    return OutboxOp(
      opId: data.opId.present ? data.opId.value : this.opId,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      correlationId: data.correlationId.present
          ? data.correlationId.value
          : this.correlationId,
      dependsOn: data.dependsOn.present ? data.dependsOn.value : this.dependsOn,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOp(')
          ..write('opId: $opId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('correlationId: $correlationId, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opId,
    kind,
    payload,
    correlationId,
    dependsOn,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxOp &&
          other.opId == this.opId &&
          other.kind == this.kind &&
          other.payload == this.payload &&
          other.correlationId == this.correlationId &&
          other.dependsOn == this.dependsOn &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class OutboxOpsCompanion extends UpdateCompanion<OutboxOp> {
  final Value<String> opId;
  final Value<String> kind;
  final Value<String> payload;
  final Value<String> correlationId;
  final Value<String?> dependsOn;
  final Value<String> state;
  final Value<int> attempts;
  final Value<DateTime> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OutboxOpsCompanion({
    this.opId = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.dependsOn = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxOpsCompanion.insert({
    required String opId,
    required String kind,
    required String payload,
    required String correlationId,
    this.dependsOn = const Value.absent(),
    required String state,
    this.attempts = const Value.absent(),
    required DateTime nextAttemptAt,
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       kind = Value(kind),
       payload = Value(payload),
       correlationId = Value(correlationId),
       state = Value(state),
       nextAttemptAt = Value(nextAttemptAt),
       createdAt = Value(createdAt);
  static Insertable<OutboxOp> custom({
    Expression<String>? opId,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<String>? correlationId,
    Expression<String>? dependsOn,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (correlationId != null) 'correlation_id': correlationId,
      if (dependsOn != null) 'depends_on': dependsOn,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxOpsCompanion copyWith({
    Value<String>? opId,
    Value<String>? kind,
    Value<String>? payload,
    Value<String>? correlationId,
    Value<String?>? dependsOn,
    Value<String>? state,
    Value<int>? attempts,
    Value<DateTime>? nextAttemptAt,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OutboxOpsCompanion(
      opId: opId ?? this.opId,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      correlationId: correlationId ?? this.correlationId,
      dependsOn: dependsOn ?? this.dependsOn,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (correlationId.present) {
      map['correlation_id'] = Variable<String>(correlationId.value);
    }
    if (dependsOn.present) {
      map['depends_on'] = Variable<String>(dependsOn.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxOpsCompanion(')
          ..write('opId: $opId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('correlationId: $correlationId, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spotIdMeta = const VerificationMeta('spotId');
  @override
  late final GeneratedColumn<String> spotId = GeneratedColumn<String>(
    'spot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spotNameMeta = const VerificationMeta(
    'spotName',
  );
  @override
  late final GeneratedColumn<String> spotName = GeneratedColumn<String>(
    'spot_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleMeta = const VerificationMeta(
    'vehicle',
  );
  @override
  late final GeneratedColumn<String> vehicle = GeneratedColumn<String>(
    'vehicle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedEndAtMeta = const VerificationMeta(
    'plannedEndAt',
  );
  @override
  late final GeneratedColumn<DateTime> plannedEndAt = GeneratedColumn<DateTime>(
    'planned_end_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineAtMeta = const VerificationMeta(
    'deadlineAt',
  );
  @override
  late final GeneratedColumn<DateTime> deadlineAt = GeneratedColumn<DateTime>(
    'deadline_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineReasonMeta = const VerificationMeta(
    'deadlineReason',
  );
  @override
  late final GeneratedColumn<String> deadlineReason = GeneratedColumn<String>(
    'deadline_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verdictMeta = const VerificationMeta(
    'verdict',
  );
  @override
  late final GeneratedColumn<String> verdict = GeneratedColumn<String>(
    'verdict',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headlineMeta = const VerificationMeta(
    'headline',
  );
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
    'headline',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceVersionMeta = const VerificationMeta(
    'evidenceVersion',
  );
  @override
  late final GeneratedColumn<int> evidenceVersion = GeneratedColumn<int>(
    'evidence_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assessmentIdMeta = const VerificationMeta(
    'assessmentId',
  );
  @override
  late final GeneratedColumn<String> assessmentId = GeneratedColumn<String>(
    'assessment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _missingStatusMeta = const VerificationMeta(
    'missingStatus',
  );
  @override
  late final GeneratedColumn<String> missingStatus = GeneratedColumn<String>(
    'missing_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeNoteMeta = const VerificationMeta(
    'changeNote',
  );
  @override
  late final GeneratedColumn<String> changeNote = GeneratedColumn<String>(
    'change_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spotId,
    spotName,
    lat,
    lng,
    vehicle,
    startedAt,
    plannedEndAt,
    deadlineAt,
    deadlineReason,
    verdict,
    headline,
    evidenceVersion,
    assessmentId,
    state,
    missingStatus,
    changeNote,
    endedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('spot_id')) {
      context.handle(
        _spotIdMeta,
        spotId.isAcceptableOrUnknown(data['spot_id']!, _spotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotIdMeta);
    }
    if (data.containsKey('spot_name')) {
      context.handle(
        _spotNameMeta,
        spotName.isAcceptableOrUnknown(data['spot_name']!, _spotNameMeta),
      );
    } else if (isInserting) {
      context.missing(_spotNameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('vehicle')) {
      context.handle(
        _vehicleMeta,
        vehicle.isAcceptableOrUnknown(data['vehicle']!, _vehicleMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('planned_end_at')) {
      context.handle(
        _plannedEndAtMeta,
        plannedEndAt.isAcceptableOrUnknown(
          data['planned_end_at']!,
          _plannedEndAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedEndAtMeta);
    }
    if (data.containsKey('deadline_at')) {
      context.handle(
        _deadlineAtMeta,
        deadlineAt.isAcceptableOrUnknown(data['deadline_at']!, _deadlineAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deadlineAtMeta);
    }
    if (data.containsKey('deadline_reason')) {
      context.handle(
        _deadlineReasonMeta,
        deadlineReason.isAcceptableOrUnknown(
          data['deadline_reason']!,
          _deadlineReasonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deadlineReasonMeta);
    }
    if (data.containsKey('verdict')) {
      context.handle(
        _verdictMeta,
        verdict.isAcceptableOrUnknown(data['verdict']!, _verdictMeta),
      );
    } else if (isInserting) {
      context.missing(_verdictMeta);
    }
    if (data.containsKey('headline')) {
      context.handle(
        _headlineMeta,
        headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta),
      );
    } else if (isInserting) {
      context.missing(_headlineMeta);
    }
    if (data.containsKey('evidence_version')) {
      context.handle(
        _evidenceVersionMeta,
        evidenceVersion.isAcceptableOrUnknown(
          data['evidence_version']!,
          _evidenceVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evidenceVersionMeta);
    }
    if (data.containsKey('assessment_id')) {
      context.handle(
        _assessmentIdMeta,
        assessmentId.isAcceptableOrUnknown(
          data['assessment_id']!,
          _assessmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assessmentIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('missing_status')) {
      context.handle(
        _missingStatusMeta,
        missingStatus.isAcceptableOrUnknown(
          data['missing_status']!,
          _missingStatusMeta,
        ),
      );
    }
    if (data.containsKey('change_note')) {
      context.handle(
        _changeNoteMeta,
        changeNote.isAcceptableOrUnknown(data['change_note']!, _changeNoteMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_id'],
      )!,
      spotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      vehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      plannedEndAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_end_at'],
      )!,
      deadlineAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline_at'],
      )!,
      deadlineReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deadline_reason'],
      )!,
      verdict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verdict'],
      )!,
      headline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headline'],
      )!,
      evidenceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evidence_version'],
      )!,
      assessmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      missingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}missing_status'],
      ),
      changeNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_note'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String spotId;
  final String spotName;
  final double lat;
  final double lng;
  final String vehicle;
  final DateTime startedAt;
  final DateTime plannedEndAt;
  final DateTime deadlineAt;
  final String deadlineReason;
  final String verdict;
  final String headline;
  final int evidenceVersion;
  final String assessmentId;
  final String state;
  final String? missingStatus;

  /// Set when newer evidence changed the conditions after parking.
  final String? changeNote;
  final DateTime? endedAt;
  const Session({
    required this.id,
    required this.spotId,
    required this.spotName,
    required this.lat,
    required this.lng,
    required this.vehicle,
    required this.startedAt,
    required this.plannedEndAt,
    required this.deadlineAt,
    required this.deadlineReason,
    required this.verdict,
    required this.headline,
    required this.evidenceVersion,
    required this.assessmentId,
    required this.state,
    this.missingStatus,
    this.changeNote,
    this.endedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['spot_id'] = Variable<String>(spotId);
    map['spot_name'] = Variable<String>(spotName);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['vehicle'] = Variable<String>(vehicle);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['planned_end_at'] = Variable<DateTime>(plannedEndAt);
    map['deadline_at'] = Variable<DateTime>(deadlineAt);
    map['deadline_reason'] = Variable<String>(deadlineReason);
    map['verdict'] = Variable<String>(verdict);
    map['headline'] = Variable<String>(headline);
    map['evidence_version'] = Variable<int>(evidenceVersion);
    map['assessment_id'] = Variable<String>(assessmentId);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || missingStatus != null) {
      map['missing_status'] = Variable<String>(missingStatus);
    }
    if (!nullToAbsent || changeNote != null) {
      map['change_note'] = Variable<String>(changeNote);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      spotId: Value(spotId),
      spotName: Value(spotName),
      lat: Value(lat),
      lng: Value(lng),
      vehicle: Value(vehicle),
      startedAt: Value(startedAt),
      plannedEndAt: Value(plannedEndAt),
      deadlineAt: Value(deadlineAt),
      deadlineReason: Value(deadlineReason),
      verdict: Value(verdict),
      headline: Value(headline),
      evidenceVersion: Value(evidenceVersion),
      assessmentId: Value(assessmentId),
      state: Value(state),
      missingStatus: missingStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(missingStatus),
      changeNote: changeNote == null && nullToAbsent
          ? const Value.absent()
          : Value(changeNote),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      spotId: serializer.fromJson<String>(json['spotId']),
      spotName: serializer.fromJson<String>(json['spotName']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      vehicle: serializer.fromJson<String>(json['vehicle']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      plannedEndAt: serializer.fromJson<DateTime>(json['plannedEndAt']),
      deadlineAt: serializer.fromJson<DateTime>(json['deadlineAt']),
      deadlineReason: serializer.fromJson<String>(json['deadlineReason']),
      verdict: serializer.fromJson<String>(json['verdict']),
      headline: serializer.fromJson<String>(json['headline']),
      evidenceVersion: serializer.fromJson<int>(json['evidenceVersion']),
      assessmentId: serializer.fromJson<String>(json['assessmentId']),
      state: serializer.fromJson<String>(json['state']),
      missingStatus: serializer.fromJson<String?>(json['missingStatus']),
      changeNote: serializer.fromJson<String?>(json['changeNote']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spotId': serializer.toJson<String>(spotId),
      'spotName': serializer.toJson<String>(spotName),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'vehicle': serializer.toJson<String>(vehicle),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'plannedEndAt': serializer.toJson<DateTime>(plannedEndAt),
      'deadlineAt': serializer.toJson<DateTime>(deadlineAt),
      'deadlineReason': serializer.toJson<String>(deadlineReason),
      'verdict': serializer.toJson<String>(verdict),
      'headline': serializer.toJson<String>(headline),
      'evidenceVersion': serializer.toJson<int>(evidenceVersion),
      'assessmentId': serializer.toJson<String>(assessmentId),
      'state': serializer.toJson<String>(state),
      'missingStatus': serializer.toJson<String?>(missingStatus),
      'changeNote': serializer.toJson<String?>(changeNote),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  Session copyWith({
    String? id,
    String? spotId,
    String? spotName,
    double? lat,
    double? lng,
    String? vehicle,
    DateTime? startedAt,
    DateTime? plannedEndAt,
    DateTime? deadlineAt,
    String? deadlineReason,
    String? verdict,
    String? headline,
    int? evidenceVersion,
    String? assessmentId,
    String? state,
    Value<String?> missingStatus = const Value.absent(),
    Value<String?> changeNote = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    spotId: spotId ?? this.spotId,
    spotName: spotName ?? this.spotName,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    vehicle: vehicle ?? this.vehicle,
    startedAt: startedAt ?? this.startedAt,
    plannedEndAt: plannedEndAt ?? this.plannedEndAt,
    deadlineAt: deadlineAt ?? this.deadlineAt,
    deadlineReason: deadlineReason ?? this.deadlineReason,
    verdict: verdict ?? this.verdict,
    headline: headline ?? this.headline,
    evidenceVersion: evidenceVersion ?? this.evidenceVersion,
    assessmentId: assessmentId ?? this.assessmentId,
    state: state ?? this.state,
    missingStatus: missingStatus.present
        ? missingStatus.value
        : this.missingStatus,
    changeNote: changeNote.present ? changeNote.value : this.changeNote,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      spotName: data.spotName.present ? data.spotName.value : this.spotName,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      vehicle: data.vehicle.present ? data.vehicle.value : this.vehicle,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      plannedEndAt: data.plannedEndAt.present
          ? data.plannedEndAt.value
          : this.plannedEndAt,
      deadlineAt: data.deadlineAt.present
          ? data.deadlineAt.value
          : this.deadlineAt,
      deadlineReason: data.deadlineReason.present
          ? data.deadlineReason.value
          : this.deadlineReason,
      verdict: data.verdict.present ? data.verdict.value : this.verdict,
      headline: data.headline.present ? data.headline.value : this.headline,
      evidenceVersion: data.evidenceVersion.present
          ? data.evidenceVersion.value
          : this.evidenceVersion,
      assessmentId: data.assessmentId.present
          ? data.assessmentId.value
          : this.assessmentId,
      state: data.state.present ? data.state.value : this.state,
      missingStatus: data.missingStatus.present
          ? data.missingStatus.value
          : this.missingStatus,
      changeNote: data.changeNote.present
          ? data.changeNote.value
          : this.changeNote,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('spotName: $spotName, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('vehicle: $vehicle, ')
          ..write('startedAt: $startedAt, ')
          ..write('plannedEndAt: $plannedEndAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('deadlineReason: $deadlineReason, ')
          ..write('verdict: $verdict, ')
          ..write('headline: $headline, ')
          ..write('evidenceVersion: $evidenceVersion, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('state: $state, ')
          ..write('missingStatus: $missingStatus, ')
          ..write('changeNote: $changeNote, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spotId,
    spotName,
    lat,
    lng,
    vehicle,
    startedAt,
    plannedEndAt,
    deadlineAt,
    deadlineReason,
    verdict,
    headline,
    evidenceVersion,
    assessmentId,
    state,
    missingStatus,
    changeNote,
    endedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.spotId == this.spotId &&
          other.spotName == this.spotName &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.vehicle == this.vehicle &&
          other.startedAt == this.startedAt &&
          other.plannedEndAt == this.plannedEndAt &&
          other.deadlineAt == this.deadlineAt &&
          other.deadlineReason == this.deadlineReason &&
          other.verdict == this.verdict &&
          other.headline == this.headline &&
          other.evidenceVersion == this.evidenceVersion &&
          other.assessmentId == this.assessmentId &&
          other.state == this.state &&
          other.missingStatus == this.missingStatus &&
          other.changeNote == this.changeNote &&
          other.endedAt == this.endedAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> spotId;
  final Value<String> spotName;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String> vehicle;
  final Value<DateTime> startedAt;
  final Value<DateTime> plannedEndAt;
  final Value<DateTime> deadlineAt;
  final Value<String> deadlineReason;
  final Value<String> verdict;
  final Value<String> headline;
  final Value<int> evidenceVersion;
  final Value<String> assessmentId;
  final Value<String> state;
  final Value<String?> missingStatus;
  final Value<String?> changeNote;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.spotId = const Value.absent(),
    this.spotName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.vehicle = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.plannedEndAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.deadlineReason = const Value.absent(),
    this.verdict = const Value.absent(),
    this.headline = const Value.absent(),
    this.evidenceVersion = const Value.absent(),
    this.assessmentId = const Value.absent(),
    this.state = const Value.absent(),
    this.missingStatus = const Value.absent(),
    this.changeNote = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String spotId,
    required String spotName,
    required double lat,
    required double lng,
    required String vehicle,
    required DateTime startedAt,
    required DateTime plannedEndAt,
    required DateTime deadlineAt,
    required String deadlineReason,
    required String verdict,
    required String headline,
    required int evidenceVersion,
    required String assessmentId,
    required String state,
    this.missingStatus = const Value.absent(),
    this.changeNote = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spotId = Value(spotId),
       spotName = Value(spotName),
       lat = Value(lat),
       lng = Value(lng),
       vehicle = Value(vehicle),
       startedAt = Value(startedAt),
       plannedEndAt = Value(plannedEndAt),
       deadlineAt = Value(deadlineAt),
       deadlineReason = Value(deadlineReason),
       verdict = Value(verdict),
       headline = Value(headline),
       evidenceVersion = Value(evidenceVersion),
       assessmentId = Value(assessmentId),
       state = Value(state);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? spotId,
    Expression<String>? spotName,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? vehicle,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? plannedEndAt,
    Expression<DateTime>? deadlineAt,
    Expression<String>? deadlineReason,
    Expression<String>? verdict,
    Expression<String>? headline,
    Expression<int>? evidenceVersion,
    Expression<String>? assessmentId,
    Expression<String>? state,
    Expression<String>? missingStatus,
    Expression<String>? changeNote,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spotId != null) 'spot_id': spotId,
      if (spotName != null) 'spot_name': spotName,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (vehicle != null) 'vehicle': vehicle,
      if (startedAt != null) 'started_at': startedAt,
      if (plannedEndAt != null) 'planned_end_at': plannedEndAt,
      if (deadlineAt != null) 'deadline_at': deadlineAt,
      if (deadlineReason != null) 'deadline_reason': deadlineReason,
      if (verdict != null) 'verdict': verdict,
      if (headline != null) 'headline': headline,
      if (evidenceVersion != null) 'evidence_version': evidenceVersion,
      if (assessmentId != null) 'assessment_id': assessmentId,
      if (state != null) 'state': state,
      if (missingStatus != null) 'missing_status': missingStatus,
      if (changeNote != null) 'change_note': changeNote,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? spotId,
    Value<String>? spotName,
    Value<double>? lat,
    Value<double>? lng,
    Value<String>? vehicle,
    Value<DateTime>? startedAt,
    Value<DateTime>? plannedEndAt,
    Value<DateTime>? deadlineAt,
    Value<String>? deadlineReason,
    Value<String>? verdict,
    Value<String>? headline,
    Value<int>? evidenceVersion,
    Value<String>? assessmentId,
    Value<String>? state,
    Value<String?>? missingStatus,
    Value<String?>? changeNote,
    Value<DateTime?>? endedAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      spotName: spotName ?? this.spotName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      vehicle: vehicle ?? this.vehicle,
      startedAt: startedAt ?? this.startedAt,
      plannedEndAt: plannedEndAt ?? this.plannedEndAt,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      deadlineReason: deadlineReason ?? this.deadlineReason,
      verdict: verdict ?? this.verdict,
      headline: headline ?? this.headline,
      evidenceVersion: evidenceVersion ?? this.evidenceVersion,
      assessmentId: assessmentId ?? this.assessmentId,
      state: state ?? this.state,
      missingStatus: missingStatus ?? this.missingStatus,
      changeNote: changeNote ?? this.changeNote,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spotId.present) {
      map['spot_id'] = Variable<String>(spotId.value);
    }
    if (spotName.present) {
      map['spot_name'] = Variable<String>(spotName.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (vehicle.present) {
      map['vehicle'] = Variable<String>(vehicle.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (plannedEndAt.present) {
      map['planned_end_at'] = Variable<DateTime>(plannedEndAt.value);
    }
    if (deadlineAt.present) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt.value);
    }
    if (deadlineReason.present) {
      map['deadline_reason'] = Variable<String>(deadlineReason.value);
    }
    if (verdict.present) {
      map['verdict'] = Variable<String>(verdict.value);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.value);
    }
    if (evidenceVersion.present) {
      map['evidence_version'] = Variable<int>(evidenceVersion.value);
    }
    if (assessmentId.present) {
      map['assessment_id'] = Variable<String>(assessmentId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (missingStatus.present) {
      map['missing_status'] = Variable<String>(missingStatus.value);
    }
    if (changeNote.present) {
      map['change_note'] = Variable<String>(changeNote.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('spotName: $spotName, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('vehicle: $vehicle, ')
          ..write('startedAt: $startedAt, ')
          ..write('plannedEndAt: $plannedEndAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('deadlineReason: $deadlineReason, ')
          ..write('verdict: $verdict, ')
          ..write('headline: $headline, ')
          ..write('evidenceVersion: $evidenceVersion, ')
          ..write('assessmentId: $assessmentId, ')
          ..write('state: $state, ')
          ..write('missingStatus: $missingStatus, ')
          ..write('changeNote: $changeNote, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssessmentLogTable extends AssessmentLog
    with TableInfo<$AssessmentLogTable, AssessmentLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spotIdMeta = const VerificationMeta('spotId');
  @override
  late final GeneratedColumn<String> spotId = GeneratedColumn<String>(
    'spot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verdictMeta = const VerificationMeta(
    'verdict',
  );
  @override
  late final GeneratedColumn<String> verdict = GeneratedColumn<String>(
    'verdict',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceVersionMeta = const VerificationMeta(
    'evidenceVersion',
  );
  @override
  late final GeneratedColumn<int> evidenceVersion = GeneratedColumn<int>(
    'evidence_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spotId,
    verdict,
    evidenceVersion,
    json,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessment_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('spot_id')) {
      context.handle(
        _spotIdMeta,
        spotId.isAcceptableOrUnknown(data['spot_id']!, _spotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spotIdMeta);
    }
    if (data.containsKey('verdict')) {
      context.handle(
        _verdictMeta,
        verdict.isAcceptableOrUnknown(data['verdict']!, _verdictMeta),
      );
    } else if (isInserting) {
      context.missing(_verdictMeta);
    }
    if (data.containsKey('evidence_version')) {
      context.handle(
        _evidenceVersionMeta,
        evidenceVersion.isAcceptableOrUnknown(
          data['evidence_version']!,
          _evidenceVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evidenceVersionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_id'],
      )!,
      verdict: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verdict'],
      )!,
      evidenceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evidence_version'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AssessmentLogTable createAlias(String alias) {
    return $AssessmentLogTable(attachedDatabase, alias);
  }
}

class AssessmentLogData extends DataClass
    implements Insertable<AssessmentLogData> {
  final String id;
  final String spotId;
  final String verdict;
  final int evidenceVersion;
  final String json;
  final DateTime createdAt;
  const AssessmentLogData({
    required this.id,
    required this.spotId,
    required this.verdict,
    required this.evidenceVersion,
    required this.json,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['spot_id'] = Variable<String>(spotId);
    map['verdict'] = Variable<String>(verdict);
    map['evidence_version'] = Variable<int>(evidenceVersion);
    map['json'] = Variable<String>(json);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssessmentLogCompanion toCompanion(bool nullToAbsent) {
    return AssessmentLogCompanion(
      id: Value(id),
      spotId: Value(spotId),
      verdict: Value(verdict),
      evidenceVersion: Value(evidenceVersion),
      json: Value(json),
      createdAt: Value(createdAt),
    );
  }

  factory AssessmentLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentLogData(
      id: serializer.fromJson<String>(json['id']),
      spotId: serializer.fromJson<String>(json['spotId']),
      verdict: serializer.fromJson<String>(json['verdict']),
      evidenceVersion: serializer.fromJson<int>(json['evidenceVersion']),
      json: serializer.fromJson<String>(json['json']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spotId': serializer.toJson<String>(spotId),
      'verdict': serializer.toJson<String>(verdict),
      'evidenceVersion': serializer.toJson<int>(evidenceVersion),
      'json': serializer.toJson<String>(json),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AssessmentLogData copyWith({
    String? id,
    String? spotId,
    String? verdict,
    int? evidenceVersion,
    String? json,
    DateTime? createdAt,
  }) => AssessmentLogData(
    id: id ?? this.id,
    spotId: spotId ?? this.spotId,
    verdict: verdict ?? this.verdict,
    evidenceVersion: evidenceVersion ?? this.evidenceVersion,
    json: json ?? this.json,
    createdAt: createdAt ?? this.createdAt,
  );
  AssessmentLogData copyWithCompanion(AssessmentLogCompanion data) {
    return AssessmentLogData(
      id: data.id.present ? data.id.value : this.id,
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      verdict: data.verdict.present ? data.verdict.value : this.verdict,
      evidenceVersion: data.evidenceVersion.present
          ? data.evidenceVersion.value
          : this.evidenceVersion,
      json: data.json.present ? data.json.value : this.json,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentLogData(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('verdict: $verdict, ')
          ..write('evidenceVersion: $evidenceVersion, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, spotId, verdict, evidenceVersion, json, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentLogData &&
          other.id == this.id &&
          other.spotId == this.spotId &&
          other.verdict == this.verdict &&
          other.evidenceVersion == this.evidenceVersion &&
          other.json == this.json &&
          other.createdAt == this.createdAt);
}

class AssessmentLogCompanion extends UpdateCompanion<AssessmentLogData> {
  final Value<String> id;
  final Value<String> spotId;
  final Value<String> verdict;
  final Value<int> evidenceVersion;
  final Value<String> json;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AssessmentLogCompanion({
    this.id = const Value.absent(),
    this.spotId = const Value.absent(),
    this.verdict = const Value.absent(),
    this.evidenceVersion = const Value.absent(),
    this.json = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentLogCompanion.insert({
    required String id,
    required String spotId,
    required String verdict,
    required int evidenceVersion,
    required String json,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spotId = Value(spotId),
       verdict = Value(verdict),
       evidenceVersion = Value(evidenceVersion),
       json = Value(json),
       createdAt = Value(createdAt);
  static Insertable<AssessmentLogData> custom({
    Expression<String>? id,
    Expression<String>? spotId,
    Expression<String>? verdict,
    Expression<int>? evidenceVersion,
    Expression<String>? json,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spotId != null) 'spot_id': spotId,
      if (verdict != null) 'verdict': verdict,
      if (evidenceVersion != null) 'evidence_version': evidenceVersion,
      if (json != null) 'json': json,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentLogCompanion copyWith({
    Value<String>? id,
    Value<String>? spotId,
    Value<String>? verdict,
    Value<int>? evidenceVersion,
    Value<String>? json,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AssessmentLogCompanion(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      verdict: verdict ?? this.verdict,
      evidenceVersion: evidenceVersion ?? this.evidenceVersion,
      json: json ?? this.json,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spotId.present) {
      map['spot_id'] = Variable<String>(spotId.value);
    }
    if (verdict.present) {
      map['verdict'] = Variable<String>(verdict.value);
    }
    if (evidenceVersion.present) {
      map['evidence_version'] = Variable<int>(evidenceVersion.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentLogCompanion(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('verdict: $verdict, ')
          ..write('evidenceVersion: $evidenceVersion, ')
          ..write('json: $json, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventLogTable extends EventLog
    with TableInfo<$EventLogTable, EventLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correlationIdMeta = const VerificationMeta(
    'correlationId',
  );
  @override
  late final GeneratedColumn<String> correlationId = GeneratedColumn<String>(
    'correlation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attrsMeta = const VerificationMeta('attrs');
  @override
  late final GeneratedColumn<String> attrs = GeneratedColumn<String>(
    'attrs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    origin,
    type,
    correlationId,
    attrs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('correlation_id')) {
      context.handle(
        _correlationIdMeta,
        correlationId.isAcceptableOrUnknown(
          data['correlation_id']!,
          _correlationIdMeta,
        ),
      );
    }
    if (data.containsKey('attrs')) {
      context.handle(
        _attrsMeta,
        attrs.isAcceptableOrUnknown(data['attrs']!, _attrsMeta),
      );
    } else if (isInserting) {
      context.missing(_attrsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      correlationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correlation_id'],
      ),
      attrs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attrs'],
      )!,
    );
  }

  @override
  $EventLogTable createAlias(String alias) {
    return $EventLogTable(attachedDatabase, alias);
  }
}

class EventLogData extends DataClass implements Insertable<EventLogData> {
  final int id;
  final DateTime at;
  final String origin;
  final String type;
  final String? correlationId;
  final String attrs;
  const EventLogData({
    required this.id,
    required this.at,
    required this.origin,
    required this.type,
    this.correlationId,
    required this.attrs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['origin'] = Variable<String>(origin);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || correlationId != null) {
      map['correlation_id'] = Variable<String>(correlationId);
    }
    map['attrs'] = Variable<String>(attrs);
    return map;
  }

  EventLogCompanion toCompanion(bool nullToAbsent) {
    return EventLogCompanion(
      id: Value(id),
      at: Value(at),
      origin: Value(origin),
      type: Value(type),
      correlationId: correlationId == null && nullToAbsent
          ? const Value.absent()
          : Value(correlationId),
      attrs: Value(attrs),
    );
  }

  factory EventLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventLogData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      origin: serializer.fromJson<String>(json['origin']),
      type: serializer.fromJson<String>(json['type']),
      correlationId: serializer.fromJson<String?>(json['correlationId']),
      attrs: serializer.fromJson<String>(json['attrs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'origin': serializer.toJson<String>(origin),
      'type': serializer.toJson<String>(type),
      'correlationId': serializer.toJson<String?>(correlationId),
      'attrs': serializer.toJson<String>(attrs),
    };
  }

  EventLogData copyWith({
    int? id,
    DateTime? at,
    String? origin,
    String? type,
    Value<String?> correlationId = const Value.absent(),
    String? attrs,
  }) => EventLogData(
    id: id ?? this.id,
    at: at ?? this.at,
    origin: origin ?? this.origin,
    type: type ?? this.type,
    correlationId: correlationId.present
        ? correlationId.value
        : this.correlationId,
    attrs: attrs ?? this.attrs,
  );
  EventLogData copyWithCompanion(EventLogCompanion data) {
    return EventLogData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      origin: data.origin.present ? data.origin.value : this.origin,
      type: data.type.present ? data.type.value : this.type,
      correlationId: data.correlationId.present
          ? data.correlationId.value
          : this.correlationId,
      attrs: data.attrs.present ? data.attrs.value : this.attrs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventLogData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('origin: $origin, ')
          ..write('type: $type, ')
          ..write('correlationId: $correlationId, ')
          ..write('attrs: $attrs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, origin, type, correlationId, attrs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventLogData &&
          other.id == this.id &&
          other.at == this.at &&
          other.origin == this.origin &&
          other.type == this.type &&
          other.correlationId == this.correlationId &&
          other.attrs == this.attrs);
}

class EventLogCompanion extends UpdateCompanion<EventLogData> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> origin;
  final Value<String> type;
  final Value<String?> correlationId;
  final Value<String> attrs;
  const EventLogCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.origin = const Value.absent(),
    this.type = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.attrs = const Value.absent(),
  });
  EventLogCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required String origin,
    required String type,
    this.correlationId = const Value.absent(),
    required String attrs,
  }) : at = Value(at),
       origin = Value(origin),
       type = Value(type),
       attrs = Value(attrs);
  static Insertable<EventLogData> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? origin,
    Expression<String>? type,
    Expression<String>? correlationId,
    Expression<String>? attrs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (origin != null) 'origin': origin,
      if (type != null) 'type': type,
      if (correlationId != null) 'correlation_id': correlationId,
      if (attrs != null) 'attrs': attrs,
    });
  }

  EventLogCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? origin,
    Value<String>? type,
    Value<String?>? correlationId,
    Value<String>? attrs,
  }) {
    return EventLogCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      origin: origin ?? this.origin,
      type: type ?? this.type,
      correlationId: correlationId ?? this.correlationId,
      attrs: attrs ?? this.attrs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (correlationId.present) {
      map['correlation_id'] = Variable<String>(correlationId.value);
    }
    if (attrs.present) {
      map['attrs'] = Variable<String>(attrs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventLogCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('origin: $origin, ')
          ..write('type: $type, ')
          ..write('correlationId: $correlationId, ')
          ..write('attrs: $attrs')
          ..write(')'))
        .toString();
  }
}

abstract class _$DeviceDb extends GeneratedDatabase {
  _$DeviceDb(QueryExecutor e) : super(e);
  $DeviceDbManager get managers => $DeviceDbManager(this);
  late final $KvEntriesTable kvEntries = $KvEntriesTable(this);
  late final $EvidenceCacheTable evidenceCache = $EvidenceCacheTable(this);
  late final $TipsTable tips = $TipsTable(this);
  late final $OutboxOpsTable outboxOps = $OutboxOpsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $AssessmentLogTable assessmentLog = $AssessmentLogTable(this);
  late final $EventLogTable eventLog = $EventLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    kvEntries,
    evidenceCache,
    tips,
    outboxOps,
    sessions,
    assessmentLog,
    eventLog,
  ];
}

typedef $$KvEntriesTableCreateCompanionBuilder = KvEntriesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KvEntriesTableUpdateCompanionBuilder = KvEntriesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KvEntriesTableFilterComposer
    extends Composer<_$DeviceDb, $KvEntriesTable> {
  $$KvEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KvEntriesTableOrderingComposer
    extends Composer<_$DeviceDb, $KvEntriesTable> {
  $$KvEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KvEntriesTableAnnotationComposer
    extends Composer<_$DeviceDb, $KvEntriesTable> {
  $$KvEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KvEntriesTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $KvEntriesTable,
          KvEntry,
          $$KvEntriesTableFilterComposer,
          $$KvEntriesTableOrderingComposer,
          $$KvEntriesTableAnnotationComposer,
          $$KvEntriesTableCreateCompanionBuilder,
          $$KvEntriesTableUpdateCompanionBuilder,
          (KvEntry, BaseReferences<_$DeviceDb, $KvEntriesTable, KvEntry>),
          KvEntry,
          PrefetchHooks Function()
        > {
  $$KvEntriesTableTableManager(_$DeviceDb db, $KvEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KvEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KvEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KvEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KvEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KvEntriesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KvEntriesTable, KvEntry>(table),
                  BaseReferences<_$DeviceDb, $KvEntriesTable, KvEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KvEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $KvEntriesTable,
      KvEntry,
      $$KvEntriesTableFilterComposer,
      $$KvEntriesTableOrderingComposer,
      $$KvEntriesTableAnnotationComposer,
      $$KvEntriesTableCreateCompanionBuilder,
      $$KvEntriesTableUpdateCompanionBuilder,
      (KvEntry, BaseReferences<_$DeviceDb, $KvEntriesTable, KvEntry>),
      KvEntry,
      PrefetchHooks Function()
    >;
typedef $$EvidenceCacheTableCreateCompanionBuilder =
    EvidenceCacheCompanion Function({
      Value<int> slot,
      required int version,
      required String json,
      required DateTime fetchedAt,
    });
typedef $$EvidenceCacheTableUpdateCompanionBuilder =
    EvidenceCacheCompanion Function({
      Value<int> slot,
      Value<int> version,
      Value<String> json,
      Value<DateTime> fetchedAt,
    });

class $$EvidenceCacheTableFilterComposer
    extends Composer<_$DeviceDb, $EvidenceCacheTable> {
  $$EvidenceCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EvidenceCacheTableOrderingComposer
    extends Composer<_$DeviceDb, $EvidenceCacheTable> {
  $$EvidenceCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidenceCacheTableAnnotationComposer
    extends Composer<_$DeviceDb, $EvidenceCacheTable> {
  $$EvidenceCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$EvidenceCacheTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $EvidenceCacheTable,
          EvidenceCacheData,
          $$EvidenceCacheTableFilterComposer,
          $$EvidenceCacheTableOrderingComposer,
          $$EvidenceCacheTableAnnotationComposer,
          $$EvidenceCacheTableCreateCompanionBuilder,
          $$EvidenceCacheTableUpdateCompanionBuilder,
          (
            EvidenceCacheData,
            BaseReferences<_$DeviceDb, $EvidenceCacheTable, EvidenceCacheData>,
          ),
          EvidenceCacheData,
          PrefetchHooks Function()
        > {
  $$EvidenceCacheTableTableManager(_$DeviceDb db, $EvidenceCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => EvidenceCacheCompanion(
                slot: slot,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                required int version,
                required String json,
                required DateTime fetchedAt,
              }) => EvidenceCacheCompanion.insert(
                slot: slot,
                version: version,
                json: json,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EvidenceCacheTable, EvidenceCacheData>(table),
                  BaseReferences<
                    _$DeviceDb,
                    $EvidenceCacheTable,
                    EvidenceCacheData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EvidenceCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $EvidenceCacheTable,
      EvidenceCacheData,
      $$EvidenceCacheTableFilterComposer,
      $$EvidenceCacheTableOrderingComposer,
      $$EvidenceCacheTableAnnotationComposer,
      $$EvidenceCacheTableCreateCompanionBuilder,
      $$EvidenceCacheTableUpdateCompanionBuilder,
      (
        EvidenceCacheData,
        BaseReferences<_$DeviceDb, $EvidenceCacheTable, EvidenceCacheData>,
      ),
      EvidenceCacheData,
      PrefetchHooks Function()
    >;
typedef $$TipsTableCreateCompanionBuilder = TipsCompanion Function({
  required String id,
  required String spotId,
  required String payload,
  Value<String?> photoId,
  Value<String?> photoPath,
  required String status,
  Value<int?> serverVersion,
  Value<String?> reviewNote,
  Value<String?> failure,
  Value<int> points,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TipsTableUpdateCompanionBuilder = TipsCompanion Function({
  Value<String> id,
  Value<String> spotId,
  Value<String> payload,
  Value<String?> photoId,
  Value<String?> photoPath,
  Value<String> status,
  Value<int?> serverVersion,
  Value<String?> reviewNote,
  Value<String?> failure,
  Value<int> points,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TipsTableFilterComposer extends Composer<_$DeviceDb, $TipsTable> {
  $$TipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoId => $composableBuilder(
    column: $table.photoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failure => $composableBuilder(
    column: $table.failure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TipsTableOrderingComposer extends Composer<_$DeviceDb, $TipsTable> {
  $$TipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoId => $composableBuilder(
    column: $table.photoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failure => $composableBuilder(
    column: $table.failure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TipsTableAnnotationComposer extends Composer<_$DeviceDb, $TipsTable> {
  $$TipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spotId =>
      $composableBuilder(column: $table.spotId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get photoId =>
      $composableBuilder(column: $table.photoId, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failure =>
      $composableBuilder(column: $table.failure, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TipsTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $TipsTable,
          Tip,
          $$TipsTableFilterComposer,
          $$TipsTableOrderingComposer,
          $$TipsTableAnnotationComposer,
          $$TipsTableCreateCompanionBuilder,
          $$TipsTableUpdateCompanionBuilder,
          (Tip, BaseReferences<_$DeviceDb, $TipsTable, Tip>),
          Tip,
          PrefetchHooks Function()
        > {
  $$TipsTableTableManager(_$DeviceDb db, $TipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spotId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> photoId = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> serverVersion = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<String?> failure = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TipsCompanion(
                id: id,
                spotId: spotId,
                payload: payload,
                photoId: photoId,
                photoPath: photoPath,
                status: status,
                serverVersion: serverVersion,
                reviewNote: reviewNote,
                failure: failure,
                points: points,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spotId,
                required String payload,
                Value<String?> photoId = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required String status,
                Value<int?> serverVersion = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<String?> failure = const Value.absent(),
                Value<int> points = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TipsCompanion.insert(
                id: id,
                spotId: spotId,
                payload: payload,
                photoId: photoId,
                photoPath: photoPath,
                status: status,
                serverVersion: serverVersion,
                reviewNote: reviewNote,
                failure: failure,
                points: points,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TipsTable, Tip>(table),
                  BaseReferences<_$DeviceDb, $TipsTable, Tip>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TipsTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $TipsTable,
      Tip,
      $$TipsTableFilterComposer,
      $$TipsTableOrderingComposer,
      $$TipsTableAnnotationComposer,
      $$TipsTableCreateCompanionBuilder,
      $$TipsTableUpdateCompanionBuilder,
      (Tip, BaseReferences<_$DeviceDb, $TipsTable, Tip>),
      Tip,
      PrefetchHooks Function()
    >;
typedef $$OutboxOpsTableCreateCompanionBuilder = OutboxOpsCompanion Function({
  required String opId,
  required String kind,
  required String payload,
  required String correlationId,
  Value<String?> dependsOn,
  required String state,
  Value<int> attempts,
  required DateTime nextAttemptAt,
  Value<String?> lastError,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$OutboxOpsTableUpdateCompanionBuilder = OutboxOpsCompanion Function({
  Value<String> opId,
  Value<String> kind,
  Value<String> payload,
  Value<String> correlationId,
  Value<String?> dependsOn,
  Value<String> state,
  Value<int> attempts,
  Value<DateTime> nextAttemptAt,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$OutboxOpsTableFilterComposer
    extends Composer<_$DeviceDb, $OutboxOpsTable> {
  $$OutboxOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxOpsTableOrderingComposer
    extends Composer<_$DeviceDb, $OutboxOpsTable> {
  $$OutboxOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxOpsTableAnnotationComposer
    extends Composer<_$DeviceDb, $OutboxOpsTable> {
  $$OutboxOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dependsOn =>
      $composableBuilder(column: $table.dependsOn, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxOpsTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $OutboxOpsTable,
          OutboxOp,
          $$OutboxOpsTableFilterComposer,
          $$OutboxOpsTableOrderingComposer,
          $$OutboxOpsTableAnnotationComposer,
          $$OutboxOpsTableCreateCompanionBuilder,
          $$OutboxOpsTableUpdateCompanionBuilder,
          (OutboxOp, BaseReferences<_$DeviceDb, $OutboxOpsTable, OutboxOp>),
          OutboxOp,
          PrefetchHooks Function()
        > {
  $$OutboxOpsTableTableManager(_$DeviceDb db, $OutboxOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> correlationId = const Value.absent(),
                Value<String?> dependsOn = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxOpsCompanion(
                opId: opId,
                kind: kind,
                payload: payload,
                correlationId: correlationId,
                dependsOn: dependsOn,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String kind,
                required String payload,
                required String correlationId,
                Value<String?> dependsOn = const Value.absent(),
                required String state,
                Value<int> attempts = const Value.absent(),
                required DateTime nextAttemptAt,
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OutboxOpsCompanion.insert(
                opId: opId,
                kind: kind,
                payload: payload,
                correlationId: correlationId,
                dependsOn: dependsOn,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxOpsTable, OutboxOp>(table),
                  BaseReferences<_$DeviceDb, $OutboxOpsTable, OutboxOp>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $OutboxOpsTable,
      OutboxOp,
      $$OutboxOpsTableFilterComposer,
      $$OutboxOpsTableOrderingComposer,
      $$OutboxOpsTableAnnotationComposer,
      $$OutboxOpsTableCreateCompanionBuilder,
      $$OutboxOpsTableUpdateCompanionBuilder,
      (OutboxOp, BaseReferences<_$DeviceDb, $OutboxOpsTable, OutboxOp>),
      OutboxOp,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String spotId,
  required String spotName,
  required double lat,
  required double lng,
  required String vehicle,
  required DateTime startedAt,
  required DateTime plannedEndAt,
  required DateTime deadlineAt,
  required String deadlineReason,
  required String verdict,
  required String headline,
  required int evidenceVersion,
  required String assessmentId,
  required String state,
  Value<String?> missingStatus,
  Value<String?> changeNote,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> spotId,
  Value<String> spotName,
  Value<double> lat,
  Value<double> lng,
  Value<String> vehicle,
  Value<DateTime> startedAt,
  Value<DateTime> plannedEndAt,
  Value<DateTime> deadlineAt,
  Value<String> deadlineReason,
  Value<String> verdict,
  Value<String> headline,
  Value<int> evidenceVersion,
  Value<String> assessmentId,
  Value<String> state,
  Value<String?> missingStatus,
  Value<String?> changeNote,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

class $$SessionsTableFilterComposer
    extends Composer<_$DeviceDb, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotName => $composableBuilder(
    column: $table.spotName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicle => $composableBuilder(
    column: $table.vehicle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedEndAt => $composableBuilder(
    column: $table.plannedEndAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deadlineReason => $composableBuilder(
    column: $table.deadlineReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missingStatus => $composableBuilder(
    column: $table.missingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeNote => $composableBuilder(
    column: $table.changeNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$DeviceDb, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotName => $composableBuilder(
    column: $table.spotName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicle => $composableBuilder(
    column: $table.vehicle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedEndAt => $composableBuilder(
    column: $table.plannedEndAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deadlineReason => $composableBuilder(
    column: $table.deadlineReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missingStatus => $composableBuilder(
    column: $table.missingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeNote => $composableBuilder(
    column: $table.changeNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$DeviceDb, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spotId =>
      $composableBuilder(column: $table.spotId, builder: (column) => column);

  GeneratedColumn<String> get spotName =>
      $composableBuilder(column: $table.spotName, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get vehicle =>
      $composableBuilder(column: $table.vehicle, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedEndAt => $composableBuilder(
    column: $table.plannedEndAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deadlineReason => $composableBuilder(
    column: $table.deadlineReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verdict =>
      $composableBuilder(column: $table.verdict, builder: (column) => column);

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assessmentId => $composableBuilder(
    column: $table.assessmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get missingStatus => $composableBuilder(
    column: $table.missingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changeNote => $composableBuilder(
    column: $table.changeNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$DeviceDb, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$DeviceDb db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spotId = const Value.absent(),
                Value<String> spotName = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String> vehicle = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> plannedEndAt = const Value.absent(),
                Value<DateTime> deadlineAt = const Value.absent(),
                Value<String> deadlineReason = const Value.absent(),
                Value<String> verdict = const Value.absent(),
                Value<String> headline = const Value.absent(),
                Value<int> evidenceVersion = const Value.absent(),
                Value<String> assessmentId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> missingStatus = const Value.absent(),
                Value<String?> changeNote = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                spotId: spotId,
                spotName: spotName,
                lat: lat,
                lng: lng,
                vehicle: vehicle,
                startedAt: startedAt,
                plannedEndAt: plannedEndAt,
                deadlineAt: deadlineAt,
                deadlineReason: deadlineReason,
                verdict: verdict,
                headline: headline,
                evidenceVersion: evidenceVersion,
                assessmentId: assessmentId,
                state: state,
                missingStatus: missingStatus,
                changeNote: changeNote,
                endedAt: endedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spotId,
                required String spotName,
                required double lat,
                required double lng,
                required String vehicle,
                required DateTime startedAt,
                required DateTime plannedEndAt,
                required DateTime deadlineAt,
                required String deadlineReason,
                required String verdict,
                required String headline,
                required int evidenceVersion,
                required String assessmentId,
                required String state,
                Value<String?> missingStatus = const Value.absent(),
                Value<String?> changeNote = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                spotId: spotId,
                spotName: spotName,
                lat: lat,
                lng: lng,
                vehicle: vehicle,
                startedAt: startedAt,
                plannedEndAt: plannedEndAt,
                deadlineAt: deadlineAt,
                deadlineReason: deadlineReason,
                verdict: verdict,
                headline: headline,
                evidenceVersion: evidenceVersion,
                assessmentId: assessmentId,
                state: state,
                missingStatus: missingStatus,
                changeNote: changeNote,
                endedAt: endedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  BaseReferences<_$DeviceDb, $SessionsTable, Session>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$DeviceDb, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$AssessmentLogTableCreateCompanionBuilder =
    AssessmentLogCompanion Function({
      required String id,
      required String spotId,
      required String verdict,
      required int evidenceVersion,
      required String json,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AssessmentLogTableUpdateCompanionBuilder =
    AssessmentLogCompanion Function({
      Value<String> id,
      Value<String> spotId,
      Value<String> verdict,
      Value<int> evidenceVersion,
      Value<String> json,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AssessmentLogTableFilterComposer
    extends Composer<_$DeviceDb, $AssessmentLogTable> {
  $$AssessmentLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssessmentLogTableOrderingComposer
    extends Composer<_$DeviceDb, $AssessmentLogTable> {
  $$AssessmentLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotId => $composableBuilder(
    column: $table.spotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verdict => $composableBuilder(
    column: $table.verdict,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssessmentLogTableAnnotationComposer
    extends Composer<_$DeviceDb, $AssessmentLogTable> {
  $$AssessmentLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spotId =>
      $composableBuilder(column: $table.spotId, builder: (column) => column);

  GeneratedColumn<String> get verdict =>
      $composableBuilder(column: $table.verdict, builder: (column) => column);

  GeneratedColumn<int> get evidenceVersion => $composableBuilder(
    column: $table.evidenceVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AssessmentLogTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $AssessmentLogTable,
          AssessmentLogData,
          $$AssessmentLogTableFilterComposer,
          $$AssessmentLogTableOrderingComposer,
          $$AssessmentLogTableAnnotationComposer,
          $$AssessmentLogTableCreateCompanionBuilder,
          $$AssessmentLogTableUpdateCompanionBuilder,
          (
            AssessmentLogData,
            BaseReferences<_$DeviceDb, $AssessmentLogTable, AssessmentLogData>,
          ),
          AssessmentLogData,
          PrefetchHooks Function()
        > {
  $$AssessmentLogTableTableManager(_$DeviceDb db, $AssessmentLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssessmentLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssessmentLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spotId = const Value.absent(),
                Value<String> verdict = const Value.absent(),
                Value<int> evidenceVersion = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssessmentLogCompanion(
                id: id,
                spotId: spotId,
                verdict: verdict,
                evidenceVersion: evidenceVersion,
                json: json,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spotId,
                required String verdict,
                required int evidenceVersion,
                required String json,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AssessmentLogCompanion.insert(
                id: id,
                spotId: spotId,
                verdict: verdict,
                evidenceVersion: evidenceVersion,
                json: json,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssessmentLogTable, AssessmentLogData>(table),
                  BaseReferences<
                    _$DeviceDb,
                    $AssessmentLogTable,
                    AssessmentLogData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssessmentLogTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $AssessmentLogTable,
      AssessmentLogData,
      $$AssessmentLogTableFilterComposer,
      $$AssessmentLogTableOrderingComposer,
      $$AssessmentLogTableAnnotationComposer,
      $$AssessmentLogTableCreateCompanionBuilder,
      $$AssessmentLogTableUpdateCompanionBuilder,
      (
        AssessmentLogData,
        BaseReferences<_$DeviceDb, $AssessmentLogTable, AssessmentLogData>,
      ),
      AssessmentLogData,
      PrefetchHooks Function()
    >;
typedef $$EventLogTableCreateCompanionBuilder = EventLogCompanion Function({
  Value<int> id,
  required DateTime at,
  required String origin,
  required String type,
  Value<String?> correlationId,
  required String attrs,
});
typedef $$EventLogTableUpdateCompanionBuilder = EventLogCompanion Function({
  Value<int> id,
  Value<DateTime> at,
  Value<String> origin,
  Value<String> type,
  Value<String?> correlationId,
  Value<String> attrs,
});

class $$EventLogTableFilterComposer
    extends Composer<_$DeviceDb, $EventLogTable> {
  $$EventLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attrs => $composableBuilder(
    column: $table.attrs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventLogTableOrderingComposer
    extends Composer<_$DeviceDb, $EventLogTable> {
  $$EventLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attrs => $composableBuilder(
    column: $table.attrs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventLogTableAnnotationComposer
    extends Composer<_$DeviceDb, $EventLogTable> {
  $$EventLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attrs =>
      $composableBuilder(column: $table.attrs, builder: (column) => column);
}

class $$EventLogTableTableManager
    extends
        RootTableManager<
          _$DeviceDb,
          $EventLogTable,
          EventLogData,
          $$EventLogTableFilterComposer,
          $$EventLogTableOrderingComposer,
          $$EventLogTableAnnotationComposer,
          $$EventLogTableCreateCompanionBuilder,
          $$EventLogTableUpdateCompanionBuilder,
          (
            EventLogData,
            BaseReferences<_$DeviceDb, $EventLogTable, EventLogData>,
          ),
          EventLogData,
          PrefetchHooks Function()
        > {
  $$EventLogTableTableManager(_$DeviceDb db, $EventLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> correlationId = const Value.absent(),
                Value<String> attrs = const Value.absent(),
              }) => EventLogCompanion(
                id: id,
                at: at,
                origin: origin,
                type: type,
                correlationId: correlationId,
                attrs: attrs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required String origin,
                required String type,
                Value<String?> correlationId = const Value.absent(),
                required String attrs,
              }) => EventLogCompanion.insert(
                id: id,
                at: at,
                origin: origin,
                type: type,
                correlationId: correlationId,
                attrs: attrs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventLogTable, EventLogData>(table),
                  BaseReferences<_$DeviceDb, $EventLogTable, EventLogData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventLogTableProcessedTableManager =
    ProcessedTableManager<
      _$DeviceDb,
      $EventLogTable,
      EventLogData,
      $$EventLogTableFilterComposer,
      $$EventLogTableOrderingComposer,
      $$EventLogTableAnnotationComposer,
      $$EventLogTableCreateCompanionBuilder,
      $$EventLogTableUpdateCompanionBuilder,
      (EventLogData, BaseReferences<_$DeviceDb, $EventLogTable, EventLogData>),
      EventLogData,
      PrefetchHooks Function()
    >;

class $DeviceDbManager {
  final _$DeviceDb _db;
  $DeviceDbManager(this._db);
  $$KvEntriesTableTableManager get kvEntries =>
      $$KvEntriesTableTableManager(_db, _db.kvEntries);
  $$EvidenceCacheTableTableManager get evidenceCache =>
      $$EvidenceCacheTableTableManager(_db, _db.evidenceCache);
  $$TipsTableTableManager get tips => $$TipsTableTableManager(_db, _db.tips);
  $$OutboxOpsTableTableManager get outboxOps =>
      $$OutboxOpsTableTableManager(_db, _db.outboxOps);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$AssessmentLogTableTableManager get assessmentLog =>
      $$AssessmentLogTableTableManager(_db, _db.assessmentLog);
  $$EventLogTableTableManager get eventLog =>
      $$EventLogTableTableManager(_db, _db.eventLog);
}
