// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _baseVersionMeta =
      const VerificationMeta('baseVersion');
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
      'base_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        version,
        baseVersion,
        syncStatus,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('base_version')) {
      context.handle(
          _baseVersionMeta,
          baseVersion.isAcceptableOrUnknown(
              data['base_version']!, _baseVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      baseVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final String id;
  final String userId;
  final String title;
  final int version;
  final int baseVersion;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Song(
      {required this.id,
      required this.userId,
      required this.title,
      required this.version,
      required this.baseVersion,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['version'] = Variable<int>(version);
    map['base_version'] = Variable<int>(baseVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      version: Value(version),
      baseVersion: Value(baseVersion),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      version: serializer.fromJson<int>(json['version']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'version': serializer.toJson<int>(version),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Song copyWith(
          {String? id,
          String? userId,
          String? title,
          int? version,
          int? baseVersion,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Song(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        version: version ?? this.version,
        baseVersion: baseVersion ?? this.baseVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      version: data.version.present ? data.version.value : this.version,
      baseVersion:
          data.baseVersion.present ? data.baseVersion.value : this.baseVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, version, baseVersion,
      syncStatus, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.version == this.version &&
          other.baseVersion == this.baseVersion &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<int> version;
  final Value<int> baseVersion;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title);
  static Insertable<Song> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<int>? version,
    Expression<int>? baseVersion,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (version != null) 'version': version,
      if (baseVersion != null) 'base_version': baseVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<int>? version,
      Value<int>? baseVersion,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return SongsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      version: version ?? this.version,
      baseVersion: baseVersion ?? this.baseVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongAssetsTable extends SongAssets
    with TableInfo<$SongAssetsTable, SongAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES songs(id) ON DELETE CASCADE');
  static const VerificationMeta _assetTypeMeta =
      const VerificationMeta('assetType');
  @override
  late final GeneratedColumn<String> assetType = GeneratedColumn<String>(
      'asset_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _revisionMeta =
      const VerificationMeta('revision');
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
      'revision', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _storagePathMeta =
      const VerificationMeta('storagePath');
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
      'storage_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _baseVersionMeta =
      const VerificationMeta('baseVersion');
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
      'base_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        songId,
        assetType,
        revision,
        storagePath,
        localPath,
        mimeType,
        fileSize,
        checksum,
        isActive,
        isDownloaded,
        version,
        baseVersion,
        syncStatus,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'song_assets';
  @override
  VerificationContext validateIntegrity(Insertable<SongAsset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('asset_type')) {
      context.handle(_assetTypeMeta,
          assetType.isAcceptableOrUnknown(data['asset_type']!, _assetTypeMeta));
    } else if (isInserting) {
      context.missing(_assetTypeMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(_revisionMeta,
          revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta));
    }
    if (data.containsKey('storage_path')) {
      context.handle(
          _storagePathMeta,
          storagePath.isAcceptableOrUnknown(
              data['storage_path']!, _storagePathMeta));
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('base_version')) {
      context.handle(
          _baseVersionMeta,
          baseVersion.isAcceptableOrUnknown(
              data['base_version']!, _baseVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SongAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongAsset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      assetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asset_type'])!,
      revision: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}revision'])!,
      storagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}storage_path'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      baseVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $SongAssetsTable createAlias(String alias) {
    return $SongAssetsTable(attachedDatabase, alias);
  }
}

class SongAsset extends DataClass implements Insertable<SongAsset> {
  final String id;
  final String songId;
  final String assetType;
  final int revision;
  final String storagePath;
  final String? localPath;
  final String mimeType;
  final int fileSize;
  final String checksum;
  final bool isActive;
  final bool isDownloaded;
  final int version;
  final int baseVersion;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const SongAsset(
      {required this.id,
      required this.songId,
      required this.assetType,
      required this.revision,
      required this.storagePath,
      this.localPath,
      required this.mimeType,
      required this.fileSize,
      required this.checksum,
      required this.isActive,
      required this.isDownloaded,
      required this.version,
      required this.baseVersion,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    map['asset_type'] = Variable<String>(assetType);
    map['revision'] = Variable<int>(revision);
    map['storage_path'] = Variable<String>(storagePath);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['mime_type'] = Variable<String>(mimeType);
    map['file_size'] = Variable<int>(fileSize);
    map['checksum'] = Variable<String>(checksum);
    map['is_active'] = Variable<bool>(isActive);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['version'] = Variable<int>(version);
    map['base_version'] = Variable<int>(baseVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SongAssetsCompanion toCompanion(bool nullToAbsent) {
    return SongAssetsCompanion(
      id: Value(id),
      songId: Value(songId),
      assetType: Value(assetType),
      revision: Value(revision),
      storagePath: Value(storagePath),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      mimeType: Value(mimeType),
      fileSize: Value(fileSize),
      checksum: Value(checksum),
      isActive: Value(isActive),
      isDownloaded: Value(isDownloaded),
      version: Value(version),
      baseVersion: Value(baseVersion),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SongAsset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongAsset(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      assetType: serializer.fromJson<String>(json['assetType']),
      revision: serializer.fromJson<int>(json['revision']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      checksum: serializer.fromJson<String>(json['checksum']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      version: serializer.fromJson<int>(json['version']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'assetType': serializer.toJson<String>(assetType),
      'revision': serializer.toJson<int>(revision),
      'storagePath': serializer.toJson<String>(storagePath),
      'localPath': serializer.toJson<String?>(localPath),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int>(fileSize),
      'checksum': serializer.toJson<String>(checksum),
      'isActive': serializer.toJson<bool>(isActive),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'version': serializer.toJson<int>(version),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SongAsset copyWith(
          {String? id,
          String? songId,
          String? assetType,
          int? revision,
          String? storagePath,
          Value<String?> localPath = const Value.absent(),
          String? mimeType,
          int? fileSize,
          String? checksum,
          bool? isActive,
          bool? isDownloaded,
          int? version,
          int? baseVersion,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      SongAsset(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        assetType: assetType ?? this.assetType,
        revision: revision ?? this.revision,
        storagePath: storagePath ?? this.storagePath,
        localPath: localPath.present ? localPath.value : this.localPath,
        mimeType: mimeType ?? this.mimeType,
        fileSize: fileSize ?? this.fileSize,
        checksum: checksum ?? this.checksum,
        isActive: isActive ?? this.isActive,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        version: version ?? this.version,
        baseVersion: baseVersion ?? this.baseVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  SongAsset copyWithCompanion(SongAssetsCompanion data) {
    return SongAsset(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      assetType: data.assetType.present ? data.assetType.value : this.assetType,
      revision: data.revision.present ? data.revision.value : this.revision,
      storagePath:
          data.storagePath.present ? data.storagePath.value : this.storagePath,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      version: data.version.present ? data.version.value : this.version,
      baseVersion:
          data.baseVersion.present ? data.baseVersion.value : this.baseVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongAsset(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('assetType: $assetType, ')
          ..write('revision: $revision, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('checksum: $checksum, ')
          ..write('isActive: $isActive, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      songId,
      assetType,
      revision,
      storagePath,
      localPath,
      mimeType,
      fileSize,
      checksum,
      isActive,
      isDownloaded,
      version,
      baseVersion,
      syncStatus,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongAsset &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.assetType == this.assetType &&
          other.revision == this.revision &&
          other.storagePath == this.storagePath &&
          other.localPath == this.localPath &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.checksum == this.checksum &&
          other.isActive == this.isActive &&
          other.isDownloaded == this.isDownloaded &&
          other.version == this.version &&
          other.baseVersion == this.baseVersion &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SongAssetsCompanion extends UpdateCompanion<SongAsset> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String> assetType;
  final Value<int> revision;
  final Value<String> storagePath;
  final Value<String?> localPath;
  final Value<String> mimeType;
  final Value<int> fileSize;
  final Value<String> checksum;
  final Value<bool> isActive;
  final Value<bool> isDownloaded;
  final Value<int> version;
  final Value<int> baseVersion;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SongAssetsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.assetType = const Value.absent(),
    this.revision = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.localPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.checksum = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongAssetsCompanion.insert({
    required String id,
    required String songId,
    required String assetType,
    this.revision = const Value.absent(),
    required String storagePath,
    this.localPath = const Value.absent(),
    required String mimeType,
    required int fileSize,
    required String checksum,
    this.isActive = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        assetType = Value(assetType),
        storagePath = Value(storagePath),
        mimeType = Value(mimeType),
        fileSize = Value(fileSize),
        checksum = Value(checksum);
  static Insertable<SongAsset> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? assetType,
    Expression<int>? revision,
    Expression<String>? storagePath,
    Expression<String>? localPath,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<String>? checksum,
    Expression<bool>? isActive,
    Expression<bool>? isDownloaded,
    Expression<int>? version,
    Expression<int>? baseVersion,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (assetType != null) 'asset_type': assetType,
      if (revision != null) 'revision': revision,
      if (storagePath != null) 'storage_path': storagePath,
      if (localPath != null) 'local_path': localPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (checksum != null) 'checksum': checksum,
      if (isActive != null) 'is_active': isActive,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (version != null) 'version': version,
      if (baseVersion != null) 'base_version': baseVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongAssetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? songId,
      Value<String>? assetType,
      Value<int>? revision,
      Value<String>? storagePath,
      Value<String?>? localPath,
      Value<String>? mimeType,
      Value<int>? fileSize,
      Value<String>? checksum,
      Value<bool>? isActive,
      Value<bool>? isDownloaded,
      Value<int>? version,
      Value<int>? baseVersion,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return SongAssetsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      assetType: assetType ?? this.assetType,
      revision: revision ?? this.revision,
      storagePath: storagePath ?? this.storagePath,
      localPath: localPath ?? this.localPath,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      checksum: checksum ?? this.checksum,
      isActive: isActive ?? this.isActive,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      version: version ?? this.version,
      baseVersion: baseVersion ?? this.baseVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (assetType.present) {
      map['asset_type'] = Variable<String>(assetType.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongAssetsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('assetType: $assetType, ')
          ..write('revision: $revision, ')
          ..write('storagePath: $storagePath, ')
          ..write('localPath: $localPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('checksum: $checksum, ')
          ..write('isActive: $isActive, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncVersionsTable extends SyncVersions
    with TableInfo<$SyncVersionsTable, SyncVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES songs(id) ON DELETE CASCADE');
  static const VerificationMeta _pdfAssetIdMeta =
      const VerificationMeta('pdfAssetId');
  @override
  late final GeneratedColumn<String> pdfAssetId = GeneratedColumn<String>(
      'pdf_asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES song_assets(id) ON DELETE CASCADE');
  static const VerificationMeta _audioAssetIdMeta =
      const VerificationMeta('audioAssetId');
  @override
  late final GeneratedColumn<String> audioAssetId = GeneratedColumn<String>(
      'audio_asset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES song_assets(id) ON DELETE CASCADE');
  static const VerificationMeta _audioDurationMsMeta =
      const VerificationMeta('audioDurationMs');
  @override
  late final GeneratedColumn<int> audioDurationMs = GeneratedColumn<int>(
      'audio_duration_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _baseVersionMeta =
      const VerificationMeta('baseVersion');
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
      'base_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        songId,
        pdfAssetId,
        audioAssetId,
        audioDurationMs,
        isActive,
        version,
        baseVersion,
        syncStatus,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_versions';
  @override
  VerificationContext validateIntegrity(Insertable<SyncVersion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('pdf_asset_id')) {
      context.handle(
          _pdfAssetIdMeta,
          pdfAssetId.isAcceptableOrUnknown(
              data['pdf_asset_id']!, _pdfAssetIdMeta));
    } else if (isInserting) {
      context.missing(_pdfAssetIdMeta);
    }
    if (data.containsKey('audio_asset_id')) {
      context.handle(
          _audioAssetIdMeta,
          audioAssetId.isAcceptableOrUnknown(
              data['audio_asset_id']!, _audioAssetIdMeta));
    } else if (isInserting) {
      context.missing(_audioAssetIdMeta);
    }
    if (data.containsKey('audio_duration_ms')) {
      context.handle(
          _audioDurationMsMeta,
          audioDurationMs.isAcceptableOrUnknown(
              data['audio_duration_ms']!, _audioDurationMsMeta));
    } else if (isInserting) {
      context.missing(_audioDurationMsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('base_version')) {
      context.handle(
          _baseVersionMeta,
          baseVersion.isAcceptableOrUnknown(
              data['base_version']!, _baseVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncVersion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      pdfAssetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_asset_id'])!,
      audioAssetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_asset_id'])!,
      audioDurationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}audio_duration_ms'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      baseVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $SyncVersionsTable createAlias(String alias) {
    return $SyncVersionsTable(attachedDatabase, alias);
  }
}

class SyncVersion extends DataClass implements Insertable<SyncVersion> {
  final String id;
  final String songId;
  final String pdfAssetId;
  final String audioAssetId;
  final int audioDurationMs;
  final bool isActive;
  final int version;
  final int baseVersion;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const SyncVersion(
      {required this.id,
      required this.songId,
      required this.pdfAssetId,
      required this.audioAssetId,
      required this.audioDurationMs,
      required this.isActive,
      required this.version,
      required this.baseVersion,
      required this.syncStatus,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    map['pdf_asset_id'] = Variable<String>(pdfAssetId);
    map['audio_asset_id'] = Variable<String>(audioAssetId);
    map['audio_duration_ms'] = Variable<int>(audioDurationMs);
    map['is_active'] = Variable<bool>(isActive);
    map['version'] = Variable<int>(version);
    map['base_version'] = Variable<int>(baseVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SyncVersionsCompanion toCompanion(bool nullToAbsent) {
    return SyncVersionsCompanion(
      id: Value(id),
      songId: Value(songId),
      pdfAssetId: Value(pdfAssetId),
      audioAssetId: Value(audioAssetId),
      audioDurationMs: Value(audioDurationMs),
      isActive: Value(isActive),
      version: Value(version),
      baseVersion: Value(baseVersion),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SyncVersion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncVersion(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      pdfAssetId: serializer.fromJson<String>(json['pdfAssetId']),
      audioAssetId: serializer.fromJson<String>(json['audioAssetId']),
      audioDurationMs: serializer.fromJson<int>(json['audioDurationMs']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      version: serializer.fromJson<int>(json['version']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'pdfAssetId': serializer.toJson<String>(pdfAssetId),
      'audioAssetId': serializer.toJson<String>(audioAssetId),
      'audioDurationMs': serializer.toJson<int>(audioDurationMs),
      'isActive': serializer.toJson<bool>(isActive),
      'version': serializer.toJson<int>(version),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SyncVersion copyWith(
          {String? id,
          String? songId,
          String? pdfAssetId,
          String? audioAssetId,
          int? audioDurationMs,
          bool? isActive,
          int? version,
          int? baseVersion,
          String? syncStatus,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      SyncVersion(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        pdfAssetId: pdfAssetId ?? this.pdfAssetId,
        audioAssetId: audioAssetId ?? this.audioAssetId,
        audioDurationMs: audioDurationMs ?? this.audioDurationMs,
        isActive: isActive ?? this.isActive,
        version: version ?? this.version,
        baseVersion: baseVersion ?? this.baseVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  SyncVersion copyWithCompanion(SyncVersionsCompanion data) {
    return SyncVersion(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      pdfAssetId:
          data.pdfAssetId.present ? data.pdfAssetId.value : this.pdfAssetId,
      audioAssetId: data.audioAssetId.present
          ? data.audioAssetId.value
          : this.audioAssetId,
      audioDurationMs: data.audioDurationMs.present
          ? data.audioDurationMs.value
          : this.audioDurationMs,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      version: data.version.present ? data.version.value : this.version,
      baseVersion:
          data.baseVersion.present ? data.baseVersion.value : this.baseVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncVersion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('pdfAssetId: $pdfAssetId, ')
          ..write('audioAssetId: $audioAssetId, ')
          ..write('audioDurationMs: $audioDurationMs, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      songId,
      pdfAssetId,
      audioAssetId,
      audioDurationMs,
      isActive,
      version,
      baseVersion,
      syncStatus,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncVersion &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.pdfAssetId == this.pdfAssetId &&
          other.audioAssetId == this.audioAssetId &&
          other.audioDurationMs == this.audioDurationMs &&
          other.isActive == this.isActive &&
          other.version == this.version &&
          other.baseVersion == this.baseVersion &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SyncVersionsCompanion extends UpdateCompanion<SyncVersion> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String> pdfAssetId;
  final Value<String> audioAssetId;
  final Value<int> audioDurationMs;
  final Value<bool> isActive;
  final Value<int> version;
  final Value<int> baseVersion;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SyncVersionsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.pdfAssetId = const Value.absent(),
    this.audioAssetId = const Value.absent(),
    this.audioDurationMs = const Value.absent(),
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncVersionsCompanion.insert({
    required String id,
    required String songId,
    required String pdfAssetId,
    required String audioAssetId,
    required int audioDurationMs,
    this.isActive = const Value.absent(),
    this.version = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        pdfAssetId = Value(pdfAssetId),
        audioAssetId = Value(audioAssetId),
        audioDurationMs = Value(audioDurationMs);
  static Insertable<SyncVersion> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? pdfAssetId,
    Expression<String>? audioAssetId,
    Expression<int>? audioDurationMs,
    Expression<bool>? isActive,
    Expression<int>? version,
    Expression<int>? baseVersion,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (pdfAssetId != null) 'pdf_asset_id': pdfAssetId,
      if (audioAssetId != null) 'audio_asset_id': audioAssetId,
      if (audioDurationMs != null) 'audio_duration_ms': audioDurationMs,
      if (isActive != null) 'is_active': isActive,
      if (version != null) 'version': version,
      if (baseVersion != null) 'base_version': baseVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncVersionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? songId,
      Value<String>? pdfAssetId,
      Value<String>? audioAssetId,
      Value<int>? audioDurationMs,
      Value<bool>? isActive,
      Value<int>? version,
      Value<int>? baseVersion,
      Value<String>? syncStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return SyncVersionsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      pdfAssetId: pdfAssetId ?? this.pdfAssetId,
      audioAssetId: audioAssetId ?? this.audioAssetId,
      audioDurationMs: audioDurationMs ?? this.audioDurationMs,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      baseVersion: baseVersion ?? this.baseVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (pdfAssetId.present) {
      map['pdf_asset_id'] = Variable<String>(pdfAssetId.value);
    }
    if (audioAssetId.present) {
      map['audio_asset_id'] = Variable<String>(audioAssetId.value);
    }
    if (audioDurationMs.present) {
      map['audio_duration_ms'] = Variable<int>(audioDurationMs.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncVersionsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('pdfAssetId: $pdfAssetId, ')
          ..write('audioAssetId: $audioAssetId, ')
          ..write('audioDurationMs: $audioDurationMs, ')
          ..write('isActive: $isActive, ')
          ..write('version: $version, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasuresTable extends Measures with TableInfo<$MeasuresTable, Measure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES sync_versions(id) ON DELETE CASCADE');
  static const VerificationMeta _measureOrderMeta =
      const VerificationMeta('measureOrder');
  @override
  late final GeneratedColumn<int> measureOrder = GeneratedColumn<int>(
      'measure_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _measureLabelMeta =
      const VerificationMeta('measureLabel');
  @override
  late final GeneratedColumn<String> measureLabel = GeneratedColumn<String>(
      'measure_label', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _startMsMeta =
      const VerificationMeta('startMs');
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
      'start_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, syncId, measureOrder, measureLabel, startMs, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measures';
  @override
  VerificationContext validateIntegrity(Insertable<Measure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    } else if (isInserting) {
      context.missing(_syncIdMeta);
    }
    if (data.containsKey('measure_order')) {
      context.handle(
          _measureOrderMeta,
          measureOrder.isAcceptableOrUnknown(
              data['measure_order']!, _measureOrderMeta));
    } else if (isInserting) {
      context.missing(_measureOrderMeta);
    }
    if (data.containsKey('measure_label')) {
      context.handle(
          _measureLabelMeta,
          measureLabel.isAcceptableOrUnknown(
              data['measure_label']!, _measureLabelMeta));
    }
    if (data.containsKey('start_ms')) {
      context.handle(_startMsMeta,
          startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {syncId, measureOrder},
      ];
  @override
  Measure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Measure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id'])!,
      measureOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}measure_order'])!,
      measureLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}measure_label'])!,
      startMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ms']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(attachedDatabase, alias);
  }
}

class Measure extends DataClass implements Insertable<Measure> {
  final String id;
  final String syncId;
  final int measureOrder;
  final String measureLabel;
  final int? startMs;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Measure(
      {required this.id,
      required this.syncId,
      required this.measureOrder,
      required this.measureLabel,
      this.startMs,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sync_id'] = Variable<String>(syncId);
    map['measure_order'] = Variable<int>(measureOrder);
    map['measure_label'] = Variable<String>(measureLabel);
    if (!nullToAbsent || startMs != null) {
      map['start_ms'] = Variable<int>(startMs);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MeasuresCompanion toCompanion(bool nullToAbsent) {
    return MeasuresCompanion(
      id: Value(id),
      syncId: Value(syncId),
      measureOrder: Value(measureOrder),
      measureLabel: Value(measureLabel),
      startMs: startMs == null && nullToAbsent
          ? const Value.absent()
          : Value(startMs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Measure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<String>(json['id']),
      syncId: serializer.fromJson<String>(json['syncId']),
      measureOrder: serializer.fromJson<int>(json['measureOrder']),
      measureLabel: serializer.fromJson<String>(json['measureLabel']),
      startMs: serializer.fromJson<int?>(json['startMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'syncId': serializer.toJson<String>(syncId),
      'measureOrder': serializer.toJson<int>(measureOrder),
      'measureLabel': serializer.toJson<String>(measureLabel),
      'startMs': serializer.toJson<int?>(startMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Measure copyWith(
          {String? id,
          String? syncId,
          int? measureOrder,
          String? measureLabel,
          Value<int?> startMs = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Measure(
        id: id ?? this.id,
        syncId: syncId ?? this.syncId,
        measureOrder: measureOrder ?? this.measureOrder,
        measureLabel: measureLabel ?? this.measureLabel,
        startMs: startMs.present ? startMs.value : this.startMs,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Measure copyWithCompanion(MeasuresCompanion data) {
    return Measure(
      id: data.id.present ? data.id.value : this.id,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      measureOrder: data.measureOrder.present
          ? data.measureOrder.value
          : this.measureOrder,
      measureLabel: data.measureLabel.present
          ? data.measureLabel.value
          : this.measureLabel,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Measure(')
          ..write('id: $id, ')
          ..write('syncId: $syncId, ')
          ..write('measureOrder: $measureOrder, ')
          ..write('measureLabel: $measureLabel, ')
          ..write('startMs: $startMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, syncId, measureOrder, measureLabel, startMs, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measure &&
          other.id == this.id &&
          other.syncId == this.syncId &&
          other.measureOrder == this.measureOrder &&
          other.measureLabel == this.measureLabel &&
          other.startMs == this.startMs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MeasuresCompanion extends UpdateCompanion<Measure> {
  final Value<String> id;
  final Value<String> syncId;
  final Value<int> measureOrder;
  final Value<String> measureLabel;
  final Value<int?> startMs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MeasuresCompanion({
    this.id = const Value.absent(),
    this.syncId = const Value.absent(),
    this.measureOrder = const Value.absent(),
    this.measureLabel = const Value.absent(),
    this.startMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasuresCompanion.insert({
    required String id,
    required String syncId,
    required int measureOrder,
    this.measureLabel = const Value.absent(),
    this.startMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        syncId = Value(syncId),
        measureOrder = Value(measureOrder);
  static Insertable<Measure> custom({
    Expression<String>? id,
    Expression<String>? syncId,
    Expression<int>? measureOrder,
    Expression<String>? measureLabel,
    Expression<int>? startMs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (syncId != null) 'sync_id': syncId,
      if (measureOrder != null) 'measure_order': measureOrder,
      if (measureLabel != null) 'measure_label': measureLabel,
      if (startMs != null) 'start_ms': startMs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasuresCompanion copyWith(
      {Value<String>? id,
      Value<String>? syncId,
      Value<int>? measureOrder,
      Value<String>? measureLabel,
      Value<int?>? startMs,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      syncId: syncId ?? this.syncId,
      measureOrder: measureOrder ?? this.measureOrder,
      measureLabel: measureLabel ?? this.measureLabel,
      startMs: startMs ?? this.startMs,
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
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (measureOrder.present) {
      map['measure_order'] = Variable<int>(measureOrder.value);
    }
    if (measureLabel.present) {
      map['measure_label'] = Variable<String>(measureLabel.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
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
    return (StringBuffer('MeasuresCompanion(')
          ..write('id: $id, ')
          ..write('syncId: $syncId, ')
          ..write('measureOrder: $measureOrder, ')
          ..write('measureLabel: $measureLabel, ')
          ..write('startMs: $startMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasureRegionsTable extends MeasureRegions
    with TableInfo<$MeasureRegionsTable, MeasureRegion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasureRegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _measureIdMeta =
      const VerificationMeta('measureId');
  @override
  late final GeneratedColumn<String> measureId = GeneratedColumn<String>(
      'measure_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES measures(id) ON DELETE CASCADE');
  static const VerificationMeta _regionOrderMeta =
      const VerificationMeta('regionOrder');
  @override
  late final GeneratedColumn<int> regionOrder = GeneratedColumn<int>(
      'region_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
      'x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
      'y', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _wMeta = const VerificationMeta('w');
  @override
  late final GeneratedColumn<double> w = GeneratedColumn<double>(
      'w', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hMeta = const VerificationMeta('h');
  @override
  late final GeneratedColumn<double> h = GeneratedColumn<double>(
      'h', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        measureId,
        regionOrder,
        pageNumber,
        x,
        y,
        w,
        h,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measure_regions';
  @override
  VerificationContext validateIntegrity(Insertable<MeasureRegion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measure_id')) {
      context.handle(_measureIdMeta,
          measureId.isAcceptableOrUnknown(data['measure_id']!, _measureIdMeta));
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('region_order')) {
      context.handle(
          _regionOrderMeta,
          regionOrder.isAcceptableOrUnknown(
              data['region_order']!, _regionOrderMeta));
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('w')) {
      context.handle(_wMeta, w.isAcceptableOrUnknown(data['w']!, _wMeta));
    } else if (isInserting) {
      context.missing(_wMeta);
    }
    if (data.containsKey('h')) {
      context.handle(_hMeta, h.isAcceptableOrUnknown(data['h']!, _hMeta));
    } else if (isInserting) {
      context.missing(_hMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {measureId, regionOrder},
      ];
  @override
  MeasureRegion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasureRegion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      measureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}measure_id'])!,
      regionOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}region_order'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      x: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}x'])!,
      y: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}y'])!,
      w: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}w'])!,
      h: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}h'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MeasureRegionsTable createAlias(String alias) {
    return $MeasureRegionsTable(attachedDatabase, alias);
  }
}

class MeasureRegion extends DataClass implements Insertable<MeasureRegion> {
  final String id;
  final String measureId;
  final int regionOrder;
  final int pageNumber;
  final double x;
  final double y;
  final double w;
  final double h;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MeasureRegion(
      {required this.id,
      required this.measureId,
      required this.regionOrder,
      required this.pageNumber,
      required this.x,
      required this.y,
      required this.w,
      required this.h,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measure_id'] = Variable<String>(measureId);
    map['region_order'] = Variable<int>(regionOrder);
    map['page_number'] = Variable<int>(pageNumber);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['w'] = Variable<double>(w);
    map['h'] = Variable<double>(h);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MeasureRegionsCompanion toCompanion(bool nullToAbsent) {
    return MeasureRegionsCompanion(
      id: Value(id),
      measureId: Value(measureId),
      regionOrder: Value(regionOrder),
      pageNumber: Value(pageNumber),
      x: Value(x),
      y: Value(y),
      w: Value(w),
      h: Value(h),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MeasureRegion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasureRegion(
      id: serializer.fromJson<String>(json['id']),
      measureId: serializer.fromJson<String>(json['measureId']),
      regionOrder: serializer.fromJson<int>(json['regionOrder']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      w: serializer.fromJson<double>(json['w']),
      h: serializer.fromJson<double>(json['h']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measureId': serializer.toJson<String>(measureId),
      'regionOrder': serializer.toJson<int>(regionOrder),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'w': serializer.toJson<double>(w),
      'h': serializer.toJson<double>(h),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MeasureRegion copyWith(
          {String? id,
          String? measureId,
          int? regionOrder,
          int? pageNumber,
          double? x,
          double? y,
          double? w,
          double? h,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MeasureRegion(
        id: id ?? this.id,
        measureId: measureId ?? this.measureId,
        regionOrder: regionOrder ?? this.regionOrder,
        pageNumber: pageNumber ?? this.pageNumber,
        x: x ?? this.x,
        y: y ?? this.y,
        w: w ?? this.w,
        h: h ?? this.h,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MeasureRegion copyWithCompanion(MeasureRegionsCompanion data) {
    return MeasureRegion(
      id: data.id.present ? data.id.value : this.id,
      measureId: data.measureId.present ? data.measureId.value : this.measureId,
      regionOrder:
          data.regionOrder.present ? data.regionOrder.value : this.regionOrder,
      pageNumber:
          data.pageNumber.present ? data.pageNumber.value : this.pageNumber,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      w: data.w.present ? data.w.value : this.w,
      h: data.h.present ? data.h.value : this.h,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasureRegion(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('regionOrder: $regionOrder, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('w: $w, ')
          ..write('h: $h, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, measureId, regionOrder, pageNumber, x, y, w, h, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasureRegion &&
          other.id == this.id &&
          other.measureId == this.measureId &&
          other.regionOrder == this.regionOrder &&
          other.pageNumber == this.pageNumber &&
          other.x == this.x &&
          other.y == this.y &&
          other.w == this.w &&
          other.h == this.h &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MeasureRegionsCompanion extends UpdateCompanion<MeasureRegion> {
  final Value<String> id;
  final Value<String> measureId;
  final Value<int> regionOrder;
  final Value<int> pageNumber;
  final Value<double> x;
  final Value<double> y;
  final Value<double> w;
  final Value<double> h;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MeasureRegionsCompanion({
    this.id = const Value.absent(),
    this.measureId = const Value.absent(),
    this.regionOrder = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.w = const Value.absent(),
    this.h = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasureRegionsCompanion.insert({
    required String id,
    required String measureId,
    this.regionOrder = const Value.absent(),
    required int pageNumber,
    required double x,
    required double y,
    required double w,
    required double h,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        measureId = Value(measureId),
        pageNumber = Value(pageNumber),
        x = Value(x),
        y = Value(y),
        w = Value(w),
        h = Value(h);
  static Insertable<MeasureRegion> custom({
    Expression<String>? id,
    Expression<String>? measureId,
    Expression<int>? regionOrder,
    Expression<int>? pageNumber,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? w,
    Expression<double>? h,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measureId != null) 'measure_id': measureId,
      if (regionOrder != null) 'region_order': regionOrder,
      if (pageNumber != null) 'page_number': pageNumber,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (w != null) 'w': w,
      if (h != null) 'h': h,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasureRegionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? measureId,
      Value<int>? regionOrder,
      Value<int>? pageNumber,
      Value<double>? x,
      Value<double>? y,
      Value<double>? w,
      Value<double>? h,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MeasureRegionsCompanion(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      regionOrder: regionOrder ?? this.regionOrder,
      pageNumber: pageNumber ?? this.pageNumber,
      x: x ?? this.x,
      y: y ?? this.y,
      w: w ?? this.w,
      h: h ?? this.h,
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
    if (measureId.present) {
      map['measure_id'] = Variable<String>(measureId.value);
    }
    if (regionOrder.present) {
      map['region_order'] = Variable<int>(regionOrder.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (w.present) {
      map['w'] = Variable<double>(w.value);
    }
    if (h.present) {
      map['h'] = Variable<double>(h.value);
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
    return (StringBuffer('MeasureRegionsCompanion(')
          ..write('id: $id, ')
          ..write('measureId: $measureId, ')
          ..write('regionOrder: $regionOrder, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('w: $w, ')
          ..write('h: $h, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operationType,
        payloadJson,
        status,
        retryCount,
        errorMessage,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOperation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final int id;
  final String entityType;
  final String entityId;
  final String operationType;
  final String? payloadJson;
  final String status;
  final int retryCount;
  final String? errorMessage;
  final DateTime createdAt;
  const SyncOperation(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operationType,
      this.payloadJson,
      required this.status,
      required this.retryCount,
      this.errorMessage,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operationType: Value(operationType),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOperation copyWith(
          {int? id,
          String? entityType,
          String? entityId,
          String? operationType,
          Value<String?> payloadJson = const Value.absent(),
          String? status,
          int? retryCount,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt}) =>
      SyncOperation(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operationType: operationType ?? this.operationType,
        payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operationType,
      payloadJson, status, retryCount, errorMessage, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operationType;
  final Value<String?> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operationType,
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : entityType = Value(entityType),
        entityId = Value(entityId),
        operationType = Value(operationType);
  static Insertable<SyncOperation> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncOperationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operationType,
      Value<String?>? payloadJson,
      Value<String>? status,
      Value<int>? retryCount,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt}) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $SongAssetsTable songAssets = $SongAssetsTable(this);
  late final $SyncVersionsTable syncVersions = $SyncVersionsTable(this);
  late final $MeasuresTable measures = $MeasuresTable(this);
  late final $MeasureRegionsTable measureRegions = $MeasureRegionsTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        songs,
        songAssets,
        syncVersions,
        measures,
        measureRegions,
        syncOperations
      ];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  required String id,
  required String userId,
  required String title,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            userId: userId,
            title: title,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String title,
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongsCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()>;
typedef $$SongAssetsTableCreateCompanionBuilder = SongAssetsCompanion Function({
  required String id,
  required String songId,
  required String assetType,
  Value<int> revision,
  required String storagePath,
  Value<String?> localPath,
  required String mimeType,
  required int fileSize,
  required String checksum,
  Value<bool> isActive,
  Value<bool> isDownloaded,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SongAssetsTableUpdateCompanionBuilder = SongAssetsCompanion Function({
  Value<String> id,
  Value<String> songId,
  Value<String> assetType,
  Value<int> revision,
  Value<String> storagePath,
  Value<String?> localPath,
  Value<String> mimeType,
  Value<int> fileSize,
  Value<String> checksum,
  Value<bool> isActive,
  Value<bool> isDownloaded,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$SongAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $SongAssetsTable> {
  $$SongAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetType => $composableBuilder(
      column: $table.assetType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revision => $composableBuilder(
      column: $table.revision, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$SongAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongAssetsTable> {
  $$SongAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetType => $composableBuilder(
      column: $table.assetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revision => $composableBuilder(
      column: $table.revision, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$SongAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongAssetsTable> {
  $$SongAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get assetType =>
      $composableBuilder(column: $table.assetType, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
      column: $table.storagePath, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$SongAssetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongAssetsTable,
    SongAsset,
    $$SongAssetsTableFilterComposer,
    $$SongAssetsTableOrderingComposer,
    $$SongAssetsTableAnnotationComposer,
    $$SongAssetsTableCreateCompanionBuilder,
    $$SongAssetsTableUpdateCompanionBuilder,
    (SongAsset, BaseReferences<_$AppDatabase, $SongAssetsTable, SongAsset>),
    SongAsset,
    PrefetchHooks Function()> {
  $$SongAssetsTableTableManager(_$AppDatabase db, $SongAssetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> songId = const Value.absent(),
            Value<String> assetType = const Value.absent(),
            Value<int> revision = const Value.absent(),
            Value<String> storagePath = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongAssetsCompanion(
            id: id,
            songId: songId,
            assetType: assetType,
            revision: revision,
            storagePath: storagePath,
            localPath: localPath,
            mimeType: mimeType,
            fileSize: fileSize,
            checksum: checksum,
            isActive: isActive,
            isDownloaded: isDownloaded,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String songId,
            required String assetType,
            Value<int> revision = const Value.absent(),
            required String storagePath,
            Value<String?> localPath = const Value.absent(),
            required String mimeType,
            required int fileSize,
            required String checksum,
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongAssetsCompanion.insert(
            id: id,
            songId: songId,
            assetType: assetType,
            revision: revision,
            storagePath: storagePath,
            localPath: localPath,
            mimeType: mimeType,
            fileSize: fileSize,
            checksum: checksum,
            isActive: isActive,
            isDownloaded: isDownloaded,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SongAssetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongAssetsTable,
    SongAsset,
    $$SongAssetsTableFilterComposer,
    $$SongAssetsTableOrderingComposer,
    $$SongAssetsTableAnnotationComposer,
    $$SongAssetsTableCreateCompanionBuilder,
    $$SongAssetsTableUpdateCompanionBuilder,
    (SongAsset, BaseReferences<_$AppDatabase, $SongAssetsTable, SongAsset>),
    SongAsset,
    PrefetchHooks Function()>;
typedef $$SyncVersionsTableCreateCompanionBuilder = SyncVersionsCompanion
    Function({
  required String id,
  required String songId,
  required String pdfAssetId,
  required String audioAssetId,
  required int audioDurationMs,
  Value<bool> isActive,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SyncVersionsTableUpdateCompanionBuilder = SyncVersionsCompanion
    Function({
  Value<String> id,
  Value<String> songId,
  Value<String> pdfAssetId,
  Value<String> audioAssetId,
  Value<int> audioDurationMs,
  Value<bool> isActive,
  Value<int> version,
  Value<int> baseVersion,
  Value<String> syncStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$SyncVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncVersionsTable> {
  $$SyncVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pdfAssetId => $composableBuilder(
      column: $table.pdfAssetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioAssetId => $composableBuilder(
      column: $table.audioAssetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get audioDurationMs => $composableBuilder(
      column: $table.audioDurationMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncVersionsTable> {
  $$SyncVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pdfAssetId => $composableBuilder(
      column: $table.pdfAssetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioAssetId => $composableBuilder(
      column: $table.audioAssetId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get audioDurationMs => $composableBuilder(
      column: $table.audioDurationMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncVersionsTable> {
  $$SyncVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<String> get pdfAssetId => $composableBuilder(
      column: $table.pdfAssetId, builder: (column) => column);

  GeneratedColumn<String> get audioAssetId => $composableBuilder(
      column: $table.audioAssetId, builder: (column) => column);

  GeneratedColumn<int> get audioDurationMs => $composableBuilder(
      column: $table.audioDurationMs, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
      column: $table.baseVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$SyncVersionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncVersionsTable,
    SyncVersion,
    $$SyncVersionsTableFilterComposer,
    $$SyncVersionsTableOrderingComposer,
    $$SyncVersionsTableAnnotationComposer,
    $$SyncVersionsTableCreateCompanionBuilder,
    $$SyncVersionsTableUpdateCompanionBuilder,
    (
      SyncVersion,
      BaseReferences<_$AppDatabase, $SyncVersionsTable, SyncVersion>
    ),
    SyncVersion,
    PrefetchHooks Function()> {
  $$SyncVersionsTableTableManager(_$AppDatabase db, $SyncVersionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> songId = const Value.absent(),
            Value<String> pdfAssetId = const Value.absent(),
            Value<String> audioAssetId = const Value.absent(),
            Value<int> audioDurationMs = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncVersionsCompanion(
            id: id,
            songId: songId,
            pdfAssetId: pdfAssetId,
            audioAssetId: audioAssetId,
            audioDurationMs: audioDurationMs,
            isActive: isActive,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String songId,
            required String pdfAssetId,
            required String audioAssetId,
            required int audioDurationMs,
            Value<bool> isActive = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> baseVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncVersionsCompanion.insert(
            id: id,
            songId: songId,
            pdfAssetId: pdfAssetId,
            audioAssetId: audioAssetId,
            audioDurationMs: audioDurationMs,
            isActive: isActive,
            version: version,
            baseVersion: baseVersion,
            syncStatus: syncStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncVersionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncVersionsTable,
    SyncVersion,
    $$SyncVersionsTableFilterComposer,
    $$SyncVersionsTableOrderingComposer,
    $$SyncVersionsTableAnnotationComposer,
    $$SyncVersionsTableCreateCompanionBuilder,
    $$SyncVersionsTableUpdateCompanionBuilder,
    (
      SyncVersion,
      BaseReferences<_$AppDatabase, $SyncVersionsTable, SyncVersion>
    ),
    SyncVersion,
    PrefetchHooks Function()>;
typedef $$MeasuresTableCreateCompanionBuilder = MeasuresCompanion Function({
  required String id,
  required String syncId,
  required int measureOrder,
  Value<String> measureLabel,
  Value<int?> startMs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$MeasuresTableUpdateCompanionBuilder = MeasuresCompanion Function({
  Value<String> id,
  Value<String> syncId,
  Value<int> measureOrder,
  Value<String> measureLabel,
  Value<int?> startMs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MeasuresTableFilterComposer
    extends Composer<_$AppDatabase, $MeasuresTable> {
  $$MeasuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get measureOrder => $composableBuilder(
      column: $table.measureOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measureLabel => $composableBuilder(
      column: $table.measureLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MeasuresTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasuresTable> {
  $$MeasuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get measureOrder => $composableBuilder(
      column: $table.measureOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measureLabel => $composableBuilder(
      column: $table.measureLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MeasuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasuresTable> {
  $$MeasuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<int> get measureOrder => $composableBuilder(
      column: $table.measureOrder, builder: (column) => column);

  GeneratedColumn<String> get measureLabel => $composableBuilder(
      column: $table.measureLabel, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MeasuresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MeasuresTable,
    Measure,
    $$MeasuresTableFilterComposer,
    $$MeasuresTableOrderingComposer,
    $$MeasuresTableAnnotationComposer,
    $$MeasuresTableCreateCompanionBuilder,
    $$MeasuresTableUpdateCompanionBuilder,
    (Measure, BaseReferences<_$AppDatabase, $MeasuresTable, Measure>),
    Measure,
    PrefetchHooks Function()> {
  $$MeasuresTableTableManager(_$AppDatabase db, $MeasuresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> syncId = const Value.absent(),
            Value<int> measureOrder = const Value.absent(),
            Value<String> measureLabel = const Value.absent(),
            Value<int?> startMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasuresCompanion(
            id: id,
            syncId: syncId,
            measureOrder: measureOrder,
            measureLabel: measureLabel,
            startMs: startMs,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String syncId,
            required int measureOrder,
            Value<String> measureLabel = const Value.absent(),
            Value<int?> startMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasuresCompanion.insert(
            id: id,
            syncId: syncId,
            measureOrder: measureOrder,
            measureLabel: measureLabel,
            startMs: startMs,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MeasuresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MeasuresTable,
    Measure,
    $$MeasuresTableFilterComposer,
    $$MeasuresTableOrderingComposer,
    $$MeasuresTableAnnotationComposer,
    $$MeasuresTableCreateCompanionBuilder,
    $$MeasuresTableUpdateCompanionBuilder,
    (Measure, BaseReferences<_$AppDatabase, $MeasuresTable, Measure>),
    Measure,
    PrefetchHooks Function()>;
typedef $$MeasureRegionsTableCreateCompanionBuilder = MeasureRegionsCompanion
    Function({
  required String id,
  required String measureId,
  Value<int> regionOrder,
  required int pageNumber,
  required double x,
  required double y,
  required double w,
  required double h,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$MeasureRegionsTableUpdateCompanionBuilder = MeasureRegionsCompanion
    Function({
  Value<String> id,
  Value<String> measureId,
  Value<int> regionOrder,
  Value<int> pageNumber,
  Value<double> x,
  Value<double> y,
  Value<double> w,
  Value<double> h,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MeasureRegionsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasureRegionsTable> {
  $$MeasureRegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get measureId => $composableBuilder(
      column: $table.measureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get regionOrder => $composableBuilder(
      column: $table.regionOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get w => $composableBuilder(
      column: $table.w, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get h => $composableBuilder(
      column: $table.h, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MeasureRegionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasureRegionsTable> {
  $$MeasureRegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get measureId => $composableBuilder(
      column: $table.measureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get regionOrder => $composableBuilder(
      column: $table.regionOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get w => $composableBuilder(
      column: $table.w, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get h => $composableBuilder(
      column: $table.h, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MeasureRegionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasureRegionsTable> {
  $$MeasureRegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get measureId =>
      $composableBuilder(column: $table.measureId, builder: (column) => column);

  GeneratedColumn<int> get regionOrder => $composableBuilder(
      column: $table.regionOrder, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get w =>
      $composableBuilder(column: $table.w, builder: (column) => column);

  GeneratedColumn<double> get h =>
      $composableBuilder(column: $table.h, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MeasureRegionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MeasureRegionsTable,
    MeasureRegion,
    $$MeasureRegionsTableFilterComposer,
    $$MeasureRegionsTableOrderingComposer,
    $$MeasureRegionsTableAnnotationComposer,
    $$MeasureRegionsTableCreateCompanionBuilder,
    $$MeasureRegionsTableUpdateCompanionBuilder,
    (
      MeasureRegion,
      BaseReferences<_$AppDatabase, $MeasureRegionsTable, MeasureRegion>
    ),
    MeasureRegion,
    PrefetchHooks Function()> {
  $$MeasureRegionsTableTableManager(
      _$AppDatabase db, $MeasureRegionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasureRegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasureRegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasureRegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> measureId = const Value.absent(),
            Value<int> regionOrder = const Value.absent(),
            Value<int> pageNumber = const Value.absent(),
            Value<double> x = const Value.absent(),
            Value<double> y = const Value.absent(),
            Value<double> w = const Value.absent(),
            Value<double> h = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasureRegionsCompanion(
            id: id,
            measureId: measureId,
            regionOrder: regionOrder,
            pageNumber: pageNumber,
            x: x,
            y: y,
            w: w,
            h: h,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String measureId,
            Value<int> regionOrder = const Value.absent(),
            required int pageNumber,
            required double x,
            required double y,
            required double w,
            required double h,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasureRegionsCompanion.insert(
            id: id,
            measureId: measureId,
            regionOrder: regionOrder,
            pageNumber: pageNumber,
            x: x,
            y: y,
            w: w,
            h: h,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MeasureRegionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MeasureRegionsTable,
    MeasureRegion,
    $$MeasureRegionsTableFilterComposer,
    $$MeasureRegionsTableOrderingComposer,
    $$MeasureRegionsTableAnnotationComposer,
    $$MeasureRegionsTableCreateCompanionBuilder,
    $$MeasureRegionsTableUpdateCompanionBuilder,
    (
      MeasureRegion,
      BaseReferences<_$AppDatabase, $MeasureRegionsTable, MeasureRegion>
    ),
    MeasureRegion,
    PrefetchHooks Function()>;
typedef $$SyncOperationsTableCreateCompanionBuilder = SyncOperationsCompanion
    Function({
  Value<int> id,
  required String entityType,
  required String entityId,
  required String operationType,
  Value<String?> payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
});
typedef $$SyncOperationsTableUpdateCompanionBuilder = SyncOperationsCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operationType,
  Value<String?> payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
});

class $$SyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOperationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOperationsTable,
    SyncOperation,
    $$SyncOperationsTableFilterComposer,
    $$SyncOperationsTableOrderingComposer,
    $$SyncOperationsTableAnnotationComposer,
    $$SyncOperationsTableCreateCompanionBuilder,
    $$SyncOperationsTableUpdateCompanionBuilder,
    (
      SyncOperation,
      BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>
    ),
    SyncOperation,
    PrefetchHooks Function()> {
  $$SyncOperationsTableTableManager(
      _$AppDatabase db, $SyncOperationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String?> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncOperationsCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operationType: operationType,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            errorMessage: errorMessage,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required String entityId,
            required String operationType,
            Value<String?> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncOperationsCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operationType: operationType,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            errorMessage: errorMessage,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOperationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncOperationsTable,
    SyncOperation,
    $$SyncOperationsTableFilterComposer,
    $$SyncOperationsTableOrderingComposer,
    $$SyncOperationsTableAnnotationComposer,
    $$SyncOperationsTableCreateCompanionBuilder,
    $$SyncOperationsTableUpdateCompanionBuilder,
    (
      SyncOperation,
      BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>
    ),
    SyncOperation,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$SongAssetsTableTableManager get songAssets =>
      $$SongAssetsTableTableManager(_db, _db.songAssets);
  $$SyncVersionsTableTableManager get syncVersions =>
      $$SyncVersionsTableTableManager(_db, _db.syncVersions);
  $$MeasuresTableTableManager get measures =>
      $$MeasuresTableTableManager(_db, _db.measures);
  $$MeasureRegionsTableTableManager get measureRegions =>
      $$MeasureRegionsTableTableManager(_db, _db.measureRegions);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
}
