import 'package:singersinc/features/editor/domain/entities/measure_region_entity.dart';

/// Entidade de domínio representando um compasso em ordem de reprodução linear na partitura.
class MeasureEntity {
  const MeasureEntity({
    required this.id,
    required this.syncId,
    required this.measureOrder,
    this.measureLabel = '',
    this.startMs,
    this.regions = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String syncId;
  final int measureOrder;
  final String measureLabel;
  final int? startMs;
  final List<MeasureRegionEntity> regions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Retorna o rótulo exibível do compasso (ex.: "1", "2", ou rótulo customizado).
  String get displayLabel =>
      measureLabel.trim().isNotEmpty ? measureLabel.trim() : '$measureOrder';

  MeasureEntity copyWith({
    String? id,
    String? syncId,
    int? measureOrder,
    String? measureLabel,
    int? startMs,
    List<MeasureRegionEntity>? regions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeasureEntity(
      id: id ?? this.id,
      syncId: syncId ?? this.syncId,
      measureOrder: measureOrder ?? this.measureOrder,
      measureLabel: measureLabel ?? this.measureLabel,
      startMs: startMs ?? this.startMs,
      regions: regions ?? this.regions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          syncId == other.syncId &&
          measureOrder == other.measureOrder &&
          measureLabel == other.measureLabel &&
          startMs == other.startMs;

  @override
  int get hashCode => Object.hash(id, syncId, measureOrder, measureLabel, startMs);
}

