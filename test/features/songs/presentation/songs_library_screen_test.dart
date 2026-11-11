import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:singersinc/features/auth/domain/entities/app_user.dart';
import 'package:singersinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:singersinc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:singersinc/features/songs/domain/entities/song_asset_entity.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/domain/entities/sync_version_entity.dart';
import 'package:singersinc/features/songs/domain/repositories/songs_repository.dart';
import 'package:singersinc/features/songs/presentation/controllers/songs_controller.dart';
import 'package:singersinc/features/songs/presentation/screens/songs_library_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSongsRepository extends Mock implements SongsRepository {}

void main() {
  late _MockAuthRepository mockAuthRepository;
  late _MockSongsRepository mockSongsRepository;
  late StreamController<List<SongLibraryItem>> songsStreamController;

  const testUser = AppUser(id: 'user-1', email: 'prof@singersinc.com');

  setUp(() {
    mockAuthRepository = _MockAuthRepository();
    mockSongsRepository = _MockSongsRepository();
    songsStreamController = StreamController<List<SongLibraryItem>>.broadcast();

    when(() => mockAuthRepository.currentUser).thenReturn(testUser);
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(testUser));
    when(() => mockSongsRepository.watchUserSongs('user-1'))
        .thenAnswer((_) => songsStreamController.stream);
  });

  tearDown(() async {
    await songsStreamController.close();
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        songsRepositoryProvider.overrideWithValue(mockSongsRepository),
      ],
      child: const MaterialApp(
        home: SongsLibraryScreen(),
      ),
    );
  }

  testWidgets(
    'deve exibir estado vazio quando não houver músicas e exibir cards com indicadores offline e de nuvem quando houver',
    (tester) async {
      await tester.pumpWidget(createSubject());

      // Emite lista vazia
      songsStreamController.add(const []);
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma música cadastrada'), findsOneWidget);

      // Emite uma música disponível offline e pendente de sincronização com a nuvem
      final now = DateTime(2026, 11, 6);
      songsStreamController.add([
        SongLibraryItem(
          id: 'song-1',
          userId: 'user-1',
          title: 'Chopin - Nocturne Op. 9 No. 2',
          version: 1,
          syncStatus: 'pending',
          createdAt: now,
          updatedAt: now,
          activePdfAsset: SongAssetEntity(
            id: 'pdf-1',
            songId: 'song-1',
            assetType: AssetType.pdf,
            revision: 1,
            storagePath: 'user-1/song-1/pdf-1.pdf',
            localPath: 'singersinc_media/user-1/song-1/pdf-1.pdf',
            mimeType: 'application/pdf',
            fileSize: 204800,
            checksum: '12345678901234567890123456789012',
            isActive: true,
            isDownloaded: true,
            version: 1,
            syncStatus: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
          activeAudioAsset: SongAssetEntity(
            id: 'audio-1',
            songId: 'song-1',
            assetType: AssetType.audio,
            revision: 1,
            storagePath: 'user-1/song-1/audio-1.mp3',
            localPath: 'singersinc_media/user-1/song-1/audio-1.mp3',
            mimeType: 'audio/mpeg',
            fileSize: 4096000,
            checksum: '12345678901234567890123456789012',
            isActive: true,
            isDownloaded: true,
            version: 1,
            syncStatus: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
          activeSyncVersion: SyncVersionEntity(
            id: 'sync-1',
            songId: 'song-1',
            pdfAssetId: 'pdf-1',
            audioAssetId: 'audio-1',
            audioDurationMs: 260000,
            isActive: true,
            version: 1,
            syncStatus: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
          measuresCount: 12,
          syncedMeasuresCount: 12,
        ),
      ]);

      await tester.pumpAndSettle();

      expect(find.text('Chopin - Nocturne Op. 9 No. 2'), findsOneWidget);
      expect(find.text('Disponível offline'), findsOneWidget);
      expect(find.text('Pendente de nuvem'), findsOneWidget);
      expect(find.text('12/12 compassos'), findsOneWidget);
    },
  );
}

