import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/connection_style.dart';
import 'package:voo_node_canvas/src/domain/enums/port_position.dart';

/// A custom painter that draws a connection line between two points.
///
/// Supports multiple connection styles including straight, bezier,
/// and stepped connections. The bezier curves adapt based on the
/// port positions to create natural-looking connections.
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
    this.sourcePosition,
    this.targetPosition,
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

  /// The position of the source port (which side of the node it's on).
  ///
  /// Used to determine the direction of bezier control points.
  /// If null, defaults to [PortPosition.right] for the source.
  final PortPosition? sourcePosition;

  /// The position of the target port (which side of the node it's on).
  ///
  /// Used to determine the direction of bezier control points.
  /// If null, defaults to [PortPosition.left] for the target.
  final PortPosition? targetPosition;

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

        // Calculate control points based on port positions
        final sourcePos = sourcePosition ?? PortPosition.right;
        final targetPos = targetPosition ?? PortPosition.left;

        final sourceControl = _getControlPoint(start, sourcePos, true);
        final targetControl = _getControlPoint(end, targetPos, false);

        path.cubicTo(
          sourceControl.dx,
          sourceControl.dy,
          targetControl.dx,
          targetControl.dy,
          end.dx,
          end.dy,
        );

      case ConnectionStyle.stepped:
        path.moveTo(start.dx, start.dy);
        _createSteppedPath(path);
    }

    return path;
  }

  /// Gets the control point offset for a bezier curve based on port position.
  Offset _getControlPoint(Offset point, PortPosition position, bool isSource) {
    // Distance for the control point from the port
    final distance = (end - start).distance.clamp(50.0, 150.0) * 0.4;

    switch (position) {
      case PortPosition.left:
        return Offset(point.dx - distance, point.dy);
      case PortPosition.right:
        return Offset(point.dx + distance, point.dy);
      case PortPosition.top:
        return Offset(point.dx, point.dy - distance);
      case PortPosition.bottom:
        return Offset(point.dx, point.dy + distance);
    }
  }

  /// Creates a stepped path that handles all port position combinations.
  void _createSteppedPath(ui.Path path) {
    final sourcePos = sourcePosition ?? PortPosition.right;
    final targetPos = targetPosition ?? PortPosition.left;

    // Horizontal source, horizontal target
    if (_isHorizontal(sourcePos) && _isHorizontal(targetPos)) {
      final midX = (start.dx + end.dx) / 2;
      path.lineTo(midX, start.dy);
      path.lineTo(midX, end.dy);
      path.lineTo(end.dx, end.dy);
    }
    // Vertical source, vertical target
    else if (_isVertical(sourcePos) && _isVertical(targetPos)) {
      final midY = (start.dy + end.dy) / 2;
      path.lineTo(start.dx, midY);
      path.lineTo(end.dx, midY);
      path.lineTo(end.dx, end.dy);
    }
    // Horizontal source, vertical target
    else if (_isHorizontal(sourcePos) && _isVertical(targetPos)) {
      path.lineTo(end.dx, start.dy);
      path.lineTo(end.dx, end.dy);
    }
    // Vertical source, horizontal target
    else {
      path.lineTo(start.dx, end.dy);
      path.lineTo(end.dx, end.dy);
    }
  }

  bool _isHorizontal(PortPosition pos) =>
      pos == PortPosition.left || pos == PortPosition.right;

  bool _isVertical(PortPosition pos) =>
      pos == PortPosition.top || pos == PortPosition.bottom;

  void _drawArrow(Canvas canvas, Paint paint) {
    const arrowSize = 8.0;

    // Calculate the direction at the end of the path based on target port position
    final targetPos = targetPosition ?? PortPosition.left;
    Offset direction;

    switch (style) {
      case ConnectionStyle.straight:
        direction = (end - start).normalize();
      case ConnectionStyle.bezier:
        // Use the direction the connection approaches the target
        direction = _getArrowDirection(targetPos);
      case ConnectionStyle.stepped:
        // Arrow direction based on target position
        direction = _getArrowDirection(targetPos);
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

  /// Gets the arrow direction based on target port position.
  Offset _getArrowDirection(PortPosition targetPos) {
    switch (targetPos) {
      case PortPosition.left:
        return const Offset(-1, 0); // Arrow points left (into left port)
      case PortPosition.right:
        return const Offset(1, 0); // Arrow points right (into right port)
      case PortPosition.top:
        return const Offset(0, -1); // Arrow points up (into top port)
      case PortPosition.bottom:
        return const Offset(0, 1); // Arrow points down (into bottom port)
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) =>
      start != oldDelegate.start ||
      end != oldDelegate.end ||
      style != oldDelegate.style ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      isSelected != oldDelegate.isSelected ||
      isDragging != oldDelegate.isDragging ||
      sourcePosition != oldDelegate.sourcePosition ||
      targetPosition != oldDelegate.targetPosition;
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
    this.sourcePosition,
    this.targetPosition,
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

  /// The position of the source port.
  final PortPosition? sourcePosition;

  /// The position of the target port.
  final PortPosition? targetPosition;

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
          sourcePosition: sourcePosition,
          targetPosition: targetPosition,
        ),
        size: Size.infinite,
      ),
    );
  }
}
