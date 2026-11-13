import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/entities/measure_region_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';
import 'package:singersinc/features/editor/domain/repositories/editor_repository.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';

class _MockEditorRepository extends Mock implements EditorRepository {}

void main() {
  late _MockEditorRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const NormalizedRect(x: 0, y: 0, w: 0.1, h: 0.1));
  });

  setUp(() {
    mockRepository = _MockEditorRepository();
  });

  test('NormalizedRect conversão de e para pixel rect funciona com precisão', () {
    const pageSize = Size(1000, 2000);
    const screenRect = Rect.fromLTWH(100, 200, 400, 300);

    final norm = NormalizedRect.fromPixelRect(
      pixelRect: screenRect,
      pageSize: pageSize,
    );

    expect(norm.x, closeTo(0.1, 0.0001));
    expect(norm.y, closeTo(0.1, 0.0001));
    expect(norm.w, closeTo(0.4, 0.0001));
    expect(norm.h, closeTo(0.15, 0.0001));

    final backToPixels = norm.toPixelRect(pageSize);
    expect(backToPixels.left, closeTo(100, 0.1));
    expect(backToPixels.top, closeTo(200, 0.1));
    expect(backToPixels.width, closeTo(400, 0.1));
    expect(backToPixels.height, closeTo(300, 0.1));
  });

  test('EditorController adiciona compasso e atualiza estado reativo', () async {
    final container = ProviderContainer(
      overrides: [
        editorRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    const testRect = NormalizedRect(x: 0.1, y: 0.2, w: 0.3, h: 0.08);
    const createdMeasure = MeasureEntity(
      id: 'm-1',
      syncId: 'sync-1',
      measureOrder: 1,
      measureLabel: '1',
      regions: [
        MeasureRegionEntity(
          id: 'r-1',
          measureId: 'm-1',
          regionOrder: 1,
          pageNumber: 1,
          rect: testRect,
        ),
      ],
    );

    when(() => mockRepository.getMeasures('sync-1'))
        .thenAnswer((_) async => const Success([]));
    when(() => mockRepository.addMeasureWithRegion(
          syncId: any(named: 'syncId'),
          pageNumber: any(named: 'pageNumber'),
          rect: any(named: 'rect'),
          measureLabel: any(named: 'measureLabel'),
        )).thenAnswer((_) async => const Success(createdMeasure));

    final controller = container.read(editorControllerProvider.notifier);

    // Carrega compassos
    await controller.loadMeasures('sync-1');
    expect(container.read(editorControllerProvider).measures, isEmpty);

    // Adiciona novo compasso
    final success = await controller.addMeasureFromRect(
      pageNumber: 1,
      rect: testRect,
    );

    expect(success, isTrue);
    final state = container.read(editorControllerProvider);
    expect(state.measures, hasLength(1));
    expect(state.measures.first.id, 'm-1');
    expect(state.selectedMeasureId, 'm-1');
  });
}
