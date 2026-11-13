import 'package:drift/drift.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/entities/measure_region_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';
import 'package:uuid/uuid.dart';

/// Fonte de dados local para operações de compassos e regiões no SQLite via Drift.
class EditorLocalDataSource {
  const EditorLocalDataSource(this._db, {Uuid uuid = const Uuid()})
      : _uuid = uuid;

  final AppDatabase _db;
  final Uuid _uuid;

  /// Retorna todos os compassos ordenados com suas respectivas regiões.
  Future<List<MeasureEntity>> getMeasuresBySyncId(String syncId) async {
    try {
      final measureRows = await (_db.select(_db.measures)
            ..where((m) => m.syncId.equals(syncId))
            ..orderBy([(m) => OrderingTerm.asc(m.measureOrder)]))
          .get();

      if (measureRows.isEmpty) return const [];

      final measureIds = measureRows.map((m) => m.id).toList();
      final regionRows = await (_db.select(_db.measureRegions)
            ..where((r) => r.measureId.isIn(measureIds))
            ..orderBy([(r) => OrderingTerm.asc(r.regionOrder)]))
          .get();

      return measureRows.map((m) {
        final regionsForMeasure = regionRows
            .where((r) => r.measureId == m.id)
            .map(_mapRegion)
            .toList();

        return MeasureEntity(
          id: m.id,
          syncId: m.syncId,
          measureOrder: m.measureOrder,
          measureLabel: m.measureLabel,
          startMs: m.startMs,
          regions: regionsForMeasure,
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
        );
      }).toList();
    } catch (e) {
      throw LocalDatabaseException(
        'Falha ao carregar compassos do banco local.',
        cause: e,
      );
    }
  }

  /// Insere um novo compasso associado a uma região retangular.
  Future<MeasureEntity> insertMeasureWithRegion({
    required String syncId,
    required int pageNumber,
    required NormalizedRect rect,
    String? measureLabel,
  }) async {
    try {
      final now = DateTime.now();
      final measureId = _uuid.v4();
      final regionId = _uuid.v4();

      return await _db.transaction(() async {
        // Determina o próximo número de ordem
        final existingMeasures = await (_db.select(_db.measures)
              ..where((m) => m.syncId.equals(syncId)))
            .get();
        final nextOrder = existingMeasures.isEmpty
            ? 1
            : existingMeasures.map((m) => m.measureOrder).reduce((a, b) => a > b ? a : b) + 1;

        final label = measureLabel?.trim().isNotEmpty == true
            ? measureLabel!.trim()
            : '$nextOrder';

        await _db.into(_db.measures).insert(
              MeasuresCompanion.insert(
                id: measureId,
                syncId: syncId,
                measureOrder: nextOrder,
                measureLabel: Value(label),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await _db.into(_db.measureRegions).insert(
              MeasureRegionsCompanion.insert(
                id: regionId,
                measureId: measureId,
                regionOrder: const Value(1),
                pageNumber: pageNumber,
                x: rect.x,
                y: rect.y,
                w: rect.w,
                h: rect.h,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // Marca sync_version e song como pendente de sync
        await _markSyncPending(syncId);

        return MeasureEntity(
          id: measureId,
          syncId: syncId,
          measureOrder: nextOrder,
          measureLabel: label,
          regions: [
            MeasureRegionEntity(
              id: regionId,
              measureId: measureId,
              regionOrder: 1,
              pageNumber: pageNumber,
              rect: rect,
              createdAt: now,
              updatedAt: now,
            ),
          ],
          createdAt: now,
          updatedAt: now,
        );
      });
    } catch (e) {
      throw LocalDatabaseException(
        'Erro ao criar o compasso na partitura.',
        cause: e,
      );
    }
  }

  /// Adiciona uma nova região a um compasso já cadastrado.
  Future<void> insertRegion({
    required String measureId,
    required int pageNumber,
    required NormalizedRect rect,
  }) async {
    try {
      final now = DateTime.now();
      await _db.transaction(() async {
        final existingRegions = await (_db.select(_db.measureRegions)
              ..where((r) => r.measureId.equals(measureId)))
            .get();
        final nextOrder = existingRegions.isEmpty
            ? 1
            : existingRegions.map((r) => r.regionOrder).reduce((a, b) => a > b ? a : b) + 1;

        await _db.into(_db.measureRegions).insert(
              MeasureRegionsCompanion.insert(
                id: _uuid.v4(),
                measureId: measureId,
                regionOrder: Value(nextOrder),
                pageNumber: pageNumber,
                x: rect.x,
                y: rect.y,
                w: rect.w,
                h: rect.h,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        final measure = await (_db.select(_db.measures)
              ..where((m) => m.id.equals(measureId)))
            .getSingle();
        await _markSyncPending(measure.syncId);
      });
    } catch (e) {
      throw LocalDatabaseException('Erro ao adicionar região ao compasso.', cause: e);
    }
  }

  /// Atualiza o retângulo normalizado de uma região.
  Future<void> updateRegionCoordinates({
    required String regionId,
    required NormalizedRect newRect,
  }) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.measureRegions)..where((r) => r.id.equals(regionId))).write(
        MeasureRegionsCompanion(
          x: Value(newRect.x),
          y: Value(newRect.y),
          w: Value(newRect.w),
          h: Value(newRect.h),
          updatedAt: Value(now),
        ),
      );
    } catch (e) {
      throw LocalDatabaseException('Erro ao ajustar retângulo do compasso.', cause: e);
    }
  }

  /// Atualiza o rótulo do compasso.
  Future<void> updateLabel({
    required String measureId,
    required String newLabel,
  }) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.measures)..where((m) => m.id.equals(measureId))).write(
        MeasuresCompanion(
          measureLabel: Value(newLabel.trim()),
          updatedAt: Value(now),
        ),
      );
    } catch (e) {
      throw LocalDatabaseException('Erro ao renomear compasso.', cause: e);
    }
  }

  /// Exclui um compasso e reordena os compassos subsequentes.
  Future<void> deleteMeasureAndReorder(String measureId) async {
    try {
      await _db.transaction(() async {
        final target = await (_db.select(_db.measures)
              ..where((m) => m.id.equals(measureId)))
            .getSingleOrNull();
        if (target == null) return;

        final syncId = target.syncId;
        final deletedOrder = target.measureOrder;

        // Exclui o compasso (exclusão em cascata cuidará das regiões)
        await (_db.delete(_db.measures)..where((m) => m.id.equals(measureId))).go();

        // Reordena compassos posteriores
        final laterMeasures = await (_db.select(_db.measures)
              ..where((m) => m.syncId.equals(syncId) & m.measureOrder.isBiggerThanValue(deletedOrder))
              ..orderBy([(m) => OrderingTerm.asc(m.measureOrder)]))
            .get();

        for (final m in laterMeasures) {
          await (_db.update(_db.measures)..where((x) => x.id.equals(m.id))).write(
            MeasuresCompanion(
              measureOrder: Value(m.measureOrder - 1),
            ),
          );
        }

        await _markSyncPending(syncId);
      });
    } catch (e) {
      throw LocalDatabaseException('Erro ao excluir compasso.', cause: e);
    }
  }

  /// Exclui uma única região de um compasso.
  Future<void> deleteRegion(String regionId) async {
    try {
      await (_db.delete(_db.measureRegions)..where((r) => r.id.equals(regionId))).go();
    } catch (e) {
      throw LocalDatabaseException('Erro ao excluir região.', cause: e);
    }
  }

  /// Reorganiza a ordem dos compassos conforme lista ordenada de IDs.
  Future<void> reorderMeasures({
    required String syncId,
    required List<String> orderedMeasureIds,
  }) async {
    try {
      await _db.transaction(() async {
        for (var i = 0; i < orderedMeasureIds.length; i++) {
          final id = orderedMeasureIds[i];
          final newOrder = i + 1;
          await (_db.update(_db.measures)..where((m) => m.id.equals(id))).write(
            MeasuresCompanion(
              measureOrder: Value(newOrder),
            ),
          );
        }
        await _markSyncPending(syncId);
      });
    } catch (e) {
      throw LocalDatabaseException('Erro ao reorganizar compassos.', cause: e);
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

      final song = await (_db.select(_db.songs)..where((s) => s.id.equals(syncVersion.songId)))
          .getSingleOrNull();
      if (song != null) {
        await (_db.update(_db.songs)..where((s) => s.id.equals(song.id))).write(
          SongsCompanion(
            version: Value(song.version + 1),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  MeasureRegionEntity _mapRegion(MeasureRegion row) {
    return MeasureRegionEntity(
      id: row.id,
      measureId: row.measureId,
      regionOrder: row.regionOrder,
      pageNumber: row.pageNumber,
      rect: NormalizedRect(
        x: row.x,
        y: row.y,
        w: row.w,
        h: row.h,
      ),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

