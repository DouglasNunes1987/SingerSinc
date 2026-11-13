import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// Visualizador de partituras em PDF de alta performance baseado em `pdfrx` (PDFium).
class ScoreViewerWidget extends StatefulWidget {
  const ScoreViewerWidget({
    required this.pdfFilePath,
    this.initialPage = 1,
    this.onPageChanged,
    super.key,
  });

  final String pdfFilePath;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;

  @override
  State<ScoreViewerWidget> createState() => ScoreViewerWidgetState();
}

class ScoreViewerWidgetState extends State<ScoreViewerWidget> {
  late final PdfViewerController _pdfController;
  int _currentPage = 1;
  int _pageCount = 0;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Pula diretamente para uma página específica (1-based).
  Future<void> goToPage(int pageNumber) async {
    if (pageNumber >= 1 && pageNumber <= _pageCount) {
      await _pdfController.goToPage(pageNumber: pageNumber);
    }
  }

  /// Retorna o controlador subjacente do `pdfrx`.
  PdfViewerController get pdfController => _pdfController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final file = File(widget.pdfFilePath);

    if (!file.existsSync()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Arquivo de partitura não encontrado no dispositivo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Componente Principal de Renderização PDF
        PdfViewer.file(
          widget.pdfFilePath,
          controller: _pdfController,
          params: PdfViewerParams(
            enableTextSelection: false,
            maxScale: 4.0,
            minScale: 0.8,
            onViewerReady: (document, controller) {
              setState(() {
                _pageCount = document.pages.length;
                _isReady = true;
                _currentPage = controller.pageNumber ?? 1;
              });
            },
            onPageChanged: (pageNumber) {
              if (pageNumber != null) {
                setState(() {
                  _currentPage = pageNumber;
                });
                widget.onPageChanged?.call(pageNumber);
              }
            },
          ),
        ),

        // Barra Flutuante de Controle de Páginas e Zoom
        if (_isReady && _pageCount > 0)
          Positioned(
            top: 12,
            right: 12,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: theme.colorScheme.surface.withValues(alpha: 0.92),
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
                          ? () => goToPage(_currentPage - 1)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '$_currentPage / $_pageCount',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: 'Próxima página',
                      visualDensity: VisualDensity.compact,
                      onPressed: _currentPage < _pageCount
                          ? () => goToPage(_currentPage + 1)
                          : null,
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 1,
                      height: 16,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.zoom_in_rounded),
                      tooltip: 'Aproximar zoom',
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _pdfController.zoomUp();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_out_rounded),
                      tooltip: 'Afastar zoom',
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _pdfController.zoomDown();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

