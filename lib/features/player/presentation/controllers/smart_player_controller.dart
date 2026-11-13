import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/player/domain/usecases/find_active_measure_usecase.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';

final findActiveMeasureUseCaseProvider = Provider<FindActiveMeasureUseCase>((ref) {
  return const FindActiveMeasureUseCase();
});

/// Estado do Player Inteligente com destaque em tempo real.
class SmartPlayerState {
  const SmartPlayerState({
    this.isLoading = false,
    this.syncId = '',
    this.measures = const [],
    this.activeMeasure,
    this.isLoopingCurrentMeasure = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String syncId;
  final List<MeasureEntity> measures;
  final MeasureEntity? activeMeasure;
  final bool isLoopingCurrentMeasure;
  final String? errorMessage;

  SmartPlayerState copyWith({
    bool? isLoading,
    String? syncId,
    List<MeasureEntity>? measures,
    MeasureEntity? Function()? activeMeasure,
    bool? isLoopingCurrentMeasure,
    String? Function()? errorMessage,
  }) {
    return SmartPlayerState(
      isLoading: isLoading ?? this.isLoading,
      syncId: syncId ?? this.syncId,
      measures: measures ?? this.measures,
      activeMeasure:
          activeMeasure != null ? activeMeasure() : this.activeMeasure,
      isLoopingCurrentMeasure:
          isLoopingCurrentMeasure ?? this.isLoopingCurrentMeasure,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// Controller responsável pelo destaque visual dos compassos e saltos de reprodução.
class SmartPlayerController extends AutoDisposeNotifier<SmartPlayerState> {
  FindActiveMeasureUseCase get _findActiveMeasure =>
      ref.read(findActiveMeasureUseCaseProvider);

  @override
  SmartPlayerState build() {
    // Observa a posição do áudio e executa a busca binária
    ref.listen<int>(
      audioPlaybackControllerProvider.select((state) => state.positionMs),
      (_, currentPositionMs) {
        _updateActiveMeasure(currentPositionMs);
      },
    );

    return const SmartPlayerState();
  }

  /// Inicializa o player inteligente carregando os compassos.
  Future<void> initialize(String syncId) async {
    state = state.copyWith(isLoading: true, syncId: syncId);

    final result = await ref.read(editorRepositoryProvider).getMeasures(syncId);

    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      onSuccess: (list) {
        state = state.copyWith(
          isLoading: false,
          measures: list,
        );
        final currentPos = ref.read(audioPlaybackControllerProvider).positionMs;
        _updateActiveMeasure(currentPos);
      },
    );
  }

  void _updateActiveMeasure(int positionMs) {
    if (state.measures.isEmpty) return;

    final found = _findActiveMeasure(
      measures: state.measures,
      currentPositionMs: positionMs,
    );

    // Se a opção de loop de compasso estiver ativa e o áudio passou para o próximo compasso
    if (state.isLoopingCurrentMeasure && state.activeMeasure != null) {
      final current = state.activeMeasure!;
      final currentOrder = current.measureOrder;
      final next = state.measures
          .where((m) => m.measureOrder == currentOrder + 1 && m.startMs != null)
          .firstOrNull;

      if (next != null && positionMs >= next.startMs!) {
        // Volta para o início do compasso atual em loop
        ref.read(audioPlaybackControllerProvider.notifier).seekTo(current.startMs!);
        return;
      }
    }

    // Otimização: Só atualiza o estado se o compasso ativo realmente tiver mudado!
    if (found?.id != state.activeMeasure?.id) {
      state = state.copyWith(activeMeasure: () => found);
    }
  }

  /// Salta a reprodução diretamente para o início do compasso ao tocá-lo na partitura (Seek on Tap).
  Future<void> seekToMeasure(String measureId) async {
    final target = state.measures.where((m) => m.id == measureId).firstOrNull;
    if (target != null && target.startMs != null) {
      await ref
          .read(audioPlaybackControllerProvider.notifier)
          .seekTo(target.startMs!);
    }
  }

  /// Salta para o compasso anterior.
  Future<void> previousMeasure() async {
    final current = state.activeMeasure;
    if (current == null) {
      if (state.measures.isNotEmpty && state.measures.first.startMs != null) {
        await seekToMeasure(state.measures.first.id);
      }
      return;
    }

    final prev = state.measures
        .where((m) => m.measureOrder == current.measureOrder - 1 && m.startMs != null)
        .firstOrNull;

    if (prev != null) {
      await seekToMeasure(prev.id);
    } else {
      await seekToMeasure(current.id);
    }
  }

  /// Salta para o próximo compasso.
  Future<void> nextMeasure() async {
    final current = state.activeMeasure;
    if (current == null) {
      if (state.measures.isNotEmpty && state.measures.first.startMs != null) {
        await seekToMeasure(state.measures.first.id);
      }
      return;
    }

    final next = state.measures
        .where((m) => m.measureOrder == current.measureOrder + 1 && m.startMs != null)
        .firstOrNull;

    if (next != null) {
      await seekToMeasure(next.id);
    }
  }

  /// Alterna a repetição do compasso ativo (Loop do Compasso).
  void toggleLoopCurrentMeasure() {
    state = state.copyWith(
      isLoopingCurrentMeasure: !state.isLoopingCurrentMeasure,
    );
  }
}

final smartPlayerControllerProvider =
    AutoDisposeNotifierProvider<SmartPlayerController, SmartPlayerState>(
  SmartPlayerController.new,
);

