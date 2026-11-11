import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/utils/validators.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para cadastrar uma nova música com partitura PDF e áudio MP3.
class CreateSongUseCase {
  const CreateSongUseCase(this._repository);

  final SongsRepository _repository;

  Future<Result<SongLibraryItem>> call({
    required String userId,
    required String title,
    required String pdfSourcePath,
    required String audioSourcePath,
  }) async {
    if (userId.trim().isEmpty) {
      return const Err(ValidationFailure('Usuário não identificado.'));
    }

    final titleError = Validators.validateSongTitle(title);
    if (titleError != null) {
      return Err(ValidationFailure(titleError));
    }

    final cleanPdf = pdfSourcePath.trim();
    if (cleanPdf.isEmpty || !cleanPdf.toLowerCase().endsWith('.pdf')) {
      return const Err(
        ValidationFailure('Selecione um arquivo de partitura válido (.pdf).'),
      );
    }

    final cleanAudio = audioSourcePath.trim();
    if (cleanAudio.isEmpty || !cleanAudio.toLowerCase().endsWith('.mp3')) {
      return const Err(
        ValidationFailure('Selecione um arquivo de áudio válido (.mp3).'),
      );
    }

    return _repository.createSong(
      userId: userId.trim(),
      title: title.trim(),
      pdfSourcePath: cleanPdf,
      audioSourcePath: cleanAudio,
    );
  }
}

