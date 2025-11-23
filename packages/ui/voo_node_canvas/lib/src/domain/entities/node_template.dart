import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/entities/canvas_node.dart';
import 'package:voo_node_canvas/src/domain/entities/node_port.dart';

/// A template for creating nodes on the canvas.
///
/// Node templates define the blueprint for creating new nodes.
/// They specify the default properties, ports, and how to build
/// the node's visual content.
///
/// Example:
/// ```dart
/// final template = NodeTemplate(
///   type: 'process',
///   label: 'Process Node',
///   icon: Icons.settings,
///   color: Colors.blue,
///   defaultSize: const Size(150, 100),
///   defaultPorts: [
///     const NodePort(id: 'in1', type: PortType.input),
///     const NodePort(id: 'out1', type: PortType.output),
///   ],
/// );
/// ```
class NodeTemplate extends Equatable {
  /// Creates a node template.
  const NodeTemplate({
    required this.type,
    required this.label,
    this.description,
    this.icon,
    this.color,
    this.defaultSize = const Size(150, 100),
    this.defaultPorts = const [],
    this.defaultMetadata,
    this.category,
  });

  /// The unique type identifier for this template.
  ///
  /// This is used to identify the node type when serializing/deserializing.
  final String type;

  /// The display label for this template.
  final String label;

  /// Optional description of what this node type does.
  final String? description;

  /// Optional icon to display in the palette.
  final IconData? icon;

  /// Optional color theme for this node type.
  final Color? color;

  /// The default size for nodes created from this template.
  final Size defaultSize;

  /// The default ports for nodes created from this template.
  final List<NodePort> defaultPorts;

  /// Default metadata to include when creating nodes.
  final Map<String, dynamic>? defaultMetadata;

  /// Optional category for grouping templates in the palette.
  final String? category;

  /// Creates a new [CanvasNode] from this template.
  ///
  /// The [id] must be unique across all nodes on the canvas.
  /// The [position] specifies where to place the node.
  /// The [child] is the widget to display as the node content.
  /// Additional [metadata] is merged with [defaultMetadata].
  CanvasNode createNode({
    required String id,
    required Offset position,
    Widget? child,
    Map<String, dynamic>? metadata,
  }) {
    final mergedMetadata = <String, dynamic>{
      'type': type,
      if (defaultMetadata != null) ...defaultMetadata!,
      if (metadata != null) ...metadata,
    };

    return CanvasNode(
      id: id,
      position: position,
      size: defaultSize,
      ports: defaultPorts,
      child: child,
      metadata: mergedMetadata,
    );
  }

  /// Creates a copy of this template with optional new values.
  NodeTemplate copyWith({
    String? type,
    String? label,
    String? description,
    IconData? icon,
    Color? color,
    Size? defaultSize,
    List<NodePort>? defaultPorts,
    Map<String, dynamic>? defaultMetadata,
    String? category,
  }) =>
      NodeTemplate(
        type: type ?? this.type,
        label: label ?? this.label,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        defaultSize: defaultSize ?? this.defaultSize,
        defaultPorts: defaultPorts ?? this.defaultPorts,
        defaultMetadata: defaultMetadata ?? this.defaultMetadata,
        category: category ?? this.category,
      );

  @override
  List<Object?> get props => [
        type,
        label,
        description,
        icon,
        color,
        defaultSize,
        defaultPorts,
        defaultMetadata,
        category,
      ];
}
