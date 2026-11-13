import 'package:singersinc/features/editor/domain/models/normalized_rect.dart';

/// Entidade de domínio representando uma região retangular visual de um compasso na partitura.
class MeasureRegionEntity {
  const MeasureRegionEntity({
    required this.id,
    required this.measureId,
    required this.regionOrder,
    required this.pageNumber,
    required this.rect,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String measureId;
  final int regionOrder;
  final int pageNumber;
  final NormalizedRect rect;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MeasureRegionEntity copyWith({
    String? id,
    String? measureId,
    int? regionOrder,
    int? pageNumber,
    NormalizedRect? rect,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeasureRegionEntity(
      id: id ?? this.id,
      measureId: measureId ?? this.measureId,
      regionOrder: regionOrder ?? this.regionOrder,
      pageNumber: pageNumber ?? this.pageNumber,
      rect: rect ?? this.rect,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureRegionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          measureId == other.measureId &&
          regionOrder == other.regionOrder &&
          pageNumber == other.pageNumber &&
          rect == other.rect;

  @override
  int get hashCode => Object.hash(id, measureId, regionOrder, pageNumber, rect);
}

