import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/services/audio_player_service.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';

class _MockAudioPlayerService extends Mock implements AudioPlayerService {}

void main() {
  late _MockAudioPlayerService mockAudioService;
  late StreamController<int> positionController;
  late StreamController<int?> durationController;
  late StreamController<bool> isPlayingController;
  late StreamController<bool> isCompletedController;

  setUp(() {
    mockAudioService = _MockAudioPlayerService();
    positionController = StreamController<int>.broadcast();
    durationController = StreamController<int?>.broadcast();
    isPlayingController = StreamController<bool>.broadcast();
    isCompletedController = StreamController<bool>.broadcast();

    when(() => mockAudioService.positionMsStream)
        .thenAnswer((_) => positionController.stream);
    when(() => mockAudioService.durationMsStream)
        .thenAnswer((_) => durationController.stream);
    when(() => mockAudioService.isPlayingStream)
        .thenAnswer((_) => isPlayingController.stream);
    when(() => mockAudioService.isCompletedStream)
        .thenAnswer((_) => isCompletedController.stream);
    when(() => mockAudioService.speed).thenReturn(1.0);
    when(() => mockAudioService.isPlaying).thenReturn(false);
    when(() => mockAudioService.positionMs).thenReturn(0);
    when(() => mockAudioService.durationMs).thenReturn(180000);
  });

  tearDown(() async {
    await positionController.close();
    await durationController.close();
    await isPlayingController.close();
    await isCompletedController.close();
  });

  test('AudioPlaybackController carrega áudio e sincroniza streams corretamente',
      () async {
    when(() => mockAudioService.loadFile(any()))
        .thenAnswer((_) async => 180000);
    when(() => mockAudioService.play()).thenAnswer((_) async {});
    when(() => mockAudioService.pause()).thenAnswer((_) async {});
    when(() => mockAudioService.seek(any())).thenAnswer((_) async {});
    when(() => mockAudioService.setSpeed(any())).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        audioPlayerServiceProvider.overrideWithValue(mockAudioService),
      ],
    );
    addTearDown(container.dispose);

    // Mantém o provider ativo durante o teste (AutoDispose)
    final sub = container.listen(
      audioPlaybackControllerProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(sub.close);

    final controller =
        container.read(audioPlaybackControllerProvider.notifier);

    expect(container.read(audioPlaybackControllerProvider).isPlaying, isFalse);
    expect(container.read(audioPlaybackControllerProvider).durationMs, 0);

    // Carrega arquivo de áudio
    await controller.loadAudio('C:/audio.mp3', fallbackDurationMs: 180000);

    expect(
      container.read(audioPlaybackControllerProvider).durationMs,
      180000,
    );

    // Emite nova posição no stream
    positionController.add(45000);
    await pumpEventQueue();

    expect(
      container.read(audioPlaybackControllerProvider).positionMs,
      45000,
    );
    expect(
      container.read(audioPlaybackControllerProvider).progress,
      closeTo(0.25, 0.001),
    );

    // Emite mudança de reprodução
    isPlayingController.add(true);
    await pumpEventQueue();

    expect(
      container.read(audioPlaybackControllerProvider).isPlaying,
      isTrue,
    );

    // Testa alteração de velocidade
    await controller.setSpeed(1.5);
    verify(() => mockAudioService.setSpeed(1.5)).called(1);
    expect(container.read(audioPlaybackControllerProvider).speed, 1.5);

    // Testa seek relativo (+5000ms)
    await controller.seekRelative(5000);
    verify(() => mockAudioService.seek(50000)).called(1);
    expect(
      container.read(audioPlaybackControllerProvider).positionMs,
      50000,
    );
  });
}
