import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para disparar a sincronização das músicas e arquivos pendentes
/// com o Supabase Cloud.
class SyncPendingSongsUseCase {
  const SyncPendingSongsUseCase(this._repository);

  final SongsRepository _repository;

  Future<Result<int>> call(String userId) {
    return _repository.syncPendingSongs(userId);
  }
}

