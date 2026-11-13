import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';
import 'package:singersinc/features/player/presentation/controllers/smart_player_controller.dart';
import 'package:singersinc/features/player/presentation/screens/song_preview_screen.dart';
import 'package:singersinc/features/player/presentation/widgets/audio_control_bar.dart';
import 'package:singersinc/features/player/presentation/widgets/smart_player_overlay.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Tela do Player Inteligente com destaque em tempo real e auto-scroll de partitura (Etapa 6).
class SmartPlayerScreen extends ConsumerStatefulWidget {
  const SmartPlayerScreen({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  ConsumerState<SmartPlayerScreen> createState() => _SmartPlayerScreenState();
}

class _SmartPlayerScreenState extends ConsumerState<SmartPlayerScreen> {
  late final PdfViewerController _pdfController;
  String? _pdfAbsolutePath;
  bool _isLoading = true;
  String? _errorMessage;
  int _lastAutoScrolledPage = 1;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _initializePlayer();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      final song = await ref.read(songDetailsProvider(widget.songId).future);
      if (song == null || song.activeSyncVersion == null || song.activePdfAsset?.localPath == null || song.activeAudioAsset?.localPath == null) {
        setState(() {
          _errorMessage = 'Arquivos da música não encontrados.';
          _isLoading = false;
        });
        return;
      }

      final storage = ref.read(localFileStorageProvider);
      final pdfAbs = await storage.resolveAbsolutePath(song.activePdfAsset!.localPath!);
      final audioAbs = await storage.resolveAbsolutePath(song.activeAudioAsset!.localPath!);

      if (!mounted) return;

      setState(() {
        _pdfAbsolutePath = pdfAbs;
        _isLoading = false;
      });

      // Carrega o áudio e inicializa o SmartPlayer
      await ref.read(audioPlaybackControllerProvider.notifier).loadAudio(
            audioAbs,
            fallbackDurationMs: song.activeSyncVersion!.audioDurationMs,
          );

      await ref.read(smartPlayerControllerProvider.notifier).initialize(
            song.activeSyncVersion!.id,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao inicializar o player: $e';
        _isLoading = false;
      });
    }
  }

  void _checkAutoPageScroll(int? targetPage) {
    if (targetPage != null && targetPage != _lastAutoScrolledPage) {
      _lastAutoScrolledPage = targetPage;
      _pdfController.goToPage(pageNumber: targetPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final smartState = ref.watch(smartPlayerControllerProvider);
    final smartNotifier = ref.read(smartPlayerControllerProvider.notifier);
    final audioState = ref.watch(audioPlaybackControllerProvider);
    final theme = Theme.of(context);

    if (audioState.isPlaying) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    // Auto-Scroll: quando o compasso ativo mudar de página, rola automaticamente a partitura!
    final activeMeasure = smartState.activeMeasure;
    final activePage = activeMeasure?.regions.firstOrNull?.pageNumber;
    _checkAutoPageScroll(activePage);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Player com Partitura'),
            Text(
              activeMeasure != null
                  ? 'Compasso ${activeMeasure.displayLabel}'
                  : 'Aguardando início do compasso...',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Botão de Loop do Compasso Atual
          IconButton(
            tooltip: smartState.isLoopingCurrentMeasure
                ? 'Desativar repetição do compasso'
                : 'Repetir compasso atual em loop',
            icon: Icon(
              Icons.repeat_one_rounded,
              color: smartState.isLoopingCurrentMeasure
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: smartNotifier.toggleLoopCurrentMeasure,
          ),
          // Botão Compasso Anterior
          IconButton(
            tooltip: 'Compasso anterior',
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: smartNotifier.previousMeasure,
          ),
          // Botão Próximo Compasso
          IconButton(
            tooltip: 'Próximo compasso',
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: smartNotifier.nextMeasure,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(context, smartState, smartNotifier),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartPlayerState smartState,
    SmartPlayerController smartNotifier,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_errorMessage!),
        ),
      );
    }

    return Column(
      children: [
        // 1. Partitura com destaque do compasso ativo e toque para pular áudio (Seek on Tap)
        Expanded(
          child: PdfViewer.file(
            _pdfAbsolutePath!,
            controller: _pdfController,
            params: PdfViewerParams(
              enableTextSelection: false,
              pageOverlaysBuilder: (context, pageRect, page) {
                return [
                  SmartPlayerOverlay(
                    pageNumber: page.pageNumber,
                    pageSize: pageRect.size,
                    measures: smartState.measures,
                    activeMeasureId: smartState.activeMeasure?.id,
                    onMeasureTap: (measureId) {
                      smartNotifier.seekToMeasure(measureId);
                    },
                  ),
                ];
              },
            ),
          ),
        ),

        // 2. Barra de Controle de Áudio Completa
        const AudioControlBar(),
      ],
    );
  }
}

