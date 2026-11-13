import 'package:flutter/material.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';
import 'package:singersinc/features/editor/presentation/controllers/editor_controller.dart';

/// Overlay visual renderizado sobre uma página do PDF para exibir, selecionar e
/// desenhar retângulos de compassos em tempo real.
class PageMeasureOverlay extends StatefulWidget {
  const PageMeasureOverlay({
    required this.pageNumber,
    required this.pageSize,
    required this.measures,
    required this.mode,
    required this.selectedMeasureId,
    required this.onMeasureSelected,
    required this.onRectCreated,
    super.key,
  });

  final int pageNumber;
  final Size pageSize;
  final List<MeasureEntity> measures;
  final EditorMode mode;
  final String? selectedMeasureId;
  final ValueChanged<String> onMeasureSelected;
  final ValueChanged<NormalizedRect> onRectCreated;

  @override
  State<PageMeasureOverlay> createState() => _PageMeasureOverlayState();
}

class _PageMeasureOverlayState extends State<PageMeasureOverlay> {
  Offset? _startPoint;
  Offset? _currentPoint;

  Rect? get _draggedRect {
    if (_startPoint == null || _currentPoint == null) return null;
    return Rect.fromPoints(_startPoint!, _currentPoint!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDrawingMode = widget.mode == EditorMode.draw || widget.mode == EditorMode.addRegion;

    // Filtra as regiões pertencentes a esta página
    final regionsOnThisPage = <({MeasureEntity measure, NormalizedRect rect, String regionId})>[];
    for (final measure in widget.measures) {
      for (final region in measure.regions) {
        if (region.pageNumber == widget.pageNumber) {
          regionsOnThisPage.add((
            measure: measure,
            rect: region.rect,
            regionId: region.id,
          ));
        }
      }
    }

    return SizedBox(
      width: widget.pageSize.width,
      height: widget.pageSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Renderiza os compassos já cadastrados nesta página
          for (final item in regionsOnThisPage)
            _buildMeasureBox(
              context,
              item.measure,
              item.rect,
              item.measure.id == widget.selectedMeasureId,
            ),

          // 2. Retângulo elástico em tempo real enquanto o professor está arrastando
          if (_draggedRect != null)
            Positioned.fromRect(
              rect: _draggedRect!,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.mode == EditorMode.addRegion ? '+Região' : 'Novo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 3. Captura de gestos no modo de desenho
          if (isDrawingMode)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) {
                  setState(() {
                    _startPoint = details.localPosition;
                    _currentPoint = details.localPosition;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentPoint = details.localPosition;
                  });
                },
                onPanEnd: (_) {
                  final rect = _draggedRect;
                  setState(() {
                    _startPoint = null;
                    _currentPoint = null;
                  });

                  if (rect != null && rect.width >= 15 && rect.height >= 15) {
                    final normalized = NormalizedRect.fromPixelRect(
                      pixelRect: rect,
                      pageSize: widget.pageSize,
                    );
                    widget.onRectCreated(normalized);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeasureBox(
    BuildContext context,
    MeasureEntity measure,
    NormalizedRect normRect,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final pixelRect = normRect.toPixelRect(widget.pageSize);

    final borderColor = isSelected
        ? const Color(0xFFD97706) // Âmbar para selecionado
        : theme.colorScheme.primary.withValues(alpha: 0.85);

    final fillColor = isSelected
        ? const Color(0xFFD97706).withValues(alpha: 0.18)
        : theme.colorScheme.primary.withValues(alpha: 0.08);

    return Positioned.fromRect(
      rect: pixelRect,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onMeasureSelected(measure.id);
        },
        child: Container(
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                measure.displayLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

