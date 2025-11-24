import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_config.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';
import 'package:voo_node_canvas/src/presentation/state/canvas_controller.dart';
import 'package:voo_node_canvas/src/presentation/widgets/atoms/grid_painter.dart';
import 'package:voo_node_canvas/src/presentation/widgets/molecules/connection_layer.dart';
import 'package:voo_node_canvas/src/presentation/widgets/molecules/node_widget.dart';

/// A node-based canvas widget for creating visual node graphs.
///
/// This widget provides an infinite canvas where users can:
/// - Place and drag nodes
/// - Connect nodes via input/output ports
/// - Pan and zoom the canvas
/// - Select and delete nodes and connections
///
/// Example usage:
/// ```dart
/// final controller = CanvasController();
///
/// VooNodeCanvas(
///   controller: controller,
///   config: const CanvasConfig(
///     gridSize: 20,
///     snapToGrid: true,
///   ),
///   onNodeMoved: (nodeId, position) {
///     print('Node $nodeId moved to $position');
///   },
///   onConnectionCreated: (connection) {
///     print('Connection created: ${connection.id}');
///   },
/// )
/// ```
class VooNodeCanvas extends StatefulWidget {
  /// Creates a node canvas widget.
  const VooNodeCanvas({
    required this.controller,
    this.config = const CanvasConfig(),
    this.onNodeTap,
    this.onNodeMoved,
    this.onNodeDragStart,
    this.onNodeDragEnd,
    this.onConnectionCreated,
    this.onConnectionRemoved,
    this.onConnectionTap,
    this.onCanvasTap,
    this.onViewportChanged,
    super.key,
  });

  /// The controller managing canvas state.
  final CanvasController controller;

  /// Configuration options for the canvas.
  final CanvasConfig config;

  /// Called when a node is tapped.
  final void Function(CanvasNode)? onNodeTap;

  /// Called when a node is moved to a new position.
  final void Function(String nodeId, Offset newPosition)? onNodeMoved;

  /// Called when a node drag starts.
  final void Function(String nodeId)? onNodeDragStart;

  /// Called when a node drag ends.
  final void Function(String nodeId)? onNodeDragEnd;

  /// Called when a new connection is created.
  final void Function(NodeConnection)? onConnectionCreated;

  /// Called when a connection is removed.
  final void Function(String connectionId)? onConnectionRemoved;

  /// Called when a connection is tapped.
  final void Function(NodeConnection)? onConnectionTap;

  /// Called when the canvas background is tapped.
  final VoidCallback? onCanvasTap;

  /// Called when the viewport changes (pan/zoom).
  final void Function(Offset offset, double zoom)? onViewportChanged;

  @override
  State<VooNodeCanvas> createState() => _VooNodeCanvasState();
}

class _VooNodeCanvasState extends State<VooNodeCanvas> {
  Offset? _pendingConnectionEnd;
  Offset? _lastPanPosition;
  bool _isPanning = false;
  int? _panningPointerId;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    widget.controller.updateConfig(widget.config);
  }

  @override
  void didUpdateWidget(VooNodeCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    if (oldWidget.config != widget.config) {
      widget.controller.updateConfig(widget.config);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final viewport = state.viewport;
    final config = state.config;

    return Listener(
      onPointerSignal: _handlePointerSignal,
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: GestureDetector(
        onTap: _handleCanvasTap,
        behavior: HitTestBehavior.translucent,
        child: ClipRect(
          child: Container(
            color: config.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              children: [
                // Grid background
                if (config.showGrid)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CanvasGrid(
                        gridSize: config.gridSize,
                        offset: viewport.offset,
                        zoom: viewport.zoom,
                        color: config.gridColor,
                      ),
                    ),
                  ),

                // Transform layer for pan/zoom with nodes
                Transform(
                  transform: viewport.transformMatrix,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Connection layer - doesn't block gestures
                      IgnorePointer(
                        child: ConnectionLayer(
                          connections: state.connections,
                          nodes: state.nodes,
                          viewport: viewport.transformMatrix,
                          selectedColor: config.selectedColor,
                          onConnectionTap: _handleConnectionTap,
                          pendingConnection: state.isConnecting
                              ? (
                                  nodeId: state.connectingFromNodeId!,
                                  portId: state.connectingFromPortId!,
                                )
                              : null,
                          pendingConnectionEnd: _pendingConnectionEnd,
                        ),
                      ),

                      // Node widgets - these capture their own gestures
                      ...state.nodes.map(_buildNodeWidget),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeWidget(CanvasNode node) {
    // Determine which port type to highlight for valid connection targets
    final highlightedPortType = _getHighlightedPortType(node);

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: NodeWidget(
        node: node,
        portRadius: widget.config.portRadius,
        selectedColor: widget.config.selectedColor,
        highlightedPortType: highlightedPortType,
        onTap: () => _handleNodeTap(node),
        onDragStart: () => _handleNodeDragStart(node),
        onDragUpdate: (details) => _handleNodeDragUpdate(node, details),
        onDragEnd: () => _handleNodeDragEnd(node),
        onPortTap: (port) => _handlePortTap(node, port),
        onPortDragStart: (port) => _handlePortDragStart(node, port),
        onPortDragUpdate: (port, details) => _handlePortDragUpdate(node, port, details),
        onPortDragEnd: (port) => _handlePortDragEnd(node, port),
      ),
    );
  }

  /// Gets the port type to highlight for valid connection targets.
  ///
  /// Returns null if not connecting or if this is the source node.
  PortType? _getHighlightedPortType(CanvasNode node) {
    final state = widget.controller.state;
    if (!state.isConnecting) return null;

    // Don't highlight ports on the source node
    if (node.id == state.connectingFromNodeId) return null;

    // Find the source port to determine the target type
    final sourceNode = state.getNodeById(state.connectingFromNodeId!);
    if (sourceNode == null) return null;

    final sourcePort = sourceNode.ports
        .where((p) => p.id == state.connectingFromPortId)
        .firstOrNull;
    if (sourcePort == null) return null;

    // Highlight the opposite port type
    return sourcePort.type == PortType.output
        ? PortType.input
        : PortType.output;
  }

  // ---------------------------------------------------------------------------
  // Canvas Interactions
  // ---------------------------------------------------------------------------

  void _handleCanvasTap() {
    widget.controller.clearSelection();
    widget.controller.cancelConnection();
    setState(() => _pendingConnectionEnd = null);
    widget.onCanvasTap?.call();
  }

  // ---------------------------------------------------------------------------
  // Pointer-based Canvas Panning (doesn't compete with node gestures)
  // ---------------------------------------------------------------------------

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.config.enablePan) return;
    // Only start panning if not already panning and no node is being dragged
    if (_isPanning || widget.controller.state.draggingNodeId != null) return;

    // Check if the pointer is over a node - if so, don't start canvas panning
    // because the user likely intends to drag the node
    if (_isPointerOverNode(event.localPosition)) return;

    // Start tracking this pointer for potential panning
    _panningPointerId = event.pointer;
    _lastPanPosition = event.localPosition;
  }

  /// Checks if the given screen position is over any node.
  bool _isPointerOverNode(Offset screenPosition) {
    final viewport = widget.controller.state.viewport;

    // Convert screen position to canvas coordinates
    final canvasPosition = viewport.screenToCanvas(screenPosition);

    // Check if the position is inside any node's bounds
    for (final node in widget.controller.state.nodes) {
      if (node.bounds.contains(canvasPosition)) {
        return true;
      }
    }
    return false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!widget.config.enablePan) return;
    if (_panningPointerId != event.pointer) return;
    if (_lastPanPosition == null) return;

    // If a node drag started, stop canvas panning
    if (widget.controller.state.draggingNodeId != null) {
      _cancelPanning();
      return;
    }

    // Check if we've moved enough to start panning
    if (!_isPanning) {
      final distance = (event.localPosition - _lastPanPosition!).distance;
      if (distance > 5) {
        // Threshold to distinguish from taps
        _isPanning = true;
      } else {
        return;
      }
    }

    // Perform canvas pan
    final delta = event.localPosition - _lastPanPosition!;
    final currentOffset = widget.controller.state.viewport.offset;
    widget.controller.setViewportOffset(currentOffset + delta);
    _lastPanPosition = event.localPosition;

    final viewport = widget.controller.state.viewport;
    widget.onViewportChanged?.call(viewport.offset, viewport.zoom);
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_panningPointerId == event.pointer) {
      _cancelPanning();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_panningPointerId == event.pointer) {
      _cancelPanning();
    }
  }

  void _cancelPanning() {
    _isPanning = false;
    _panningPointerId = null;
    _lastPanPosition = null;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.config.enableZoom) return;
    if (event is PointerScrollEvent) {
      final currentZoom = widget.controller.state.viewport.zoom;
      final delta = -event.scrollDelta.dy / 500;
      final newZoom = currentZoom * (1 + delta);

      widget.controller.zoomAtPoint(newZoom, event.localPosition);

      final viewport = widget.controller.state.viewport;
      widget.onViewportChanged?.call(viewport.offset, viewport.zoom);
    }
  }

  // ---------------------------------------------------------------------------
  // Node Interactions
  // ---------------------------------------------------------------------------

  void _handleNodeTap(CanvasNode node) {
    widget.controller.selectNode(node.id);
    widget.onNodeTap?.call(node);
  }

  void _handleNodeDragStart(CanvasNode node) {
    if (!widget.config.enableNodeDrag) return;
    widget.controller.startDraggingNode(node.id);
    widget.controller.selectNode(node.id);
    widget.onNodeDragStart?.call(node.id);
  }

  void _handleNodeDragUpdate(CanvasNode node, DragUpdateDetails details) {
    if (!widget.config.enableNodeDrag) return;
    // Note: details.delta is already in canvas coordinates because the
    // GestureDetector is inside the Transform widget. No zoom conversion needed.
    widget.controller.moveNodeByDelta(node.id, details.delta);
    // Report the actual snapped position to the callback
    final updatedNode = widget.controller.state.getNodeById(node.id);
    if (updatedNode != null) {
      widget.onNodeMoved?.call(node.id, updatedNode.position);
    }
  }

  void _handleNodeDragEnd(CanvasNode node) {
    widget.controller.endDraggingNode();
    widget.onNodeDragEnd?.call(node.id);
  }

  // ---------------------------------------------------------------------------
  // Port Interactions
  // ---------------------------------------------------------------------------

  void _handlePortTap(CanvasNode node, NodePort port) {
    final state = widget.controller.state;
    if (state.isConnecting) {
      // Try to complete connection
      _completeConnection(node, port);
    } else {
      // Start new connection
      widget.controller.startConnection(node.id, port.id);
      setState(() {
        _pendingConnectionEnd = _getPortPosition(node, port);
      });
    }
  }

  void _handlePortDragStart(CanvasNode node, NodePort port) {
    widget.controller.startConnection(node.id, port.id);
    setState(() {
      _pendingConnectionEnd = _getPortPosition(node, port);
    });
  }

  void _handlePortDragUpdate(
    CanvasNode node,
    NodePort port,
    DragUpdateDetails details,
  ) {
    if (!widget.controller.state.isConnecting) return;

    // Note: details.delta is already in canvas coordinates because the
    // GestureDetector is inside the Transform widget. No zoom conversion needed.
    setState(() {
      _pendingConnectionEnd =
          (_pendingConnectionEnd ?? Offset.zero) + details.delta;
    });
  }

  void _handlePortDragEnd(CanvasNode node, NodePort port) {
    if (!widget.controller.state.isConnecting) return;
    if (_pendingConnectionEnd == null) {
      widget.controller.cancelConnection();
      return;
    }

    final state = widget.controller.state;
    final sourceNodeId = state.connectingFromNodeId;
    final sourcePortId = state.connectingFromPortId;

    // Find the target port at the current drag position (excluding source)
    final targetResult = _findPortAtPosition(
      _pendingConnectionEnd!,
      excludeNodeId: sourceNodeId,
      excludePortId: sourcePortId,
    );

    if (targetResult != null) {
      _completeConnection(targetResult.node, targetResult.port);
    } else {
      // No valid target found, cancel the connection
      widget.controller.cancelConnection();
      setState(() => _pendingConnectionEnd = null);
    }
  }

  /// Finds a port at the given canvas position.
  /// Returns the node and port if found within the hit tolerance.
  /// Optionally excludes a specific port (e.g., the source port).
  ({CanvasNode node, NodePort port})? _findPortAtPosition(
    Offset position, {
    String? excludeNodeId,
    String? excludePortId,
  }) {
    const hitTolerance = 20.0; // pixels

    for (final node in widget.controller.state.nodes) {
      for (final port in node.ports) {
        // Skip the source port
        if (node.id == excludeNodeId && port.id == excludePortId) {
          continue;
        }

        final portPosition = _getPortPosition(node, port);
        final distance = (position - portPosition).distance;
        if (distance <= hitTolerance) {
          return (node: node, port: port);
        }
      }
    }
    return null;
  }

  /// Calculates the position of a port in canvas coordinates.
  Offset _getPortPosition(CanvasNode node, NodePort port) {
    final portsOfType = node.ports.where((p) => p.type == port.type).toList();
    final portIndex = portsOfType.indexOf(port);

    final yPosition = node.position.dy +
        (node.size.height / (portsOfType.length + 1)) * (portIndex + 1);
    final xPosition = port.type == PortType.input
        ? node.position.dx
        : node.position.dx + node.size.width;

    return Offset(xPosition, yPosition) + port.offset;
  }

  void _completeConnection(CanvasNode targetNode, NodePort targetPort) {
    final previousConnectionCount = widget.controller.state.connections.length;

    widget.controller.completeConnection(targetNode.id, targetPort.id);
    setState(() => _pendingConnectionEnd = null);

    // Check if a connection was actually created
    if (widget.controller.state.connections.length > previousConnectionCount) {
      final newConnection = widget.controller.state.connections.last;
      widget.onConnectionCreated?.call(newConnection);
    }
  }

  // ---------------------------------------------------------------------------
  // Connection Interactions
  // ---------------------------------------------------------------------------

  void _handleConnectionTap(NodeConnection connection) {
    widget.controller.selectConnection(connection.id);
    widget.onConnectionTap?.call(connection);
  }
}
