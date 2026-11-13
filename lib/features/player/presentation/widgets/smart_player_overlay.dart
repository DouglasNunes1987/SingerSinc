import 'package:flutter/material.dart';
import 'package:singersinc/features/editor/domain/entities/measure_entity.dart';
import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';

/// Overlay do Player Inteligente que destaca visualmente o compasso ativo na partitura
/// e permite saltar a reprodução do áudio ao tocar diretamente em qualquer compasso.
class SmartPlayerOverlay extends StatelessWidget {
  const SmartPlayerOverlay({
    required this.pageNumber,
    required this.pageSize,
    required this.measures,
    required this.activeMeasureId,
    required this.onMeasureTap,
    super.key,
  });

  final int pageNumber;
  final Size pageSize;
  final List<MeasureEntity> measures;
  final String? activeMeasureId;
  final ValueChanged<String> onMeasureTap;

  @override
  Widget build(BuildContext context) {
    final regionsOnThisPage = <({MeasureEntity measure, NormalizedRect rect})>[];
    for (final measure in measures) {
      for (final region in measure.regions) {
        if (region.pageNumber == pageNumber) {
          regionsOnThisPage.add((measure: measure, rect: region.rect));
        }
      }
    }

    return SizedBox(
      width: pageSize.width,
      height: pageSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final item in regionsOnThisPage)
            _buildMeasureBox(
              context,
              item.measure,
              item.rect,
              item.measure.id == activeMeasureId,
            ),
        ],
      ),
    );
  }

  Widget _buildMeasureBox(
    BuildContext context,
    MeasureEntity measure,
    NormalizedRect normRect,
    bool isActive,
  ) {
    final pixelRect = normRect.toPixelRect(pageSize);

    // Cores de destaque: âmbar brilhante para o compasso ativo com preenchimento semitransparente
    final borderColor = isActive
        ? const Color(0xFFD97706)
        : Colors.blueGrey.withValues(alpha: 0.35);

    final fillColor = isActive
        ? const Color(0xFFF59E0B).withValues(alpha: 0.28)
        : Colors.transparent;

    return Positioned.fromRect(
      rect: pixelRect,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onMeasureTap(measure.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              color: borderColor,
              width: isActive ? 2.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFD97706).withValues(alpha: 0.35),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                measure.displayLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isActive ? 11 : 9,
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

