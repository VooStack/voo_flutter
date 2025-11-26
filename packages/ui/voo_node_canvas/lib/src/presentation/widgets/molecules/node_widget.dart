import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_position.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';
import 'package:voo_node_canvas/src/presentation/widgets/atoms/port_widget.dart';

/// A widget that displays a draggable node on the canvas.
///
/// Nodes are the primary interactive elements on the canvas.
/// They can be dragged, selected, and connected to other nodes.
class NodeWidget extends StatelessWidget {
  /// Creates a node widget.
  const NodeWidget({
    required this.node,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    required this.onPortTap,
    required this.onPortDragStart,
    required this.onPortDragUpdate,
    required this.onPortDragEnd,
    this.portRadius = 6.0,
    this.portHitTolerance = 20.0,
    this.selectedColor,
    this.portColor,
    this.portHighlightColor,
    this.draggingOpacity = 0.8,
    this.highlightedPortType,
    this.connectedPortIds = const {},
    super.key,
  });

  /// The node data to display.
  final CanvasNode node;

  /// Called when dragging starts.
  final VoidCallback onDragStart;

  /// Called when the node is dragged.
  final void Function(DragUpdateDetails) onDragUpdate;

  /// Called when dragging ends.
  final VoidCallback onDragEnd;

  /// Called when the node is tapped.
  final VoidCallback onTap;

  /// Called when a port is tapped.
  final void Function(NodePort) onPortTap;

  /// Called when a drag starts from a port.
  final void Function(NodePort) onPortDragStart;

  /// Called when dragging from a port.
  final void Function(NodePort, DragUpdateDetails) onPortDragUpdate;

  /// Called when a drag ends on a port.
  final void Function(NodePort) onPortDragEnd;

  /// The radius of port indicators.
  final double portRadius;

  /// The hit tolerance for detecting taps/drags on ports.
  ///
  /// This creates an invisible hit area larger than the visual port,
  /// making it easier to interact with small ports. Defaults to 20.0.
  final double portHitTolerance;

  /// The color to use when selected.
  final Color? selectedColor;

  /// The default color for ports.
  final Color? portColor;

  /// The color used for port highlight effects.
  final Color? portHighlightColor;

  /// The opacity when dragging.
  final double draggingOpacity;

  /// The port type to highlight as valid connection targets.
  ///
  /// When a connection is being created, ports of this type
  /// will be highlighted to indicate they are valid targets.
  final PortType? highlightedPortType;

  /// Set of port IDs that currently have active connections.
  ///
  /// Used to display connected state on ports.
  final Set<String> connectedPortIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSelectedColor =
        selectedColor ?? theme.colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: AnimatedScale(
        scale: node.isDragging ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: node.isDragging ? draggingOpacity : 1.0,
          duration: const Duration(milliseconds: 100),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            onPanStart: (_) => onDragStart(),
            onPanUpdate: onDragUpdate,
            onPanEnd: (_) => onDragEnd(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Node body
                _NodeBody(
                  node: node,
                  selectedColor: effectiveSelectedColor,
                ),
                // Ports on all sides
                ..._buildAllPorts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds port widgets for all sides of the node.
  List<Widget> _buildAllPorts() {
    final widgets = <Widget>[];

    // Group ports by their effective position
    final portsByPosition = <PortPosition, List<NodePort>>{};
    for (final port in node.ports) {
      final position = port.effectivePosition;
      portsByPosition.putIfAbsent(position, () => []).add(port);
    }

    // Build ports for each position
    for (final entry in portsByPosition.entries) {
      widgets.addAll(_buildPortsAtPosition(entry.key, entry.value));
    }

    return widgets;
  }

  /// Builds port widgets for ports at a specific position.
  List<Widget> _buildPortsAtPosition(PortPosition position, List<NodePort> ports) {
    if (ports.isEmpty) return [];

    final widgets = <Widget>[];
    for (var i = 0; i < ports.length; i++) {
      final port = ports[i];

      // Calculate position based on which side the port is on
      double xPosition, yPosition;

      switch (position) {
        case PortPosition.left:
          xPosition = -portRadius;
          yPosition =
              (node.size.height / (ports.length + 1)) * (i + 1) - portRadius;
        case PortPosition.right:
          xPosition = node.size.width - portRadius;
          yPosition =
              (node.size.height / (ports.length + 1)) * (i + 1) - portRadius;
        case PortPosition.top:
          xPosition =
              (node.size.width / (ports.length + 1)) * (i + 1) - portRadius;
          yPosition = -portRadius;
        case PortPosition.bottom:
          xPosition =
              (node.size.width / (ports.length + 1)) * (i + 1) - portRadius;
          yPosition = node.size.height - portRadius;
      }

      // Highlight ports that are valid connection targets
      final isHighlighted =
          highlightedPortType != null && port.type == highlightedPortType;

      // Check if this port has an active connection
      final isConnected = connectedPortIds.contains(port.id);

      // Adjust position to account for larger hit area
      final hitAreaOffset = (portHitTolerance - portRadius * 2) / 2;

      widgets.add(
        Positioned(
          left: xPosition + port.offset.dx - hitAreaOffset,
          top: yPosition + port.offset.dy - hitAreaOffset,
          child: PortWidget(
            port: port,
            radius: portRadius,
            hitTolerance: portHitTolerance,
            color: portColor,
            highlightColor: portHighlightColor,
            isHighlighted: isHighlighted,
            isConnected: isConnected,
            onTap: () => onPortTap(port),
            onDragStart: () => onPortDragStart(port),
            onDragUpdate: (details) => onPortDragUpdate(port, details),
            onDragEnd: () => onPortDragEnd(port),
          ),
        ),
      );
    }

    return widgets;
  }
}

/// The visual body of a node.
class _NodeBody extends StatelessWidget {
  const _NodeBody({
    required this.node,
    required this.selectedColor,
  });

  final CanvasNode node;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = node.borderRadius ?? 8.0;

    // Use custom colors if provided, otherwise use theme defaults
    final backgroundColor =
        node.backgroundColor ?? theme.colorScheme.surface;
    final borderColor = node.isSelected
        ? selectedColor
        : (node.borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.3));

    // Enhanced shadow when dragging for depth effect
    final shadow = node.isDragging
        ? BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        : BoxShadow(
            color: node.isSelected
                ? selectedColor.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: node.isSelected ? 12 : 8,
            offset: const Offset(0, 2),
          );

    return Container(
      width: node.size.width,
      height: node.size.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: node.isSelected ? 2 : 1,
        ),
        boxShadow: [shadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: node.child ??
            Center(
              child: Text(
                node.id,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ),
    );
  }
}
