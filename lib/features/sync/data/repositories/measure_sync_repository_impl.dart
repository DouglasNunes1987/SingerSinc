import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/sync/data/datasources/measure_sync_local_datasource.dart';
import 'package:singersinc/features/sync/domain/repositories/measure_sync_repository.dart';

/// Implementação do [MeasureSyncRepository] usando SQLite local.
class MeasureSyncRepositoryImpl implements MeasureSyncRepository {
  const MeasureSyncRepositoryImpl(this._localDataSource);

  final MeasureSyncLocalDataSource _localDataSource;

  @override
  Future<Result<void>> saveMeasureTimestamp({
    required String measureId,
    required int startMs,
  }) async {
    try {
      await _localDataSource.updateStartMs(
        measureId: measureId,
        startMs: startMs,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao salvar tempo do compasso.'));
    }
  }

  @override
  Future<Result<void>> clearMeasureTimestamp(String measureId) async {
    try {
      await _localDataSource.updateStartMs(
        measureId: measureId,
        startMs: null,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao limpar tempo do compasso.'));
    }
  }

  @override
  Future<Result<void>> shiftSubsequentTimestamps({
    required String syncId,
    required int fromMeasureOrder,
    required int deltaMs,
    required int audioDurationMs,
  }) async {
    try {
      await _localDataSource.shiftTimestamps(
        syncId: syncId,
        fromMeasureOrder: fromMeasureOrder,
        deltaMs: deltaMs,
        audioDurationMs: audioDurationMs,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao deslocar tempos dos compassos.'));
    }
  }

  @override
  Future<Result<void>> saveBatchTimestamps({
    required String syncId,
    required Map<String, int> timestamps,
  }) async {
    try {
      await _localDataSource.saveBatch(
        syncId: syncId,
        timestamps: timestamps,
      );
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Erro ao persistir sincronizações.'));
    }
  }
}

