import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// An icon indicating the type of a JSON node.
class NodeTypeIcon extends StatelessWidget {
  /// Creates a new [NodeTypeIcon].
  const NodeTypeIcon({
    super.key,
    required this.type,
    required this.theme,
    this.size = 14.0,
  });

  /// The type of the node.
  final JsonNodeType type;

  /// The theme to use for colors.
  final VooJsonTreeTheme theme;

  /// The size of the icon.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(),
      size: size,
      color: _getColor(),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case JsonNodeType.object:
        return Icons.data_object;
      case JsonNodeType.array:
        return Icons.data_array;
      case JsonNodeType.string:
        return Icons.text_fields;
      case JsonNodeType.number:
        return Icons.numbers;
      case JsonNodeType.boolean:
        return Icons.toggle_on_outlined;
      case JsonNodeType.nullValue:
        return Icons.block;
    }
  }

  Color _getColor() {
    switch (type) {
      case JsonNodeType.object:
        return theme.bracketColor;
      case JsonNodeType.array:
        return theme.bracketColor;
      case JsonNodeType.string:
        return theme.stringColor;
      case JsonNodeType.number:
        return theme.numberColor;
      case JsonNodeType.boolean:
        return theme.booleanColor;
      case JsonNodeType.nullValue:
        return theme.nullColor;
    }
  }
}
