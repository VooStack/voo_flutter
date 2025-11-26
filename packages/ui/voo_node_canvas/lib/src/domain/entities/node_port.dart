import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:voo_node_canvas/src/domain/enums/port_position.dart';
import 'package:voo_node_canvas/src/domain/enums/port_type.dart';

/// Represents a connection port on a node.
///
/// Ports are the connection points on nodes where connections
/// can be made. Each port has a type (input or output), a unique
/// identifier, and an optional position that determines which
/// side of the node the port appears on.
class NodePort extends Equatable {
  /// Creates a node port.
  ///
  /// The [id] must be unique within a node.
  /// The [type] determines whether this port receives or initiates connections.
  /// The [position] determines which side of the node the port appears on.
  ///   If null, defaults to [PortPosition.left] for inputs and
  ///   [PortPosition.right] for outputs.
  /// The [label] is an optional display label for the port.
  /// The [offset] defines the position relative to the port's default position.
  /// The [color] overrides the default port color.
  /// The [highlightColor] is used when the port is a valid connection target.
  /// The [connectedColor] is used when the port has an active connection.
  const NodePort({
    required this.id,
    required this.type,
    this.position,
    this.label,
    this.offset = Offset.zero,
    this.color,
    this.highlightColor,
    this.connectedColor,
  });

  /// Creates a node port from JSON.
  factory NodePort.fromJson(Map<String, dynamic> json) => NodePort(
        id: json['id'] as String,
        type: PortType.values.byName(json['type'] as String),
        position: json['position'] != null
            ? PortPosition.values.byName(json['position'] as String)
            : null,
        label: json['label'] as String?,
        offset: json['offset'] != null
            ? Offset(
                (json['offset']['dx'] as num).toDouble(),
                (json['offset']['dy'] as num).toDouble(),
              )
            : Offset.zero,
        color: json['color'] != null ? Color(json['color'] as int) : null,
        highlightColor: json['highlightColor'] != null
            ? Color(json['highlightColor'] as int)
            : null,
        connectedColor: json['connectedColor'] != null
            ? Color(json['connectedColor'] as int)
            : null,
      );

  /// Unique identifier for this port within its parent node.
  final String id;

  /// The type of this port (input or output).
  final PortType type;

  /// The position of this port on the node (left, right, top, bottom).
  ///
  /// If null, defaults based on [type]:
  /// - [PortType.input] defaults to [PortPosition.left]
  /// - [PortType.output] defaults to [PortPosition.right]
  final PortPosition? position;

  /// Optional display label for the port.
  final String? label;

  /// Position offset relative to the port's default placement.
  final Offset offset;

  /// Optional custom color for this port.
  final Color? color;

  /// Optional highlight color for when the port is a valid connection target.
  ///
  /// If null, uses a lighter version of [color] or the theme highlight color.
  final Color? highlightColor;

  /// Optional color for when the port has an active connection.
  ///
  /// If null, uses [color] or the theme connected color.
  final Color? connectedColor;

  /// Returns the effective position of this port.
  ///
  /// If [position] is set, returns it. Otherwise, returns the default
  /// position based on [type] (left for inputs, right for outputs).
  PortPosition get effectivePosition =>
      position ??
      (type == PortType.input ? PortPosition.left : PortPosition.right);

  /// Converts this port to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        if (position != null) 'position': position!.name,
        if (label != null) 'label': label,
        if (offset != Offset.zero)
          'offset': {'dx': offset.dx, 'dy': offset.dy},
        if (color != null) 'color': color!.toARGB32(),
        if (highlightColor != null)
          'highlightColor': highlightColor!.toARGB32(),
        if (connectedColor != null)
          'connectedColor': connectedColor!.toARGB32(),
      };

  /// Creates a copy of this port with optional new values.
  NodePort copyWith({
    String? id,
    PortType? type,
    PortPosition? position,
    String? label,
    Offset? offset,
    Color? color,
    Color? highlightColor,
    Color? connectedColor,
  }) =>
      NodePort(
        id: id ?? this.id,
        type: type ?? this.type,
        position: position ?? this.position,
        label: label ?? this.label,
        offset: offset ?? this.offset,
        color: color ?? this.color,
        highlightColor: highlightColor ?? this.highlightColor,
        connectedColor: connectedColor ?? this.connectedColor,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        position,
        label,
        offset,
        color,
        highlightColor,
        connectedColor,
      ];
}
