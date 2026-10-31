// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_db.dart';

// ignore_for_file: type=lint
class $SrvOperationsTable extends SrvOperations
    with TableInfo<$SrvOperationsTable, SrvOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvOperationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _resultJsonMeta = const VerificationMeta(
    'resultJson',
  );
  @override
  late final GeneratedColumn<String> resultJson = GeneratedColumn<String>(
    'result_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _committedAtMeta = const VerificationMeta(
    'committedAt',
  );
  @override
  late final GeneratedColumn<DateTime> committedAt = GeneratedColumn<DateTime>(
    'committed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [opId, kind, resultJson, committedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvOperation> instance, {
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
    if (data.containsKey('result_json')) {
      context.handle(
        _resultJsonMeta,
        resultJson.isAcceptableOrUnknown(data['result_json']!, _resultJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_resultJsonMeta);
    }
    if (data.containsKey('committed_at')) {
      context.handle(
        _committedAtMeta,
        committedAt.isAcceptableOrUnknown(
          data['committed_at']!,
          _committedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_committedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  SrvOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvOperation(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      resultJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_json'],
      )!,
      committedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}committed_at'],
      )!,
    );
  }

  @override
  $SrvOperationsTable createAlias(String alias) {
    return $SrvOperationsTable(attachedDatabase, alias);
  }
}

class SrvOperation extends DataClass implements Insertable<SrvOperation> {
  final String opId;
  final String kind;
  final String resultJson;
  final DateTime committedAt;
  const SrvOperation({
    required this.opId,
    required this.kind,
    required this.resultJson,
    required this.committedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['kind'] = Variable<String>(kind);
    map['result_json'] = Variable<String>(resultJson);
    map['committed_at'] = Variable<DateTime>(committedAt);
    return map;
  }

  SrvOperationsCompanion toCompanion(bool nullToAbsent) {
    return SrvOperationsCompanion(
      opId: Value(opId),
      kind: Value(kind),
      resultJson: Value(resultJson),
      committedAt: Value(committedAt),
    );
  }

  factory SrvOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvOperation(
      opId: serializer.fromJson<String>(json['opId']),
      kind: serializer.fromJson<String>(json['kind']),
      resultJson: serializer.fromJson<String>(json['resultJson']),
      committedAt: serializer.fromJson<DateTime>(json['committedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'kind': serializer.toJson<String>(kind),
      'resultJson': serializer.toJson<String>(resultJson),
      'committedAt': serializer.toJson<DateTime>(committedAt),
    };
  }

  SrvOperation copyWith({
    String? opId,
    String? kind,
    String? resultJson,
    DateTime? committedAt,
  }) => SrvOperation(
    opId: opId ?? this.opId,
    kind: kind ?? this.kind,
    resultJson: resultJson ?? this.resultJson,
    committedAt: committedAt ?? this.committedAt,
  );
  SrvOperation copyWithCompanion(SrvOperationsCompanion data) {
    return SrvOperation(
      opId: data.opId.present ? data.opId.value : this.opId,
      kind: data.kind.present ? data.kind.value : this.kind,
      resultJson: data.resultJson.present
          ? data.resultJson.value
          : this.resultJson,
      committedAt: data.committedAt.present
          ? data.committedAt.value
          : this.committedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvOperation(')
          ..write('opId: $opId, ')
          ..write('kind: $kind, ')
          ..write('resultJson: $resultJson, ')
          ..write('committedAt: $committedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(opId, kind, resultJson, committedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvOperation &&
          other.opId == this.opId &&
          other.kind == this.kind &&
          other.resultJson == this.resultJson &&
          other.committedAt == this.committedAt);
}

class SrvOperationsCompanion extends UpdateCompanion<SrvOperation> {
  final Value<String> opId;
  final Value<String> kind;
  final Value<String> resultJson;
  final Value<DateTime> committedAt;
  final Value<int> rowid;
  const SrvOperationsCompanion({
    this.opId = const Value.absent(),
    this.kind = const Value.absent(),
    this.resultJson = const Value.absent(),
    this.committedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrvOperationsCompanion.insert({
    required String opId,
    required String kind,
    required String resultJson,
    required DateTime committedAt,
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       kind = Value(kind),
       resultJson = Value(resultJson),
       committedAt = Value(committedAt);
  static Insertable<SrvOperation> custom({
    Expression<String>? opId,
    Expression<String>? kind,
    Expression<String>? resultJson,
    Expression<DateTime>? committedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (kind != null) 'kind': kind,
      if (resultJson != null) 'result_json': resultJson,
      if (committedAt != null) 'committed_at': committedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrvOperationsCompanion copyWith({
    Value<String>? opId,
    Value<String>? kind,
    Value<String>? resultJson,
    Value<DateTime>? committedAt,
    Value<int>? rowid,
  }) {
    return SrvOperationsCompanion(
      opId: opId ?? this.opId,
      kind: kind ?? this.kind,
      resultJson: resultJson ?? this.resultJson,
      committedAt: committedAt ?? this.committedAt,
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
    if (resultJson.present) {
      map['result_json'] = Variable<String>(resultJson.value);
    }
    if (committedAt.present) {
      map['committed_at'] = Variable<DateTime>(committedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvOperationsCompanion(')
          ..write('opId: $opId, ')
          ..write('kind: $kind, ')
          ..write('resultJson: $resultJson, ')
          ..write('committedAt: $committedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrvTipsTable extends SrvTips with TableInfo<$SrvTipsTable, SrvTip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvTipsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewerIdMeta = const VerificationMeta(
    'reviewerId',
  );
  @override
  late final GeneratedColumn<String> reviewerId = GeneratedColumn<String>(
    'reviewer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spotId,
    authorId,
    payload,
    photoId,
    status,
    version,
    submittedAt,
    reviewedAt,
    reviewerId,
    reviewNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_tips';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvTip> instance, {
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
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    }
    if (data.containsKey('reviewer_id')) {
      context.handle(
        _reviewerIdMeta,
        reviewerId.isAcceptableOrUnknown(data['reviewer_id']!, _reviewerIdMeta),
      );
    }
    if (data.containsKey('review_note')) {
      context.handle(
        _reviewNoteMeta,
        reviewNote.isAcceptableOrUnknown(data['review_note']!, _reviewNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrvTip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvTip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      photoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      ),
      reviewerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewer_id'],
      ),
      reviewNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_note'],
      ),
    );
  }

  @override
  $SrvTipsTable createAlias(String alias) {
    return $SrvTipsTable(attachedDatabase, alias);
  }
}

class SrvTip extends DataClass implements Insertable<SrvTip> {
  final String id;
  final String spotId;
  final String authorId;
  final String payload;
  final String? photoId;
  final String status;
  final int version;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewerId;
  final String? reviewNote;
  const SrvTip({
    required this.id,
    required this.spotId,
    required this.authorId,
    required this.payload,
    this.photoId,
    required this.status,
    required this.version,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewerId,
    this.reviewNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['spot_id'] = Variable<String>(spotId);
    map['author_id'] = Variable<String>(authorId);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || photoId != null) {
      map['photo_id'] = Variable<String>(photoId);
    }
    map['status'] = Variable<String>(status);
    map['version'] = Variable<int>(version);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    if (!nullToAbsent || reviewedAt != null) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    }
    if (!nullToAbsent || reviewerId != null) {
      map['reviewer_id'] = Variable<String>(reviewerId);
    }
    if (!nullToAbsent || reviewNote != null) {
      map['review_note'] = Variable<String>(reviewNote);
    }
    return map;
  }

  SrvTipsCompanion toCompanion(bool nullToAbsent) {
    return SrvTipsCompanion(
      id: Value(id),
      spotId: Value(spotId),
      authorId: Value(authorId),
      payload: Value(payload),
      photoId: photoId == null && nullToAbsent
          ? const Value.absent()
          : Value(photoId),
      status: Value(status),
      version: Value(version),
      submittedAt: Value(submittedAt),
      reviewedAt: reviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAt),
      reviewerId: reviewerId == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewerId),
      reviewNote: reviewNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewNote),
    );
  }

  factory SrvTip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvTip(
      id: serializer.fromJson<String>(json['id']),
      spotId: serializer.fromJson<String>(json['spotId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      payload: serializer.fromJson<String>(json['payload']),
      photoId: serializer.fromJson<String?>(json['photoId']),
      status: serializer.fromJson<String>(json['status']),
      version: serializer.fromJson<int>(json['version']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
      reviewedAt: serializer.fromJson<DateTime?>(json['reviewedAt']),
      reviewerId: serializer.fromJson<String?>(json['reviewerId']),
      reviewNote: serializer.fromJson<String?>(json['reviewNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spotId': serializer.toJson<String>(spotId),
      'authorId': serializer.toJson<String>(authorId),
      'payload': serializer.toJson<String>(payload),
      'photoId': serializer.toJson<String?>(photoId),
      'status': serializer.toJson<String>(status),
      'version': serializer.toJson<int>(version),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
      'reviewedAt': serializer.toJson<DateTime?>(reviewedAt),
      'reviewerId': serializer.toJson<String?>(reviewerId),
      'reviewNote': serializer.toJson<String?>(reviewNote),
    };
  }

  SrvTip copyWith({
    String? id,
    String? spotId,
    String? authorId,
    String? payload,
    Value<String?> photoId = const Value.absent(),
    String? status,
    int? version,
    DateTime? submittedAt,
    Value<DateTime?> reviewedAt = const Value.absent(),
    Value<String?> reviewerId = const Value.absent(),
    Value<String?> reviewNote = const Value.absent(),
  }) => SrvTip(
    id: id ?? this.id,
    spotId: spotId ?? this.spotId,
    authorId: authorId ?? this.authorId,
    payload: payload ?? this.payload,
    photoId: photoId.present ? photoId.value : this.photoId,
    status: status ?? this.status,
    version: version ?? this.version,
    submittedAt: submittedAt ?? this.submittedAt,
    reviewedAt: reviewedAt.present ? reviewedAt.value : this.reviewedAt,
    reviewerId: reviewerId.present ? reviewerId.value : this.reviewerId,
    reviewNote: reviewNote.present ? reviewNote.value : this.reviewNote,
  );
  SrvTip copyWithCompanion(SrvTipsCompanion data) {
    return SrvTip(
      id: data.id.present ? data.id.value : this.id,
      spotId: data.spotId.present ? data.spotId.value : this.spotId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      payload: data.payload.present ? data.payload.value : this.payload,
      photoId: data.photoId.present ? data.photoId.value : this.photoId,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
      reviewerId: data.reviewerId.present
          ? data.reviewerId.value
          : this.reviewerId,
      reviewNote: data.reviewNote.present
          ? data.reviewNote.value
          : this.reviewNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvTip(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('authorId: $authorId, ')
          ..write('payload: $payload, ')
          ..write('photoId: $photoId, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('reviewerId: $reviewerId, ')
          ..write('reviewNote: $reviewNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spotId,
    authorId,
    payload,
    photoId,
    status,
    version,
    submittedAt,
    reviewedAt,
    reviewerId,
    reviewNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvTip &&
          other.id == this.id &&
          other.spotId == this.spotId &&
          other.authorId == this.authorId &&
          other.payload == this.payload &&
          other.photoId == this.photoId &&
          other.status == this.status &&
          other.version == this.version &&
          other.submittedAt == this.submittedAt &&
          other.reviewedAt == this.reviewedAt &&
          other.reviewerId == this.reviewerId &&
          other.reviewNote == this.reviewNote);
}

class SrvTipsCompanion extends UpdateCompanion<SrvTip> {
  final Value<String> id;
  final Value<String> spotId;
  final Value<String> authorId;
  final Value<String> payload;
  final Value<String?> photoId;
  final Value<String> status;
  final Value<int> version;
  final Value<DateTime> submittedAt;
  final Value<DateTime?> reviewedAt;
  final Value<String?> reviewerId;
  final Value<String?> reviewNote;
  final Value<int> rowid;
  const SrvTipsCompanion({
    this.id = const Value.absent(),
    this.spotId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.payload = const Value.absent(),
    this.photoId = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.reviewerId = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrvTipsCompanion.insert({
    required String id,
    required String spotId,
    required String authorId,
    required String payload,
    this.photoId = const Value.absent(),
    required String status,
    required int version,
    required DateTime submittedAt,
    this.reviewedAt = const Value.absent(),
    this.reviewerId = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spotId = Value(spotId),
       authorId = Value(authorId),
       payload = Value(payload),
       status = Value(status),
       version = Value(version),
       submittedAt = Value(submittedAt);
  static Insertable<SrvTip> custom({
    Expression<String>? id,
    Expression<String>? spotId,
    Expression<String>? authorId,
    Expression<String>? payload,
    Expression<String>? photoId,
    Expression<String>? status,
    Expression<int>? version,
    Expression<DateTime>? submittedAt,
    Expression<DateTime>? reviewedAt,
    Expression<String>? reviewerId,
    Expression<String>? reviewNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spotId != null) 'spot_id': spotId,
      if (authorId != null) 'author_id': authorId,
      if (payload != null) 'payload': payload,
      if (photoId != null) 'photo_id': photoId,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (reviewerId != null) 'reviewer_id': reviewerId,
      if (reviewNote != null) 'review_note': reviewNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrvTipsCompanion copyWith({
    Value<String>? id,
    Value<String>? spotId,
    Value<String>? authorId,
    Value<String>? payload,
    Value<String?>? photoId,
    Value<String>? status,
    Value<int>? version,
    Value<DateTime>? submittedAt,
    Value<DateTime?>? reviewedAt,
    Value<String?>? reviewerId,
    Value<String?>? reviewNote,
    Value<int>? rowid,
  }) {
    return SrvTipsCompanion(
      id: id ?? this.id,
      spotId: spotId ?? this.spotId,
      authorId: authorId ?? this.authorId,
      payload: payload ?? this.payload,
      photoId: photoId ?? this.photoId,
      status: status ?? this.status,
      version: version ?? this.version,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewNote: reviewNote ?? this.reviewNote,
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
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (photoId.present) {
      map['photo_id'] = Variable<String>(photoId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (reviewerId.present) {
      map['reviewer_id'] = Variable<String>(reviewerId.value);
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvTipsCompanion(')
          ..write('id: $id, ')
          ..write('spotId: $spotId, ')
          ..write('authorId: $authorId, ')
          ..write('payload: $payload, ')
          ..write('photoId: $photoId, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('reviewerId: $reviewerId, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrvPhotosTable extends SrvPhotos
    with TableInfo<$SrvPhotosTable, SrvPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, sizeBytes, uploadedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrvPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
    );
  }

  @override
  $SrvPhotosTable createAlias(String alias) {
    return $SrvPhotosTable(attachedDatabase, alias);
  }
}

class SrvPhoto extends DataClass implements Insertable<SrvPhoto> {
  final String id;
  final String path;
  final int sizeBytes;
  final DateTime uploadedAt;
  const SrvPhoto({
    required this.id,
    required this.path,
    required this.sizeBytes,
    required this.uploadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    return map;
  }

  SrvPhotosCompanion toCompanion(bool nullToAbsent) {
    return SrvPhotosCompanion(
      id: Value(id),
      path: Value(path),
      sizeBytes: Value(sizeBytes),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory SrvPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvPhoto(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
    };
  }

  SrvPhoto copyWith({
    String? id,
    String? path,
    int? sizeBytes,
    DateTime? uploadedAt,
  }) => SrvPhoto(
    id: id ?? this.id,
    path: path ?? this.path,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    uploadedAt: uploadedAt ?? this.uploadedAt,
  );
  SrvPhoto copyWithCompanion(SrvPhotosCompanion data) {
    return SrvPhoto(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvPhoto(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, sizeBytes, uploadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvPhoto &&
          other.id == this.id &&
          other.path == this.path &&
          other.sizeBytes == this.sizeBytes &&
          other.uploadedAt == this.uploadedAt);
}

class SrvPhotosCompanion extends UpdateCompanion<SrvPhoto> {
  final Value<String> id;
  final Value<String> path;
  final Value<int> sizeBytes;
  final Value<DateTime> uploadedAt;
  final Value<int> rowid;
  const SrvPhotosCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrvPhotosCompanion.insert({
    required String id,
    required String path,
    required int sizeBytes,
    required DateTime uploadedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       path = Value(path),
       sizeBytes = Value(sizeBytes),
       uploadedAt = Value(uploadedAt);
  static Insertable<SrvPhoto> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<int>? sizeBytes,
    Expression<DateTime>? uploadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrvPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? path,
    Value<int>? sizeBytes,
    Value<DateTime>? uploadedAt,
    Value<int>? rowid,
  }) {
    return SrvPhotosCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvPhotosCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrvRewardsTable extends SrvRewards
    with TableInfo<$SrvRewardsTable, SrvReward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvRewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tipIdMeta = const VerificationMeta('tipId');
  @override
  late final GeneratedColumn<String> tipId = GeneratedColumn<String>(
    'tip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grantedAtMeta = const VerificationMeta(
    'grantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> grantedAt = GeneratedColumn<DateTime>(
    'granted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tipId, userId, points, grantedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvReward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tip_id')) {
      context.handle(
        _tipIdMeta,
        tipId.isAcceptableOrUnknown(data['tip_id']!, _tipIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tipIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('granted_at')) {
      context.handle(
        _grantedAtMeta,
        grantedAt.isAcceptableOrUnknown(data['granted_at']!, _grantedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_grantedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tipId};
  @override
  SrvReward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvReward(
      tipId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tip_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      grantedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}granted_at'],
      )!,
    );
  }

  @override
  $SrvRewardsTable createAlias(String alias) {
    return $SrvRewardsTable(attachedDatabase, alias);
  }
}

class SrvReward extends DataClass implements Insertable<SrvReward> {
  final String tipId;
  final String userId;
  final int points;
  final DateTime grantedAt;
  const SrvReward({
    required this.tipId,
    required this.userId,
    required this.points,
    required this.grantedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tip_id'] = Variable<String>(tipId);
    map['user_id'] = Variable<String>(userId);
    map['points'] = Variable<int>(points);
    map['granted_at'] = Variable<DateTime>(grantedAt);
    return map;
  }

  SrvRewardsCompanion toCompanion(bool nullToAbsent) {
    return SrvRewardsCompanion(
      tipId: Value(tipId),
      userId: Value(userId),
      points: Value(points),
      grantedAt: Value(grantedAt),
    );
  }

  factory SrvReward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvReward(
      tipId: serializer.fromJson<String>(json['tipId']),
      userId: serializer.fromJson<String>(json['userId']),
      points: serializer.fromJson<int>(json['points']),
      grantedAt: serializer.fromJson<DateTime>(json['grantedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tipId': serializer.toJson<String>(tipId),
      'userId': serializer.toJson<String>(userId),
      'points': serializer.toJson<int>(points),
      'grantedAt': serializer.toJson<DateTime>(grantedAt),
    };
  }

  SrvReward copyWith({
    String? tipId,
    String? userId,
    int? points,
    DateTime? grantedAt,
  }) => SrvReward(
    tipId: tipId ?? this.tipId,
    userId: userId ?? this.userId,
    points: points ?? this.points,
    grantedAt: grantedAt ?? this.grantedAt,
  );
  SrvReward copyWithCompanion(SrvRewardsCompanion data) {
    return SrvReward(
      tipId: data.tipId.present ? data.tipId.value : this.tipId,
      userId: data.userId.present ? data.userId.value : this.userId,
      points: data.points.present ? data.points.value : this.points,
      grantedAt: data.grantedAt.present ? data.grantedAt.value : this.grantedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvReward(')
          ..write('tipId: $tipId, ')
          ..write('userId: $userId, ')
          ..write('points: $points, ')
          ..write('grantedAt: $grantedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tipId, userId, points, grantedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvReward &&
          other.tipId == this.tipId &&
          other.userId == this.userId &&
          other.points == this.points &&
          other.grantedAt == this.grantedAt);
}

class SrvRewardsCompanion extends UpdateCompanion<SrvReward> {
  final Value<String> tipId;
  final Value<String> userId;
  final Value<int> points;
  final Value<DateTime> grantedAt;
  final Value<int> rowid;
  const SrvRewardsCompanion({
    this.tipId = const Value.absent(),
    this.userId = const Value.absent(),
    this.points = const Value.absent(),
    this.grantedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrvRewardsCompanion.insert({
    required String tipId,
    required String userId,
    required int points,
    required DateTime grantedAt,
    this.rowid = const Value.absent(),
  }) : tipId = Value(tipId),
       userId = Value(userId),
       points = Value(points),
       grantedAt = Value(grantedAt);
  static Insertable<SrvReward> custom({
    Expression<String>? tipId,
    Expression<String>? userId,
    Expression<int>? points,
    Expression<DateTime>? grantedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tipId != null) 'tip_id': tipId,
      if (userId != null) 'user_id': userId,
      if (points != null) 'points': points,
      if (grantedAt != null) 'granted_at': grantedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrvRewardsCompanion copyWith({
    Value<String>? tipId,
    Value<String>? userId,
    Value<int>? points,
    Value<DateTime>? grantedAt,
    Value<int>? rowid,
  }) {
    return SrvRewardsCompanion(
      tipId: tipId ?? this.tipId,
      userId: userId ?? this.userId,
      points: points ?? this.points,
      grantedAt: grantedAt ?? this.grantedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tipId.present) {
      map['tip_id'] = Variable<String>(tipId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (grantedAt.present) {
      map['granted_at'] = Variable<DateTime>(grantedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvRewardsCompanion(')
          ..write('tipId: $tipId, ')
          ..write('userId: $userId, ')
          ..write('points: $points, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrvEvidenceTable extends SrvEvidence
    with TableInfo<$SrvEvidenceTable, SrvEvidenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvEvidenceTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, version, json, publishedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvEvidenceData> instance, {
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
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  SrvEvidenceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvEvidenceData(
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
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
    );
  }

  @override
  $SrvEvidenceTable createAlias(String alias) {
    return $SrvEvidenceTable(attachedDatabase, alias);
  }
}

class SrvEvidenceData extends DataClass implements Insertable<SrvEvidenceData> {
  final int slot;
  final int version;
  final String json;
  final DateTime publishedAt;
  const SrvEvidenceData({
    required this.slot,
    required this.version,
    required this.json,
    required this.publishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['version'] = Variable<int>(version);
    map['json'] = Variable<String>(json);
    map['published_at'] = Variable<DateTime>(publishedAt);
    return map;
  }

  SrvEvidenceCompanion toCompanion(bool nullToAbsent) {
    return SrvEvidenceCompanion(
      slot: Value(slot),
      version: Value(version),
      json: Value(json),
      publishedAt: Value(publishedAt),
    );
  }

  factory SrvEvidenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvEvidenceData(
      slot: serializer.fromJson<int>(json['slot']),
      version: serializer.fromJson<int>(json['version']),
      json: serializer.fromJson<String>(json['json']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'version': serializer.toJson<int>(version),
      'json': serializer.toJson<String>(json),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
    };
  }

  SrvEvidenceData copyWith({
    int? slot,
    int? version,
    String? json,
    DateTime? publishedAt,
  }) => SrvEvidenceData(
    slot: slot ?? this.slot,
    version: version ?? this.version,
    json: json ?? this.json,
    publishedAt: publishedAt ?? this.publishedAt,
  );
  SrvEvidenceData copyWithCompanion(SrvEvidenceCompanion data) {
    return SrvEvidenceData(
      slot: data.slot.present ? data.slot.value : this.slot,
      version: data.version.present ? data.version.value : this.version,
      json: data.json.present ? data.json.value : this.json,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvEvidenceData(')
          ..write('slot: $slot, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, version, json, publishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvEvidenceData &&
          other.slot == this.slot &&
          other.version == this.version &&
          other.json == this.json &&
          other.publishedAt == this.publishedAt);
}

class SrvEvidenceCompanion extends UpdateCompanion<SrvEvidenceData> {
  final Value<int> slot;
  final Value<int> version;
  final Value<String> json;
  final Value<DateTime> publishedAt;
  const SrvEvidenceCompanion({
    this.slot = const Value.absent(),
    this.version = const Value.absent(),
    this.json = const Value.absent(),
    this.publishedAt = const Value.absent(),
  });
  SrvEvidenceCompanion.insert({
    this.slot = const Value.absent(),
    required int version,
    required String json,
    required DateTime publishedAt,
  }) : version = Value(version),
       json = Value(json),
       publishedAt = Value(publishedAt);
  static Insertable<SrvEvidenceData> custom({
    Expression<int>? slot,
    Expression<int>? version,
    Expression<String>? json,
    Expression<DateTime>? publishedAt,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (version != null) 'version': version,
      if (json != null) 'json': json,
      if (publishedAt != null) 'published_at': publishedAt,
    });
  }

  SrvEvidenceCompanion copyWith({
    Value<int>? slot,
    Value<int>? version,
    Value<String>? json,
    Value<DateTime>? publishedAt,
  }) {
    return SrvEvidenceCompanion(
      slot: slot ?? this.slot,
      version: version ?? this.version,
      json: json ?? this.json,
      publishedAt: publishedAt ?? this.publishedAt,
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
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvEvidenceCompanion(')
          ..write('slot: $slot, ')
          ..write('version: $version, ')
          ..write('json: $json, ')
          ..write('publishedAt: $publishedAt')
          ..write(')'))
        .toString();
  }
}

class $SrvAuditTable extends SrvAudit
    with TableInfo<$SrvAuditTable, SrvAuditData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrvAuditTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    actor,
    action,
    target,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srv_audit';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrvAuditData> instance, {
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
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrvAuditData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrvAuditData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
    );
  }

  @override
  $SrvAuditTable createAlias(String alias) {
    return $SrvAuditTable(attachedDatabase, alias);
  }
}

class SrvAuditData extends DataClass implements Insertable<SrvAuditData> {
  final int id;
  final DateTime at;
  final String actor;
  final String action;
  final String target;
  final String details;
  const SrvAuditData({
    required this.id,
    required this.at,
    required this.actor,
    required this.action,
    required this.target,
    required this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['actor'] = Variable<String>(actor);
    map['action'] = Variable<String>(action);
    map['target'] = Variable<String>(target);
    map['details'] = Variable<String>(details);
    return map;
  }

  SrvAuditCompanion toCompanion(bool nullToAbsent) {
    return SrvAuditCompanion(
      id: Value(id),
      at: Value(at),
      actor: Value(actor),
      action: Value(action),
      target: Value(target),
      details: Value(details),
    );
  }

  factory SrvAuditData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrvAuditData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      actor: serializer.fromJson<String>(json['actor']),
      action: serializer.fromJson<String>(json['action']),
      target: serializer.fromJson<String>(json['target']),
      details: serializer.fromJson<String>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'actor': serializer.toJson<String>(actor),
      'action': serializer.toJson<String>(action),
      'target': serializer.toJson<String>(target),
      'details': serializer.toJson<String>(details),
    };
  }

  SrvAuditData copyWith({
    int? id,
    DateTime? at,
    String? actor,
    String? action,
    String? target,
    String? details,
  }) => SrvAuditData(
    id: id ?? this.id,
    at: at ?? this.at,
    actor: actor ?? this.actor,
    action: action ?? this.action,
    target: target ?? this.target,
    details: details ?? this.details,
  );
  SrvAuditData copyWithCompanion(SrvAuditCompanion data) {
    return SrvAuditData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      actor: data.actor.present ? data.actor.value : this.actor,
      action: data.action.present ? data.action.value : this.action,
      target: data.target.present ? data.target.value : this.target,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrvAuditData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('actor: $actor, ')
          ..write('action: $action, ')
          ..write('target: $target, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, actor, action, target, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrvAuditData &&
          other.id == this.id &&
          other.at == this.at &&
          other.actor == this.actor &&
          other.action == this.action &&
          other.target == this.target &&
          other.details == this.details);
}

class SrvAuditCompanion extends UpdateCompanion<SrvAuditData> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> actor;
  final Value<String> action;
  final Value<String> target;
  final Value<String> details;
  const SrvAuditCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.actor = const Value.absent(),
    this.action = const Value.absent(),
    this.target = const Value.absent(),
    this.details = const Value.absent(),
  });
  SrvAuditCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required String actor,
    required String action,
    required String target,
    required String details,
  }) : at = Value(at),
       actor = Value(actor),
       action = Value(action),
       target = Value(target),
       details = Value(details);
  static Insertable<SrvAuditData> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? actor,
    Expression<String>? action,
    Expression<String>? target,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (actor != null) 'actor': actor,
      if (action != null) 'action': action,
      if (target != null) 'target': target,
      if (details != null) 'details': details,
    });
  }

  SrvAuditCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? actor,
    Value<String>? action,
    Value<String>? target,
    Value<String>? details,
  }) {
    return SrvAuditCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      actor: actor ?? this.actor,
      action: action ?? this.action,
      target: target ?? this.target,
      details: details ?? this.details,
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
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrvAuditCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('actor: $actor, ')
          ..write('action: $action, ')
          ..write('target: $target, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

abstract class _$ServerDb extends GeneratedDatabase {
  _$ServerDb(QueryExecutor e) : super(e);
  $ServerDbManager get managers => $ServerDbManager(this);
  late final $SrvOperationsTable srvOperations = $SrvOperationsTable(this);
  late final $SrvTipsTable srvTips = $SrvTipsTable(this);
  late final $SrvPhotosTable srvPhotos = $SrvPhotosTable(this);
  late final $SrvRewardsTable srvRewards = $SrvRewardsTable(this);
  late final $SrvEvidenceTable srvEvidence = $SrvEvidenceTable(this);
  late final $SrvAuditTable srvAudit = $SrvAuditTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    srvOperations,
    srvTips,
    srvPhotos,
    srvRewards,
    srvEvidence,
    srvAudit,
  ];
}

typedef $$SrvOperationsTableCreateCompanionBuilder =
    SrvOperationsCompanion Function({
      required String opId,
      required String kind,
      required String resultJson,
      required DateTime committedAt,
      Value<int> rowid,
    });
typedef $$SrvOperationsTableUpdateCompanionBuilder =
    SrvOperationsCompanion Function({
      Value<String> opId,
      Value<String> kind,
      Value<String> resultJson,
      Value<DateTime> committedAt,
      Value<int> rowid,
    });

class $$SrvOperationsTableFilterComposer
    extends Composer<_$ServerDb, $SrvOperationsTable> {
  $$SrvOperationsTableFilterComposer({
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

  ColumnFilters<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get committedAt => $composableBuilder(
    column: $table.committedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvOperationsTableOrderingComposer
    extends Composer<_$ServerDb, $SrvOperationsTable> {
  $$SrvOperationsTableOrderingComposer({
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

  ColumnOrderings<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get committedAt => $composableBuilder(
    column: $table.committedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvOperationsTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvOperationsTable> {
  $$SrvOperationsTableAnnotationComposer({
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

  GeneratedColumn<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get committedAt => $composableBuilder(
    column: $table.committedAt,
    builder: (column) => column,
  );
}

class $$SrvOperationsTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvOperationsTable,
          SrvOperation,
          $$SrvOperationsTableFilterComposer,
          $$SrvOperationsTableOrderingComposer,
          $$SrvOperationsTableAnnotationComposer,
          $$SrvOperationsTableCreateCompanionBuilder,
          $$SrvOperationsTableUpdateCompanionBuilder,
          (
            SrvOperation,
            BaseReferences<_$ServerDb, $SrvOperationsTable, SrvOperation>,
          ),
          SrvOperation,
          PrefetchHooks Function()
        > {
  $$SrvOperationsTableTableManager(_$ServerDb db, $SrvOperationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> resultJson = const Value.absent(),
                Value<DateTime> committedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrvOperationsCompanion(
                opId: opId,
                kind: kind,
                resultJson: resultJson,
                committedAt: committedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String kind,
                required String resultJson,
                required DateTime committedAt,
                Value<int> rowid = const Value.absent(),
              }) => SrvOperationsCompanion.insert(
                opId: opId,
                kind: kind,
                resultJson: resultJson,
                committedAt: committedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvOperationsTable, SrvOperation>(table),
                  BaseReferences<_$ServerDb, $SrvOperationsTable, SrvOperation>(
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

typedef $$SrvOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvOperationsTable,
      SrvOperation,
      $$SrvOperationsTableFilterComposer,
      $$SrvOperationsTableOrderingComposer,
      $$SrvOperationsTableAnnotationComposer,
      $$SrvOperationsTableCreateCompanionBuilder,
      $$SrvOperationsTableUpdateCompanionBuilder,
      (
        SrvOperation,
        BaseReferences<_$ServerDb, $SrvOperationsTable, SrvOperation>,
      ),
      SrvOperation,
      PrefetchHooks Function()
    >;
typedef $$SrvTipsTableCreateCompanionBuilder = SrvTipsCompanion Function({
  required String id,
  required String spotId,
  required String authorId,
  required String payload,
  Value<String?> photoId,
  required String status,
  required int version,
  required DateTime submittedAt,
  Value<DateTime?> reviewedAt,
  Value<String?> reviewerId,
  Value<String?> reviewNote,
  Value<int> rowid,
});
typedef $$SrvTipsTableUpdateCompanionBuilder = SrvTipsCompanion Function({
  Value<String> id,
  Value<String> spotId,
  Value<String> authorId,
  Value<String> payload,
  Value<String?> photoId,
  Value<String> status,
  Value<int> version,
  Value<DateTime> submittedAt,
  Value<DateTime?> reviewedAt,
  Value<String?> reviewerId,
  Value<String?> reviewNote,
  Value<int> rowid,
});

class $$SrvTipsTableFilterComposer extends Composer<_$ServerDb, $SrvTipsTable> {
  $$SrvTipsTableFilterComposer({
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

  ColumnFilters<String> get authorId => $composableBuilder(
    column: $table.authorId,
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewerId => $composableBuilder(
    column: $table.reviewerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvTipsTableOrderingComposer
    extends Composer<_$ServerDb, $SrvTipsTable> {
  $$SrvTipsTableOrderingComposer({
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

  ColumnOrderings<String> get authorId => $composableBuilder(
    column: $table.authorId,
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewerId => $composableBuilder(
    column: $table.reviewerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvTipsTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvTipsTable> {
  $$SrvTipsTableAnnotationComposer({
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

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get photoId =>
      $composableBuilder(column: $table.photoId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewerId => $composableBuilder(
    column: $table.reviewerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => column,
  );
}

class $$SrvTipsTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvTipsTable,
          SrvTip,
          $$SrvTipsTableFilterComposer,
          $$SrvTipsTableOrderingComposer,
          $$SrvTipsTableAnnotationComposer,
          $$SrvTipsTableCreateCompanionBuilder,
          $$SrvTipsTableUpdateCompanionBuilder,
          (SrvTip, BaseReferences<_$ServerDb, $SrvTipsTable, SrvTip>),
          SrvTip,
          PrefetchHooks Function()
        > {
  $$SrvTipsTableTableManager(_$ServerDb db, $SrvTipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvTipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvTipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvTipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spotId = const Value.absent(),
                Value<String> authorId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> photoId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<DateTime?> reviewedAt = const Value.absent(),
                Value<String?> reviewerId = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrvTipsCompanion(
                id: id,
                spotId: spotId,
                authorId: authorId,
                payload: payload,
                photoId: photoId,
                status: status,
                version: version,
                submittedAt: submittedAt,
                reviewedAt: reviewedAt,
                reviewerId: reviewerId,
                reviewNote: reviewNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spotId,
                required String authorId,
                required String payload,
                Value<String?> photoId = const Value.absent(),
                required String status,
                required int version,
                required DateTime submittedAt,
                Value<DateTime?> reviewedAt = const Value.absent(),
                Value<String?> reviewerId = const Value.absent(),
                Value<String?> reviewNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrvTipsCompanion.insert(
                id: id,
                spotId: spotId,
                authorId: authorId,
                payload: payload,
                photoId: photoId,
                status: status,
                version: version,
                submittedAt: submittedAt,
                reviewedAt: reviewedAt,
                reviewerId: reviewerId,
                reviewNote: reviewNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvTipsTable, SrvTip>(table),
                  BaseReferences<_$ServerDb, $SrvTipsTable, SrvTip>(
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

typedef $$SrvTipsTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvTipsTable,
      SrvTip,
      $$SrvTipsTableFilterComposer,
      $$SrvTipsTableOrderingComposer,
      $$SrvTipsTableAnnotationComposer,
      $$SrvTipsTableCreateCompanionBuilder,
      $$SrvTipsTableUpdateCompanionBuilder,
      (SrvTip, BaseReferences<_$ServerDb, $SrvTipsTable, SrvTip>),
      SrvTip,
      PrefetchHooks Function()
    >;
typedef $$SrvPhotosTableCreateCompanionBuilder = SrvPhotosCompanion Function({
  required String id,
  required String path,
  required int sizeBytes,
  required DateTime uploadedAt,
  Value<int> rowid,
});
typedef $$SrvPhotosTableUpdateCompanionBuilder = SrvPhotosCompanion Function({
  Value<String> id,
  Value<String> path,
  Value<int> sizeBytes,
  Value<DateTime> uploadedAt,
  Value<int> rowid,
});

class $$SrvPhotosTableFilterComposer
    extends Composer<_$ServerDb, $SrvPhotosTable> {
  $$SrvPhotosTableFilterComposer({
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

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvPhotosTableOrderingComposer
    extends Composer<_$ServerDb, $SrvPhotosTable> {
  $$SrvPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvPhotosTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvPhotosTable> {
  $$SrvPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );
}

class $$SrvPhotosTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvPhotosTable,
          SrvPhoto,
          $$SrvPhotosTableFilterComposer,
          $$SrvPhotosTableOrderingComposer,
          $$SrvPhotosTableAnnotationComposer,
          $$SrvPhotosTableCreateCompanionBuilder,
          $$SrvPhotosTableUpdateCompanionBuilder,
          (SrvPhoto, BaseReferences<_$ServerDb, $SrvPhotosTable, SrvPhoto>),
          SrvPhoto,
          PrefetchHooks Function()
        > {
  $$SrvPhotosTableTableManager(_$ServerDb db, $SrvPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrvPhotosCompanion(
                id: id,
                path: path,
                sizeBytes: sizeBytes,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String path,
                required int sizeBytes,
                required DateTime uploadedAt,
                Value<int> rowid = const Value.absent(),
              }) => SrvPhotosCompanion.insert(
                id: id,
                path: path,
                sizeBytes: sizeBytes,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvPhotosTable, SrvPhoto>(table),
                  BaseReferences<_$ServerDb, $SrvPhotosTable, SrvPhoto>(
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

typedef $$SrvPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvPhotosTable,
      SrvPhoto,
      $$SrvPhotosTableFilterComposer,
      $$SrvPhotosTableOrderingComposer,
      $$SrvPhotosTableAnnotationComposer,
      $$SrvPhotosTableCreateCompanionBuilder,
      $$SrvPhotosTableUpdateCompanionBuilder,
      (SrvPhoto, BaseReferences<_$ServerDb, $SrvPhotosTable, SrvPhoto>),
      SrvPhoto,
      PrefetchHooks Function()
    >;
typedef $$SrvRewardsTableCreateCompanionBuilder = SrvRewardsCompanion Function({
  required String tipId,
  required String userId,
  required int points,
  required DateTime grantedAt,
  Value<int> rowid,
});
typedef $$SrvRewardsTableUpdateCompanionBuilder = SrvRewardsCompanion Function({
  Value<String> tipId,
  Value<String> userId,
  Value<int> points,
  Value<DateTime> grantedAt,
  Value<int> rowid,
});

class $$SrvRewardsTableFilterComposer
    extends Composer<_$ServerDb, $SrvRewardsTable> {
  $$SrvRewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tipId => $composableBuilder(
    column: $table.tipId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvRewardsTableOrderingComposer
    extends Composer<_$ServerDb, $SrvRewardsTable> {
  $$SrvRewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tipId => $composableBuilder(
    column: $table.tipId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvRewardsTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvRewardsTable> {
  $$SrvRewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tipId =>
      $composableBuilder(column: $table.tipId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get grantedAt =>
      $composableBuilder(column: $table.grantedAt, builder: (column) => column);
}

class $$SrvRewardsTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvRewardsTable,
          SrvReward,
          $$SrvRewardsTableFilterComposer,
          $$SrvRewardsTableOrderingComposer,
          $$SrvRewardsTableAnnotationComposer,
          $$SrvRewardsTableCreateCompanionBuilder,
          $$SrvRewardsTableUpdateCompanionBuilder,
          (SrvReward, BaseReferences<_$ServerDb, $SrvRewardsTable, SrvReward>),
          SrvReward,
          PrefetchHooks Function()
        > {
  $$SrvRewardsTableTableManager(_$ServerDb db, $SrvRewardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvRewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvRewardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvRewardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tipId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> grantedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrvRewardsCompanion(
                tipId: tipId,
                userId: userId,
                points: points,
                grantedAt: grantedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tipId,
                required String userId,
                required int points,
                required DateTime grantedAt,
                Value<int> rowid = const Value.absent(),
              }) => SrvRewardsCompanion.insert(
                tipId: tipId,
                userId: userId,
                points: points,
                grantedAt: grantedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvRewardsTable, SrvReward>(table),
                  BaseReferences<_$ServerDb, $SrvRewardsTable, SrvReward>(
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

typedef $$SrvRewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvRewardsTable,
      SrvReward,
      $$SrvRewardsTableFilterComposer,
      $$SrvRewardsTableOrderingComposer,
      $$SrvRewardsTableAnnotationComposer,
      $$SrvRewardsTableCreateCompanionBuilder,
      $$SrvRewardsTableUpdateCompanionBuilder,
      (SrvReward, BaseReferences<_$ServerDb, $SrvRewardsTable, SrvReward>),
      SrvReward,
      PrefetchHooks Function()
    >;
typedef $$SrvEvidenceTableCreateCompanionBuilder =
    SrvEvidenceCompanion Function({
      Value<int> slot,
      required int version,
      required String json,
      required DateTime publishedAt,
    });
typedef $$SrvEvidenceTableUpdateCompanionBuilder =
    SrvEvidenceCompanion Function({
      Value<int> slot,
      Value<int> version,
      Value<String> json,
      Value<DateTime> publishedAt,
    });

class $$SrvEvidenceTableFilterComposer
    extends Composer<_$ServerDb, $SrvEvidenceTable> {
  $$SrvEvidenceTableFilterComposer({
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

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvEvidenceTableOrderingComposer
    extends Composer<_$ServerDb, $SrvEvidenceTable> {
  $$SrvEvidenceTableOrderingComposer({
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

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvEvidenceTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvEvidenceTable> {
  $$SrvEvidenceTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );
}

class $$SrvEvidenceTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvEvidenceTable,
          SrvEvidenceData,
          $$SrvEvidenceTableFilterComposer,
          $$SrvEvidenceTableOrderingComposer,
          $$SrvEvidenceTableAnnotationComposer,
          $$SrvEvidenceTableCreateCompanionBuilder,
          $$SrvEvidenceTableUpdateCompanionBuilder,
          (
            SrvEvidenceData,
            BaseReferences<_$ServerDb, $SrvEvidenceTable, SrvEvidenceData>,
          ),
          SrvEvidenceData,
          PrefetchHooks Function()
        > {
  $$SrvEvidenceTableTableManager(_$ServerDb db, $SrvEvidenceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvEvidenceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvEvidenceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvEvidenceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
              }) => SrvEvidenceCompanion(
                slot: slot,
                version: version,
                json: json,
                publishedAt: publishedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                required int version,
                required String json,
                required DateTime publishedAt,
              }) => SrvEvidenceCompanion.insert(
                slot: slot,
                version: version,
                json: json,
                publishedAt: publishedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvEvidenceTable, SrvEvidenceData>(table),
                  BaseReferences<
                    _$ServerDb,
                    $SrvEvidenceTable,
                    SrvEvidenceData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrvEvidenceTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvEvidenceTable,
      SrvEvidenceData,
      $$SrvEvidenceTableFilterComposer,
      $$SrvEvidenceTableOrderingComposer,
      $$SrvEvidenceTableAnnotationComposer,
      $$SrvEvidenceTableCreateCompanionBuilder,
      $$SrvEvidenceTableUpdateCompanionBuilder,
      (
        SrvEvidenceData,
        BaseReferences<_$ServerDb, $SrvEvidenceTable, SrvEvidenceData>,
      ),
      SrvEvidenceData,
      PrefetchHooks Function()
    >;
typedef $$SrvAuditTableCreateCompanionBuilder = SrvAuditCompanion Function({
  Value<int> id,
  required DateTime at,
  required String actor,
  required String action,
  required String target,
  required String details,
});
typedef $$SrvAuditTableUpdateCompanionBuilder = SrvAuditCompanion Function({
  Value<int> id,
  Value<DateTime> at,
  Value<String> actor,
  Value<String> action,
  Value<String> target,
  Value<String> details,
});

class $$SrvAuditTableFilterComposer
    extends Composer<_$ServerDb, $SrvAuditTable> {
  $$SrvAuditTableFilterComposer({
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

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrvAuditTableOrderingComposer
    extends Composer<_$ServerDb, $SrvAuditTable> {
  $$SrvAuditTableOrderingComposer({
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

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrvAuditTableAnnotationComposer
    extends Composer<_$ServerDb, $SrvAuditTable> {
  $$SrvAuditTableAnnotationComposer({
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

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$SrvAuditTableTableManager
    extends
        RootTableManager<
          _$ServerDb,
          $SrvAuditTable,
          SrvAuditData,
          $$SrvAuditTableFilterComposer,
          $$SrvAuditTableOrderingComposer,
          $$SrvAuditTableAnnotationComposer,
          $$SrvAuditTableCreateCompanionBuilder,
          $$SrvAuditTableUpdateCompanionBuilder,
          (
            SrvAuditData,
            BaseReferences<_$ServerDb, $SrvAuditTable, SrvAuditData>,
          ),
          SrvAuditData,
          PrefetchHooks Function()
        > {
  $$SrvAuditTableTableManager(_$ServerDb db, $SrvAuditTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrvAuditTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrvAuditTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrvAuditTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> details = const Value.absent(),
              }) => SrvAuditCompanion(
                id: id,
                at: at,
                actor: actor,
                action: action,
                target: target,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required String actor,
                required String action,
                required String target,
                required String details,
              }) => SrvAuditCompanion.insert(
                id: id,
                at: at,
                actor: actor,
                action: action,
                target: target,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SrvAuditTable, SrvAuditData>(table),
                  BaseReferences<_$ServerDb, $SrvAuditTable, SrvAuditData>(
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

typedef $$SrvAuditTableProcessedTableManager =
    ProcessedTableManager<
      _$ServerDb,
      $SrvAuditTable,
      SrvAuditData,
      $$SrvAuditTableFilterComposer,
      $$SrvAuditTableOrderingComposer,
      $$SrvAuditTableAnnotationComposer,
      $$SrvAuditTableCreateCompanionBuilder,
      $$SrvAuditTableUpdateCompanionBuilder,
      (SrvAuditData, BaseReferences<_$ServerDb, $SrvAuditTable, SrvAuditData>),
      SrvAuditData,
      PrefetchHooks Function()
    >;

class $ServerDbManager {
  final _$ServerDb _db;
  $ServerDbManager(this._db);
  $$SrvOperationsTableTableManager get srvOperations =>
      $$SrvOperationsTableTableManager(_db, _db.srvOperations);
  $$SrvTipsTableTableManager get srvTips =>
      $$SrvTipsTableTableManager(_db, _db.srvTips);
  $$SrvPhotosTableTableManager get srvPhotos =>
      $$SrvPhotosTableTableManager(_db, _db.srvPhotos);
  $$SrvRewardsTableTableManager get srvRewards =>
      $$SrvRewardsTableTableManager(_db, _db.srvRewards);
  $$SrvEvidenceTableTableManager get srvEvidence =>
      $$SrvEvidenceTableTableManager(_db, _db.srvEvidence);
  $$SrvAuditTableTableManager get srvAudit =>
      $$SrvAuditTableTableManager(_db, _db.srvAudit);
}
