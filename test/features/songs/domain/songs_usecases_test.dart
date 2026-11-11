import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';
import 'package:singersinc/features/songs/domain/usecases/create_song_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/replace_song_asset_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/update_song_title_usecase.dart';

class _MockSongsRepository extends Mock implements SongsRepository {}

void main() {
  late _MockSongsRepository mockRepository;
  late CreateSongUseCase createSongUseCase;
  late UpdateSongTitleUseCase updateSongTitleUseCase;
  late ReplaceSongAssetUseCase replaceSongAssetUseCase;

  setUp(() {
    mockRepository = _MockSongsRepository();
    createSongUseCase = CreateSongUseCase(mockRepository);
    updateSongTitleUseCase = UpdateSongTitleUseCase(mockRepository);
    replaceSongAssetUseCase = ReplaceSongAssetUseCase(mockRepository);
  });

  group('CreateSongUseCase', () {
    test('deve rejeitar título vazio', () async {
      final result = await createSongUseCase(
        userId: 'user-1',
        title: '   ',
        pdfSourcePath: 'C:/partitura.pdf',
        audioSourcePath: 'C:/audio.mp3',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('deve rejeitar arquivo de partitura que não seja .pdf', () async {
      final result = await createSongUseCase(
        userId: 'user-1',
        title: 'Estudo 1',
        pdfSourcePath: 'C:/imagem.png',
        audioSourcePath: 'C:/audio.mp3',
      );

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull?.message,
        contains('partitura válido (.pdf)'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('deve rejeitar arquivo de áudio que não seja .mp3', () async {
      final result = await createSongUseCase(
        userId: 'user-1',
        title: 'Estudo 1',
        pdfSourcePath: 'C:/partitura.pdf',
        audioSourcePath: 'C:/audio.wav',
      );

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull?.message,
        contains('áudio válido (.mp3)'),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('deve delegar ao repositório quando todos os parâmetros forem válidos',
        () async {
      final fakeItem = SongLibraryItem(
        id: 'song-1',
        userId: 'user-1',
        title: 'Estudo 1',
        version: 1,
        syncStatus: 'pending',
        createdAt: DateTime(2026, 11, 6),
        updatedAt: DateTime(2026, 11, 6),
      );

      when(
        () => mockRepository.createSong(
          userId: 'user-1',
          title: 'Estudo 1',
          pdfSourcePath: 'C:/partitura.pdf',
          audioSourcePath: 'C:/audio.mp3',
        ),
      ).thenAnswer((_) async => Success(fakeItem));

      final result = await createSongUseCase(
        userId: 'user-1',
        title: '  Estudo 1  ',
        pdfSourcePath: 'C:/partitura.pdf',
        audioSourcePath: 'C:/audio.mp3',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.title, 'Estudo 1');
    });
  });

  group('UpdateSongTitleUseCase & ReplaceSongAssetUseCase', () {
    test('deve validar extensão ao substituir arquivo de áudio', () async {
      final result = await replaceSongAssetUseCase(
        userId: 'user-1',
        songId: 'song-1',
        assetType: AssetType.audio,
        newSourceFilePath: 'C:/partitura.pdf',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('deve atualizar título quando válido', () async {
      when(
        () => mockRepository.updateSongTitle(
          songId: 'song-1',
          newTitle: 'Novo Título',
        ),
      ).thenAnswer((_) async => const Success(null));

      final result = await updateSongTitleUseCase(
        songId: 'song-1',
        newTitle: 'Novo Título',
      );

      expect(result.isSuccess, isTrue);
    });
  });
}

