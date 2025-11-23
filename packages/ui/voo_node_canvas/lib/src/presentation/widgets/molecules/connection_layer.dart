import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';
import 'package:voo_node_canvas/src/presentation/widgets/atoms/connection_painter.dart';

/// A widget that renders all connections on the canvas.
///
/// This layer sits below the nodes and renders the connection lines
/// between ports using the appropriate connection style.
class ConnectionLayer extends StatelessWidget {
  /// Creates a connection layer.
  const ConnectionLayer({
    required this.connections,
    required this.nodes,
    required this.viewport,
    this.onConnectionTap,
    this.selectedColor,
    this.pendingConnection,
    this.pendingConnectionEnd,
    super.key,
  });

  /// All connections to render.
  final List<NodeConnection> connections;

  /// All nodes (needed to calculate port positions).
  final List<CanvasNode> nodes;

  /// The current viewport state for transformations.
  final Matrix4 viewport;

  /// Called when a connection is tapped.
  final void Function(NodeConnection)? onConnectionTap;

  /// The color to use for selected connections.
  final Color? selectedColor;

  /// A pending connection being drawn (source port info).
  final ({String nodeId, String portId})? pendingConnection;

  /// The current end position of a pending connection.
  final Offset? pendingConnectionEnd;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConnectionLayerPainter(
        connections: connections,
        nodes: nodes,
        selectedColor: selectedColor ?? Theme.of(context).colorScheme.primary,
        pendingConnection: pendingConnection,
        pendingConnectionEnd: pendingConnectionEnd,
        getPortPosition: _getPortPosition,
      ),
      size: Size.infinite,
    );
  }

  Offset? _getPortPosition(String nodeId, String portId) {
    final node = nodes.where((n) => n.id == nodeId).firstOrNull;
    if (node == null) return null;

    final port = node.ports.where((p) => p.id == portId).firstOrNull;
    if (port == null) return null;

    final portsOfType = node.ports.where((p) => p.type == port.type).toList();
    final portIndex = portsOfType.indexOf(port);

    final yPosition =
        node.position.dy + (node.size.height / (portsOfType.length + 1)) * (portIndex + 1);
    final xPosition = port.type == PortType.input
        ? node.position.dx
        : node.position.dx + node.size.width;

    return Offset(xPosition, yPosition) + port.offset;
  }
}

/// Custom painter for rendering all connections.
class _ConnectionLayerPainter extends CustomPainter {
  _ConnectionLayerPainter({
    required this.connections,
    required this.nodes,
    required this.selectedColor,
    required this.getPortPosition,
    this.pendingConnection,
    this.pendingConnectionEnd,
  });

  final List<NodeConnection> connections;
  final List<CanvasNode> nodes;
  final Color selectedColor;
  final Offset? Function(String nodeId, String portId) getPortPosition;
  final ({String nodeId, String portId})? pendingConnection;
  final Offset? pendingConnectionEnd;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all established connections
    for (final connection in connections) {
      final start = getPortPosition(connection.sourceNodeId, connection.sourcePortId);
      final end = getPortPosition(connection.targetNodeId, connection.targetPortId);

      if (start == null || end == null) continue;

      final painter = ConnectionPainter(
        start: start,
        end: end,
        style: connection.style,
        color: connection.color,
        strokeWidth: connection.strokeWidth,
        isSelected: connection.isSelected,
        selectedColor: selectedColor,
      );

      painter.paint(canvas, size);
    }

    // Draw pending connection if one is being created
    if (pendingConnection != null && pendingConnectionEnd != null) {
      final start = getPortPosition(pendingConnection!.nodeId, pendingConnection!.portId);
      if (start != null) {
        final painter = ConnectionPainter(
          start: start,
          end: pendingConnectionEnd!,
          isDragging: true,
        );
        painter.paint(canvas, size);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionLayerPainter oldDelegate) =>
      connections != oldDelegate.connections ||
      nodes != oldDelegate.nodes ||
      pendingConnection != oldDelegate.pendingConnection ||
      pendingConnectionEnd != oldDelegate.pendingConnectionEnd;
}
