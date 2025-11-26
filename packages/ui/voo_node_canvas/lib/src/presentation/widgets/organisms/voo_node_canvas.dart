import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_config.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_position.dart';
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
  final FocusNode _focusNode = FocusNode();

  // Marquee selection state
  Offset? _marqueeStartScreen;
  Offset? _marqueeEndScreen;
  bool _isMarqueeSelecting = false;

  // Direct node interaction state (bypasses Flutter's hit testing)
  // This handles nodes that are outside the constrained hit test bounds
  String? _directDragNodeId;
  Offset? _directDragOffset; // Offset from cursor to node origin at drag start
  bool _directDragStarted = false;

  // Direct port interaction state (bypasses Flutter's hit testing)
  String? _directPortNodeId;
  String? _directPortId;
  bool _directPortDragStarted = false;

  // Hover tracking (bypasses Flutter's hit testing for distant nodes)
  String? _hoveredNodeId;
  String? _hoveredPortNodeId;
  String? _hoveredPortId;

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
    _focusNode.dispose();
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

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        onHover: _handlePointerHover,
        onExit: (_) => setState(() {
          _hoveredNodeId = null;
          _hoveredPortNodeId = null;
          _hoveredPortId = null;
        }),
        cursor: _hoveredPortId != null
            ? SystemMouseCursors.click
            : (_hoveredNodeId != null
                ? SystemMouseCursors.grab
                : SystemMouseCursors.basic),
        child: Listener(
            onPointerSignal: _handlePointerSignal,
            onPointerDown: (event) {
              _focusNode.requestFocus();
              _handlePointerDown(event);
            },
            onPointerMove: _handlePointerMove,
            onPointerUp: _handlePointerUp,
            onPointerCancel: _handlePointerCancel,
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
                  // Use LayoutBuilder to calculate proper canvas size for hit testing.
                  // The inner Stack must be large enough to cover:
                  // 1. The visible canvas area (accounting for zoom and pan offset)
                  // 2. All actual node positions
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final effectiveZoom = viewport.zoom.clamp(0.1, 10.0);

                      // Calculate the visible canvas area bounds.
                      // Screen point (0,0) maps to canvas: -offset / zoom
                      // Screen point (width,height) maps to canvas: (screen - offset) / zoom
                      final visibleRight =
                          (constraints.maxWidth - viewport.offset.dx) / effectiveZoom;
                      final visibleBottom =
                          (constraints.maxHeight - viewport.offset.dy) / effectiveZoom;

                      // Start with visible area (from origin to visible edge)
                      var canvasWidth = visibleRight.abs() + 1000;
                      var canvasHeight = visibleBottom.abs() + 1000;

                      // Expand to include all node positions
                      for (final node in state.nodes) {
                        final nodeRight = node.position.dx + node.size.width + 500;
                        final nodeBottom = node.position.dy + node.size.height + 500;
                        if (nodeRight > canvasWidth) canvasWidth = nodeRight;
                        if (nodeBottom > canvasHeight) canvasHeight = nodeBottom;
                      }

                      return Transform(
                        transform: viewport.transformMatrix,
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: canvasWidth,
                          height: canvasHeight,
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
                      );
                    },
                  ),

                  // Marquee selection overlay (rendered in screen space)
                  if (_isMarqueeSelecting &&
                      _marqueeStartScreen != null &&
                      _marqueeEndScreen != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _MarqueeSelectionPainter(
                            startPoint: _marqueeStartScreen!,
                            endPoint: _marqueeEndScreen!,
                            color: config.marqueeColor ??
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                            borderColor: config.marqueeColor ??
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles keyboard events for the canvas.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Only handle key down events
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    // Handle Delete or Backspace to delete selected items
    if (event.logicalKey == LogicalKeyboardKey.delete ||
        event.logicalKey == LogicalKeyboardKey.backspace) {
      final state = widget.controller.state;
      final hasSelection = state.selectedNodeIds.isNotEmpty ||
          state.selectedConnectionIds.isNotEmpty;

      if (hasSelection) {
        _deleteSelectedWithCallbacks();
        return KeyEventResult.handled;
      }
    }

    // Handle Escape to cancel connection or clear selection
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (widget.controller.state.isConnecting) {
        widget.controller.cancelConnection();
        setState(() => _pendingConnectionEnd = null);
        return KeyEventResult.handled;
      }
      if (widget.controller.state.selectedNodeIds.isNotEmpty ||
          widget.controller.state.selectedConnectionIds.isNotEmpty) {
        widget.controller.clearSelection();
        return KeyEventResult.handled;
      }
    }

    // Handle Ctrl/Cmd+A to select all nodes
    if (event.logicalKey == LogicalKeyboardKey.keyA &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      widget.controller.selectAllNodes();
      return KeyEventResult.handled;
    }

    // Handle Ctrl/Cmd+Z for undo (without Shift)
    if (event.logicalKey == LogicalKeyboardKey.keyZ &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed) &&
        !HardwareKeyboard.instance.isShiftPressed) {
      if (widget.controller.undo()) {
        return KeyEventResult.handled;
      }
    }

    // Handle Ctrl/Cmd+Shift+Z for redo
    if (event.logicalKey == LogicalKeyboardKey.keyZ &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed) &&
        HardwareKeyboard.instance.isShiftPressed) {
      if (widget.controller.redo()) {
        return KeyEventResult.handled;
      }
    }

    // Handle Ctrl/Cmd+Y for redo (alternative shortcut)
    if (event.logicalKey == LogicalKeyboardKey.keyY &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      if (widget.controller.redo()) {
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  /// Deletes selected items and fires appropriate callbacks.
  void _deleteSelectedWithCallbacks() {
    final result = widget.controller.deleteSelected();

    // Fire callbacks for removed connections
    for (final connectionId in result.deletedConnectionIds) {
      widget.onConnectionRemoved?.call(connectionId);
    }
  }

  Widget _buildNodeWidget(CanvasNode node) {
    // Determine which port type to highlight for valid connection targets
    final highlightedPortType = _getHighlightedPortType(node);

    // Build set of connected port IDs for this node
    final connectedPortIds = _getConnectedPortIds(node.id);

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: NodeWidget(
        node: node,
        portRadius: widget.config.portRadius,
        portHitTolerance: widget.config.portHitTolerance,
        selectedColor: widget.config.selectedColor,
        portColor: widget.config.portColor,
        portHighlightColor: widget.config.portHighlightColor,
        highlightedPortType: highlightedPortType,
        connectedPortIds: connectedPortIds,
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

  /// Gets the set of port IDs that have active connections for a node.
  Set<String> _getConnectedPortIds(String nodeId) {
    final connections = widget.controller.state.connections;
    final connectedIds = <String>{};

    for (final connection in connections) {
      if (connection.sourceNodeId == nodeId) {
        connectedIds.add(connection.sourcePortId);
      }
      if (connection.targetNodeId == nodeId) {
        connectedIds.add(connection.targetPortId);
      }
    }

    return connectedIds;
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
  // Pointer-based Canvas Panning & Marquee Selection
  // ---------------------------------------------------------------------------

  void _handlePointerDown(PointerDownEvent event) {
    // Only handle if not already tracking a pointer
    if (_panningPointerId != null) return;
    if (widget.controller.state.draggingNodeId != null) return;

    // Check ports first (they're smaller and should take priority)
    final portUnderPointer = _findPortAtScreenPosition(event.localPosition);
    if (portUnderPointer != null) {
      // Start tracking this port for direct interaction
      _panningPointerId = event.pointer;
      _directPortNodeId = portUnderPointer.node.id;
      _directPortId = portUnderPointer.port.id;
      _directPortDragStarted = false;
      _lastPanPosition = event.localPosition;
      return;
    }

    // Check if the pointer is over a node
    final nodeUnderPointer = _findNodeAtScreenPosition(event.localPosition);
    if (nodeUnderPointer != null) {
      // Start tracking this node for direct interaction
      // This bypasses Flutter's hit testing which may fail for distant nodes
      _panningPointerId = event.pointer;
      _directDragNodeId = nodeUnderPointer.id;
      _directDragStarted = false;

      // Calculate offset from cursor to node origin (in canvas coordinates)
      // This offset stays constant during the drag
      final viewport = widget.controller.state.viewport;
      final cursorCanvas = viewport.screenToCanvas(event.localPosition);
      _directDragOffset = cursorCanvas - nodeUnderPointer.position;
      _lastPanPosition = event.localPosition; // For detecting drag threshold
      return;
    }

    // Start tracking this pointer for potential panning or marquee selection
    _panningPointerId = event.pointer;
    _lastPanPosition = event.localPosition;
    _marqueeStartScreen = event.localPosition;
  }

  /// Finds a node at the given screen position.
  /// Returns the node if found, null otherwise.
  CanvasNode? _findNodeAtScreenPosition(Offset screenPosition) {
    final viewport = widget.controller.state.viewport;
    final canvasPosition = viewport.screenToCanvas(screenPosition);

    for (final node in widget.controller.state.nodes) {
      if (node.bounds.contains(canvasPosition)) {
        return node;
      }
    }
    return null;
  }

  /// Finds a port at the given screen position.
  /// Returns a record with the node and port if found, null otherwise.
  ({CanvasNode node, NodePort port})? _findPortAtScreenPosition(
      Offset screenPosition) {
    final viewport = widget.controller.state.viewport;
    final canvasPosition = viewport.screenToCanvas(screenPosition);
    const portRadius = 6.0;
    const portHitTolerance = 20.0;

    for (final node in widget.controller.state.nodes) {
      // Group ports by their effective position (same logic as NodeWidget)
      final portsByPosition = <PortPosition, List<NodePort>>{};
      for (final port in node.ports) {
        final position = port.effectivePosition;
        portsByPosition.putIfAbsent(position, () => []).add(port);
      }

      // Check each port
      for (final entry in portsByPosition.entries) {
        final position = entry.key;
        final ports = entry.value;

        for (var i = 0; i < ports.length; i++) {
          final port = ports[i];

          // Calculate port center position (same logic as NodeWidget)
          double xPosition, yPosition;
          switch (position) {
            case PortPosition.left:
              xPosition = -portRadius;
              yPosition = (node.size.height / (ports.length + 1)) * (i + 1) -
                  portRadius;
            case PortPosition.right:
              xPosition = node.size.width - portRadius;
              yPosition = (node.size.height / (ports.length + 1)) * (i + 1) -
                  portRadius;
            case PortPosition.top:
              xPosition =
                  (node.size.width / (ports.length + 1)) * (i + 1) - portRadius;
              yPosition = -portRadius;
            case PortPosition.bottom:
              xPosition =
                  (node.size.width / (ports.length + 1)) * (i + 1) - portRadius;
              yPosition = node.size.height - portRadius;
          }

          // Port center in canvas coordinates
          final portCenterX =
              node.position.dx + xPosition + portRadius + port.offset.dx;
          final portCenterY =
              node.position.dy + yPosition + portRadius + port.offset.dy;
          final portCenter = Offset(portCenterX, portCenterY);

          // Check if click is within hit tolerance
          final distance = (canvasPosition - portCenter).distance;
          if (distance <= portHitTolerance / 2) {
            return (node: node, port: port);
          }
        }
      }
    }
    return null;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    // Update hover state for any pointer movement (not just tracked pointer)
    _updateHoverState(event.localPosition);

    if (_panningPointerId != event.pointer) return;

    // Handle direct port dragging (for creating connections)
    if (_directPortNodeId != null && _directPortId != null) {
      final distance = _lastPanPosition != null
          ? (event.localPosition - _lastPanPosition!).distance
          : 0.0;

      // Start connection drag after small movement threshold
      if (!_directPortDragStarted && distance > 5) {
        _directPortDragStarted = true;
        // Start a connection from this port
        widget.controller.startConnection(_directPortNodeId!, _directPortId!);
      }

      if (_directPortDragStarted) {
        // Update pending connection end position
        final viewport = widget.controller.state.viewport;
        final canvasPosition = viewport.screenToCanvas(event.localPosition);
        setState(() {
          _pendingConnectionEnd = canvasPosition;
        });
      }
      return;
    }

    // Handle direct node dragging (bypasses Flutter hit testing)
    if (_directDragNodeId != null && _directDragOffset != null) {
      final distance = _lastPanPosition != null
          ? (event.localPosition - _lastPanPosition!).distance
          : 0.0;

      // Start dragging after small movement threshold
      if (!_directDragStarted && distance > 5) {
        if (widget.config.enableNodeDrag) {
          _directDragStarted = true;
          widget.controller.startDraggingNode(_directDragNodeId!);
          widget.controller.selectNode(_directDragNodeId!);
          widget.onNodeDragStart?.call(_directDragNodeId!);
        }
      }

      if (_directDragStarted && widget.config.enableNodeDrag) {
        // Calculate new node position: cursor position minus the fixed offset
        // This makes the node follow the cursor exactly at the grab point
        final viewport = widget.controller.state.viewport;
        final cursorCanvas = viewport.screenToCanvas(event.localPosition);
        final newNodePosition = cursorCanvas - _directDragOffset!;

        widget.controller.moveNode(_directDragNodeId!, newNodePosition);

        // Report the actual (possibly snapped) position to the callback
        final updatedNode =
            widget.controller.state.getNodeById(_directDragNodeId!);
        if (updatedNode != null) {
          widget.onNodeMoved?.call(_directDragNodeId!, updatedNode.position);
        }
      }
      return;
    }

    if (_lastPanPosition == null) return;

    // If a node drag started via GestureDetector, stop canvas operations
    if (widget.controller.state.draggingNodeId != null) {
      _cancelCanvasOperation();
      return;
    }

    final distance = (event.localPosition - _lastPanPosition!).distance;

    // Determine if we should start marquee selection or panning
    if (!_isPanning && !_isMarqueeSelecting && distance > 5) {
      // Marquee selection requires Shift+drag when enabled
      final isShiftHeld = HardwareKeyboard.instance.isShiftPressed;
      if (widget.config.enableMarqueeSelection && isShiftHeld) {
        _isMarqueeSelecting = true;
        _marqueeEndScreen = event.localPosition;
        setState(() {});
      } else if (widget.config.enablePan) {
        _isPanning = true;
      }
    }

    if (_isMarqueeSelecting) {
      // Update marquee selection rectangle
      setState(() {
        _marqueeEndScreen = event.localPosition;
      });

      // Update selection in real-time
      _updateMarqueeSelection();
    } else if (_isPanning && widget.config.enablePan) {
      // Perform canvas pan
      final delta = event.localPosition - _lastPanPosition!;
      final currentOffset = widget.controller.state.viewport.offset;
      widget.controller.setViewportOffset(currentOffset + delta);
      _lastPanPosition = event.localPosition;

      final viewport = widget.controller.state.viewport;
      widget.onViewportChanged?.call(viewport.offset, viewport.zoom);
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_panningPointerId == event.pointer) {
      // Handle direct port interaction completion
      if (_directPortNodeId != null && _directPortId != null) {
        if (_directPortDragStarted) {
          // End connection drag - check if we're over a valid target port
          final targetPort = _findPortAtScreenPosition(event.localPosition);
          if (targetPort != null &&
              targetPort.node.id != _directPortNodeId) {
            // Complete the connection to the target port
            widget.controller
                .completeConnection(targetPort.node.id, targetPort.port.id);
          } else {
            // Cancel the connection
            widget.controller.cancelConnection();
          }
          setState(() => _pendingConnectionEnd = null);
        } else {
          // This was a tap on a port (no significant movement)
          // Port taps can be used to start/complete connections
          final node =
              widget.controller.state.getNodeById(_directPortNodeId!);
          if (node != null) {
            final port =
                node.ports.where((p) => p.id == _directPortId).firstOrNull;
            if (port != null) {
              _handlePortTap(node, port);
            }
          }
        }
        _cancelCanvasOperation();
        return;
      }

      // Handle direct node interaction completion
      if (_directDragNodeId != null) {
        if (_directDragStarted) {
          // End drag
          widget.controller.endDraggingNode();
          widget.onNodeDragEnd?.call(_directDragNodeId!);
        } else {
          // This was a tap on a node (no significant movement)
          final node = widget.controller.state.getNodeById(_directDragNodeId!);
          if (node != null) {
            final addToSelection = HardwareKeyboard.instance.isShiftPressed;
            widget.controller.selectNode(node.id, addToSelection: addToSelection);
            widget.onNodeTap?.call(node);
          }
        }
        _cancelCanvasOperation();
        return;
      }

      // Finalize marquee selection if active
      if (_isMarqueeSelecting) {
        _updateMarqueeSelection();
      } else if (!_isPanning && _lastPanPosition != null) {
        // This was a tap (no significant movement) - check for connection clicks
        final viewport = widget.controller.state.viewport;
        final canvasPosition = viewport.screenToCanvas(event.localPosition);
        final hitConnection = _findConnectionAtPosition(canvasPosition);

        if (hitConnection != null) {
          _handleConnectionTap(hitConnection);
        } else {
          // No connection hit, treat as canvas tap
          _handleCanvasTap();
        }
      }
      _cancelCanvasOperation();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_panningPointerId == event.pointer) {
      // Cancel any in-progress direct drag
      if (_directDragStarted && _directDragNodeId != null) {
        widget.controller.endDraggingNode();
      }
      // Cancel any in-progress connection
      if (_directPortDragStarted) {
        widget.controller.cancelConnection();
        setState(() => _pendingConnectionEnd = null);
      }
      _cancelCanvasOperation();
    }
  }

  void _cancelCanvasOperation() {
    setState(() {
      _isPanning = false;
      _isMarqueeSelecting = false;
      _panningPointerId = null;
      _lastPanPosition = null;
      _marqueeStartScreen = null;
      _marqueeEndScreen = null;
      _directDragNodeId = null;
      _directDragOffset = null;
      _directDragStarted = false;
      _directPortNodeId = null;
      _directPortId = null;
      _directPortDragStarted = false;
    });
  }

  /// Updates the hover state based on the current pointer position.
  /// This is called on every pointer move to track which node/port is hovered.
  void _updateHoverState(Offset screenPosition) {
    // Check ports first (they take priority)
    final portUnderPointer = _findPortAtScreenPosition(screenPosition);
    final newHoveredPortNodeId = portUnderPointer?.node.id;
    final newHoveredPortId = portUnderPointer?.port.id;

    // Only check node if not over a port
    final nodeUnderPointer =
        portUnderPointer == null ? _findNodeAtScreenPosition(screenPosition) : null;
    final newHoveredNodeId = nodeUnderPointer?.id;

    if (newHoveredPortNodeId != _hoveredPortNodeId ||
        newHoveredPortId != _hoveredPortId ||
        newHoveredNodeId != _hoveredNodeId) {
      setState(() {
        _hoveredPortNodeId = newHoveredPortNodeId;
        _hoveredPortId = newHoveredPortId;
        _hoveredNodeId = newHoveredNodeId;
      });
    }
  }

  /// Handles pointer hover events (mouse move without buttons pressed).
  void _handlePointerHover(PointerHoverEvent event) {
    _updateHoverState(event.localPosition);
  }

  /// Updates the selection based on the current marquee rectangle.
  void _updateMarqueeSelection() {
    if (_marqueeStartScreen == null || _marqueeEndScreen == null) return;

    final viewport = widget.controller.state.viewport;

    // Convert screen coordinates to canvas coordinates
    final canvasStart = viewport.screenToCanvas(_marqueeStartScreen!);
    final canvasEnd = viewport.screenToCanvas(_marqueeEndScreen!);

    // Create the selection rectangle in canvas coordinates
    final selectionRect = Rect.fromPoints(canvasStart, canvasEnd);

    // Find all nodes that intersect with or are contained by the selection rect
    final selectedNodeIds = <String>{};
    for (final node in widget.controller.state.nodes) {
      final nodeRect = node.bounds;

      final shouldSelect = widget.config.marqueeRequiresContain
          ? _rectContains(selectionRect, nodeRect)
          : selectionRect.overlaps(nodeRect);

      if (shouldSelect) {
        selectedNodeIds.add(node.id);
      }
    }

    // Find all connections that intersect with the selection rect
    final selectedConnectionIds = <String>{};
    for (final connection in widget.controller.state.connections) {
      if (_connectionIntersectsRect(connection, selectionRect)) {
        selectedConnectionIds.add(connection.id);
      }
    }

    // Update selection (both nodes and connections)
    widget.controller.setSelection(
      nodeIds: selectedNodeIds,
      connectionIds: selectedConnectionIds,
    );
  }

  /// Checks if a connection's bezier curve intersects with a rectangle.
  bool _connectionIntersectsRect(NodeConnection connection, Rect rect) {
    final sourceNode =
        widget.controller.state.getNodeById(connection.sourceNodeId);
    final targetNode =
        widget.controller.state.getNodeById(connection.targetNodeId);

    if (sourceNode == null || targetNode == null) return false;

    final sourcePort = sourceNode.ports
        .where((p) => p.id == connection.sourcePortId)
        .firstOrNull;
    final targetPort = targetNode.ports
        .where((p) => p.id == connection.targetPortId)
        .firstOrNull;

    if (sourcePort == null || targetPort == null) return false;

    final start =
        CanvasController.calculatePortPosition(sourceNode, sourcePort);
    final end = CanvasController.calculatePortPosition(targetNode, targetPort);

    // Calculate control points
    final distance = (end - start).distance.clamp(50.0, 150.0) * 0.4;
    final cp1 = _getControlPoint(start, sourcePort.effectivePosition, distance);
    final cp2 = _getControlPoint(end, targetPort.effectivePosition, distance);

    // Sample points along the bezier curve and check if any are inside the rect
    const samples = 20;
    for (var i = 0; i <= samples; i++) {
      final t = i / samples;
      final curvePoint = _bezierPoint(start, cp1, cp2, end, t);

      if (rect.contains(curvePoint)) {
        return true;
      }
    }
    return false;
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
    // Check if Shift is held for multi-select
    final addToSelection = HardwareKeyboard.instance.isShiftPressed;
    widget.controller.selectNode(node.id, addToSelection: addToSelection);
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
    final hitTolerance = widget.config.portHitTolerance;

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
    return CanvasController.calculatePortPosition(node, port);
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

  // ---------------------------------------------------------------------------
  // Helper Methods
  // ---------------------------------------------------------------------------

  /// Checks if [outer] fully contains [inner].
  bool _rectContains(Rect outer, Rect inner) {
    return outer.left <= inner.left &&
        outer.top <= inner.top &&
        outer.right >= inner.right &&
        outer.bottom >= inner.bottom;
  }

  /// Finds a connection at the given canvas position.
  ///
  /// Returns the connection if found within the hit tolerance.
  NodeConnection? _findConnectionAtPosition(Offset position) {
    final tolerance = widget.config.connectionHitTolerance;

    for (final connection in widget.controller.state.connections) {
      // Get source and target port positions
      final sourceNode =
          widget.controller.state.getNodeById(connection.sourceNodeId);
      final targetNode =
          widget.controller.state.getNodeById(connection.targetNodeId);

      if (sourceNode == null || targetNode == null) continue;

      final sourcePort = sourceNode.ports
          .where((p) => p.id == connection.sourcePortId)
          .firstOrNull;
      final targetPort = targetNode.ports
          .where((p) => p.id == connection.targetPortId)
          .firstOrNull;

      if (sourcePort == null || targetPort == null) continue;

      final start = CanvasController.calculatePortPosition(sourceNode, sourcePort);
      final end = CanvasController.calculatePortPosition(targetNode, targetPort);

      // Check if the point is close to the bezier curve
      if (_isPointNearBezierCurve(
        position,
        start,
        end,
        sourcePort.effectivePosition,
        targetPort.effectivePosition,
        tolerance,
      )) {
        return connection;
      }
    }
    return null;
  }

  /// Checks if a point is near a bezier curve.
  ///
  /// Samples points along the curve and checks if any are within tolerance.
  bool _isPointNearBezierCurve(
    Offset point,
    Offset start,
    Offset end,
    PortPosition sourcePosition,
    PortPosition targetPosition,
    double tolerance,
  ) {
    // Calculate control points based on port positions
    final distance = (end - start).distance.clamp(50.0, 150.0) * 0.4;
    final cp1 = _getControlPoint(start, sourcePosition, distance);
    final cp2 = _getControlPoint(end, targetPosition, distance);

    // Sample points along the bezier curve
    const samples = 20;
    for (var i = 0; i <= samples; i++) {
      final t = i / samples;
      final curvePoint = _bezierPoint(start, cp1, cp2, end, t);
      final distanceToPoint = (point - curvePoint).distance;

      if (distanceToPoint <= tolerance) {
        return true;
      }
    }
    return false;
  }

  /// Gets a control point offset based on port position.
  Offset _getControlPoint(Offset point, PortPosition position, double distance) {
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

  /// Calculates a point on a cubic bezier curve at parameter t.
  Offset _bezierPoint(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;
    final mt = 1 - t;
    final mt2 = mt * mt;
    final mt3 = mt2 * mt;

    return Offset(
      mt3 * p0.dx + 3 * mt2 * t * p1.dx + 3 * mt * t2 * p2.dx + t3 * p3.dx,
      mt3 * p0.dy + 3 * mt2 * t * p1.dy + 3 * mt * t2 * p2.dy + t3 * p3.dy,
    );
  }
}

/// Custom painter for the marquee selection rectangle.
class _MarqueeSelectionPainter extends CustomPainter {
  _MarqueeSelectionPainter({
    required this.startPoint,
    required this.endPoint,
    required this.color,
    required this.borderColor,
  });

  final Offset startPoint;
  final Offset endPoint;
  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(startPoint, endPoint);

    // Fill
    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(rect, borderPaint);

    // Draw corner indicators
    const cornerSize = 8.0;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Top-left corner
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(cornerSize, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(0, cornerSize),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-cornerSize, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(cornerSize, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -cornerSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-cornerSize, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(_MarqueeSelectionPainter oldDelegate) {
    return startPoint != oldDelegate.startPoint ||
        endPoint != oldDelegate.endPoint ||
        color != oldDelegate.color ||
        borderColor != oldDelegate.borderColor;
  }
}
