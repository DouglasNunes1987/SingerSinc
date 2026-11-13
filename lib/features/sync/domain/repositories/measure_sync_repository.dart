import 'package:singersinc/core/errors/failure.dart';

/// Contrato para persistência e manipulação dos timestamps dos compassos (Etapa 5).
abstract interface class MeasureSyncRepository {
  /// Registra o timestamp inicial (em milissegundos) de um compasso.
  Future<Result<void>> saveMeasureTimestamp({
    required String measureId,
    required int startMs,
  });

  /// Remove o timestamp registrado de um compasso (tornando-o nulo).
  Future<Result<void>> clearMeasureTimestamp(String measureId);

  /// Desloca (em lote) os timestamps de todos os compassos a partir de uma determinada ordem
  /// aplicando uma compensação de milissegundos (deltaMs positivo ou negativo).
  Future<Result<void>> shiftSubsequentTimestamps({
    required String syncId,
    required int fromMeasureOrder,
    required int deltaMs,
    required int audioDurationMs,
  });

  /// Salva em lote um mapa de timestamps {measureId: startMs}.
  Future<Result<void>> saveBatchTimestamps({
    required String syncId,
    required Map<String, int> timestamps,
  });
}

