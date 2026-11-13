import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';

/// Contrato do repositório para edição visual e persistência dos compassos da partitura.
abstract interface class EditorRepository {
  /// Busca todos os compassos ordenados de uma versão de sincronização com suas regiões visuais.
  Future<Result<List<MeasureEntity>>> getMeasures(String syncId);

  /// Cria um novo compasso no final da lista associado a uma região retangular desenhada.
  Future<Result<MeasureEntity>> addMeasureWithRegion({
    required String syncId,
    required int pageNumber,
    required NormalizedRect rect,
    String? measureLabel,
  });

  /// Adiciona uma nova região visual a um compasso existente (ex.: quando o compasso quebra de linha).
  Future<Result<void>> addRegionToMeasure({
    required String measureId,
    required int pageNumber,
    required NormalizedRect rect,
  });

  /// Atualiza as coordenadas normalizadas de uma região retangular existente.
  Future<Result<void>> updateRegionRect({
    required String regionId,
    required NormalizedRect newRect,
  });

  /// Atualiza o rótulo textual de um compasso (ex.: "1a", "2b").
  Future<Result<void>> updateMeasureLabel({
    required String measureId,
    required String newLabel,
  });

  /// Remove um compasso e todas as suas regiões visuais vinculadas.
  Future<Result<void>> deleteMeasure(String measureId);

  /// Remove uma região específica de um compasso.
  Future<Result<void>> deleteRegion(String regionId);

  /// Reorganiza a ordem linear dos compassos na partitura.
  Future<Result<void>> reorderMeasures({
    required String syncId,
    required List<String> orderedMeasureIds,
  });
}

