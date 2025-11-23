import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
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
    this.selectedColor,
    this.draggingOpacity = 0.8,
    this.highlightedPortType,
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

  /// The color to use when selected.
  final Color? selectedColor;

  /// The opacity when dragging.
  final double draggingOpacity;

  /// The port type to highlight as valid connection targets.
  ///
  /// When a connection is being created, ports of this type
  /// will be highlighted to indicate they are valid targets.
  final PortType? highlightedPortType;

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
                // Input ports (left side)
                ..._buildInputPorts(),
                // Output ports (right side)
                ..._buildOutputPorts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputPorts() {
    final inputPorts = node.ports.where((p) => p.type == PortType.input).toList();
    return _buildPortsOnSide(inputPorts, isLeft: true);
  }

  List<Widget> _buildOutputPorts() {
    final outputPorts = node.ports.where((p) => p.type == PortType.output).toList();
    return _buildPortsOnSide(outputPorts, isLeft: false);
  }

  List<Widget> _buildPortsOnSide(List<NodePort> ports, {required bool isLeft}) {
    if (ports.isEmpty) return [];

    final widgets = <Widget>[];
    for (var i = 0; i < ports.length; i++) {
      final port = ports[i];
      final yPosition =
          (node.size.height / (ports.length + 1)) * (i + 1) - portRadius;
      final xPosition = isLeft ? -portRadius : node.size.width - portRadius;

      // Highlight ports that are valid connection targets
      final isHighlighted = highlightedPortType != null &&
          port.type == highlightedPortType;

      widgets.add(
        Positioned(
          left: xPosition + port.offset.dx,
          top: yPosition + port.offset.dy,
          child: PortWidget(
            port: port,
            radius: portRadius,
            isHighlighted: isHighlighted,
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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: node.isSelected
              ? selectedColor
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: node.isSelected ? 2 : 1,
        ),
        boxShadow: [shadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
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
