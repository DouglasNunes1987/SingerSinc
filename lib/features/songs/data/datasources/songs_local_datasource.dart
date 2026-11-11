import 'package:drift/drift.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/core/errors/app_exception.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/entities/sync_version_entity.dart';
import 'package:uuid/uuid.dart';

/// Pacote completo de dados locais de uma música para sincronização com o Supabase.
class LocalSongSyncBundle {
  const LocalSongSyncBundle({
    required this.song,
    required this.assets,
    required this.syncVersions,
  });

  final Song song;
  final List<SongAsset> assets;
  final List<SyncVersion> syncVersions;
}

/// Fonte de dados local baseada no SQLite/Drift para a Biblioteca de Músicas.
class SongsLocalDataSource {
  const SongsLocalDataSource(this._db, {Uuid uuid = const Uuid()})
      : _uuid = uuid;

  final AppDatabase _db;
  final Uuid _uuid;

  /// Observa reativamente a lista de músicas não excluídas do usuário.
  Stream<List<SongLibraryItem>> watchUserSongs(String userId) {
    final songsQuery = (_db.select(_db.songs)
          ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();

    return songsQuery.asyncMap((songs) async {
      if (songs.isEmpty) return const <SongLibraryItem>[];

      final songIds = songs.map((s) => s.id).toList();

      final activeAssets = await (_db.select(_db.songAssets)
            ..where(
              (a) =>
                  a.songId.isIn(songIds) &
                  a.isActive.equals(true) &
                  a.deletedAt.isNull(),
            ))
          .get();

      final activeSyncs = await (_db.select(_db.syncVersions)
            ..where(
              (sv) =>
                  sv.songId.isIn(songIds) &
                  sv.isActive.equals(true) &
                  sv.deletedAt.isNull(),
            ))
          .get();

      final syncIds = activeSyncs.map((sv) => sv.id).toList();
      final allMeasures = syncIds.isEmpty
          ? const <Measure>[]
          : await (_db.select(_db.measures)
                ..where((m) => m.syncId.isIn(syncIds)))
              .get();

      return songs.map((song) {
        final songAssets =
            activeAssets.where((a) => a.songId == song.id).toList();
        final pdfAsset = songAssets
            .where((a) => a.assetType == AssetType.pdf.value)
            .firstOrNull;
        final audioAsset = songAssets
            .where((a) => a.assetType == AssetType.audio.value)
            .firstOrNull;
        final activeSync =
            activeSyncs.where((sv) => sv.songId == song.id).firstOrNull;

        final measuresForSync = activeSync == null
            ? const <Measure>[]
            : allMeasures.where((m) => m.syncId == activeSync.id).toList();

        final syncedCount =
            measuresForSync.where((m) => m.startMs != null).length;

        return SongLibraryItem(
          id: song.id,
          userId: song.userId,
          title: song.title,
          version: song.version,
          syncStatus: song.syncStatus,
          createdAt: song.createdAt,
          updatedAt: song.updatedAt,
          activePdfAsset: pdfAsset != null ? _mapAsset(pdfAsset) : null,
          activeAudioAsset: audioAsset != null ? _mapAsset(audioAsset) : null,
          activeSyncVersion:
              activeSync != null ? _mapSyncVersion(activeSync) : null,
          measuresCount: measuresForSync.length,
          syncedMeasuresCount: syncedCount,
        );
      }).toList();
    });
  }

  /// Obtém uma música específica pelo `songId`.
  Future<SongLibraryItem?> getSongById(String songId) async {
    final song = await (_db.select(_db.songs)
          ..where((t) => t.id.equals(songId) & t.deletedAt.isNull()))
        .getSingleOrNull();
    if (song == null) return null;

    final assets = await (_db.select(_db.songAssets)
          ..where(
            (a) =>
                a.songId.equals(songId) &
                a.isActive.equals(true) &
                a.deletedAt.isNull(),
          ))
        .get();

    final activeSync = await (_db.select(_db.syncVersions)
          ..where(
            (sv) =>
                sv.songId.equals(songId) &
                sv.isActive.equals(true) &
                sv.deletedAt.isNull(),
          ))
        .getSingleOrNull();

    final pdfAsset =
        assets.where((a) => a.assetType == AssetType.pdf.value).firstOrNull;
    final audioAsset =
        assets.where((a) => a.assetType == AssetType.audio.value).firstOrNull;

    final measures = activeSync == null
        ? const <Measure>[]
        : await (_db.select(_db.measures)
              ..where((m) => m.syncId.equals(activeSync.id)))
            .get();

    return SongLibraryItem(
      id: song.id,
      userId: song.userId,
      title: song.title,
      version: song.version,
      syncStatus: song.syncStatus,
      createdAt: song.createdAt,
      updatedAt: song.updatedAt,
      activePdfAsset: pdfAsset != null ? _mapAsset(pdfAsset) : null,
      activeAudioAsset: audioAsset != null ? _mapAsset(audioAsset) : null,
      activeSyncVersion:
          activeSync != null ? _mapSyncVersion(activeSync) : null,
      measuresCount: measures.length,
      syncedMeasuresCount: measures.where((m) => m.startMs != null).length,
    );
  }

  /// Insere atomicamente no SQLite a música, o asset de PDF, o asset de áudio,
  /// a versão de sincronização inicial e registra a operação na fila `sync_operations`.
  Future<SongLibraryItem> insertSongBundle({
    required String songId,
    required String userId,
    required String title,
    required String pdfAssetId,
    required String pdfStoragePath,
    required String pdfLocalPath,
    required int pdfFileSize,
    required String pdfChecksum,
    required String audioAssetId,
    required String audioStoragePath,
    required String audioLocalPath,
    required int audioFileSize,
    required String audioChecksum,
    required String syncVersionId,
    required int audioDurationMs,
  }) async {
    try {
      final now = DateTime.now();

      await _db.transaction(() async {
        await _db.into(_db.songs).insert(
              SongsCompanion.insert(
                id: songId,
                userId: userId,
                title: title,
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await _db.into(_db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: pdfAssetId,
                songId: songId,
                assetType: AssetType.pdf.value,
                revision: const Value(1),
                storagePath: pdfStoragePath,
                localPath: Value(pdfLocalPath),
                mimeType: 'application/pdf',
                fileSize: pdfFileSize,
                checksum: pdfChecksum,
                isActive: const Value(true),
                isDownloaded: const Value(true),
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await _db.into(_db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: audioAssetId,
                songId: songId,
                assetType: AssetType.audio.value,
                revision: const Value(1),
                storagePath: audioStoragePath,
                localPath: Value(audioLocalPath),
                mimeType: 'audio/mpeg',
                fileSize: audioFileSize,
                checksum: audioChecksum,
                isActive: const Value(true),
                isDownloaded: const Value(true),
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await _db.into(_db.syncVersions).insert(
              SyncVersionsCompanion.insert(
                id: syncVersionId,
                songId: songId,
                pdfAssetId: pdfAssetId,
                audioAssetId: audioAssetId,
                audioDurationMs: audioDurationMs,
                isActive: const Value(true),
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await _enqueueOperation(
          entityType: 'song',
          entityId: songId,
          operationType: 'UPSERT',
        );
      });

      final created = await getSongById(songId);
      if (created == null) {
        throw const LocalDatabaseException(
          'Falha ao recuperar a música recém-cadastrada no banco local.',
        );
      }
      return created;
    } catch (e) {
      if (e is AppException) rethrow;
      throw LocalDatabaseException(
        'Erro ao salvar a música no banco de dados local.',
        cause: e,
      );
    }
  }

  /// Atualiza o título da música e marca `sync_status = 'pending'`.
  Future<void> updateSongTitle({
    required String songId,
    required String newTitle,
  }) async {
    try {
      await _db.transaction(() async {
        final current = await (_db.select(_db.songs)
              ..where((t) => t.id.equals(songId)))
            .getSingleOrNull();
        if (current == null) {
          throw const LocalDatabaseException('Música não encontrada.');
        }

        final now = DateTime.now();
        await (_db.update(_db.songs)..where((t) => t.id.equals(songId))).write(
          SongsCompanion(
            title: Value(newTitle),
            version: Value(current.version + 1),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );

        await _enqueueOperation(
          entityType: 'song',
          entityId: songId,
          operationType: 'UPSERT',
        );
      });
    } catch (e) {
      if (e is AppException) rethrow;
      throw LocalDatabaseException(
        'Erro ao atualizar o título da música.',
        cause: e,
      );
    }
  }

  /// Obtém a próxima revisão numérica para um tipo de arquivo (`pdf` ou `audio`) da música.
  Future<int> getNextAssetRevision({
    required String songId,
    required AssetType assetType,
  }) async {
    final assets = await (_db.select(_db.songAssets)
          ..where(
            (a) =>
                a.songId.equals(songId) &
                a.assetType.equals(assetType.value),
          ))
        .get();
    if (assets.isEmpty) return 1;
    final maxRev =
        assets.map((a) => a.revision).reduce((a, b) => a > b ? a : b);
    return maxRev + 1;
  }

  /// Substitui um asset (PDF ou Áudio) criando uma nova revisão, uma nova
  /// `sync_version` ativa e, caso apenas o áudio tenha sido substituído (Decisão #3),
  /// clona automaticamente todos os `measures` e `measure_regions` da versão anterior.
  Future<void> replaceSongAssetWithRevision({
    required String songId,
    required AssetType assetType,
    required String newAssetId,
    required int newRevision,
    required String storagePath,
    required String localPath,
    required String mimeType,
    required int fileSize,
    required String checksum,
    required String newSyncVersionId,
    int? newAudioDurationMs,
  }) async {
    try {
      final now = DateTime.now();

      await _db.transaction(() async {
        // 1. Busca a sync_version ativa atual
        final currentSync = await (_db.select(_db.syncVersions)
              ..where(
                (sv) =>
                    sv.songId.equals(songId) &
                    sv.isActive.equals(true) &
                    sv.deletedAt.isNull(),
              ))
            .getSingleOrNull();

        if (currentSync == null) {
          throw const LocalDatabaseException(
            'Versão de sincronização ativa não encontrada para a música.',
          );
        }

        // 2. Desativa os assets anteriores do mesmo tipo
        await (_db.update(_db.songAssets)
              ..where(
                (a) =>
                    a.songId.equals(songId) &
                    a.assetType.equals(assetType.value) &
                    a.isActive.equals(true),
              ))
            .write(
          SongAssetsCompanion(
            isActive: const Value(false),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );

        // 3. Insere a nova revisão do asset
        await _db.into(_db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: newAssetId,
                songId: songId,
                assetType: assetType.value,
                revision: Value(newRevision),
                storagePath: storagePath,
                localPath: Value(localPath),
                mimeType: mimeType,
                fileSize: fileSize,
                checksum: checksum,
                isActive: const Value(true),
                isDownloaded: const Value(true),
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // 4. Desativa a sync_version anterior
        await (_db.update(_db.syncVersions)
              ..where((sv) => sv.id.equals(currentSync.id)))
            .write(
          SyncVersionsCompanion(
            isActive: const Value(false),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );

        final effectivePdfAssetId =
            assetType == AssetType.pdf ? newAssetId : currentSync.pdfAssetId;
        final effectiveAudioAssetId = assetType == AssetType.audio
            ? newAssetId
            : currentSync.audioAssetId;
        final effectiveDurationMs =
            newAudioDurationMs ?? currentSync.audioDurationMs;

        // 5. Cria a nova sync_version ativa
        await _db.into(_db.syncVersions).insert(
              SyncVersionsCompanion.insert(
                id: newSyncVersionId,
                songId: songId,
                pdfAssetId: effectivePdfAssetId,
                audioAssetId: effectiveAudioAssetId,
                audioDurationMs: effectiveDurationMs,
                isActive: const Value(true),
                version: const Value(1),
                baseVersion: const Value(0),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // 6. Se o PDF permaneceu o mesmo (substituição de áudio), clona os compassos
        // e regiões visuais para evitar que o professor precise redesenhar os retângulos!
        if (assetType == AssetType.audio) {
          final oldMeasures = await (_db.select(_db.measures)
                ..where((m) => m.syncId.equals(currentSync.id))
                ..orderBy([(m) => OrderingTerm.asc(m.measureOrder)]))
              .get();

          for (final oldMeasure in oldMeasures) {
            final newMeasureId = _uuid.v4();
            final validStartMs = (oldMeasure.startMs != null &&
                    oldMeasure.startMs! <= effectiveDurationMs)
                ? oldMeasure.startMs
                : null;

            await _db.into(_db.measures).insert(
                  MeasuresCompanion.insert(
                    id: newMeasureId,
                    syncId: newSyncVersionId,
                    measureOrder: oldMeasure.measureOrder,
                    measureLabel: Value(oldMeasure.measureLabel),
                    startMs: Value(validStartMs),
                    createdAt: Value(now),
                    updatedAt: Value(now),
                  ),
                );

            final oldRegions = await (_db.select(_db.measureRegions)
                  ..where((r) => r.measureId.equals(oldMeasure.id))
                  ..orderBy([(r) => OrderingTerm.asc(r.regionOrder)]))
                .get();

            for (final oldRegion in oldRegions) {
              await _db.into(_db.measureRegions).insert(
                    MeasureRegionsCompanion.insert(
                      id: _uuid.v4(),
                      measureId: newMeasureId,
                      regionOrder: Value(oldRegion.regionOrder),
                      pageNumber: oldRegion.pageNumber,
                      x: oldRegion.x,
                      y: oldRegion.y,
                      w: oldRegion.w,
                      h: oldRegion.h,
                      createdAt: Value(now),
                      updatedAt: Value(now),
                    ),
                  );
            }
          }
        }

        // 7. Atualiza timestamp e status da música
        final song = await (_db.select(_db.songs)
              ..where((s) => s.id.equals(songId)))
            .getSingle();

        await (_db.update(_db.songs)..where((s) => s.id.equals(songId))).write(
          SongsCompanion(
            version: Value(song.version + 1),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );

        await _enqueueOperation(
          entityType: 'song',
          entityId: songId,
          operationType: 'UPSERT',
        );
      });
    } catch (e) {
      if (e is AppException) rethrow;
      throw LocalDatabaseException(
        'Erro ao substituir o arquivo da música.',
        cause: e,
      );
    }
  }

  /// Exclui a música do banco local (ou registra exclusão).
  Future<void> deleteSong(String songId) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.songs)..where((t) => t.id.equals(songId))).go();
        await (_db.delete(_db.syncOperations)
              ..where((op) => op.entityId.equals(songId)))
            .go();
      });
    } catch (e) {
      throw LocalDatabaseException(
        'Erro ao excluir a música do banco local.',
        cause: e,
      );
    }
  }

  /// Retorna todas as músicas do usuário que possuem alterações pendentes de envio (`pending`).
  Future<List<LocalSongSyncBundle>> getPendingSongBundles(String userId) async {
    final allUserSongs = await (_db.select(_db.songs)
          ..where((s) => s.userId.equals(userId) & s.deletedAt.isNull()))
        .get();

    final bundles = <LocalSongSyncBundle>[];

    for (final song in allUserSongs) {
      final assets = await (_db.select(_db.songAssets)
            ..where((a) => a.songId.equals(song.id) & a.deletedAt.isNull()))
          .get();
      final syncs = await (_db.select(_db.syncVersions)
            ..where((sv) => sv.songId.equals(song.id) & sv.deletedAt.isNull()))
          .get();

      final hasPending = song.syncStatus == 'pending' ||
          assets.any((a) => a.syncStatus == 'pending') ||
          syncs.any((sv) => sv.syncStatus == 'pending');

      if (hasPending) {
        bundles.add(
          LocalSongSyncBundle(
            song: song,
            assets: assets,
            syncVersions: syncs,
          ),
        );
      }
    }

    return bundles;
  }

  /// Marca a música, seus assets e versões de sincronização como `'synced'`.
  Future<void> markBundleSynced({
    required String songId,
    required int syncedVersion,
  }) async {
    await _db.transaction(() async {
      await (_db.update(_db.songs)..where((s) => s.id.equals(songId))).write(
        SongsCompanion(
          baseVersion: Value(syncedVersion),
          syncStatus: const Value('synced'),
        ),
      );

      await (_db.update(_db.songAssets)..where((a) => a.songId.equals(songId)))
          .write(
        const SongAssetsCompanion(
          syncStatus: Value('synced'),
        ),
      );

      await (_db.update(_db.syncVersions)
            ..where((sv) => sv.songId.equals(songId)))
          .write(
        const SyncVersionsCompanion(
          syncStatus: Value('synced'),
        ),
      );

      await (_db.delete(_db.syncOperations)
            ..where((op) => op.entityId.equals(songId)))
          .go();
    });
  }

  /// Marca a música como em estado de conflito (`'conflict'`).
  Future<void> markSongConflict(String songId) async {
    await (_db.update(_db.songs)..where((s) => s.id.equals(songId))).write(
      const SongsCompanion(
        syncStatus: Value('conflict'),
      ),
    );
  }

  Future<void> _enqueueOperation({
    required String entityType,
    required String entityId,
    required String operationType,
  }) async {
    await _db.into(_db.syncOperations).insert(
          SyncOperationsCompanion.insert(
            entityType: entityType,
            entityId: entityId,
            operationType: operationType,
          ),
        );
  }

  SongAssetEntity _mapAsset(SongAsset row) {
    return SongAssetEntity(
      id: row.id,
      songId: row.songId,
      assetType: AssetType.fromValue(row.assetType),
      revision: row.revision,
      storagePath: row.storagePath,
      localPath: row.localPath,
      mimeType: row.mimeType,
      fileSize: row.fileSize,
      checksum: row.checksum,
      isActive: row.isActive,
      isDownloaded: row.isDownloaded,
      version: row.version,
      syncStatus: row.syncStatus,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  SyncVersionEntity _mapSyncVersion(SyncVersion row) {
    return SyncVersionEntity(
      id: row.id,
      songId: row.songId,
      pdfAssetId: row.pdfAssetId,
      audioAssetId: row.audioAssetId,
      audioDurationMs: row.audioDurationMs,
      isActive: row.isActive,
      version: row.version,
      syncStatus: row.syncStatus,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

