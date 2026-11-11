import 'dart:io';

import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Contrato para comunicação remota de músicas e arquivos com o Supabase.
abstract interface class SongsRemoteDataSource {
  /// Consulta a versão atual de uma música no banco remoto para controle otimista.
  Future<int?> fetchRemoteSongVersion(String songId);

  /// Insere ou atualiza o registro pai `songs` no PostgreSQL.
  Future<void> upsertSong(Song song);

  /// Faz upload do arquivo binário (`.pdf` ou `.mp3`) para o bucket privado correspondente
  /// (`scores` ou `audio`) no caminho `{user_id}/{song_id}/{asset_id}.{pdf|mp3}`.
  Future<void> uploadAssetFile({
    required AssetType assetType,
    required String storagePath,
    required String absoluteLocalFilePath,
    required String mimeType,
  });

  /// Insere ou atualiza o metadado do arquivo em `public.song_assets`.
  Future<void> upsertSongAsset(SongAsset asset);

  /// Insere ou atualiza a versão de sincronização em `public.sync_versions`.
  Future<void> upsertSyncVersion(SyncVersion syncVersion);

  /// Remove uma música e seus objetos do Supabase Storage.
  Future<void> deleteRemoteSong({
    required String userId,
    required String songId,
    required List<SongAsset> assets,
  });
}

/// Implementação concreta de [SongsRemoteDataSource] utilizando Supabase PostgREST e Storage.
class SupabaseSongsRemoteDataSource implements SongsRemoteDataSource {
  const SupabaseSongsRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<int?> fetchRemoteSongVersion(String songId) async {
    try {
      final response = await _client
          .from('songs')
          .select('version')
          .eq('id', songId)
          .maybeSingle();
      if (response == null) return null;
      return response['version'] as int?;
    } catch (e) {
      throw RemoteServerException(
        'Não foi possível verificar a versão remota da música.',
        cause: e,
      );
    }
  }

  @override
  Future<void> upsertSong(Song song) async {
    try {
      await _client.from('songs').upsert({
        'id': song.id,
        'user_id': song.userId,
        'title': song.title,
        'version': song.version,
        'created_at': song.createdAt.toUtc().toIso8601String(),
        'updated_at': song.updatedAt.toUtc().toIso8601String(),
        'deleted_at': song.deletedAt?.toUtc().toIso8601String(),
      });
    } catch (e) {
      throw RemoteServerException(
        'Erro ao sincronizar metadados da música com a nuvem.',
        cause: e,
      );
    }
  }

  @override
  Future<void> uploadAssetFile({
    required AssetType assetType,
    required String storagePath,
    required String absoluteLocalFilePath,
    required String mimeType,
  }) async {
    try {
      final bucketName = assetType == AssetType.pdf ? 'scores' : 'audio';
      final file = File(absoluteLocalFilePath);
      if (!await file.exists()) {
        throw const StorageFileException(
          'Arquivo local não encontrado para envio à nuvem.',
        );
      }

      await _client.storage.from(bucketName).upload(
            storagePath,
            file,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: true,
            ),
          );
    } catch (e) {
      if (e is AppException) rethrow;
      throw RemoteServerException(
        'Erro ao enviar arquivo (${assetType.value}) para o Supabase Storage.',
        cause: e,
      );
    }
  }

  @override
  Future<void> upsertSongAsset(SongAsset asset) async {
    try {
      await _client.from('song_assets').upsert({
        'id': asset.id,
        'song_id': asset.songId,
        'asset_type': asset.assetType,
        'revision': asset.revision,
        'storage_path': asset.storagePath,
        'mime_type': asset.mimeType,
        'file_size': asset.fileSize,
        'checksum': asset.checksum,
        'is_active': asset.isActive,
        'version': asset.version,
        'created_at': asset.createdAt.toUtc().toIso8601String(),
        'updated_at': asset.updatedAt.toUtc().toIso8601String(),
        'deleted_at': asset.deletedAt?.toUtc().toIso8601String(),
      });
    } catch (e) {
      throw RemoteServerException(
        'Erro ao registrar metadados do arquivo no banco remoto.',
        cause: e,
      );
    }
  }

  @override
  Future<void> upsertSyncVersion(SyncVersion syncVersion) async {
    try {
      await _client.from('sync_versions').upsert({
        'id': syncVersion.id,
        'song_id': syncVersion.songId,
        'pdf_asset_id': syncVersion.pdfAssetId,
        'audio_asset_id': syncVersion.audioAssetId,
        'audio_duration_ms': syncVersion.audioDurationMs,
        'is_active': syncVersion.isActive,
        'version': syncVersion.version,
        'created_at': syncVersion.createdAt.toUtc().toIso8601String(),
        'updated_at': syncVersion.updatedAt.toUtc().toIso8601String(),
        'deleted_at': syncVersion.deletedAt?.toUtc().toIso8601String(),
      });
    } catch (e) {
      throw RemoteServerException(
        'Erro ao sincronizar versão de sincronização com a nuvem.',
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteRemoteSong({
    required String userId,
    required String songId,
    required List<SongAsset> assets,
  }) async {
    try {
      final pdfPaths = assets
          .where((a) => a.assetType == AssetType.pdf.value)
          .map((a) => a.storagePath)
          .toList();
      final audioPaths = assets
          .where((a) => a.assetType == AssetType.audio.value)
          .map((a) => a.storagePath)
          .toList();

      if (pdfPaths.isNotEmpty) {
        await _client.storage.from('scores').remove(pdfPaths);
      }
      if (audioPaths.isNotEmpty) {
        await _client.storage.from('audio').remove(audioPaths);
      }

      await _client.from('songs').delete().eq('id', songId);
    } catch (_) {
      // Se estiver offline no momento da exclusão, a limpeza local ainda é garantida.
    }
  }
}

