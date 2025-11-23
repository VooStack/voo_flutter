import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/connection_style.dart';

/// Represents a connection between two node ports.
///
/// Connections link an output port from one node to an input port
/// of another node, creating a directed edge in the node graph.
class NodeConnection extends Equatable {
  /// Creates a node connection.
  ///
  /// The [id] must be unique across all connections.
  /// The [sourceNodeId] and [sourcePortId] identify the output port.
  /// The [targetNodeId] and [targetPortId] identify the input port.
  const NodeConnection({
    required this.id,
    required this.sourceNodeId,
    required this.sourcePortId,
    required this.targetNodeId,
    required this.targetPortId,
    this.style = ConnectionStyle.bezier,
    this.color,
    this.strokeWidth = 2.0,
    this.isSelected = false,
    this.metadata,
  });

  /// Creates a connection from JSON.
  factory NodeConnection.fromJson(Map<String, dynamic> json) => NodeConnection(
        id: json['id'] as String,
        sourceNodeId: json['sourceNodeId'] as String,
        sourcePortId: json['sourcePortId'] as String,
        targetNodeId: json['targetNodeId'] as String,
        targetPortId: json['targetPortId'] as String,
        style: json['style'] != null
            ? ConnectionStyle.values.byName(json['style'] as String)
            : ConnectionStyle.bezier,
        color: json['color'] != null ? Color(json['color'] as int) : null,
        strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2.0,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique identifier for this connection.
  final String id;

  /// The ID of the source node (where the connection starts).
  final String sourceNodeId;

  /// The ID of the output port on the source node.
  final String sourcePortId;

  /// The ID of the target node (where the connection ends).
  final String targetNodeId;

  /// The ID of the input port on the target node.
  final String targetPortId;

  /// The visual style of the connection line.
  final ConnectionStyle style;

  /// Optional custom color for this connection.
  final Color? color;

  /// The width of the connection line.
  final double strokeWidth;

  /// Whether this connection is currently selected.
  final bool isSelected;

  /// Optional custom metadata associated with this connection.
  final Map<String, dynamic>? metadata;

  /// Converts this connection to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceNodeId': sourceNodeId,
        'sourcePortId': sourcePortId,
        'targetNodeId': targetNodeId,
        'targetPortId': targetPortId,
        if (style != ConnectionStyle.bezier) 'style': style.name,
        if (color != null) 'color': color!.toARGB32(),
        if (strokeWidth != 2.0) 'strokeWidth': strokeWidth,
        if (metadata != null) 'metadata': metadata,
      };

  /// Creates a copy of this connection with optional new values.
  NodeConnection copyWith({
    String? id,
    String? sourceNodeId,
    String? sourcePortId,
    String? targetNodeId,
    String? targetPortId,
    ConnectionStyle? style,
    Color? color,
    double? strokeWidth,
    bool? isSelected,
    Map<String, dynamic>? metadata,
  }) =>
      NodeConnection(
        id: id ?? this.id,
        sourceNodeId: sourceNodeId ?? this.sourceNodeId,
        sourcePortId: sourcePortId ?? this.sourcePortId,
        targetNodeId: targetNodeId ?? this.targetNodeId,
        targetPortId: targetPortId ?? this.targetPortId,
        style: style ?? this.style,
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        isSelected: isSelected ?? this.isSelected,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        sourceNodeId,
        sourcePortId,
        targetNodeId,
        targetPortId,
        style,
        color,
        strokeWidth,
        isSelected,
        metadata,
      ];
}
