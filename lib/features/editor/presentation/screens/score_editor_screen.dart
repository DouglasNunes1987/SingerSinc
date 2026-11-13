import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:singersinc/core/storage/local_file_storage.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';
import 'package:singersinc/features/editor/presentation/widgets/score_editor_overlay.dart';
import 'package:singersinc/features/player/presentation/screens/song_preview_screen.dart';

/// Tela completa do Editor de Partituras para delimitação visual de compassos (Etapa 4).
class ScoreEditorScreen extends ConsumerStatefulWidget {
  const ScoreEditorScreen({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  ConsumerState<ScoreEditorScreen> createState() => _ScoreEditorScreenState();
}

class _ScoreEditorScreenState extends ConsumerState<ScoreEditorScreen> {
  late final PdfViewerController _pdfController;
  String? _pdfAbsolutePath;
  int _currentPage = 1;
  int _pageCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _initializeEditor();
  }

  Future<void> _initializeEditor() async {
    try {
      final song = await ref.read(songDetailsProvider(widget.songId).future);
      if (song == null) {
        setState(() {
          _errorMessage = 'Música não encontrada.';
          _isLoading = false;
        });
        return;
      }

      final activeSync = song.activeSyncVersion;
      final activePdf = song.activePdfAsset;

      if (activeSync == null || activePdf?.localPath == null) {
        setState(() {
          _errorMessage = 'Partitura PDF não encontrada para esta música.';
          _isLoading = false;
        });
        return;
      }

      final storage = ref.read(localFileStorageProvider);
      final absPath = await storage.resolveAbsolutePath(activePdf!.localPath!);

      if (!mounted) return;

      setState(() {
        _pdfAbsolutePath = absPath;
        _isLoading = false;
      });

      // Carrega os compassos já cadastrados no SQLite
      await ref.read(editorControllerProvider.notifier).loadMeasures(activeSync.id);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erro ao inicializar editor: $e';
        _isLoading = false;
      });
    }
  }

  void _showEditLabelDialog(String measureId, String currentLabel) {
    final textController = TextEditingController(text: currentLabel);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Rótulo do Compasso'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Rótulo (ex.: 1, 2a, Coda)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(editorControllerProvider.notifier).updateMeasureLabel(
                    measureId: measureId,
                    newLabel: textController.text.trim(),
                  );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorControllerProvider);
    final editorNotifier = ref.read(editorControllerProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<EditorState>(editorControllerProvider, (prev, next) {
      if (next.successMessage != null && next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editor de Compassos'),
            Text(
              '${editorState.measures.length} compasso(s) delimitado(s)',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          // Botão de alternar modo Desenhar / Navegar
          SegmentedButton<EditorMode>(
            segments: const [
              ButtonSegment(
                value: EditorMode.draw,
                icon: Icon(Icons.crop_square_rounded),
                label: Text('Desenhar'),
              ),
              ButtonSegment(
                value: EditorMode.view,
                icon: Icon(Icons.pan_tool_outlined),
                label: Text('Navegar'),
              ),
            ],
            selected: {
              editorState.mode == EditorMode.view ? EditorMode.view : EditorMode.draw,
            },
            onSelectionChanged: (set) {
              editorNotifier.setMode(set.first);
            },
          ),
          const SizedBox(width: 8),

          // Botão para avançar para a Sincronização do Áudio
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              key: const Key('go_to_sync_button'),
              icon: const Icon(Icons.music_note_rounded),
              label: const Text('Sincronizar'),
              onPressed: editorState.measures.isEmpty
                  ? null
                  : () {
                      context.push('/songs/${widget.songId}/sync');
                    },
            ),
          ),
        ],
      ),
      body: _buildContent(context, editorState, editorNotifier),
      bottomNavigationBar: _buildBottomPanel(context, editorState, editorNotifier),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EditorState editorState,
    EditorController editorNotifier,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    final file = File(_pdfAbsolutePath!);
    if (!file.existsSync()) {
      return const Center(
        child: Text('Arquivo PDF não encontrado localmente.'),
      );
    }

    return Stack(
      children: [
        // Componente Principal pdfrx com Overlay de marcação
        PdfViewer.file(
          _pdfAbsolutePath!,
          controller: _pdfController,
          params: PdfViewerParams(
            enableTextSelection: false,
            maxScale: 4.0,
            minScale: 0.8,
            onViewerReady: (document, controller) {
              setState(() {
                _pageCount = document.pages.length;
                _currentPage = controller.pageNumber ?? 1;
              });
            },
            onPageChanged: (page) {
              if (page != null) {
                setState(() {
                  _currentPage = page;
                });
                editorNotifier.setActivePage(page);
              }
            },
            pageOverlaysBuilder: (context, pageRect, page) {
              return [
                PageMeasureOverlay(
                  pageNumber: page.pageNumber,
                  pageSize: pageRect.size,
                  measures: editorState.measures,
                  mode: editorState.mode,
                  selectedMeasureId: editorState.selectedMeasureId,
                  onMeasureSelected: (id) {
                    editorNotifier.selectMeasure(id);
                  },
                  onRectCreated: (rect) {
                    if (editorState.mode == EditorMode.addRegion) {
                      editorNotifier.addRegionToSelectedMeasure(
                        pageNumber: page.pageNumber,
                        rect: rect,
                      );
                    } else {
                      editorNotifier.addMeasureFromRect(
                        pageNumber: page.pageNumber,
                        rect: rect,
                      );
                    }
                  },
                ),
              ];
            },
          ),
        ),

        // Barra Flutuante de Páginas e Zoom
        if (_pageCount > 0)
          Positioned(
            top: 12,
            right: 12,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Página anterior',
                      visualDensity: VisualDensity.compact,
                      onPressed: _currentPage > 1
                          ? () => _pdfController.goToPage(pageNumber: _currentPage - 1)
                          : null,
                    ),
                    Text(
                      '$_currentPage / $_pageCount',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: 'Próxima página',
                      visualDensity: VisualDensity.compact,
                      onPressed: _currentPage < _pageCount
                          ? () => _pdfController.goToPage(pageNumber: _currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildBottomPanel(
    BuildContext context,
    EditorState state,
    EditorController notifier,
  ) {
    final theme = Theme.of(context);
    final selected = state.selectedMeasure;

    if (selected == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Icon(Icons.touch_app_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  state.mode == EditorMode.draw
                      ? 'Arraste o dedo ou mouse sobre a partitura para marcar o próximo compasso.'
                      : 'Toque em um compasso marcado para editar, renomear ou excluir.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compasso ${selected.displayLabel}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ordem: ${selected.measureOrder} • ${selected.regions.length} região(ões)',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Rótulo'),
              onPressed: () => _showEditLabelDialog(selected.id, selected.displayLabel),
            ),
            const SizedBox(width: 4),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_box_outlined, size: 18),
              label: const Text('+ Região'),
              onPressed: () {
                notifier.setMode(EditorMode.addRegion);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Desenhe a região adicional na partitura para este compasso.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              tooltip: 'Excluir compasso',
              onPressed: () => notifier.deleteMeasure(selected.id),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Fechar seleção',
              onPressed: () => notifier.selectMeasure(null),
            ),
          ],
        ),
      ),
    );
  }
}

