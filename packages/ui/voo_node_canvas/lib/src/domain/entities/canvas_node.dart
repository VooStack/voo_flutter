import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/node_port.dart';

/// Represents a node on the canvas.
///
/// A canvas node is a draggable widget that can be placed anywhere
/// on the infinite canvas. Nodes can have multiple input and output
/// ports for creating connections to other nodes.
class CanvasNode extends Equatable {
  /// Creates a canvas node.
  ///
  /// The [id] must be unique across all nodes on the canvas.
  /// The [position] defines the top-left corner of the node on the canvas.
  /// The [size] defines the dimensions of the node.
  /// The [ports] define the connection points available on this node.
  /// The [child] is the widget to display as the node content.
  /// The [metadata] stores custom serializable data.
  const CanvasNode({
    required this.id,
    required this.position,
    this.size = const Size(150, 100),
    this.ports = const [],
    this.child,
    this.isSelected = false,
    this.isDragging = false,
    this.metadata,
  });

  /// Creates a canvas node from JSON.
  ///
  /// Note: The [child] widget is not serialized and must be provided
  /// separately using a node builder callback.
  factory CanvasNode.fromJson(Map<String, dynamic> json) => CanvasNode(
        id: json['id'] as String,
        position: Offset(
          (json['position']['dx'] as num).toDouble(),
          (json['position']['dy'] as num).toDouble(),
        ),
        size: json['size'] != null
            ? Size(
                (json['size']['width'] as num).toDouble(),
                (json['size']['height'] as num).toDouble(),
              )
            : const Size(150, 100),
        ports: (json['ports'] as List<dynamic>?)
                ?.map((p) => NodePort.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique identifier for this node.
  final String id;

  /// The position of the node on the canvas (top-left corner).
  final Offset position;

  /// The size of the node.
  final Size size;

  /// The connection ports available on this node.
  final List<NodePort> ports;

  /// The widget to display as the node content.
  ///
  /// Note: This is not serialized. Use [metadata] to store
  /// information needed to rebuild the widget on load.
  final Widget? child;

  /// Whether this node is currently selected.
  final bool isSelected;

  /// Whether this node is currently being dragged.
  final bool isDragging;

  /// Optional custom metadata associated with this node.
  ///
  /// Use this to store serializable data like node type,
  /// labels, or any custom properties needed to rebuild
  /// the node widget when loading from JSON.
  final Map<String, dynamic>? metadata;

  /// Returns the center position of this node.
  Offset get center => Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      );

  /// Returns the bounding rectangle of this node.
  Rect get bounds => Rect.fromLTWH(
        position.dx,
        position.dy,
        size.width,
        size.height,
      );

  /// Converts this node to JSON.
  ///
  /// Note: The [child] widget is not serialized. Store node type
  /// or other identifying info in [metadata] to rebuild widgets.
  Map<String, dynamic> toJson() => {
        'id': id,
        'position': {'dx': position.dx, 'dy': position.dy},
        if (size != const Size(150, 100))
          'size': {'width': size.width, 'height': size.height},
        if (ports.isNotEmpty) 'ports': ports.map((p) => p.toJson()).toList(),
        if (metadata != null) 'metadata': metadata,
      };

  /// Creates a copy of this node with optional new values.
  CanvasNode copyWith({
    String? id,
    Offset? position,
    Size? size,
    List<NodePort>? ports,
    Widget? child,
    bool? isSelected,
    bool? isDragging,
    Map<String, dynamic>? metadata,
  }) =>
      CanvasNode(
        id: id ?? this.id,
        position: position ?? this.position,
        size: size ?? this.size,
        ports: ports ?? this.ports,
        child: child ?? this.child,
        isSelected: isSelected ?? this.isSelected,
        isDragging: isDragging ?? this.isDragging,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        position,
        size,
        ports,
        isSelected,
        isDragging,
        metadata,
      ];
}
