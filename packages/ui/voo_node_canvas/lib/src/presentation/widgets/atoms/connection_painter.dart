import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/connection_style.dart';

/// A custom painter that draws a connection line between two points.
///
/// Supports multiple connection styles including straight, bezier,
/// and stepped connections.
class ConnectionPainter extends CustomPainter {
  /// Creates a connection painter.
  const ConnectionPainter({
    required this.start,
    required this.end,
    this.style = ConnectionStyle.bezier,
    this.color,
    this.strokeWidth = 2.0,
    this.isSelected = false,
    this.selectedColor,
    this.isDragging = false,
  });

  /// The starting point of the connection.
  final Offset start;

  /// The ending point of the connection.
  final Offset end;

  /// The visual style of the connection.
  final ConnectionStyle style;

  /// The color of the connection line.
  final Color? color;

  /// The width of the connection line.
  final double strokeWidth;

  /// Whether this connection is selected.
  final bool isSelected;

  /// The color to use when selected.
  final Color? selectedColor;

  /// Whether this connection is being drawn (during drag).
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveColor = isSelected
        ? (selectedColor ?? Colors.blue)
        : (color ?? Colors.grey);

    final paint = Paint()
      ..color = effectiveColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (isDragging) {
      paint.color = paint.color.withValues(alpha: 0.6);
    }

    final path = _createPath();
    canvas.drawPath(path, paint);

    // Draw arrow at the end
    _drawArrow(canvas, paint);
  }

  ui.Path _createPath() {
    final path = ui.Path();

    switch (style) {
      case ConnectionStyle.straight:
        path.moveTo(start.dx, start.dy);
        path.lineTo(end.dx, end.dy);

      case ConnectionStyle.bezier:
        path.moveTo(start.dx, start.dy);
        final controlOffset = (end.dx - start.dx).abs() / 2;
        path.cubicTo(
          start.dx + controlOffset,
          start.dy,
          end.dx - controlOffset,
          end.dy,
          end.dx,
          end.dy,
        );

      case ConnectionStyle.stepped:
        path.moveTo(start.dx, start.dy);
        final midX = (start.dx + end.dx) / 2;
        path.lineTo(midX, start.dy);
        path.lineTo(midX, end.dy);
        path.lineTo(end.dx, end.dy);
    }

    return path;
  }

  void _drawArrow(Canvas canvas, Paint paint) {
    const arrowSize = 8.0;

    // Calculate the direction at the end of the path
    Offset direction;
    switch (style) {
      case ConnectionStyle.straight:
      case ConnectionStyle.bezier:
        direction = (end - start).normalize();
      case ConnectionStyle.stepped:
        direction = const Offset(1, 0); // Arrow always points right for stepped
    }

    final arrowPoint1 = end -
        direction * arrowSize +
        Offset(-direction.dy, direction.dx) * arrowSize / 2;
    final arrowPoint2 = end -
        direction * arrowSize -
        Offset(-direction.dy, direction.dx) * arrowSize / 2;

    final arrowPath = ui.Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();

    canvas.drawPath(
      arrowPath,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) =>
      start != oldDelegate.start ||
      end != oldDelegate.end ||
      style != oldDelegate.style ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      isSelected != oldDelegate.isSelected ||
      isDragging != oldDelegate.isDragging;
}

/// Extension to normalize an Offset.
extension OffsetNormalize on Offset {
  /// Returns a normalized version of this offset.
  Offset normalize() {
    final length = distance;
    if (length == 0) return Offset.zero;
    return this / length;
  }
}

/// A widget that displays a single connection.
class ConnectionWidget extends StatelessWidget {
  /// Creates a connection widget.
  const ConnectionWidget({
    required this.start,
    required this.end,
    this.style = ConnectionStyle.bezier,
    this.color,
    this.strokeWidth = 2.0,
    this.isSelected = false,
    this.selectedColor,
    this.isDragging = false,
    this.onTap,
    super.key,
  });

  /// The starting point of the connection.
  final Offset start;

  /// The ending point of the connection.
  final Offset end;

  /// The visual style of the connection.
  final ConnectionStyle style;

  /// The color of the connection line.
  final Color? color;

  /// The width of the connection line.
  final double strokeWidth;

  /// Whether this connection is selected.
  final bool isSelected;

  /// The color to use when selected.
  final Color? selectedColor;

  /// Whether this connection is being drawn (during drag).
  final bool isDragging;

  /// Called when the connection is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: CustomPaint(
        painter: ConnectionPainter(
          start: start,
          end: end,
          style: style,
          color: color,
          strokeWidth: strokeWidth,
          isSelected: isSelected,
          selectedColor: selectedColor,
          isDragging: isDragging,
        ),
        size: Size.infinite,
      ),
    );
  }
}
