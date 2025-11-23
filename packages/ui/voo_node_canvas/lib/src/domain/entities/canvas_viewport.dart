import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents the viewport state of the canvas.
///
/// The viewport defines what portion of the infinite canvas
/// is currently visible, including the pan offset and zoom level.
class CanvasViewport extends Equatable {
  /// Creates a canvas viewport.
  const CanvasViewport({
    this.offset = Offset.zero,
    this.zoom = 1.0,
  }) : assert(zoom > 0, 'Zoom must be positive');

  /// Creates a viewport from JSON.
  factory CanvasViewport.fromJson(Map<String, dynamic> json) => CanvasViewport(
        offset: json['offset'] != null
            ? Offset(
                (json['offset']['dx'] as num).toDouble(),
                (json['offset']['dy'] as num).toDouble(),
              )
            : Offset.zero,
        zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
      );

  /// The pan offset of the viewport (in logical pixels).
  final Offset offset;

  /// The current zoom level.
  final double zoom;

  /// Transforms a point from screen coordinates to canvas coordinates.
  Offset screenToCanvas(Offset screenPoint) => Offset(
        (screenPoint.dx - offset.dx) / zoom,
        (screenPoint.dy - offset.dy) / zoom,
      );

  /// Transforms a point from canvas coordinates to screen coordinates.
  Offset canvasToScreen(Offset canvasPoint) => Offset(
        canvasPoint.dx * zoom + offset.dx,
        canvasPoint.dy * zoom + offset.dy,
      );

  /// Returns the transformation matrix for this viewport.
  Matrix4 get transformMatrix {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 3, offset.dx);
    matrix.setEntry(1, 3, offset.dy);
    matrix.setEntry(0, 0, zoom);
    matrix.setEntry(1, 1, zoom);
    return matrix;
  }

  /// Converts this viewport to JSON.
  Map<String, dynamic> toJson() => {
        if (offset != Offset.zero) 'offset': {'dx': offset.dx, 'dy': offset.dy},
        if (zoom != 1.0) 'zoom': zoom,
      };

  /// Creates a copy of this viewport with optional new values.
  CanvasViewport copyWith({
    Offset? offset,
    double? zoom,
  }) =>
      CanvasViewport(
        offset: offset ?? this.offset,
        zoom: zoom ?? this.zoom,
      );

  @override
  List<Object?> get props => [offset, zoom];
}
