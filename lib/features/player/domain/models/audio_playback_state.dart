/// Estado imutável da reprodução de áudio.
class AudioPlaybackState {
  const AudioPlaybackState({
    this.isPlaying = false,
    this.isCompleted = false,
    this.isLoading = false,
    this.positionMs = 0,
    this.durationMs = 0,
    this.speed = 1.0,
    this.errorMessage,
  });

  final bool isPlaying;
  final bool isCompleted;
  final bool isLoading;
  final int positionMs;
  final int durationMs;
  final double speed;
  final String? errorMessage;

  /// Retorna o progresso normalizado no intervalo [0.0..1.0].
  double get progress {
    if (durationMs <= 0) return 0.0;
    return (positionMs / durationMs).clamp(0.0, 1.0);
  }

  AudioPlaybackState copyWith({
    bool? isPlaying,
    bool? isCompleted,
    bool? isLoading,
    int? positionMs,
    int? durationMs,
    double? speed,
    String? Function()? errorMessage,
  }) {
    return AudioPlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      speed: speed ?? this.speed,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioPlaybackState &&
          runtimeType == other.runtimeType &&
          isPlaying == other.isPlaying &&
          isCompleted == other.isCompleted &&
          isLoading == other.isLoading &&
          positionMs == other.positionMs &&
          durationMs == other.durationMs &&
          speed == other.speed &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        isPlaying,
        isCompleted,
        isLoading,
        positionMs,
        durationMs,
        speed,
        errorMessage,
      );

  @override
  String toString() =>
      'AudioPlaybackState(playing: $isPlaying, pos: ${positionMs}ms, dur: ${durationMs}ms, speed: ${speed}x)';
}
