import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/editor/data/datasources/editor_local_datasource.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';
import 'package:singersinc/features/editor/domain/repositories/editor_repository.dart';

/// Implementação do [EditorRepository] delegando para a fonte de dados SQLite local.
class EditorRepositoryImpl implements EditorRepository {
  const EditorRepositoryImpl(this._localDataSource);

  final EditorLocalDataSource _localDataSource;

  @override
  Future<Result<List<MeasureEntity>>> getMeasures(String syncId) async {
    try {
      final list = await _localDataSource.getMeasuresBySyncId(syncId);
      return Success(list);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao carregar compassos da partitura.'));
    }
  }

  @override
  Future<Result<MeasureEntity>> addMeasureWithRegion({
    required String syncId,
    required int pageNumber,
    required NormalizedRect rect,
    String? measureLabel,
  }) async {
    try {
      final created = await _localDataSource.insertMeasureWithRegion(
        syncId: syncId,
        pageNumber: pageNumber,
        rect: rect,
        measureLabel: measureLabel,
      );
      return Success(created);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Não foi possível salvar o compasso.'));
    }
  }

  @override
  Future<Result<void>> addRegionToMeasure({
    required String measureId,
    required int pageNumber,
    required NormalizedRect rect,
  }) async {
    try {
      await _localDataSource.insertRegion(
        measureId: measureId,
        pageNumber: pageNumber,
        rect: rect,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao adicionar região ao compasso.'));
    }
  }

  @override
  Future<Result<void>> updateRegionRect({
    required String regionId,
    required NormalizedRect newRect,
  }) async {
    try {
      await _localDataSource.updateRegionCoordinates(
        regionId: regionId,
        newRect: newRect,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao salvar ajuste do compasso.'));
    }
  }

  @override
  Future<Result<void>> updateMeasureLabel({
    required String measureId,
    required String newLabel,
  }) async {
    try {
      await _localDataSource.updateLabel(
        measureId: measureId,
        newLabel: newLabel,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao renomear compasso.'));
    }
  }

  @override
  Future<Result<void>> deleteMeasure(String measureId) async {
    try {
      await _localDataSource.deleteMeasureAndReorder(measureId);
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao excluir compasso.'));
    }
  }

  @override
  Future<Result<void>> deleteRegion(String regionId) async {
    try {
      await _localDataSource.deleteRegion(regionId);
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao excluir região do compasso.'));
    }
  }

  @override
  Future<Result<void>> reorderMeasures({
    required String syncId,
    required List<String> orderedMeasureIds,
  }) async {
    try {
      await _localDataSource.reorderMeasures(
        syncId: syncId,
        orderedMeasureIds: orderedMeasureIds,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao reordenar compassos.'));
    }
  }
}

