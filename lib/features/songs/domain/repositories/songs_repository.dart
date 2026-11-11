import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';

/// Contrato (interface) do repositório de músicas na camada de Domínio.
abstract interface class SongsRepository {
  /// Observa reativamente todas as músicas ativas do usuário a partir do SQLite local.
  Stream<List<SongLibraryItem>> watchUserSongs(String userId);

  /// Cadastra uma nova música importando o PDF e o MP3 localmente e enfileirando
  /// o envio para a nuvem.
  Future<Result<SongLibraryItem>> createSong({
    required String userId,
    required String title,
    required String pdfSourcePath,
    required String audioSourcePath,
  });

  /// Atualiza o título de uma música existente.
  Future<Result<void>> updateSongTitle({
    required String songId,
    required String newTitle,
  });

  /// Substitui o arquivo PDF ou MP3 de uma música, gerando nova revisão e
  /// nova versão de sincronização (clonando compassos caso apenas o áudio mude).
  Future<Result<void>> replaceSongAsset({
    required String userId,
    required String songId,
    required AssetType assetType,
    required String newSourceFilePath,
  });

  /// Exclui uma música (removendo arquivos locais e sincronizando a exclusão).
  Future<Result<void>> deleteSong({
    required String userId,
    required String songId,
  });

  /// Executa a sincronização de envio/recebimento de músicas e arquivos pendentes com o Supabase.
  Future<Result<int>> syncPendingSongs(String userId);
}

