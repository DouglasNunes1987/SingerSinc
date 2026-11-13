import 'package:drift/drift.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/app_exception.dart';

/// Fonte de dados local para atualização e ajustes em lote de timestamps dos compassos.
class MeasureSyncLocalDataSource {
  const MeasureSyncLocalDataSource(this._db);

  final AppDatabase _db;

  /// Salva o start_ms de um compasso individual.
  Future<void> updateStartMs({
    required String measureId,
    required int? startMs,
  }) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.measures)..where((m) => m.id.equals(measureId))).write(
        MeasuresCompanion(
          startMs: Value(startMs),
          updatedAt: Value(now),
        ),
      );

      final measure = await (_db.select(_db.measures)..where((m) => m.id.equals(measureId)))
          .getSingleOrNull();
      if (measure != null) {
        await _markSyncPending(measure.syncId);
      }
    } catch (e) {
      throw LocalDatabaseException('Falha ao registrar tempo do compasso.', cause: e);
    }
  }

  /// Desloca em lote os tempos de compassos subsequentes.
  Future<void> shiftTimestamps({
    required String syncId,
    required int fromMeasureOrder,
    required int deltaMs,
    required int audioDurationMs,
  }) async {
    try {
      final now = DateTime.now();
      await _db.transaction(() async {
        final measures = await (_db.select(_db.measures)
              ..where(
                (m) =>
                    m.syncId.equals(syncId) &
                    m.measureOrder.isBiggerOrEqualValue(fromMeasureOrder) &
                    m.startMs.isNotNull(),
              )
              ..orderBy([(m) => OrderingTerm.asc(m.measureOrder)]))
            .get();

        for (final m in measures) {
          if (m.startMs != null) {
            final shifted = (m.startMs! + deltaMs).clamp(0, audioDurationMs);
            await (_db.update(_db.measures)..where((x) => x.id.equals(m.id))).write(
              MeasuresCompanion(
                startMs: Value(shifted),
                updatedAt: Value(now),
              ),
            );
          }
        }

        await _markSyncPending(syncId);
      });
    } catch (e) {
      throw LocalDatabaseException('Falha ao deslocar tempos em lote.', cause: e);
    }
  }

  /// Salva múltiplos timestamps em uma única transação atômica.
  Future<void> saveBatch({
    required String syncId,
    required Map<String, int> timestamps,
  }) async {
    try {
      final now = DateTime.now();
      await _db.transaction(() async {
        for (final entry in timestamps.entries) {
          await (_db.update(_db.measures)..where((m) => m.id.equals(entry.key))).write(
            MeasuresCompanion(
              startMs: Value(entry.value),
              updatedAt: Value(now),
            ),
          );
        }
        await _markSyncPending(syncId);
      });
    } catch (e) {
      throw LocalDatabaseException('Falha ao salvar lote de tempos.', cause: e);
    }
  }

  Future<void> _markSyncPending(String syncId) async {
    final now = DateTime.now();
    final syncVersion = await (_db.select(_db.syncVersions)..where((s) => s.id.equals(syncId)))
        .getSingleOrNull();
    if (syncVersion != null) {
      await (_db.update(_db.syncVersions)..where((s) => s.id.equals(syncId))).write(
        SyncVersionsCompanion(
          syncStatus: const Value('pending'),
          updatedAt: Value(now),
        ),
      );
    }
  }
}

