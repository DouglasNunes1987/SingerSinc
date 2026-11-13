import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';
import 'package:singersinc/features/player/presentation/widgets/audio_control_bar.dart';
import 'package:singersinc/features/player/presentation/widgets/score_viewer_widget.dart';
import 'package:singersinc/features/songs/domain/entities/song_library_item.dart';
import 'package:singersinc/features/songs/presentation/controllers/songs_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Provider que carrega os dados locais completos de uma música pelo `songId`.
final songDetailsProvider =
    FutureProvider.family<SongLibraryItem?, String>((ref, songId) async {
  final localDs = ref.watch(songsLocalDataSourceProvider);
  return localDs.getSongById(songId);
});

/// Tela de visualização da partitura em PDF com player integrado de áudio MP3 (Etapa 3).
class SongPreviewScreen extends ConsumerStatefulWidget {
  const SongPreviewScreen({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  ConsumerState<SongPreviewScreen> createState() => _SongPreviewScreenState();
}

class _SongPreviewScreenState extends ConsumerState<SongPreviewScreen> {
  String? _pdfAbsolutePath;
  bool _isFilesResolved = false;
  String? _resolveError;

  @override
  void initState() {
    super.initState();
    _loadSongFiles();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _loadSongFiles() async {
    try {
      final item = await ref.read(songDetailsProvider(widget.songId).future);
      if (item == null) {
        setState(() {
          _resolveError = 'Música não encontrada na biblioteca local.';
        });
        return;
      }

      final pdfRel = item.activePdfAsset?.localPath;
      final audioRel = item.activeAudioAsset?.localPath;

      if (pdfRel == null || audioRel == null) {
        setState(() {
          _resolveError = 'Arquivos de partitura ou áudio não encontrados.';
        });
        return;
      }

      final storage = ref.read(localFileStorageProvider);
      final pdfAbs = await storage.resolveAbsolutePath(pdfRel);
      final audioAbs = await storage.resolveAbsolutePath(audioRel);

      if (!mounted) return;

      setState(() {
        _pdfAbsolutePath = pdfAbs;
        _isFilesResolved = true;
      });

      // Inicializa o motor de reprodução de áudio
      await ref.read(audioPlaybackControllerProvider.notifier).loadAudio(
            audioAbs,
            fallbackDurationMs: item.activeSyncVersion?.audioDurationMs,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resolveError = 'Erro ao carregar arquivos da música: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final songAsync = ref.watch(songDetailsProvider(widget.songId));
    final audioState = ref.watch(audioPlaybackControllerProvider);
    final theme = Theme.of(context);

    // Mantém a tela acesa enquanto o áudio estiver tocando
    if (audioState.isPlaying) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return Scaffold(
      appBar: AppBar(
        title: songAsync.when(
          data: (song) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song?.title ?? 'Partitura e Áudio',
                style: const TextStyle(fontSize: 18),
              ),
              if (song?.activePdfAsset != null)
                Text(
                  'PDF v${song!.activePdfAsset!.revision} • MP3 v${song.activeAudioAsset?.revision ?? 1}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          loading: () => const Text('Carregando música...'),
          error: (_, __) => const Text('Erro ao carregar'),
        ),
        actions: [
          IconButton(
            key: const Key('open_editor_button'),
            tooltip: 'Delimitar Compassos (Editor)',
            icon: const Icon(Icons.crop_square_rounded),
            onPressed: () {
              context.push('/songs/${widget.songId}/editor');
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);

    if (_resolveError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                _resolveError!,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    _resolveError = null;
                    _isFilesResolved = false;
                  });
                  _loadSongFiles();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isFilesResolved || _pdfAbsolutePath == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando partitura e áudio...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 1. Área Principal de Visualização do PDF da Partitura
        Expanded(
          child: ScoreViewerWidget(
            key: Key('score_viewer_${widget.songId}'),
            pdfFilePath: _pdfAbsolutePath!,
          ),
        ),

        // 2. Barra de Controle de Áudio na Parte Inferior
        const AudioControlBar(),
      ],
    );
  }
}
