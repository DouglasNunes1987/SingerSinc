import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/editor/presentation/widgets/score_editor_overlay.dart';
import 'package:singersinc/features/player/presentation/controllers/audio_playback_controller.dart';
import 'package:singersinc/features/player/presentation/screens/song_preview_screen.dart';
import 'package:singersinc/features/player/presentation/widgets/audio_control_bar.dart';
import 'package:singersinc/features/sync/presentation/controllers/manual_sync_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Tela de Sincronização Manual de Compassos com Áudio MP3 (Etapa 5).
class ManualSyncScreen extends ConsumerStatefulWidget {
  const ManualSyncScreen({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  ConsumerState<ManualSyncScreen> createState() => _ManualSyncScreenState();
}

class _ManualSyncScreenState extends ConsumerState<ManualSyncScreen> {
  final FocusNode _keyboardFocusNode = FocusNode();
  late final PdfViewerController _pdfController;
  String? _pdfAbsolutePath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _initializeSync();
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _initializeSync() async {
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

      // Inicializa áudio e sincronizador
      await ref.read(audioPlaybackControllerProvider.notifier).loadAudio(
            audioAbs,
            fallbackDurationMs: song.activeSyncVersion!.audioDurationMs,
          );

      await ref.read(manualSyncControllerProvider.notifier).initialize(
            syncId: song.activeSyncVersion!.id,
            audioDurationMs: song.activeSyncVersion!.audioDurationMs,
          );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao carregar dados para sincronização: $e';
        _isLoading = false;
      });
    }
  }

  String _formatMs(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final millis = (ms % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(2, '0')}';
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      // Tecla Espaço no desktop marca o compasso imediatamente!
      ref.read(manualSyncControllerProvider.notifier).markCurrentMeasure();
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(manualSyncControllerProvider);
    final syncNotifier = ref.read(manualSyncControllerProvider.notifier);
    final audioState = ref.watch(audioPlaybackControllerProvider);
    final theme = Theme.of(context);

    if (audioState.isPlaying) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sincronização Manual'),
              Text(
                '${syncState.syncedCount}/${syncState.measures.length} compassos sincronizados',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilledButton.icon(
                key: const Key('go_to_player_button'),
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('Player Inteligente'),
                onPressed: () {
                  context.push('/songs/${widget.songId}/player');
                },
              ),
            ),
          ],
        ),
        body: _buildBody(context, syncState, syncNotifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ManualSyncState syncState,
    ManualSyncController syncNotifier,
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

    final focused = syncState.focusedMeasure;

    return Column(
      children: [
        // 1. Visualizador de Partitura com foco no compasso atual
        Expanded(
          flex: 5,
          child: PdfViewer.file(
            _pdfAbsolutePath!,
            controller: _pdfController,
            params: PdfViewerParams(
              enableTextSelection: false,
              pageOverlaysBuilder: (context, pageRect, page) {
                return [
                  PageMeasureOverlay(
                    pageNumber: page.pageNumber,
                    pageSize: pageRect.size,
                    measures: syncState.measures,
                    mode: EditorMode.select,
                    selectedMeasureId: focused?.id,
                    onMeasureSelected: (id) {
                      final idx = syncState.measures.indexWhere((m) => m.id == id);
                      if (idx != -1) {
                        syncNotifier.setFocusedIndex(idx);
                      }
                    },
                    onRectCreated: (_) {},
                  ),
                ];
              },
            ),
          ),
        ),

        // 2. Painel Inferior de Sincronização e Marcação
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Barra de Áudio (Seek, Play/Pause, Velocidade)
                const AudioControlBar(),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: focused == null
                        ? const Center(child: Text('Nenhum compasso cadastrado.'))
                        : _buildFocusedMeasureControls(context, focused, syncState, syncNotifier),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusedMeasureControls(
    BuildContext context,
    MeasureEntity measure,
    ManualSyncState state,
    ManualSyncController notifier,
  ) {
    final theme = Theme.of(context);
    final hasTimestamp = measure.startMs != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Navegação de compasso e exibição de tempo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
              tooltip: 'Compasso anterior',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: state.focusedIndex > 0 ? notifier.previousMeasure : null,
            ),
            Column(
              children: [
                Text(
                  'Compasso ${measure.displayLabel}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  hasTimestamp
                      ? 'Início: ${_formatMs(measure.startMs!)}'
                      : 'Não sincronizado',
                  style: TextStyle(
                    color: hasTimestamp ? Colors.green.shade700 : theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton.filledTonal(
              tooltip: 'Próximo compasso',
              icon: const Icon(Icons.arrow_forward_rounded),
              onPressed: state.focusedIndex + 1 < state.measures.length
                  ? notifier.nextMeasure
                  : null,
            ),
          ],
        ),

        // Botão Principal Gigante: MARCAR COMPASSO
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            key: const Key('mark_measure_button'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD97706), // Âmbar Vibrante
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.touch_app_rounded, size: 28),
            label: Text(
              'MARCAR COMPASSO ${measure.displayLabel} (Espaço)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: notifier.markCurrentMeasure,
          ),
        ),

        // Ações de ajuste fino caso já tenha tempo gravado
        if (hasTimestamp)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => notifier.adjustCurrentMeasure(-100),
                child: const Text('-100ms'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => notifier.adjustCurrentMeasure(100),
                child: const Text('+100ms'),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.volume_up_rounded, size: 18),
                label: const Text('Ouvir'),
                onPressed: notifier.seekToCurrentMeasure,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.clear_rounded),
                tooltip: 'Limpar marcação',
                onPressed: notifier.clearCurrentMeasure,
              ),
            ],
          ),
      ],
    );
  }
}

