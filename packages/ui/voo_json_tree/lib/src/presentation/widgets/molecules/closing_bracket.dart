import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/indent_guide.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/node_bracket.dart';

/// A row displaying a closing bracket for expanded containers.
class ClosingBracket extends StatelessWidget {
  /// Creates a new [ClosingBracket].
  const ClosingBracket({
    super.key,
    required this.node,
    required this.theme,
    required this.config,
  });

  /// The container node this bracket closes.
  final JsonNode node;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The configuration.
  final JsonTreeConfig config;

  @override
  Widget build(BuildContext context) {
    final rowHeight = theme.fontSize * theme.lineHeight + theme.nodeSpacing * 2;

    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          // Indentation
          IndentGuide(
            depth: node.depth,
            theme: theme,
            height: rowHeight,
          ),

          // Spacer for expand icon
          const SizedBox(width: 20),

          // Closing bracket
          NodeBracket(
            type: node.type,
            isOpening: false,
            theme: theme,
          ),
        ],
      ),
    );
  }
}
