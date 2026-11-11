import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singersinc/core/database/app_database.dart';
import 'package:singersinc/features/songs/data/datasources/songs_local_datasource.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';

void main() {
  late AppDatabase db;
  late SongsLocalDataSource dataSource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dataSource = SongsLocalDataSource(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SongsLocalDataSource (Etapa 2 - Biblioteca de Músicas)', () {
    test(
      'deve cadastrar bundle completo de música (PDF + MP3 + SyncVersion) e indicar disponibilidade offline',
      () async {
        final item = await dataSource.insertSongBundle(
          songId: 'song-1',
          userId: 'user-1',
          title: 'Bach - Prelúdio em Dó Maior',
          pdfAssetId: 'pdf-1',
          pdfStoragePath: 'user-1/song-1/pdf-1.pdf',
          pdfLocalPath: 'singersinc_media/user-1/song-1/pdf-1.pdf',
          pdfFileSize: 250000,
          pdfChecksum: 'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4',
          audioAssetId: 'audio-1',
          audioStoragePath: 'user-1/song-1/audio-1.mp3',
          audioLocalPath: 'singersinc_media/user-1/song-1/audio-1.mp3',
          audioFileSize: 4200000,
          audioChecksum: 'f6e5d4c3b2a1f6e5d4c3b2a1f6e5d4c3',
          syncVersionId: 'sync-1',
          audioDurationMs: 135000,
        );

        expect(item.title, 'Bach - Prelúdio em Dó Maior');
        expect(item.isAvailableOffline, isTrue);
        expect(item.hasPendingCloudSync, isTrue);
        expect(item.activePdfAsset?.revision, 1);
        expect(item.activeAudioAsset?.revision, 1);
        expect(item.activeSyncVersion?.audioDurationMs, 135000);

        final watched = await dataSource.watchUserSongs('user-1').first;
        expect(watched, hasLength(1));
        expect(watched.first.id, 'song-1');
      },
    );

    test(
      'deve atualizar o título da música, incrementar version e manter pendente de sincronização',
      () async {
        await dataSource.insertSongBundle(
          songId: 'song-2',
          userId: 'user-1',
          title: 'Título Original',
          pdfAssetId: 'pdf-2',
          pdfStoragePath: 'user-1/song-2/pdf-2.pdf',
          pdfLocalPath: 'singersinc_media/user-1/song-2/pdf-2.pdf',
          pdfFileSize: 100000,
          pdfChecksum: '12345678901234567890123456789012',
          audioAssetId: 'audio-2',
          audioStoragePath: 'user-1/song-2/audio-2.mp3',
          audioLocalPath: 'singersinc_media/user-1/song-2/audio-2.mp3',
          audioFileSize: 2000000,
          audioChecksum: '12345678901234567890123456789012',
          syncVersionId: 'sync-2',
          audioDurationMs: 90000,
        );

        await dataSource.markBundleSynced(songId: 'song-2', syncedVersion: 1);

        var current = await dataSource.getSongById('song-2');
        expect(current?.hasPendingCloudSync, isFalse);

        await dataSource.updateSongTitle(
          songId: 'song-2',
          newTitle: 'Título Editado pelo Professor',
        );

        current = await dataSource.getSongById('song-2');
        expect(current?.title, 'Título Editado pelo Professor');
        expect(current?.version, 2);
        expect(current?.hasPendingCloudSync, isTrue);
      },
    );

    test(
      'deve substituir apenas o áudio (nova revisão) e clonar automaticamente os compassos e regiões do PDF',
      () async {
        await dataSource.insertSongBundle(
          songId: 'song-3',
          userId: 'user-1',
          title: 'Villa-Lobos - Bachianas No. 5',
          pdfAssetId: 'pdf-3',
          pdfStoragePath: 'user-1/song-3/pdf-3.pdf',
          pdfLocalPath: 'singersinc_media/user-1/song-3/pdf-3.pdf',
          pdfFileSize: 300000,
          pdfChecksum: '12345678901234567890123456789012',
          audioAssetId: 'audio-3-v1',
          audioStoragePath: 'user-1/song-3/audio-3-v1.mp3',
          audioLocalPath: 'singersinc_media/user-1/song-3/audio-3-v1.mp3',
          audioFileSize: 3000000,
          audioChecksum: '12345678901234567890123456789012',
          syncVersionId: 'sync-3-v1',
          audioDurationMs: 200000,
        );

        // Simula compasso e região desenhados pelo professor na versão 1
        await db.into(db.measures).insert(
              MeasuresCompanion.insert(
                id: 'measure-v1-1',
                syncId: 'sync-3-v1',
                measureOrder: 1,
                measureLabel: const Value('1'),
                startMs: const Value(2500),
              ),
            );

        await db.into(db.measureRegions).insert(
              MeasureRegionsCompanion.insert(
                id: 'region-v1-1',
                measureId: 'measure-v1-1',
                pageNumber: 1,
                x: 0.15,
                y: 0.25,
                w: 0.40,
                h: 0.10,
              ),
            );

        final nextRev = await dataSource.getNextAssetRevision(
          songId: 'song-3',
          assetType: AssetType.audio,
        );
        expect(nextRev, 2);

        await dataSource.replaceSongAssetWithRevision(
          songId: 'song-3',
          assetType: AssetType.audio,
          newAssetId: 'audio-3-v2',
          newRevision: nextRev,
          storagePath: 'user-1/song-3/audio-3-v2.mp3',
          localPath: 'singersinc_media/user-1/song-3/audio-3-v2.mp3',
          mimeType: 'audio/mpeg',
          fileSize: 3500000,
          checksum: 'abcdef1234567890abcdef1234567890',
          newSyncVersionId: 'sync-3-v2',
          newAudioDurationMs: 210000,
        );

        final updated = await dataSource.getSongById('song-3');
        expect(updated?.activePdfAsset?.id, 'pdf-3');
        expect(updated?.activePdfAsset?.revision, 1);
        expect(updated?.activeAudioAsset?.id, 'audio-3-v2');
        expect(updated?.activeAudioAsset?.revision, 2);
        expect(updated?.activeSyncVersion?.id, 'sync-3-v2');
        expect(updated?.measuresCount, 1);
        expect(updated?.syncedMeasuresCount, 1);

        final clonedMeasures = await (db.select(db.measures)
              ..where((m) => m.syncId.equals('sync-3-v2')))
            .get();
        expect(clonedMeasures, hasLength(1));
        expect(clonedMeasures.first.startMs, 2500);

        final clonedRegions = await (db.select(db.measureRegions)
              ..where((r) => r.measureId.equals(clonedMeasures.first.id)))
            .get();
        expect(clonedRegions, hasLength(1));
        expect(clonedRegions.first.x, closeTo(0.15, 0.0001));
      },
    );
  });
}

