import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';

/// A widget that displays a single connection port.
///
/// Ports are the visual indicators where connections can be made.
/// They respond to tap and drag gestures for creating connections.
class PortWidget extends StatefulWidget {
  /// Creates a port widget.
  const PortWidget({
    required this.port,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.radius = 6.0,
    this.hitTolerance = 20.0,
    this.color,
    this.highlightColor,
    this.isHighlighted = false,
    this.isConnected = false,
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

  /// The hit tolerance for detecting taps/drags on the port.
  ///
  /// This creates an invisible hit area larger than the visual port,
  /// making it easier to interact with small ports. Defaults to 20.0.
  final double hitTolerance;

  /// The color of the port indicator.
  final Color? color;

  /// The color to use when the port is highlighted.
  final Color? highlightColor;

  /// Whether this port is highlighted (e.g., as a valid drop target).
  final bool isHighlighted;

  /// Whether this port has an active connection.
  final bool isConnected;

  @override
  State<PortWidget> createState() => _PortWidgetState();
}

class _PortWidgetState extends State<PortWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine base color: port-specific > widget-provided > type-based default
    final baseColor = widget.port.color ??
        widget.color ??
        (widget.port.type == PortType.input
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary);

    // Determine connected color
    final connectedColor = widget.port.connectedColor ?? baseColor;

    // Determine highlight color
    final highlightColor = widget.port.highlightColor ??
        widget.highlightColor ??
        HSLColor.fromColor(baseColor).withLightness(0.7).toColor();

    // Calculate effective display color based on state
    Color effectiveColor;
    if (widget.isHighlighted) {
      effectiveColor = highlightColor;
    } else if (_isHovered) {
      effectiveColor =
          HSLColor.fromColor(baseColor).withLightness(0.6).toColor();
    } else if (widget.isConnected) {
      effectiveColor = connectedColor;
    } else {
      effectiveColor = baseColor;
    }

    // Border color for highlighted/hovered states
    final borderColor = widget.isHighlighted
        ? highlightColor
        : (_isHovered ? baseColor : null);

    // Calculate hit area size (minimum of hit tolerance or visual size)
    final hitSize = widget.hitTolerance.clamp(widget.radius * 2, double.infinity);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onPanStart: (_) => widget.onDragStart(),
      onPanUpdate: widget.onDragUpdate,
      onPanEnd: (_) => widget.onDragEnd(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          // Larger hit area with transparent padding
          width: hitSize,
          height: hitSize,
          color: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _isHovered || widget.isHighlighted
                  ? widget.radius * 2.5
                  : widget.radius * 2,
              height: _isHovered || widget.isHighlighted
                  ? widget.radius * 2.5
                  : widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveColor,
                border: borderColor != null
                    ? Border.all(
                        color: borderColor,
                        width: 2,
                      )
                    : null,
                boxShadow: widget.isHighlighted || _isHovered
                    ? [
                        BoxShadow(
                          color: effectiveColor.withValues(alpha: 0.5),
                          blurRadius: _isHovered ? 12 : 8,
                          spreadRadius: _isHovered ? 3 : 2,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
