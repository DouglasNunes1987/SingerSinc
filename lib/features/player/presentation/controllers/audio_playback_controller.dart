import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/services/audio_player_service.dart';
import 'package:singersinc/features/player/domain/models/audio_playback_state.dart';

/// Controller reativo responsável por gerenciar a reprodução, seek e velocidade do áudio.
class AudioPlaybackController extends AutoDisposeNotifier<AudioPlaybackState> {
  AudioPlayerService get _audioService => ref.read(audioPlayerServiceProvider);

  StreamSubscription<int>? _posSub;
  StreamSubscription<int?>? _durSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _completedSub;

  @override
  AudioPlaybackState build() {
    ref.onDispose(() {
      _posSub?.cancel();
      _durSub?.cancel();
      _playingSub?.cancel();
      _completedSub?.cancel();
    });

    return const AudioPlaybackState();
  }

  /// Inicializa o player com o arquivo de áudio local.
  Future<void> loadAudio(
    String absoluteFilePath, {
    int? fallbackDurationMs,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      durationMs: fallbackDurationMs ?? state.durationMs,
    );

    try {
      _posSub?.cancel();
      _durSub?.cancel();
      _playingSub?.cancel();
      _completedSub?.cancel();

      final detectedDuration = await _audioService.loadFile(absoluteFilePath);

      _posSub = _audioService.positionMsStream.listen((pos) {
        state = state.copyWith(positionMs: pos);
      });

      _durSub = _audioService.durationMsStream.listen((dur) {
        if (dur != null && dur > 0) {
          state = state.copyWith(durationMs: dur);
        }
      });

      _playingSub = _audioService.isPlayingStream.listen((playing) {
        state = state.copyWith(isPlaying: playing);
      });

      _completedSub = _audioService.isCompletedStream.listen((completed) {
        state = state.copyWith(isCompleted: completed);
      });

      final finalDuration = detectedDuration ?? fallbackDurationMs ?? 0;

      state = state.copyWith(
        isLoading: false,
        durationMs: finalDuration,
        speed: _audioService.speed,
        isPlaying: _audioService.isPlaying,
        positionMs: _audioService.positionMs,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Erro ao carregar o arquivo de áudio: $e',
      );
    }
  }

  /// Inicia ou pausa a reprodução.
  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  /// Reproduz o áudio.
  Future<void> play() async {
    await _audioService.play();
  }

  /// Pausa o áudio.
  Future<void> pause() async {
    await _audioService.pause();
  }

  /// Posiciona a reprodução no instante em milissegundos.
  Future<void> seekTo(int positionMs) async {
    final clamped = positionMs.clamp(0, state.durationMs > 0 ? state.durationMs : positionMs);
    state = state.copyWith(positionMs: clamped);
    await _audioService.seek(clamped);
  }

  /// Desloca a posição relativamente em milissegundos (ex.: +5000ms ou -5000ms).
  Future<void> seekRelative(int deltaMs) async {
    final target = state.positionMs + deltaMs;
    await seekTo(target);
  }

  /// Altera a velocidade de reprodução (ex.: 0.5, 0.75, 1.0, 1.25, 1.5, 2.0).
  Future<void> setSpeed(double speed) async {
    await _audioService.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }
}

final audioPlaybackControllerProvider =
    AutoDisposeNotifierProvider<AudioPlaybackController, AudioPlaybackState>(
  AudioPlaybackController.new,
);
