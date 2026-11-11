import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para substituir o PDF ou MP3 de uma música existente,
/// preservando os compassos desenhados caso apenas o áudio seja substituído.
class ReplaceSongAssetUseCase {
  const ReplaceSongAssetUseCase(this._repository);

  final SongsRepository _repository;

  Future<Result<void>> call({
    required String userId,
    required String songId,
    required AssetType assetType,
    required String newSourceFilePath,
  }) async {
    final cleanPath = newSourceFilePath.trim();
    if (cleanPath.isEmpty) {
      return const Err(ValidationFailure('Selecione um arquivo válido.'));
    }

    if (assetType == AssetType.pdf &&
        !cleanPath.toLowerCase().endsWith('.pdf')) {
      return const Err(
        ValidationFailure('O arquivo selecionado deve estar no formato .pdf.'),
      );
    }

    if (assetType == AssetType.audio &&
        !cleanPath.toLowerCase().endsWith('.mp3')) {
      return const Err(
        ValidationFailure('O arquivo selecionado deve estar no formato .mp3.'),
      );
    }

    return _repository.replaceSongAsset(
      userId: userId.trim(),
      songId: songId.trim(),
      assetType: assetType,
      newSourceFilePath: cleanPath,
    );
  }
}

