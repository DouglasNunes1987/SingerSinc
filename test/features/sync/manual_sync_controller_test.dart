import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/audio_player_service.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/repositories/editor_repository.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/sync/domain/repositories/measure_sync_repository.dart';
import 'package:singersinc/features/sync/presentation/controllers/manual_sync_controller.dart';

class _MockEditorRepository extends Mock implements EditorRepository {}

class _MockMeasureSyncRepository extends Mock implements MeasureSyncRepository {}

class _MockAudioPlayerService extends Mock implements AudioPlayerService {}

void main() {
  late _MockEditorRepository mockEditorRepo;
  late _MockMeasureSyncRepository mockSyncRepo;
  late _MockAudioPlayerService mockAudioService;

  final testMeasures = [
    const MeasureEntity(
      id: 'm-1',
      syncId: 'sync-1',
      measureOrder: 1,
      measureLabel: '1',
      startMs: 1000,
    ),
    const MeasureEntity(
      id: 'm-2',
      syncId: 'sync-1',
      measureOrder: 2,
      measureLabel: '2',
      startMs: null,
    ),
    const MeasureEntity(
      id: 'm-3',
      syncId: 'sync-1',
      measureOrder: 3,
      measureLabel: '3',
      startMs: null,
    ),
  ];

  setUp(() {
    mockEditorRepo = _MockEditorRepository();
    mockSyncRepo = _MockMeasureSyncRepository();
    mockAudioService = _MockAudioPlayerService();

    when(() => mockAudioService.positionMs).thenReturn(3500);
    when(() => mockSyncRepo.saveMeasureTimestamp(
          measureId: any(named: 'measureId'),
          startMs: any(named: 'startMs'),
        )).thenAnswer((_) async => const Success(null));
    when(() => mockSyncRepo.clearMeasureTimestamp(any()))
        .thenAnswer((_) async => const Success(null));
  });

  test('ManualSyncController marca tempo com precisão e avança para próximo compasso', () async {
    when(() => mockEditorRepo.getMeasures('sync-1'))
        .thenAnswer((_) async => Success(testMeasures));

    final container = ProviderContainer(
      overrides: [
        editorRepositoryProvider.overrideWithValue(mockEditorRepo),
        measureSyncRepositoryProvider.overrideWithValue(mockSyncRepo),
        audioPlayerServiceProvider.overrideWithValue(mockAudioService),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(manualSyncControllerProvider.notifier);

    // Inicializa: deve focar no primeiro compasso não sincronizado (m-2, índice 1)
    await controller.initialize(syncId: 'sync-1', audioDurationMs: 60000);
    expect(container.read(manualSyncControllerProvider).focusedIndex, 1);
    expect(container.read(manualSyncControllerProvider).focusedMeasure?.id, 'm-2');

    // Marca o compasso 2: posição do áudio é 3500ms
    await controller.markCurrentMeasure();

    final state = container.read(manualSyncControllerProvider);
    expect(state.measures[1].startMs, 3500);
    // Deve avançar para o compasso 3 (índice 2)
    expect(state.focusedIndex, 2);
    expect(state.focusedMeasure?.id, 'm-3');

    verify(() => mockSyncRepo.saveMeasureTimestamp(
          measureId: 'm-2',
          startMs: 3500,
        )).called(1);
  });
}

