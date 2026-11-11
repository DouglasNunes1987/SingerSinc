import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';

/// Caso de uso para observar reativamente a biblioteca de músicas local.
class WatchUserSongsUseCase {
  const WatchUserSongsUseCase(this._repository);

  final SongsRepository _repository;

  Stream<List<SongLibraryItem>> call(String userId) {
    return _repository.watchUserSongs(userId);
  }
}

