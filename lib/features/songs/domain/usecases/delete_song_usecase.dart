import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para excluir uma música e seus arquivos vinculados.
class DeleteSongUseCase {
  const DeleteSongUseCase(this._repository);

  final SongsRepository _repository;

  Future<Result<void>> call({
    required String userId,
    required String songId,
  }) async {
    if (songId.trim().isEmpty) {
      return const Err(ValidationFailure('Identificador da música inválido.'));
    }

    return _repository.deleteSong(
      userId: userId.trim(),
      songId: songId.trim(),
    );
  }
}

