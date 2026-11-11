import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/audio_duration_probe.dart';
import 'package:singersinc/core/services/supabase_provider.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:singersinc/features/songs/data/datasources/songs_local_datasource.dart';
import 'package:singersinc/features/songs/data/datasources/songs_remote_datasource.dart';
import 'package:singersinc/features/songs/data/repositories/songs_repository_impl.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';
import 'package:singersinc/features/songs/domain/usecases/create_song_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/delete_song_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/replace_song_asset_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/sync_pending_songs_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/update_song_title_usecase.dart';
import 'package:singersinc/features/songs/domain/usecases/watch_user_songs_usecase.dart';

/// Providers de Injeção de Dependência da feature `songs`.
final songsLocalDataSourceProvider = Provider<SongsLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SongsLocalDataSource(db);
});

final songsRemoteDataSourceProvider = Provider<SongsRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSongsRemoteDataSource(client);
});

final songsRepositoryProvider = Provider<SongsRepository>((ref) {
  return SongsRepositoryImpl(
    localDataSource: ref.watch(songsLocalDataSourceProvider),
    remoteDataSource: ref.watch(songsRemoteDataSourceProvider),
    fileStorage: ref.watch(localFileStorageProvider),
    audioDurationProbe: ref.watch(audioDurationProbeProvider),
  );
});

final watchUserSongsUseCaseProvider = Provider<WatchUserSongsUseCase>((ref) {
  return WatchUserSongsUseCase(ref.watch(songsRepositoryProvider));
});

final createSongUseCaseProvider = Provider<CreateSongUseCase>((ref) {
  return CreateSongUseCase(ref.watch(songsRepositoryProvider));
});

final updateSongTitleUseCaseProvider = Provider<UpdateSongTitleUseCase>((ref) {
  return UpdateSongTitleUseCase(ref.watch(songsRepositoryProvider));
});

final replaceSongAssetUseCaseProvider =
    Provider<ReplaceSongAssetUseCase>((ref) {
  return ReplaceSongAssetUseCase(ref.watch(songsRepositoryProvider));
});

final deleteSongUseCaseProvider = Provider<DeleteSongUseCase>((ref) {
  return DeleteSongUseCase(ref.watch(songsRepositoryProvider));
});

final syncPendingSongsUseCaseProvider =
    Provider<SyncPendingSongsUseCase>((ref) {
  return SyncPendingSongsUseCase(ref.watch(songsRepositoryProvider));
});

/// StreamProvider reativo que observa todas as músicas do usuário autenticado
/// diretamente a partir do banco local SQLite.
final userSongsStreamProvider = StreamProvider<List<SongLibraryItem>>((ref) {
  final userId = ref.watch(
    authControllerProvider.select((state) => state.user?.id),
  );
  if (userId == null || userId.isEmpty) {
    return Stream.value(const <SongLibraryItem>[]);
  }
  return ref.watch(watchUserSongsUseCaseProvider)(userId);
});

/// Estado de ações da Biblioteca de Músicas (carregamento, sincronização, feedback).
class SongsActionState {
  const SongsActionState({
    this.isBusy = false,
    this.isSyncing = false,
    this.errorMessage,
    this.successMessage,
  });

  final bool isBusy;
  final bool isSyncing;
  final String? errorMessage;
  final String? successMessage;

  SongsActionState copyWith({
    bool? isBusy,
    bool? isSyncing,
    String? Function()? errorMessage,
    String? Function()? successMessage,
  }) {
    return SongsActionState(
      isBusy: isBusy ?? this.isBusy,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
    );
  }
}

/// Controller (Notifier) responsável pelas operações de criação, edição,
/// substituição de arquivos, exclusão e sincronização na Biblioteca de Músicas.
class SongsController extends Notifier<SongsActionState> {
  @override
  SongsActionState build() {
    return const SongsActionState();
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      successMessage: () => null,
    );
  }

  Future<bool> createSong({
    required String title,
    required String pdfSourcePath,
    required String audioSourcePath,
  }) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) {
      state = state.copyWith(
        errorMessage: () => 'Sessão expirada. Faça login novamente.',
      );
      return false;
    }

    state = state.copyWith(
      isBusy: true,
      errorMessage: () => null,
      successMessage: () => null,
    );

    final result = await ref.read(createSongUseCaseProvider)(
      userId: userId,
      title: title,
      pdfSourcePath: pdfSourcePath,
      audioSourcePath: audioSourcePath,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isBusy: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (_) {
        state = state.copyWith(
          isBusy: false,
          successMessage: () => 'Música cadastrada e disponível offline!',
        );
        return true;
      },
    );
  }

  Future<bool> updateTitle({
    required String songId,
    required String newTitle,
  }) async {
    state = state.copyWith(
      isBusy: true,
      errorMessage: () => null,
      successMessage: () => null,
    );

    final result = await ref.read(updateSongTitleUseCaseProvider)(
      songId: songId,
      newTitle: newTitle,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isBusy: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (_) {
        state = state.copyWith(
          isBusy: false,
          successMessage: () => 'Título atualizado com sucesso!',
        );
        return true;
      },
    );
  }

  Future<bool> replaceAsset({
    required String songId,
    required AssetType assetType,
    required String newSourceFilePath,
  }) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return false;

    state = state.copyWith(
      isBusy: true,
      errorMessage: () => null,
      successMessage: () => null,
    );

    final result = await ref.read(replaceSongAssetUseCaseProvider)(
      userId: userId,
      songId: songId,
      assetType: assetType,
      newSourceFilePath: newSourceFilePath,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isBusy: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (_) {
        final label = assetType == AssetType.pdf ? 'Partitura PDF' : 'Áudio MP3';
        state = state.copyWith(
          isBusy: false,
          successMessage: () => '$label atualizado com nova revisão!',
        );
        return true;
      },
    );
  }

  Future<bool> deleteSong(String songId) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return false;

    state = state.copyWith(
      isBusy: true,
      errorMessage: () => null,
      successMessage: () => null,
    );

    final result = await ref.read(deleteSongUseCaseProvider)(
      userId: userId,
      songId: songId,
    );

    return result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isBusy: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
      onSuccess: (_) {
        state = state.copyWith(
          isBusy: false,
          successMessage: () => 'Música excluída.',
        );
        return true;
      },
    );
  }

  Future<void> syncNow() async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null || state.isSyncing) return;

    state = state.copyWith(
      isSyncing: true,
      errorMessage: () => null,
      successMessage: () => null,
    );

    final result = await ref.read(syncPendingSongsUseCaseProvider)(userId);

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          isSyncing: false,
          errorMessage: () => failure.message,
        );
      },
      onSuccess: (int count) {
        state = state.copyWith(
          isSyncing: false,
          successMessage: () => count > 0
              ? '$count música(s) sincronizada(s) com a nuvem!'
              : 'Sincronização verificada.',
        );
      },
    );
  }
}

final songsControllerProvider =
    NotifierProvider<SongsController, SongsActionState>(SongsController.new);

