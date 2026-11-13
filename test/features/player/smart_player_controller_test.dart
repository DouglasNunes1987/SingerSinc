import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/audio_player_service.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/repositories/editor_repository.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/player/presentation/controllers/smart_player_controller.dart';

class _MockEditorRepository extends Mock implements EditorRepository {}

class _MockAudioPlayerService extends Mock implements AudioPlayerService {}

void main() {
  late _MockEditorRepository mockEditorRepo;
  late _MockAudioPlayerService mockAudioService;

  final testMeasures = [
    const MeasureEntity(
      id: 'm-1',
      syncId: 'sync-1',
      measureOrder: 1,
      measureLabel: '1',
      startMs: 2000,
    ),
    const MeasureEntity(
      id: 'm-2',
      syncId: 'sync-1',
      measureOrder: 2,
      measureLabel: '2',
      startMs: 5000,
    ),
    const MeasureEntity(
      id: 'm-3',
      syncId: 'sync-1',
      measureOrder: 3,
      measureLabel: '3',
      startMs: 8000,
    ),
  ];

  setUp(() {
    mockEditorRepo = _MockEditorRepository();
    mockAudioService = _MockAudioPlayerService();

    when(() => mockAudioService.positionMsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.durationMsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.isPlayingStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.isCompletedStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.speed).thenReturn(1.0);
    when(() => mockAudioService.isPlaying).thenReturn(false);
    when(() => mockAudioService.positionMs).thenReturn(0);
    when(() => mockAudioService.durationMs).thenReturn(60000);
    when(() => mockAudioService.seek(any())).thenAnswer((_) async {});
  });

  test('SmartPlayerController identifica compasso ativo e executa saltos de reprodução', () async {
    when(() => mockEditorRepo.getMeasures('sync-1'))
        .thenAnswer((_) async => Success(testMeasures));

    final container = ProviderContainer(
      overrides: [
        editorRepositoryProvider.overrideWithValue(mockEditorRepo),
        audioPlayerServiceProvider.overrideWithValue(mockAudioService),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(smartPlayerControllerProvider.notifier);

    // Inicializa: carrega compassos
    await controller.initialize('sync-1');
    expect(container.read(smartPlayerControllerProvider).measures, hasLength(3));
    // No instante 0ms (antes do compasso 1 que começa em 2000ms), compasso ativo deve ser nulo
    expect(container.read(smartPlayerControllerProvider).activeMeasure, isNull);

    // Salto para o compasso 2 (startMs: 5000)
    await controller.seekToMeasure('m-2');
    verify(() => mockAudioService.seek(5000)).called(1);

    // Próximo compasso (compasso 3, startMs: 8000)
    await controller.seekToMeasure('m-2'); // garante que o mock registre a busca
    controller.toggleLoopCurrentMeasure();
    expect(container.read(smartPlayerControllerProvider).isLoopingCurrentMeasure, isTrue);
  });
}

