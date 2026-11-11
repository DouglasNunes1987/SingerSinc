import 'package:drift/drift.dart';

/// Tabela local de versões de sincronização (`sync_versions`).
/// Vincula uma revisão de PDF a uma revisão de áudio (MP3).
class SyncVersions extends Table {
  TextColumn get id => text()();
  TextColumn get songId => text()
      .named('song_id')
      .customConstraint('NOT NULL REFERENCES songs(id) ON DELETE CASCADE')();
  TextColumn get pdfAssetId => text()
      .named('pdf_asset_id')
      .customConstraint(
        'NOT NULL REFERENCES song_assets(id) ON DELETE CASCADE',
      )();
  TextColumn get audioAssetId => text()
      .named('audio_asset_id')
      .customConstraint(
        'NOT NULL REFERENCES song_assets(id) ON DELETE CASCADE',
      )();
  IntColumn get audioDurationMs => integer().named('audio_duration_ms')();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();
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
