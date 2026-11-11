import 'dart:async';

import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/core/errors/failure.dart';
import 'package:singersinc/core/services/audio_duration_probe.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/songs/data/datasources/songs_local_datasource.dart';
import 'package:singersinc/features/songs/data/datasources/songs_remote_datasource.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementação Offline-First de [SongsRepository].
///
/// Todas as operações persistem primeiro no SQLite e no diretório local do dispositivo,
/// retornando sucesso imediato para a interface, e disparam a sincronização com o
/// Supabase em segundo plano.
class SongsRepositoryImpl implements SongsRepository {
  const SongsRepositoryImpl({
    required SongsLocalDataSource localDataSource,
    required SongsRemoteDataSource remoteDataSource,
    required LocalFileStorage fileStorage,
    required AudioDurationProbe audioDurationProbe,
    Uuid uuid = const Uuid(),
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _fileStorage = fileStorage,
        _audioDurationProbe = audioDurationProbe,
        _uuid = uuid;

  final SongsLocalDataSource _localDataSource;
  final SongsRemoteDataSource _remoteDataSource;
  final LocalFileStorage _fileStorage;
  final AudioDurationProbe _audioDurationProbe;
  final Uuid _uuid;

  @override
  Stream<List<SongLibraryItem>> watchUserSongs(String userId) {
    return _localDataSource.watchUserSongs(userId);
  }

  @override
  Future<Result<SongLibraryItem>> createSong({
    required String userId,
    required String title,
    required String pdfSourcePath,
    required String audioSourcePath,
  }) async {
    try {
      final songId = _uuid.v4();
      final pdfAssetId = _uuid.v4();
      final audioAssetId = _uuid.v4();
      final syncVersionId = _uuid.v4();

      // 1. Copia o PDF para o diretório controlado pelo app e calcula SHA-256
      final storedPdf = await _fileStorage.importFile(
        sourceFilePath: pdfSourcePath,
        userId: userId,
        songId: songId,
        assetId: pdfAssetId,
        extension: '.pdf',
      );

      // 2. Copia o MP3 para o diretório controlado pelo app e calcula SHA-256
      final storedAudio = await _fileStorage.importFile(
        sourceFilePath: audioSourcePath,
        userId: userId,
        songId: songId,
        assetId: audioAssetId,
        extension: '.mp3',
      );

      // 3. Obtém a duração real do áudio em milissegundos
      final audioDurationMs = await _audioDurationProbe.getAudioDurationMs(
        storedAudio.absolutePath,
      );

      // Formato exigido na Seção 7.1 dentro de cada bucket: {user_id}/{song_id}/{asset_id}.{pdf|mp3}
      final pdfStoragePath = '$userId/$songId/$pdfAssetId.pdf';
      final audioStoragePath = '$userId/$songId/$audioAssetId.mp3';

      // 4. Persiste tudo localmente no SQLite em transação única
      final createdItem = await _localDataSource.insertSongBundle(
        songId: songId,
        userId: userId,
        title: title,
        pdfAssetId: pdfAssetId,
        pdfStoragePath: pdfStoragePath,
        pdfLocalPath: storedPdf.relativePath,
        pdfFileSize: storedPdf.fileSize,
        pdfChecksum: storedPdf.checksumSha256,
        audioAssetId: audioAssetId,
        audioStoragePath: audioStoragePath,
        audioLocalPath: storedAudio.relativePath,
        audioFileSize: storedAudio.fileSize,
        audioChecksum: storedAudio.checksumSha256,
        syncVersionId: syncVersionId,
        audioDurationMs: audioDurationMs,
      );

      // 5. Dispara sincronização em background sem bloquear o fluxo offline-first
      unawaited(syncPendingSongs(userId));

      return Success(createdItem);
    } on StorageFileException catch (e) {
      return Err(DatabaseFailure(e.message));
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(
        DatabaseFailure('Não foi possível cadastrar a música localmente.'),
      );
    }
  }

  @override
  Future<Result<void>> updateSongTitle({
    required String songId,
    required String newTitle,
  }) async {
    try {
      final song = await _localDataSource.getSongById(songId);
      if (song == null) {
        return const Err(DatabaseFailure('Música não encontrada.'));
      }

      await _localDataSource.updateSongTitle(
        songId: songId,
        newTitle: newTitle,
      );

      unawaited(syncPendingSongs(song.userId));
      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(
        DatabaseFailure('Erro ao atualizar o título da música.'),
      );
    }
  }

  @override
  Future<Result<void>> replaceSongAsset({
    required String userId,
    required String songId,
    required AssetType assetType,
    required String newSourceFilePath,
  }) async {
    try {
      final newAssetId = _uuid.v4();
      final newSyncVersionId = _uuid.v4();
      final nextRevision = await _localDataSource.getNextAssetRevision(
        songId: songId,
        assetType: assetType,
      );

      final ext = assetType == AssetType.pdf ? '.pdf' : '.mp3';
      final mimeType =
          assetType == AssetType.pdf ? 'application/pdf' : 'audio/mpeg';

      final storedFile = await _fileStorage.importFile(
        sourceFilePath: newSourceFilePath,
        userId: userId,
        songId: songId,
        assetId: newAssetId,
        extension: ext,
      );

      int? newDurationMs;
      if (assetType == AssetType.audio) {
        newDurationMs = await _audioDurationProbe.getAudioDurationMs(
          storedFile.absolutePath,
        );
      }

      final storagePath = '$userId/$songId/$newAssetId$ext';

      await _localDataSource.replaceSongAssetWithRevision(
        songId: songId,
        assetType: assetType,
        newAssetId: newAssetId,
        newRevision: nextRevision,
        storagePath: storagePath,
        localPath: storedFile.relativePath,
        mimeType: mimeType,
        fileSize: storedFile.fileSize,
        checksum: storedFile.checksumSha256,
        newSyncVersionId: newSyncVersionId,
        newAudioDurationMs: newDurationMs,
      );

      unawaited(syncPendingSongs(userId));
      return const Success(null);
    } on StorageFileException catch (e) {
      return Err(DatabaseFailure(e.message));
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(
        DatabaseFailure('Não foi possível substituir o arquivo da música.'),
      );
    }
  }

  @override
  Future<Result<void>> deleteSong({
    required String userId,
    required String songId,
  }) async {
    try {
      final bundles = await _localDataSource.getPendingSongBundles(userId);
      final matchingBundle =
          bundles.where((b) => b.song.id == songId).firstOrNull;

      await _localDataSource.deleteSong(songId);
      await _fileStorage.deleteSongDirectory(userId: userId, songId: songId);

      unawaited(
        _remoteDataSource.deleteRemoteSong(
          userId: userId,
          songId: songId,
          assets: matchingBundle?.assets ?? const [],
        ),
      );

      return const Success(null);
    } on LocalDatabaseException catch (e) {
      return Err(DatabaseFailure(e.message));
    } catch (_) {
      return const Err(DatabaseFailure('Não foi possível excluir a música.'));
    }
  }

  @override
  Future<Result<int>> syncPendingSongs(String userId) async {
    try {
      final pendingBundles =
          await _localDataSource.getPendingSongBundles(userId);
      if (pendingBundles.isEmpty) {
        return const Success(0);
      }

      var syncedCount = 0;

      for (final bundle in pendingBundles) {
        try {
          // Controle otimista de versão: verifica se outro dispositivo alterou a música
          final remoteVersion =
              await _remoteDataSource.fetchRemoteSongVersion(bundle.song.id);
          if (remoteVersion != null &&
              bundle.song.baseVersion > 0 &&
              remoteVersion > bundle.song.baseVersion) {
            await _localDataSource.markSongConflict(bundle.song.id);
            continue;
          }

          // Passo 1 (Decisão #1 aprovada): Upsert do registro pai `songs` no PostgreSQL
          await _remoteDataSource.upsertSong(bundle.song);

          // Passo 2: Upload dos arquivos binários (PDF e MP3) antes de `song_assets`
          for (final asset in bundle.assets) {
            if (asset.syncStatus == 'pending' && asset.localPath != null) {
              final absPath =
                  await _fileStorage.resolveAbsolutePath(asset.localPath!);
              await _remoteDataSource.uploadAssetFile(
                assetType: AssetType.fromValue(asset.assetType),
                storagePath: asset.storagePath,
                absoluteLocalFilePath: absPath,
                mimeType: asset.mimeType,
              );
            }

            // Passo 3: Upsert do metadado em `song_assets`
            await _remoteDataSource.upsertSongAsset(asset);
          }

          // Passo 4: Upsert das versões de sincronização (`sync_versions`)
          // Ordena primeiro as inativas e por último a ativa para respeitar o índice único parcial
          final sortedSyncs = [...bundle.syncVersions]
            ..sort((a, b) => (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0));

          for (final sv in sortedSyncs) {
            await _remoteDataSource.upsertSyncVersion(sv);
          }

          // Passo 5: Confirma sucesso e atualiza o estado local para `synced`
          await _localDataSource.markBundleSynced(
            songId: bundle.song.id,
            syncedVersion: bundle.song.version,
          );
          syncedCount++;
        } catch (_) {
          // Mantém como 'pending' para retomada automática na próxima tentativa
        }
      }

      return Success(syncedCount);
    } catch (e) {
      return const Err(
        NetworkFailure('Não foi possível concluir a sincronização com a nuvem.'),
      );
    }
  }
}

