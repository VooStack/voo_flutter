import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/port_type.dart';

/// Represents a connection port on a node.
///
/// Ports are the connection points on nodes where connections
/// can be made. Each port has a type (input or output), a unique
/// identifier, and an optional position offset relative to its
/// default placement on the node.
class NodePort extends Equatable {
  /// Creates a node port.
  ///
  /// The [id] must be unique within a node.
  /// The [type] determines whether this port receives or initiates connections.
  /// The [label] is an optional display label for the port.
  /// The [offset] defines the position relative to the port's default position.
  /// The [color] overrides the default port color.
  const NodePort({
    required this.id,
    required this.type,
    this.label,
    this.offset = Offset.zero,
    this.color,
  });

  /// Creates a node port from JSON.
  factory NodePort.fromJson(Map<String, dynamic> json) => NodePort(
        id: json['id'] as String,
        type: PortType.values.byName(json['type'] as String),
        label: json['label'] as String?,
        offset: json['offset'] != null
            ? Offset(
                (json['offset']['dx'] as num).toDouble(),
                (json['offset']['dy'] as num).toDouble(),
              )
            : Offset.zero,
        color: json['color'] != null ? Color(json['color'] as int) : null,
      );

  /// Unique identifier for this port within its parent node.
  final String id;

  /// The type of this port (input or output).
  final PortType type;

  /// Optional display label for the port.
  final String? label;

  /// Position offset relative to the port's default placement.
  final Offset offset;

  /// Optional custom color for this port.
  final Color? color;

  /// Converts this port to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        if (label != null) 'label': label,
        if (offset != Offset.zero)
          'offset': {'dx': offset.dx, 'dy': offset.dy},
        if (color != null) 'color': color!.toARGB32(),
      };

  /// Creates a copy of this port with optional new values.
  NodePort copyWith({
    String? id,
    PortType? type,
    String? label,
    Offset? offset,
    Color? color,
  }) =>
      NodePort(
        id: id ?? this.id,
        type: type ?? this.type,
        label: label ?? this.label,
        offset: offset ?? this.offset,
        color: color ?? this.color,
      );

  @override
  List<Object?> get props => [id, type, label, offset, color];
}
