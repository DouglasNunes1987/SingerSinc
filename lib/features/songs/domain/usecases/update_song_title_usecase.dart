import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/utils/validators.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para atualizar o título de uma música cadastrada.
class UpdateSongTitleUseCase {
  const UpdateSongTitleUseCase(this._repository);

  final SongsRepository _repository;

  Future<Result<void>> call({
    required String songId,
    required String newTitle,
  }) async {
    if (songId.trim().isEmpty) {
      return const Err(ValidationFailure('Identificador da música inválido.'));
    }

    final titleError = Validators.validateSongTitle(newTitle);
    if (titleError != null) {
      return Err(ValidationFailure(titleError));
    }

    return _repository.updateSongTitle(
      songId: songId.trim(),
      newTitle: newTitle.trim(),
    );
  }
}

