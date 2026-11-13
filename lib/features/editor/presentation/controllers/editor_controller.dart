import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/editor/data/datasources/editor_local_datasource.dart';
import 'package:singersinc/features/editor/data/repositories/editor_repository_impl.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';
import 'package:singersinc/features/editor/domain/repositories/editor_repository.dart';

/// Provedores da feature `editor`.
final editorLocalDataSourceProvider = Provider<EditorLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return EditorLocalDataSource(db);
});

final editorRepositoryProvider = Provider<EditorRepository>((ref) {
  final ds = ref.watch(editorLocalDataSourceProvider);
  return EditorRepositoryImpl(ds);
});

/// Modos de operação do editor de partitura.
enum EditorMode {
  /// Modo de visualização e navegação normal (permite zoom e pan livre).
  view,

  /// Modo de desenho: arrastar o dedo/mouse cria um novo compasso retangular.
  draw,

  /// Modo de seleção: tocar em um compasso existente para ajustar, renomear ou excluir.
  select,

  /// Modo de adicionar região adicional ao compasso já selecionado (quebra de linha).
  addRegion,
}

/// Estado reativo do editor de partitura.
class EditorState {
  const EditorState({
    this.isLoading = false,
    this.syncId = '',
    this.measures = const [],
    this.mode = EditorMode.draw,
    this.selectedMeasureId,
    this.selectedRegionId,
    this.activePageNumber = 1,
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final String syncId;
  final List<MeasureEntity> measures;
  final EditorMode mode;
  final String? selectedMeasureId;
  final String? selectedRegionId;
  final int activePageNumber;
  final String? errorMessage;
  final String? successMessage;

  MeasureEntity? get selectedMeasure =>
      measures.where((m) => m.id == selectedMeasureId).firstOrNull;

  EditorState copyWith({
    bool? isLoading,
    String? syncId,
    List<MeasureEntity>? measures,
    EditorMode? mode,
    String? Function()? selectedMeasureId,
    String? Function()? selectedRegionId,
    int? activePageNumber,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return EditorState(
      isLoading: isLoading ?? this.isLoading,
      syncId: syncId ?? this.syncId,
      measures: measures ?? this.measures,
      mode: mode ?? this.mode,
      selectedMeasureId: selectedMeasureId != null
          ? selectedMeasureId()
          : this.selectedMeasureId,
      selectedRegionId: selectedRegionId != null
          ? selectedRegionId()
          : this.selectedRegionId,
      activePageNumber: activePageNumber ?? this.activePageNumber,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
    );
  }
}

/// Controller responsável pela lógica de manipulação e delimitação de compassos.
class EditorController extends AutoDisposeNotifier<EditorState> {
  EditorRepository get _repository => ref.read(editorRepositoryProvider);

  @override
  EditorState build() {
    return const EditorState();
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      successMessage: () => null,
    );
  }

  void setMode(EditorMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setActivePage(int page) {
    state = state.copyWith(activePageNumber: page);
  }

  void selectMeasure(String? measureId) {
    state = state.copyWith(
      selectedMeasureId: () => measureId,
      selectedRegionId: () => null,
      mode: measureId != null ? EditorMode.select : state.mode,
    );
  }

  /// Carrega todos os compassos da versão de sincronização.
  Future<void> loadMeasures(String syncId) async {
    state = state.copyWith(
      isLoading: true,
      syncId: syncId,
      errorMessage: () => null,
    );

    final result = await _repository.getMeasures(syncId);

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      onSuccess: (List<MeasureEntity> list) {
        state = state.copyWith(
          isLoading: false,
          measures: list,
        );
      },
    );
  }

  /// Adiciona um novo compasso a partir do retângulo desenhado pelo professor.
  Future<bool> addMeasureFromRect({
    required int pageNumber,
    required NormalizedRect rect,
    String? customLabel,
  }) async {
    if (state.syncId.isEmpty) return false;

    final result = await _repository.addMeasureWithRegion(
      syncId: state.syncId,
      pageNumber: pageNumber,
      rect: rect,
      measureLabel: customLabel,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(errorMessage: () => failure.message);
        return false;
      },
      onSuccess: (MeasureEntity created) {
        final updatedList = [...state.measures, created];
        state = state.copyWith(
          measures: updatedList,
          selectedMeasureId: () => created.id,
          successMessage: () => 'Compasso ${created.displayLabel} delimitado!',
        );
        return true;
      },
    );
  }

  /// Adiciona uma região adicional ao compasso atualmente selecionado (quebra de linha).
  Future<bool> addRegionToSelectedMeasure({
    required int pageNumber,
    required NormalizedRect rect,
  }) async {
    final selectedId = state.selectedMeasureId;
    if (selectedId == null) return false;

    final result = await _repository.addRegionToMeasure(
      measureId: selectedId,
      pageNumber: pageNumber,
      rect: rect,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(errorMessage: () => failure.message);
        return false;
      },
      onSuccess: (_) async {
        await loadMeasures(state.syncId);
        state = state.copyWith(
          mode: EditorMode.select,
          successMessage: () => 'Região adicional vinculada ao compasso!',
        );
        return true;
      },
    );
  }

  /// Atualiza o rótulo do compasso.
  Future<void> updateMeasureLabel({
    required String measureId,
    required String newLabel,
  }) async {
    final result = await _repository.updateMeasureLabel(
      measureId: measureId,
      newLabel: newLabel,
    );

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(errorMessage: () => failure.message);
      },
      onSuccess: (_) {
        final updatedList = state.measures.map((m) {
          if (m.id == measureId) {
            return m.copyWith(measureLabel: newLabel.trim());
          }
          return m;
        }).toList();
        state = state.copyWith(
          measures: updatedList,
          successMessage: () => 'Rótulo do compasso atualizado!',
        );
      },
    );
  }

  /// Atualiza o retângulo de uma região existente.
  Future<void> updateRegionCoordinates({
    required String regionId,
    required NormalizedRect newRect,
  }) async {
    final result = await _repository.updateRegionRect(
      regionId: regionId,
      newRect: newRect,
    );

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(errorMessage: () => failure.message);
      },
      onSuccess: (_) {
        final updatedMeasures = state.measures.map((m) {
          final updatedRegions = m.regions.map((r) {
            if (r.id == regionId) {
              return r.copyWith(rect: newRect);
            }
            return r;
          }).toList();
          return m.copyWith(regions: updatedRegions);
        }).toList();

        state = state.copyWith(measures: updatedMeasures);
      },
    );
  }

  /// Exclui o compasso selecionado.
  Future<void> deleteMeasure(String measureId) async {
    final result = await _repository.deleteMeasure(measureId);

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(errorMessage: () => failure.message);
      },
      onSuccess: (_) async {
        state = state.copyWith(
          selectedMeasureId: () => null,
          selectedRegionId: () => null,
          successMessage: () => 'Compasso removido.',
        );
        await loadMeasures(state.syncId);
      },
    );
  }
}

final editorControllerProvider =
    AutoDisposeNotifierProvider<EditorController, EditorState>(
  EditorController.new,
);

