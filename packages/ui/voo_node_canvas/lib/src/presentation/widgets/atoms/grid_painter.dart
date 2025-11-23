import 'package:flutter/material.dart';

/// A custom painter that draws the canvas background grid.
///
/// This painter efficiently renders a grid pattern that can be used
/// as visual alignment aids on the infinite canvas.
class GridPainter extends CustomPainter {
  /// Creates a grid painter.
  const GridPainter({
    required this.gridSize,
    required this.offset,
    required this.zoom,
    this.color,
  });

  /// The size of grid cells in logical pixels.
  final double gridSize;

  /// The current viewport offset.
  final Offset offset;

  /// The current zoom level.
  final double zoom;

  /// The color of grid lines.
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final gridColor = color ?? Colors.grey.withValues(alpha: 0.2);
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0 / zoom;

    final scaledGridSize = gridSize * zoom;

    // Calculate the starting position for grid lines
    final startX = offset.dx % scaledGridSize;
    final startY = offset.dy % scaledGridSize;

    // Draw vertical lines
    for (double x = startX; x <= size.width; x += scaledGridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = startY; y <= size.height; y += scaledGridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      gridSize != oldDelegate.gridSize ||
      offset != oldDelegate.offset ||
      zoom != oldDelegate.zoom ||
      color != oldDelegate.color;
}

/// A widget that displays the canvas grid background.
class CanvasGrid extends StatelessWidget {
  /// Creates a canvas grid widget.
  const CanvasGrid({
    required this.gridSize,
    required this.offset,
    required this.zoom,
    this.color,
    super.key,
  });

  /// The size of grid cells in logical pixels.
  final double gridSize;

  /// The current viewport offset.
  final Offset offset;

  /// The current zoom level.
  final double zoom;

  /// The color of grid lines.
  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: GridPainter(
          gridSize: gridSize,
          offset: offset,
          zoom: zoom,
          color: color,
        ),
        size: Size.infinite,
      );
}
