import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Contrato desacoplado para reprodução de áudio.
abstract interface class AudioPlayerService {
  /// Stream contínua de posição de reprodução em milissegundos.
  Stream<int> get positionMsStream;

  /// Stream de duração total do áudio em milissegundos.
  Stream<int?> get durationMsStream;

  /// Stream do estado de reprodução (reproduzindo ou pausado).
  Stream<bool> get isPlayingStream;

  /// Stream de término de reprodução da faixa.
  Stream<bool> get isCompletedStream;

  /// Duração atual em milissegundos, se disponível.
  int? get durationMs;

  /// Posição atual em milissegundos.
  int get positionMs;

  /// Velocidade atual de reprodução.
  double get speed;

  /// Verdadeiro se o áudio está tocando.
  bool get isPlaying;

  /// Carrega o arquivo de áudio local. Retorna a duração em milissegundos.
  Future<int?> loadFile(String absoluteFilePath);

  /// Inicia ou retoma a reprodução.
  Future<void> play();

  /// Pausa a reprodução.
  Future<void> pause();

  /// Para a reprodução e reposiciona o áudio no início (0ms).
  Future<void> stop();

  /// Posiciona a reprodução no instante especificado em milissegundos.
  Future<void> seek(int positionMs);

  /// Altera a velocidade de reprodução (ex.: 0.5x, 1.0x, 1.5x).
  Future<void> setSpeed(double speed);

  /// Libera os recursos alocados pelo mecanismo de áudio.
  Future<void> dispose();
}

/// Implementação concreta baseada no plugin `just_audio`.
class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService({AudioPlayer? player}) : _player = player ?? AudioPlayer() {
    _positionSubscription = _player
        .createPositionStream(
          minPeriod: const Duration(milliseconds: 40),
          maxPeriod: const Duration(milliseconds: 60),
        )
        .listen((position) {
      if (!_positionController.isClosed) {
        _positionController.add(position.inMilliseconds);
      }
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      if (!_durationController.isClosed) {
        _durationController.add(duration?.inMilliseconds);
      }
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!_isPlayingController.isClosed) {
        _isPlayingController.add(state.playing);
      }
      if (!_isCompletedController.isClosed) {
        _isCompletedController
            .add(state.processingState == ProcessingState.completed);
      }
    });
  }

  final AudioPlayer _player;

  final _positionController = StreamController<int>.broadcast();
  final _durationController = StreamController<int?>.broadcast();
  final _isPlayingController = StreamController<bool>.broadcast();
  final _isCompletedController = StreamController<bool>.broadcast();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  Stream<int> get positionMsStream => _positionController.stream;

  @override
  Stream<int?> get durationMsStream => _durationController.stream;

  @override
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  @override
  Stream<bool> get isCompletedStream => _isCompletedController.stream;

  @override
  int? get durationMs => _player.duration?.inMilliseconds;

  @override
  int get positionMs => _player.position.inMilliseconds;

  @override
  double get speed => _player.speed;

  @override
  bool get isPlaying => _player.playing;

  @override
  Future<int?> loadFile(String absoluteFilePath) async {
    final duration = await _player.setFilePath(absoluteFilePath);
    return duration?.inMilliseconds ?? _player.duration?.inMilliseconds;
  }

  @override
  Future<void> play() async {
    // Se o áudio tiver chegado ao fim, reinicia do começo
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  Future<void> seek(int positionMs) {
    return _player.seek(Duration(milliseconds: positionMs.clamp(0, durationMs ?? positionMs)));
  }

  @override
  Future<void> setSpeed(double speed) {
    return _player.setSpeed(speed.clamp(0.25, 3.0));
  }

  @override
  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _positionController.close();
    await _durationController.close();
    await _isPlayingController.close();
    await _isCompletedController.close();
    await _player.dispose();
  }
}

/// Provider transitório (autoDispose) para cada instância de player ativo.
final audioPlayerServiceProvider =
    Provider.autoDispose<AudioPlayerService>((ref) {
  final service = JustAudioPlayerService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

