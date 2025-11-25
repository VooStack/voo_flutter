import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A styled bracket widget for JSON objects and arrays.
class NodeBracket extends StatelessWidget {
  /// Creates a new [NodeBracket].
  const NodeBracket({
    super.key,
    required this.type,
    required this.isOpening,
    required this.theme,
    this.showCount = false,
    this.count = 0,
  });

  /// The type of container (object or array).
  final JsonNodeType type;

  /// Whether this is an opening or closing bracket.
  final bool isOpening;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Whether to show the child count.
  final bool showCount;

  /// The number of children.
  final int count;

  @override
  Widget build(BuildContext context) {
    String bracket;

    if (type == JsonNodeType.object) {
      bracket = isOpening ? '{' : '}';
    } else if (type == JsonNodeType.array) {
      bracket = isOpening ? '[' : ']';
    } else {
      return const SizedBox.shrink();
    }

    if (isOpening && showCount) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: bracket,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: theme.fontSize,
                color: theme.bracketColor,
              ),
            ),
            TextSpan(
              text: ' $count ',
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: theme.fontSize * 0.85,
                color: theme.nullColor,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      bracket,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        fontSize: theme.fontSize,
        color: theme.bracketColor,
      ),
    );
  }
}
