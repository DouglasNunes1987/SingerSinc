import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';

/// Caso de uso que identifica o compasso ativo na partitura utilizando busca binária O(log N)
/// sobre os tempos registrados (start_ms).
class FindActiveMeasureUseCase {
  const FindActiveMeasureUseCase();

  /// Encontra o compasso ativo para a posição atual de reprodução do áudio (em milissegundos).
  ///
  /// Retorna `null` caso a reprodução esteja antes do início do primeiro compasso
  /// (por exemplo, durante uma introdução instrumental).
  MeasureEntity? call({
    required List<MeasureEntity> measures,
    required int currentPositionMs,
  }) {
    if (measures.isEmpty) return null;

    // Filtra apenas compassos que possuem timestamp registrado e os ordena por startMs
    final syncedMeasures = measures
        .where((m) => m.startMs != null)
        .toList()
      ..sort((a, b) => a.startMs!.compareTo(b.startMs!));

    if (syncedMeasures.isEmpty) return null;

    // Se o áudio ainda está antes do primeiro compasso
    if (currentPositionMs < syncedMeasures.first.startMs!) {
      return null;
    }

    // Busca binária para encontrar o maior startMs <= currentPositionMs
    var low = 0;
    var high = syncedMeasures.length - 1;
    var resultIndex = -1;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final midStart = syncedMeasures[mid].startMs!;

      if (midStart <= currentPositionMs) {
        resultIndex = mid; // Candidato encontrado, tenta buscar um compasso mais à frente
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    if (resultIndex != -1) {
      return syncedMeasures[resultIndex];
    }

    return null;
  }
}

