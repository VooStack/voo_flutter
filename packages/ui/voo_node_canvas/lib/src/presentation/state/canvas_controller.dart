import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_config.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_viewport.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';
import 'package:voo_node_canvas/src/domain/enums/port_position.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';
import 'package:voo_node_canvas/src/presentation/state/canvas_state.dart';

/// Controller for managing canvas state and interactions.
///
/// This controller provides methods for manipulating nodes, connections,
/// and the viewport, while maintaining immutable state updates.
///
/// Supports undo/redo for operations that modify nodes and connections.
class CanvasController extends ChangeNotifier {
  /// Creates a canvas controller with an optional initial state.
  CanvasController({
    CanvasState? initialState,
    this.maxHistorySize = 50,
  }) : _state = initialState ?? const CanvasState();

  CanvasState _state;

  /// Maximum number of states to keep in history.
  final int maxHistorySize;

  /// History stack for undo operations.
  final List<CanvasState> _undoStack = [];

  /// Redo stack for redo operations.
  final List<CanvasState> _redoStack = [];

  /// The current canvas state.
  CanvasState get state => _state;

  /// Whether undo is available.
  bool get canUndo => _undoStack.isNotEmpty;

  /// Whether redo is available.
  bool get canRedo => _redoStack.isNotEmpty;

  /// Updates the canvas state and notifies listeners.
  /// Does NOT save to history - use for viewport/selection changes.
  void _updateState(CanvasState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Updates the canvas state with history support for undo/redo.
  /// Use for operations that modify nodes or connections.
  void _updateStateWithHistory(CanvasState newState) {
    if (_state != newState) {
      // Save current state to undo stack
      _undoStack.add(_state);

      // Limit history size
      if (_undoStack.length > maxHistorySize) {
        _undoStack.removeAt(0);
      }

      // Clear redo stack when new action is performed
      _redoStack.clear();

      _state = newState;
      notifyListeners();
    }
  }

  /// Undoes the last operation.
  ///
  /// Returns true if undo was performed, false if nothing to undo.
  bool undo() {
    if (_undoStack.isEmpty) return false;

    // Save current state to redo stack
    _redoStack.add(_state);

    // Restore previous state
    _state = _undoStack.removeLast();
    notifyListeners();
    return true;
  }

  /// Redoes the last undone operation.
  ///
  /// Returns true if redo was performed, false if nothing to redo.
  bool redo() {
    if (_redoStack.isEmpty) return false;

    // Save current state to undo stack
    _undoStack.add(_state);

    // Restore redo state
    _state = _redoStack.removeLast();
    notifyListeners();
    return true;
  }

  /// Clears all undo/redo history.
  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }

  // ---------------------------------------------------------------------------
  // Node Operations
  // ---------------------------------------------------------------------------

  /// Adds a node to the canvas.
  ///
  /// This operation supports undo/redo.
  void addNode(CanvasNode node) {
    _updateStateWithHistory(_state.copyWith(
      nodes: [..._state.nodes, node],
    ));
  }

  /// Removes a node and all its connections from the canvas.
  ///
  /// This operation supports undo/redo.
  void removeNode(String nodeId) {
    final updatedNodes =
        _state.nodes.where((n) => n.id != nodeId).toList();
    final updatedConnections = _state.connections
        .where((c) => c.sourceNodeId != nodeId && c.targetNodeId != nodeId)
        .toList();
    final updatedSelectedNodeIds = Set<String>.from(_state.selectedNodeIds)
      ..remove(nodeId);

    _updateStateWithHistory(_state.copyWith(
      nodes: updatedNodes,
      connections: updatedConnections,
      selectedNodeIds: updatedSelectedNodeIds,
    ));
  }

  /// Updates a node's properties.
  void updateNode(String nodeId, CanvasNode Function(CanvasNode) update) {
    final updatedNodes = _state.nodes.map((node) {
      if (node.id == nodeId) {
        return update(node);
      }
      return node;
    }).toList();

    _updateState(_state.copyWith(nodes: updatedNodes));
  }

  /// Moves a node to a new position.
  void moveNode(String nodeId, Offset newPosition) {
    Offset finalPosition = newPosition;

    // Snap to grid if enabled
    if (_state.config.snapToGrid) {
      final gridSize = _state.config.gridSize;
      finalPosition = Offset(
        (newPosition.dx / gridSize).round() * gridSize,
        (newPosition.dy / gridSize).round() * gridSize,
      );
    }

    updateNode(nodeId, (node) => node.copyWith(position: finalPosition));
  }

  /// Moves a node by a delta offset.
  ///
  /// This method properly handles snap-to-grid by tracking the raw position
  /// during drag operations, ensuring small movements accumulate correctly.
  void moveNodeByDelta(String nodeId, Offset delta) {
    final node = _state.getNodeById(nodeId);
    if (node == null) return;

    // Calculate new raw position from the tracked raw position (or current if not dragging)
    final basePosition = _state.dragRawPosition ?? node.position;
    final rawPosition = basePosition + delta;

    Offset finalPosition = rawPosition;

    // Snap to grid if enabled
    if (_state.config.snapToGrid) {
      final gridSize = _state.config.gridSize;
      finalPosition = Offset(
        (rawPosition.dx / gridSize).round() * gridSize,
        (rawPosition.dy / gridSize).round() * gridSize,
      );
    }

    // Update raw position tracking and node position
    _updateState(_state.copyWith(dragRawPosition: rawPosition));
    updateNode(nodeId, (node) => node.copyWith(position: finalPosition));
  }

  /// Selects a node.
  void selectNode(String nodeId, {bool addToSelection = false}) {
    Set<String> newSelection;
    if (addToSelection) {
      newSelection = Set<String>.from(_state.selectedNodeIds)..add(nodeId);
    } else {
      newSelection = {nodeId};
    }

    // Update node selection state
    final updatedNodes = _state.nodes.map((node) {
      return node.copyWith(isSelected: newSelection.contains(node.id));
    }).toList();

    _updateState(_state.copyWith(
      nodes: updatedNodes,
      selectedNodeIds: newSelection,
      selectedConnectionIds: addToSelection ? null : {},
    ));
  }

  /// Sets the selected nodes to the given set.
  ///
  /// This method is typically used for marquee (drag-to-select) operations
  /// where multiple nodes need to be selected at once.
  void setSelectedNodes(Set<String> nodeIds) {
    // Update node selection state
    final updatedNodes = _state.nodes.map((node) {
      return node.copyWith(isSelected: nodeIds.contains(node.id));
    }).toList();

    _updateState(_state.copyWith(
      nodes: updatedNodes,
      selectedNodeIds: nodeIds,
      selectedConnectionIds: {},
    ));
  }

  /// Selects all nodes on the canvas.
  void selectAllNodes() {
    final allNodeIds = _state.nodes.map((n) => n.id).toSet();
    setSelectedNodes(allNodeIds);
  }

  /// Sets the selection for both nodes and connections.
  ///
  /// This method is typically used for marquee (drag-to-select) operations
  /// where multiple items need to be selected at once.
  void setSelection({
    Set<String> nodeIds = const {},
    Set<String> connectionIds = const {},
  }) {
    // Update node selection state
    final updatedNodes = _state.nodes.map((node) {
      return node.copyWith(isSelected: nodeIds.contains(node.id));
    }).toList();

    // Update connection selection state
    final updatedConnections = _state.connections.map((connection) {
      return connection.copyWith(
          isSelected: connectionIds.contains(connection.id));
    }).toList();

    _updateState(_state.copyWith(
      nodes: updatedNodes,
      connections: updatedConnections,
      selectedNodeIds: nodeIds,
      selectedConnectionIds: connectionIds,
    ));
  }

  /// Deselects all nodes.
  void deselectAllNodes() {
    final updatedNodes = _state.nodes.map((node) {
      return node.copyWith(isSelected: false);
    }).toList();

    _updateState(_state.copyWith(
      nodes: updatedNodes,
      selectedNodeIds: {},
    ));
  }

  /// Starts dragging a node.
  ///
  /// Saves state to history so the move can be undone.
  void startDraggingNode(String nodeId) {
    final node = _state.getNodeById(nodeId);

    // Save state to history BEFORE drag starts (so undo restores original position)
    _undoStack.add(_state);
    if (_undoStack.length > maxHistorySize) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();

    updateNode(nodeId, (node) => node.copyWith(isDragging: true));
    _updateState(_state.copyWith(
      draggingNodeId: nodeId,
      dragRawPosition: node?.position,
    ));
  }

  /// Ends dragging a node.
  void endDraggingNode() {
    if (_state.draggingNodeId != null) {
      updateNode(
          _state.draggingNodeId!, (node) => node.copyWith(isDragging: false));
    }
    _updateState(_state.copyWith(clearDragging: true));
  }

  // ---------------------------------------------------------------------------
  // Connection Operations
  // ---------------------------------------------------------------------------

  /// Adds a connection between two ports.
  ///
  /// This operation supports undo/redo.
  void addConnection(NodeConnection connection) {
    // Validate that both nodes exist
    final sourceNode = _state.getNodeById(connection.sourceNodeId);
    final targetNode = _state.getNodeById(connection.targetNodeId);
    if (sourceNode == null || targetNode == null) return;

    // Validate that both ports exist and have correct types
    final sourcePort = sourceNode.ports
        .where((p) => p.id == connection.sourcePortId)
        .firstOrNull;
    final targetPort = targetNode.ports
        .where((p) => p.id == connection.targetPortId)
        .firstOrNull;

    if (sourcePort == null ||
        targetPort == null ||
        sourcePort.type != PortType.output ||
        targetPort.type != PortType.input) {
      return;
    }

    // Check for duplicate connections
    final exists = _state.connections.any((c) =>
        c.sourceNodeId == connection.sourceNodeId &&
        c.sourcePortId == connection.sourcePortId &&
        c.targetNodeId == connection.targetNodeId &&
        c.targetPortId == connection.targetPortId);
    if (exists) return;

    _updateStateWithHistory(_state.copyWith(
      connections: [..._state.connections, connection],
    ));
  }

  /// Removes a connection.
  ///
  /// This operation supports undo/redo.
  void removeConnection(String connectionId) {
    final updatedConnections =
        _state.connections.where((c) => c.id != connectionId).toList();
    final updatedSelectedConnectionIds =
        Set<String>.from(_state.selectedConnectionIds)..remove(connectionId);

    _updateStateWithHistory(_state.copyWith(
      connections: updatedConnections,
      selectedConnectionIds: updatedSelectedConnectionIds,
    ));
  }

  /// Removes all connections from/to a specific port.
  ///
  /// This operation supports undo/redo.
  /// Returns the list of removed connection IDs.
  List<String> disconnectPort(String nodeId, String portId) {
    final removedIds = <String>[];
    final updatedConnections = _state.connections.where((c) {
      final isConnected = (c.sourceNodeId == nodeId && c.sourcePortId == portId) ||
          (c.targetNodeId == nodeId && c.targetPortId == portId);
      if (isConnected) {
        removedIds.add(c.id);
        return false;
      }
      return true;
    }).toList();

    if (removedIds.isNotEmpty) {
      final updatedSelectedConnectionIds =
          Set<String>.from(_state.selectedConnectionIds)
            ..removeAll(removedIds);

      _updateStateWithHistory(_state.copyWith(
        connections: updatedConnections,
        selectedConnectionIds: updatedSelectedConnectionIds,
      ));
    }

    return removedIds;
  }

  /// Removes all connections for a node without removing the node itself.
  ///
  /// This operation supports undo/redo.
  /// Returns the list of removed connection IDs.
  List<String> disconnectNode(String nodeId) {
    final removedIds = <String>[];
    final updatedConnections = _state.connections.where((c) {
      final isConnected =
          c.sourceNodeId == nodeId || c.targetNodeId == nodeId;
      if (isConnected) {
        removedIds.add(c.id);
        return false;
      }
      return true;
    }).toList();

    if (removedIds.isNotEmpty) {
      final updatedSelectedConnectionIds =
          Set<String>.from(_state.selectedConnectionIds)
            ..removeAll(removedIds);

      _updateStateWithHistory(_state.copyWith(
        connections: updatedConnections,
        selectedConnectionIds: updatedSelectedConnectionIds,
      ));
    }

    return removedIds;
  }

  /// Gets all connections for a specific port.
  List<NodeConnection> getConnectionsForPort(String nodeId, String portId) {
    return _state.connections
        .where((c) =>
            (c.sourceNodeId == nodeId && c.sourcePortId == portId) ||
            (c.targetNodeId == nodeId && c.targetPortId == portId))
        .toList();
  }

  /// Selects a connection.
  void selectConnection(String connectionId, {bool addToSelection = false}) {
    Set<String> newSelection;
    if (addToSelection) {
      newSelection = Set<String>.from(_state.selectedConnectionIds)
        ..add(connectionId);
    } else {
      newSelection = {connectionId};
    }

    // Update connection selection state
    final updatedConnections = _state.connections.map((connection) {
      return connection.copyWith(isSelected: newSelection.contains(connection.id));
    }).toList();

    _updateState(_state.copyWith(
      connections: updatedConnections,
      selectedConnectionIds: newSelection,
      selectedNodeIds: addToSelection ? null : {},
    ));
  }

  /// Starts creating a connection from a port.
  void startConnection(String nodeId, String portId) {
    _updateState(_state.copyWith(
      connectingFromNodeId: nodeId,
      connectingFromPortId: portId,
    ));
  }

  /// Completes a connection to a target port.
  void completeConnection(String targetNodeId, String targetPortId) {
    if (!_state.isConnecting) return;

    final sourceNode = _state.getNodeById(_state.connectingFromNodeId!);
    final targetNode = _state.getNodeById(targetNodeId);
    if (sourceNode == null || targetNode == null) {
      cancelConnection();
      return;
    }

    final sourcePort = sourceNode.ports
        .where((p) => p.id == _state.connectingFromPortId)
        .firstOrNull;
    final targetPort =
        targetNode.ports.where((p) => p.id == targetPortId).firstOrNull;

    if (sourcePort == null || targetPort == null) {
      cancelConnection();
      return;
    }

    // Determine source and target based on port types
    String srcNodeId, srcPortId, tgtNodeId, tgtPortId;
    if (sourcePort.type == PortType.output &&
        targetPort.type == PortType.input) {
      srcNodeId = _state.connectingFromNodeId!;
      srcPortId = _state.connectingFromPortId!;
      tgtNodeId = targetNodeId;
      tgtPortId = targetPortId;
    } else if (sourcePort.type == PortType.input &&
        targetPort.type == PortType.output) {
      srcNodeId = targetNodeId;
      srcPortId = targetPortId;
      tgtNodeId = _state.connectingFromNodeId!;
      tgtPortId = _state.connectingFromPortId!;
    } else {
      // Invalid connection (same port types)
      cancelConnection();
      return;
    }

    final connection = NodeConnection(
      id: 'conn_${DateTime.now().millisecondsSinceEpoch}',
      sourceNodeId: srcNodeId,
      sourcePortId: srcPortId,
      targetNodeId: tgtNodeId,
      targetPortId: tgtPortId,
      style: _state.config.connectionStyle,
      color: _state.config.connectionColor,
      strokeWidth: _state.config.connectionStrokeWidth,
    );

    addConnection(connection);
    cancelConnection();
  }

  /// Cancels the current connection operation.
  void cancelConnection() {
    _updateState(_state.copyWith(clearConnecting: true));
  }

  // ---------------------------------------------------------------------------
  // Viewport Operations
  // ---------------------------------------------------------------------------

  /// Sets the viewport offset (pan).
  void setViewportOffset(Offset offset) {
    _updateState(_state.copyWith(
      viewport: _state.viewport.copyWith(offset: offset),
    ));
  }

  /// Sets the viewport zoom level.
  void setViewportZoom(double zoom) {
    final clampedZoom =
        zoom.clamp(_state.config.minZoom, _state.config.maxZoom);
    _updateState(_state.copyWith(
      viewport: _state.viewport.copyWith(zoom: clampedZoom),
    ));
  }

  /// Updates the viewport (pan and/or zoom).
  void updateViewport({Offset? offset, double? zoom}) {
    double? clampedZoom;
    if (zoom != null) {
      clampedZoom = zoom.clamp(_state.config.minZoom, _state.config.maxZoom);
    }

    _updateState(_state.copyWith(
      viewport: _state.viewport.copyWith(
        offset: offset,
        zoom: clampedZoom,
      ),
    ));
  }

  /// Zooms the canvas relative to a focal point.
  void zoomAtPoint(double newZoom, Offset focalPoint) {
    final clampedZoom =
        newZoom.clamp(_state.config.minZoom, _state.config.maxZoom);
    final currentZoom = _state.viewport.zoom;
    final currentOffset = _state.viewport.offset;

    // Calculate the canvas point under the focal point before zoom
    final canvasPoint = Offset(
      (focalPoint.dx - currentOffset.dx) / currentZoom,
      (focalPoint.dy - currentOffset.dy) / currentZoom,
    );

    // Calculate new offset to keep the canvas point under the focal point
    final newOffset = Offset(
      focalPoint.dx - canvasPoint.dx * clampedZoom,
      focalPoint.dy - canvasPoint.dy * clampedZoom,
    );

    _updateState(_state.copyWith(
      viewport: CanvasViewport(offset: newOffset, zoom: clampedZoom),
    ));
  }

  /// Resets the viewport to the initial state.
  void resetViewport() {
    _updateState(_state.copyWith(
      viewport: CanvasViewport(zoom: _state.config.initialZoom),
    ));
  }

  // ---------------------------------------------------------------------------
  // Selection Operations
  // ---------------------------------------------------------------------------

  /// Clears all selections.
  void clearSelection() {
    final updatedNodes = _state.nodes.map((node) {
      return node.copyWith(isSelected: false);
    }).toList();

    final updatedConnections = _state.connections.map((connection) {
      return connection.copyWith(isSelected: false);
    }).toList();

    _updateState(_state.copyWith(
      nodes: updatedNodes,
      connections: updatedConnections,
      selectedNodeIds: {},
      selectedConnectionIds: {},
    ));
  }

  /// Deletes all selected items.
  ///
  /// This operation supports undo/redo.
  /// Returns a record containing:
  /// - `deletedConnectionIds`: IDs of all deleted connections (including those
  ///   attached to deleted nodes)
  /// - `deletedNodeIds`: IDs of all deleted nodes
  ({List<String> deletedConnectionIds, List<String> deletedNodeIds}) deleteSelected() {
    final deletedConnectionIds = <String>[];
    final deletedNodeIds = List<String>.from(_state.selectedNodeIds);

    // Track directly selected connections
    deletedConnectionIds.addAll(_state.selectedConnectionIds);

    // Remove selected connections
    final updatedConnections = _state.connections
        .where((c) => !_state.selectedConnectionIds.contains(c.id))
        .toList();

    // Remove selected nodes and their connections
    final selectedNodeIds = _state.selectedNodeIds;
    final updatedNodes =
        _state.nodes.where((n) => !selectedNodeIds.contains(n.id)).toList();
    final finalConnections = updatedConnections.where((c) {
      final isConnectedToDeletedNode =
          selectedNodeIds.contains(c.sourceNodeId) ||
          selectedNodeIds.contains(c.targetNodeId);
      if (isConnectedToDeletedNode) {
        deletedConnectionIds.add(c.id);
        return false;
      }
      return true;
    }).toList();

    _updateStateWithHistory(_state.copyWith(
      nodes: updatedNodes,
      connections: finalConnections,
      selectedNodeIds: {},
      selectedConnectionIds: {},
    ));

    return (
      deletedConnectionIds: deletedConnectionIds,
      deletedNodeIds: deletedNodeIds,
    );
  }

  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------

  /// Updates the canvas configuration.
  void updateConfig(CanvasConfig config) {
    _updateState(_state.copyWith(config: config));
  }

  // ---------------------------------------------------------------------------
  // Utility Methods
  // ---------------------------------------------------------------------------

  /// Calculates the position of a port in canvas coordinates.
  ///
  /// Ports can be positioned on any side of the node (left, right, top, bottom).
  /// Multiple ports on the same side are evenly distributed along that edge.
  Offset? getPortPosition(String nodeId, String portId) {
    final node = _state.getNodeById(nodeId);
    if (node == null) return null;

    final port = node.ports.where((p) => p.id == portId).firstOrNull;
    if (port == null) return null;

    return calculatePortPosition(node, port);
  }

  /// Calculates the position of a port on a node in canvas coordinates.
  ///
  /// This is a static utility that can be used without accessing state.
  static Offset calculatePortPosition(CanvasNode node, NodePort port) {
    final position = port.effectivePosition;

    // Group ports by their effective position
    final portsOnSameSide = node.ports
        .where((p) => p.effectivePosition == position)
        .toList();
    final portIndex = portsOnSameSide.indexOf(port);
    final portCount = portsOnSameSide.length;

    double x, y;

    switch (position) {
      case PortPosition.left:
        x = node.position.dx;
        y = node.position.dy +
            (node.size.height / (portCount + 1)) * (portIndex + 1);
      case PortPosition.right:
        x = node.position.dx + node.size.width;
        y = node.position.dy +
            (node.size.height / (portCount + 1)) * (portIndex + 1);
      case PortPosition.top:
        x = node.position.dx +
            (node.size.width / (portCount + 1)) * (portIndex + 1);
        y = node.position.dy;
      case PortPosition.bottom:
        x = node.position.dx +
            (node.size.width / (portCount + 1)) * (portIndex + 1);
        y = node.position.dy + node.size.height;
    }

    return Offset(x, y) + port.offset;
  }

  // ---------------------------------------------------------------------------
  // Serialization
  // ---------------------------------------------------------------------------

  /// Exports the canvas state to JSON.
  ///
  /// The exported JSON contains:
  /// - All nodes (without widget children)
  /// - All connections
  /// - Viewport state (optional, based on [includeViewport])
  ///
  /// Note: Node widgets are not serialized. Use [CanvasNode.metadata]
  /// to store information needed to rebuild widgets on load.
  ///
  /// Example:
  /// ```dart
  /// final json = controller.toJson();
  /// final jsonString = jsonEncode(json);
  /// // Save to database or file
  /// ```
  Map<String, dynamic> toJson({bool includeViewport = true}) {
    return {
      'nodes': _state.nodes.map((n) => n.toJson()).toList(),
      'connections': _state.connections.map((c) => c.toJson()).toList(),
      if (includeViewport) 'viewport': _state.viewport.toJson(),
    };
  }

  /// Imports canvas state from JSON.
  ///
  /// The [nodeBuilder] callback is called for each node to allow
  /// rebuilding the widget from the node's metadata.
  ///
  /// Example:
  /// ```dart
  /// controller.fromJson(
  ///   json,
  ///   nodeBuilder: (node) {
  ///     final type = node.metadata?['type'] as String?;
  ///     return node.copyWith(
  ///       child: _buildNodeWidget(type),
  ///     );
  ///   },
  /// );
  /// ```
  void fromJson(
    Map<String, dynamic> json, {
    CanvasNode Function(CanvasNode node)? nodeBuilder,
  }) {
    final nodesList = json['nodes'] as List<dynamic>? ?? [];
    final connectionsList = json['connections'] as List<dynamic>? ?? [];

    var nodes = nodesList
        .map((n) => CanvasNode.fromJson(n as Map<String, dynamic>))
        .toList();

    // Apply node builder to reconstruct widgets
    if (nodeBuilder != null) {
      nodes = nodes.map(nodeBuilder).toList();
    }

    final connections = connectionsList
        .map((c) => NodeConnection.fromJson(c as Map<String, dynamic>))
        .toList();

    final viewport = json['viewport'] != null
        ? CanvasViewport.fromJson(json['viewport'] as Map<String, dynamic>)
        : const CanvasViewport();

    _updateState(_state.copyWith(
      nodes: nodes,
      connections: connections,
      viewport: viewport,
      selectedNodeIds: {},
      selectedConnectionIds: {},
      clearDragging: true,
      clearConnecting: true,
    ));
  }

  /// Clears all nodes and connections from the canvas.
  void clear() {
    _updateState(_state.copyWith(
      nodes: [],
      connections: [],
      selectedNodeIds: {},
      selectedConnectionIds: {},
      clearDragging: true,
      clearConnecting: true,
    ));
  }
}
