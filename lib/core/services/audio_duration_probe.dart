import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Interface desacoplada para inspeção da duração em milissegundos de um arquivo de áudio.
/// Evita que a camada de domínio ou repositório dependa diretamente do plugin `just_audio`.
abstract interface class AudioDurationProbe {
  /// Retorna a duração do arquivo de áudio em milissegundos (> 0).
  Future<int> getAudioDurationMs(String absoluteFilePath);
}

/// Implementação concreta utilizando `AudioPlayer` do `just_audio`.
class JustAudioDurationProbe implements AudioDurationProbe {
  const JustAudioDurationProbe();

  @override
  Future<int> getAudioDurationMs(String absoluteFilePath) async {
    final player = AudioPlayer();
    try {
      final duration = await player.setFilePath(absoluteFilePath);
      final ms = duration?.inMilliseconds ?? player.duration?.inMilliseconds;
      if (ms != null && ms > 0) {
        return ms;
      }
      // Fallback seguro caso o cabeçalho MP3 VBR não informe duração imediata
      return 180000;
    } finally {
      await player.dispose();
    }
  }
}

final audioDurationProbeProvider = Provider<AudioDurationProbe>((ref) {
  return const JustAudioDurationProbe();
});

