import 'package:drift/drift.dart';

/// Tabela local de arquivos vinculados à música (`song_assets`: PDF e MP3).
/// Armazena tanto o `storage_path` remoto quanto o `local_path` no dispositivo.
class SongAssets extends Table {
  TextColumn get id => text()();
  TextColumn get songId => text()
      .named('song_id')
      .customConstraint('NOT NULL REFERENCES songs(id) ON DELETE CASCADE')();
  TextColumn get assetType => text().named('asset_type')(); // 'pdf' | 'audio'
  IntColumn get revision => integer().withDefault(const Constant(1))();
  TextColumn get storagePath => text().named('storage_path')();
  TextColumn get localPath => text().named('local_path').nullable()();
  TextColumn get mimeType => text().named('mime_type')();
  IntColumn get fileSize => integer().named('file_size')();
  TextColumn get checksum => text()();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();
  BoolColumn get isDownloaded =>
      boolean().named('is_downloaded').withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get baseVersion =>
      integer().named('base_version').withDefault(const Constant(0))();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
