import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:singersinc/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase (SQLite Offline-First Schema)', () {
    test(
      'deve inserir e relacionar song, song_assets, sync_version, measures e measure_regions com sucesso',
      () async {
        // 1. Insere a música
        await db.into(db.songs).insert(
              SongsCompanion.insert(
                id: 'song-1',
                userId: 'user-1',
                title: 'Estudo Op. 10 No. 3',
              ),
            );

        // 2. Insere os assets (PDF e MP3)
        await db.into(db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: 'asset-pdf-1',
                songId: 'song-1',
                assetType: 'pdf',
                storagePath: 'user-1/song-1/asset-pdf-1.pdf',
                localPath: const Value('assets/song-1/asset-pdf-1.pdf'),
                mimeType: 'application/pdf',
                fileSize: 102400,
                checksum: 'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4',
                isDownloaded: const Value(true),
              ),
            );

        await db.into(db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: 'asset-audio-1',
                songId: 'song-1',
                assetType: 'audio',
                storagePath: 'user-1/song-1/asset-audio-1.mp3',
                localPath: const Value('assets/song-1/asset-audio-1.mp3'),
                mimeType: 'audio/mpeg',
                fileSize: 3048000,
                checksum: 'f6e5d4c3b2a1f6e5d4c3b2a1f6e5d4c3',
                isDownloaded: const Value(true),
              ),
            );

        // 3. Insere a versão de sincronização
        await db.into(db.syncVersions).insert(
              SyncVersionsCompanion.insert(
                id: 'sync-1',
                songId: 'song-1',
                pdfAssetId: 'asset-pdf-1',
                audioAssetId: 'asset-audio-1',
                audioDurationMs: 180000,
              ),
            );

        // 4. Insere compassos (um com startMs nulo e outro sincronizado)
        await db.into(db.measures).insert(
              MeasuresCompanion.insert(
                id: 'measure-1',
                syncId: 'sync-1',
                measureOrder: 1,
                measureLabel: const Value('1'),
                startMs: const Value(1250),
              ),
            );

        await db.into(db.measures).insert(
              MeasuresCompanion.insert(
                id: 'measure-2',
                syncId: 'sync-1',
                measureOrder: 2,
                measureLabel: const Value('2'),
                startMs: const Value(null),
              ),
            );

        // 5. Insere região normalizada para o compasso 1
        await db.into(db.measureRegions).insert(
              MeasureRegionsCompanion.insert(
                id: 'region-1',
                measureId: 'measure-1',
                pageNumber: 1,
                x: 0.1,
                y: 0.2,
                w: 0.35,
                h: 0.08,
              ),
            );

        final songs = await db.select(db.songs).get();
        final measures = await db.select(db.measures).get();
        final regions = await db.select(db.measureRegions).get();

        expect(songs, hasLength(1));
        expect(songs.first.title, 'Estudo Op. 10 No. 3');
        expect(songs.first.syncStatus, 'pending');
        expect(measures, hasLength(2));
        expect(measures.first.startMs, 1250);
        expect(measures.last.startMs, isNull);
        expect(regions, hasLength(1));
        expect(regions.first.w, closeTo(0.35, 0.0001));
      },
    );

    test(
      'deve remover em cascata measures e measure_regions ao excluir a song',
      () async {
        await db.into(db.songs).insert(
              SongsCompanion.insert(
                id: 'song-del',
                userId: 'user-1',
                title: 'Música Temporária',
              ),
            );

        await db.into(db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: 'pdf-del',
                songId: 'song-del',
                assetType: 'pdf',
                storagePath: 'user-1/song-del/pdf-del.pdf',
                mimeType: 'application/pdf',
                fileSize: 1000,
                checksum: '12345678901234567890123456789012',
              ),
            );

        await db.into(db.songAssets).insert(
              SongAssetsCompanion.insert(
                id: 'audio-del',
                songId: 'song-del',
                assetType: 'audio',
                storagePath: 'user-1/song-del/audio-del.mp3',
                mimeType: 'audio/mpeg',
                fileSize: 2000,
                checksum: '12345678901234567890123456789012',
              ),
            );

        await db.into(db.syncVersions).insert(
              SyncVersionsCompanion.insert(
                id: 'sync-del',
                songId: 'song-del',
                pdfAssetId: 'pdf-del',
                audioAssetId: 'audio-del',
                audioDurationMs: 60000,
              ),
            );

        await db.into(db.measures).insert(
              MeasuresCompanion.insert(
                id: 'm-del',
                syncId: 'sync-del',
                measureOrder: 1,
              ),
            );

        await (db.delete(db.songs)..where((t) => t.id.equals('song-del'))).go();

        final remainingMeasures = await db.select(db.measures).get();
        expect(remainingMeasures, isEmpty);
      },
    );
  });
}

