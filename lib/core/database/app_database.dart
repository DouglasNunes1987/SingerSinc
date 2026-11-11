import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/database/tables/measure_regions_table.dart';
import 'package:singersinc/core/database/tables/measures_table.dart';
import 'package:singersinc/core/database/tables/song_assets_table.dart';
import 'package:singersinc/core/database/tables/songs_table.dart';
import 'package:singersinc/core/database/tables/sync_operations_table.dart';
import 'package:singersinc/core/database/tables/sync_versions_table.dart';

part 'app_database.g.dart';

/// Banco de dados SQLite local do SingerSinc gerenciado pelo Drift.
/// Constitui a fonte única da verdade (Single Source of Truth) para funcionamento Offline-First.
@DriftDatabase(
  tables: [
    Songs,
    SongAssets,
    SyncVersions,
    Measures,
    MeasureRegions,
    SyncOperations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Habilita integridade referencial de chaves estrangeiras no SQLite
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'singersinc_local_db');
  }
}

/// Provider global do banco de dados SQLite local.
/// Pode ser sobrescrito em testes com uma instância em memória (`NativeDatabase.memory()`).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

