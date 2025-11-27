import 'package:equatable/equatable.dart';

import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';

/// Represents a single node in the JSON tree structure.
///
/// Each node contains information about its key, value, type, and children.
/// The [path] property provides the full JSON path from the root.
class JsonNode extends Equatable {
  /// Creates a new [JsonNode].
  const JsonNode({required this.key, required this.value, required this.type, required this.path, this.children = const [], this.depth = 0, this.index});

  /// The key of this node (property name or array index as string).
  final String key;

  /// The raw value of this node.
  ///
  /// For container types (object/array), this is the original Map or List.
  /// For primitives, this is the actual value (String, num, bool, or null).
  final dynamic value;

  /// The type of this node.
  final JsonNodeType type;

  /// The full JSON path from the root to this node.
  ///
  /// Example: "root.users[0].name"
  final String path;

  /// Child nodes for container types (object/array).
  final List<JsonNode> children;

  /// The depth level in the tree (0 for root).
  final int depth;

  /// The index of this node if it's an array element.
  final int? index;

  /// Returns true if this node can be expanded (has children).
  bool get isExpandable => type.isContainer && children.isNotEmpty;

  /// Returns the number of children.
  int get childCount => children.length;

  /// Returns a formatted string representation of the value.
  String get displayValue {
    switch (type) {
      case JsonNodeType.string:
        return '"$value"';
      case JsonNodeType.number:
      case JsonNodeType.boolean:
        return value.toString();
      case JsonNodeType.nullValue:
        return 'null';
      case JsonNodeType.object:
        return '{${children.length}}';
      case JsonNodeType.array:
        return '[${children.length}]';
    }
  }

  /// Returns just the value portion for display (without quotes for strings).
  String get rawDisplayValue {
    switch (type) {
      case JsonNodeType.nullValue:
        return 'null';
      case JsonNodeType.object:
        return '{${children.length}}';
      case JsonNodeType.array:
        return '[${children.length}]';
      default:
        return value.toString();
    }
  }

  /// Creates a copy with the given fields replaced.
  JsonNode copyWith({String? key, dynamic value, JsonNodeType? type, String? path, List<JsonNode>? children, int? depth, int? index}) => JsonNode(
    key: key ?? this.key,
    value: value ?? this.value,
    type: type ?? this.type,
    path: path ?? this.path,
    children: children ?? this.children,
    depth: depth ?? this.depth,
    index: index ?? this.index,
  );

  @override
  List<Object?> get props => [key, type, path, depth, index, children.length];
}
