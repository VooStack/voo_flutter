import 'package:equatable/equatable.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_config.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/canvas_viewport.dart';
import 'package:voo_node_canvas/src/domain/entities/node_connection.dart';

/// Represents the complete state of a node canvas.
///
/// This immutable state object contains all the data needed to
/// render and interact with the canvas.
class CanvasState extends Equatable {
  /// Creates a canvas state.
  const CanvasState({
    this.nodes = const [],
    this.connections = const [],
    this.viewport = const CanvasViewport(),
    this.config = const CanvasConfig(),
    this.selectedNodeIds = const {},
    this.selectedConnectionIds = const {},
    this.draggingNodeId,
    this.connectingFromNodeId,
    this.connectingFromPortId,
  });

  /// All nodes on the canvas.
  final List<CanvasNode> nodes;

  /// All connections between nodes.
  final List<NodeConnection> connections;

  /// The current viewport state.
  final CanvasViewport viewport;

  /// The canvas configuration.
  final CanvasConfig config;

  /// The IDs of currently selected nodes.
  final Set<String> selectedNodeIds;

  /// The IDs of currently selected connections.
  final Set<String> selectedConnectionIds;

  /// The ID of the node currently being dragged, if any.
  final String? draggingNodeId;

  /// The ID of the node being used to create a new connection, if any.
  final String? connectingFromNodeId;

  /// The ID of the port being used to create a new connection, if any.
  final String? connectingFromPortId;

  /// Whether a connection is currently being drawn.
  bool get isConnecting =>
      connectingFromNodeId != null && connectingFromPortId != null;

  /// Returns the node with the given ID, or null if not found.
  CanvasNode? getNodeById(String id) {
    for (final node in nodes) {
      if (node.id == id) return node;
    }
    return null;
  }

  /// Returns the connection with the given ID, or null if not found.
  NodeConnection? getConnectionById(String id) {
    for (final connection in connections) {
      if (connection.id == id) return connection;
    }
    return null;
  }

  /// Returns all connections involving the given node.
  List<NodeConnection> getConnectionsForNode(String nodeId) =>
      connections
          .where((c) => c.sourceNodeId == nodeId || c.targetNodeId == nodeId)
          .toList();

  /// Creates a copy of this state with optional new values.
  CanvasState copyWith({
    List<CanvasNode>? nodes,
    List<NodeConnection>? connections,
    CanvasViewport? viewport,
    CanvasConfig? config,
    Set<String>? selectedNodeIds,
    Set<String>? selectedConnectionIds,
    String? draggingNodeId,
    String? connectingFromNodeId,
    String? connectingFromPortId,
    bool clearDragging = false,
    bool clearConnecting = false,
  }) =>
      CanvasState(
        nodes: nodes ?? this.nodes,
        connections: connections ?? this.connections,
        viewport: viewport ?? this.viewport,
        config: config ?? this.config,
        selectedNodeIds: selectedNodeIds ?? this.selectedNodeIds,
        selectedConnectionIds:
            selectedConnectionIds ?? this.selectedConnectionIds,
        draggingNodeId:
            clearDragging ? null : (draggingNodeId ?? this.draggingNodeId),
        connectingFromNodeId: clearConnecting
            ? null
            : (connectingFromNodeId ?? this.connectingFromNodeId),
        connectingFromPortId: clearConnecting
            ? null
            : (connectingFromPortId ?? this.connectingFromPortId),
      );

  @override
  List<Object?> get props => [
        nodes,
        connections,
        viewport,
        config,
        selectedNodeIds,
        selectedConnectionIds,
        draggingNodeId,
        connectingFromNodeId,
        connectingFromPortId,
      ];
}
