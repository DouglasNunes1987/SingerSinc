import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/audio_player_service.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/sync/data/datasources/measure_sync_local_datasource.dart';
import 'package:singersinc/features/sync/data/repositories/measure_sync_repository_impl.dart';
import 'package:singersinc/features/sync/domain/repositories/measure_sync_repository.dart';

final measureSyncLocalDataSourceProvider =
    Provider<MeasureSyncLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MeasureSyncLocalDataSource(db);
});

final measureSyncRepositoryProvider = Provider<MeasureSyncRepository>((ref) {
  final ds = ref.watch(measureSyncLocalDataSourceProvider);
  return MeasureSyncRepositoryImpl(ds);
});

/// Estado da tela de sincronização manual de compassos.
class ManualSyncState {
  const ManualSyncState({
    this.isLoading = false,
    this.syncId = '',
    this.audioDurationMs = 0,
    this.measures = const [],
    this.focusedIndex = 0,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String syncId;
  final int audioDurationMs;
  final List<MeasureEntity> measures;
  final int focusedIndex;
  final String? errorMessage;
  final String? successMessage;

  MeasureEntity? get focusedMeasure =>
      focusedIndex >= 0 && focusedIndex < measures.length
          ? measures[focusedIndex]
          : null;

  int get syncedCount => measures.where((m) => m.startMs != null).length;
  bool get allSynced => measures.isNotEmpty && syncedCount == measures.length;

  ManualSyncState copyWith({
    bool? isLoading,
    String? syncId,
    int? audioDurationMs,
    List<MeasureEntity>? measures,
    int? focusedIndex,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return ManualSyncState(
      isLoading: isLoading ?? this.isLoading,
      syncId: syncId ?? this.syncId,
      audioDurationMs: audioDurationMs ?? this.audioDurationMs,
      measures: measures ?? this.measures,
      focusedIndex: focusedIndex ?? this.focusedIndex,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
    );
  }
}

/// Controller responsável pelo fluxo de marcação manual de timestamps dos compassos.
class ManualSyncController extends AutoDisposeNotifier<ManualSyncState> {
  MeasureSyncRepository get _syncRepo => ref.read(measureSyncRepositoryProvider);
  AudioPlayerService get _audioService => ref.read(audioPlayerServiceProvider);

  @override
  ManualSyncState build() {
    return const ManualSyncState();
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      successMessage: () => null,
    );
  }

  /// Inicializa com o syncId e a duração do áudio.
  Future<void> initialize({
    required String syncId,
    required int audioDurationMs,
  }) async {
    state = state.copyWith(
      isLoading: true,
      syncId: syncId,
      audioDurationMs: audioDurationMs,
    );

    final result = await ref.read(editorRepositoryProvider).getMeasures(syncId);

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      onSuccess: (List<MeasureEntity> list) {
        // Encontra o primeiro compasso ainda não sincronizado para focar
        final firstUnsynced = list.indexWhere((m) => m.startMs == null);
        final initialIndex = firstUnsynced != -1 ? firstUnsynced : 0;

        state = state.copyWith(
          isLoading: false,
          measures: list,
          focusedIndex: initialIndex,
        );
      },
    );
  }

  /// Define o índice do compasso focado manualmente.
  void setFocusedIndex(int index) {
    if (index >= 0 && index < state.measures.length) {
      state = state.copyWith(focusedIndex: index);
    }
  }

  /// Avança para o próximo compasso.
  void nextMeasure() {
    if (state.focusedIndex + 1 < state.measures.length) {
      state = state.copyWith(focusedIndex: state.focusedIndex + 1);
    }
  }

  /// Retorna ao compasso anterior.
  void previousMeasure() {
    if (state.focusedIndex > 0) {
      state = state.copyWith(focusedIndex: state.focusedIndex - 1);
    }
  }

  /// Registra o momento exato da reprodução do áudio (em ms) no compasso atual
  /// e avança imediatamente para o próximo compasso.
  Future<void> markCurrentMeasure() async {
    final current = state.focusedMeasure;
    if (current == null) return;

    final currentPositionMs = _audioService.positionMs;

    // Atualiza localmente no estado
    final updatedList = state.measures.map((m) {
      if (m.id == current.id) {
        return m.copyWith(startMs: currentPositionMs);
      }
      return m;
    }).toList();

    final nextIndex = (state.focusedIndex + 1 < state.measures.length)
        ? state.focusedIndex + 1
        : state.focusedIndex;

    state = state.copyWith(
      measures: updatedList,
      focusedIndex: nextIndex,
      successMessage: () =>
          'Compasso ${current.displayLabel} marcado em ${_formatMs(currentPositionMs)}!',
    );

    // Persiste no SQLite
    await _syncRepo.saveMeasureTimestamp(
      measureId: current.id,
      startMs: currentPositionMs,
    );
  }

  /// Ajusta individualmente a marcação do compasso focado por um delta em milissegundos (+/-).
  Future<void> adjustCurrentMeasure(int deltaMs) async {
    final current = state.focusedMeasure;
    if (current == null || current.startMs == null) return;

    final newStart = (current.startMs! + deltaMs).clamp(0, state.audioDurationMs);

    final updatedList = state.measures.map((m) {
      if (m.id == current.id) {
        return m.copyWith(startMs: newStart);
      }
      return m;
    }).toList();

    state = state.copyWith(measures: updatedList);

    await _syncRepo.saveMeasureTimestamp(
      measureId: current.id,
      startMs: newStart,
    );
  }

  /// Desloca em lote os tempos de todos os compassos a partir do atual (+/- deltaMs).
  Future<void> shiftFromCurrent(int deltaMs) async {
    final current = state.focusedMeasure;
    if (current == null) return;

    final updatedList = state.measures.map((m) {
      if (m.measureOrder >= current.measureOrder && m.startMs != null) {
        final shifted = (m.startMs! + deltaMs).clamp(0, state.audioDurationMs);
        return m.copyWith(startMs: shifted);
      }
      return m;
    }).toList();

    state = state.copyWith(
      measures: updatedList,
      successMessage: () => 'Deslocamento de ${deltaMs > 0 ? "+$deltaMs" : deltaMs}ms aplicado na sequência!',
    );

    await _syncRepo.shiftSubsequentTimestamps(
      syncId: state.syncId,
      fromMeasureOrder: current.measureOrder,
      deltaMs: deltaMs,
      audioDurationMs: state.audioDurationMs,
    );
  }

  /// Limpa a marcação de tempo do compasso focado.
  Future<void> clearCurrentMeasure() async {
    final current = state.focusedMeasure;
    if (current == null) return;

    final updatedList = state.measures.map((m) {
      if (m.id == current.id) {
        return m.copyWith(startMs: null);
      }
      return m;
    }).toList();

    state = state.copyWith(measures: updatedList);
    await _syncRepo.clearMeasureTimestamp(current.id);
  }

  /// Posiciona o áudio no início do compasso focado para conferência auditiva.
  Future<void> seekToCurrentMeasure() async {
    final current = state.focusedMeasure;
    if (current != null && current.startMs != null) {
      await _audioService.seek(current.startMs!);
    }
  }

  String _formatMs(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final millis = ms % 1000;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(3, '0')}';
  }
}

final manualSyncControllerProvider =
    AutoDisposeNotifierProvider<ManualSyncController, ManualSyncState>(
  ManualSyncController.new,
);

