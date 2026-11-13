import 'dart:ui';

/// Representa um retângulo com coordenadas normalizadas no intervalo [0.0..1.0]
/// em relação à largura e altura originais da página do PDF.
class NormalizedRect {
  const NormalizedRect({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  final double x;
  final double y;
  final double w;
  final double h;

  /// Converte um retângulo da tela (em pixels) para coordenadas normalizadas [0..1]
  /// com base no tamanho renderizado da página.
  factory NormalizedRect.fromPixelRect({
    required Rect pixelRect,
    required Size pageSize,
  }) {
    if (pageSize.width <= 0 || pageSize.height <= 0) {
      return const NormalizedRect(x: 0, y: 0, w: 0.1, h: 0.05);
    }

    final normX = (pixelRect.left / pageSize.width).clamp(0.0, 1.0);
    final normY = (pixelRect.top / pageSize.height).clamp(0.0, 1.0);
    final normW = (pixelRect.width / pageSize.width).clamp(0.005, 1.0 - normX);
    final normH = (pixelRect.height / pageSize.height).clamp(0.005, 1.0 - normY);

    return NormalizedRect(
      x: normX,
      y: normY,
      w: normW,
      h: normH,
    );
  }

  /// Converte as coordenadas normalizadas de volta para pixels na página renderizada.
  Rect toPixelRect(Size pageSize) {
    return Rect.fromLTWH(
      x * pageSize.width,
      y * pageSize.height,
      w * pageSize.width,
      h * pageSize.height,
    );
  }

  NormalizedRect copyWith({
    double? x,
    double? y,
    double? w,
    double? h,
  }) {
    return NormalizedRect(
      x: x ?? this.x,
      y: y ?? this.y,
      w: w ?? this.w,
      h: h ?? this.h,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalizedRect &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          w == other.w &&
          h == other.h;

  @override
  int get hashCode => Object.hash(x, y, w, h);

  @override
  String toString() =>
      'NormalizedRect(x: ${x.toStringAsFixed(3)}, y: ${y.toStringAsFixed(3)}, w: ${w.toStringAsFixed(3)}, h: ${h.toStringAsFixed(3)})';
}

