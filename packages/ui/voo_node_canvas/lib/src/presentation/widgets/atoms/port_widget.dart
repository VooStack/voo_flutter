import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';

/// A widget that displays a single connection port.
///
/// Ports are the visual indicators where connections can be made.
/// They respond to tap and drag gestures for creating connections.
class PortWidget extends StatelessWidget {
  /// Creates a port widget.
  const PortWidget({
    required this.port,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.radius = 6.0,
    this.color,
    this.isHighlighted = false,
    super.key,
  });

  /// The port data to display.
  final NodePort port;

  /// Called when the port is tapped.
  final VoidCallback onTap;

  /// Called when a drag starts from this port.
  final VoidCallback onDragStart;

  /// Called when dragging from this port.
  final void Function(DragUpdateDetails) onDragUpdate;

  /// Called when a drag ends on this port.
  final VoidCallback onDragEnd;

  /// The radius of the port indicator.
  final double radius;

  /// The color of the port indicator.
  final Color? color;

  /// Whether this port is highlighted (e.g., as a valid drop target).
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = port.color ??
        color ??
        (port.type == PortType.input
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary);

    return GestureDetector(
      onTap: onTap,
      onPanStart: (_) => onDragStart(),
      onPanUpdate: onDragUpdate,
      onPanEnd: (_) => onDragEnd(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: effectiveColor,
            border: isHighlighted
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
