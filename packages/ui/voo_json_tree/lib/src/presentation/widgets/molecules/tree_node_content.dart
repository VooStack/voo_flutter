import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_builders.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/json_key_text.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/json_value_text.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/node_bracket.dart';

/// The content portion of a tree node (key: value display).
class TreeNodeContent extends StatelessWidget {
  /// Creates a new [TreeNodeContent].
  const TreeNodeContent({
    super.key,
    required this.node,
    required this.theme,
    required this.config,
    this.builders,
    this.isExpanded = false,
    this.searchResult,
  });

  /// The node to display.
  final JsonNode node;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The configuration.
  final JsonTreeConfig config;

  /// Custom builders for rendering.
  final JsonTreeBuilders? builders;

  /// Whether the node is expanded (for containers).
  final bool isExpanded;

  /// Search result for highlighting (if any).
  final JsonSearchResult? searchResult;

  @override
  Widget build(BuildContext context) {
    final isContainer = node.type.isContainer;
    final showKey = node.key.isNotEmpty && !node.key.startsWith('[');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Key (property name)
        if (showKey) ...[
          _buildKey(context),
          Text(
            ': ',
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: theme.fontSize,
              color: theme.keyColor,
            ),
          ),
        ],

        // Array index
        if (node.key.startsWith('[') && config.showArrayIndices) ...[
          Text(
            node.key,
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: theme.fontSize,
              color: theme.nullColor,
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: theme.fontSize,
              color: theme.keyColor,
            ),
          ),
        ],

        // Value or opening bracket
        if (isContainer) ...[
          NodeBracket(
            type: node.type,
            isOpening: true,
            theme: theme,
            showCount: config.showNodeCount && !isExpanded,
            count: node.childCount,
          ),
          if (!isExpanded)
            NodeBracket(
              type: node.type,
              isOpening: false,
              theme: theme,
            ),
        ] else
          _buildValue(context),
      ],
    );
  }

  /// Builds the key widget, applying custom builder if provided.
  Widget _buildKey(BuildContext context) {
    final defaultWidget = JsonKeyText(
      text: node.key,
      theme: theme,
      searchHighlight: searchResult?.matchType == JsonSearchMatchType.key ||
              searchResult?.matchType == JsonSearchMatchType.both
          ? searchResult?.matchText
          : null,
      highlightStart: searchResult?.matchStartIndex ?? 0,
      highlightLength: searchResult?.matchLength ?? 0,
    );

    if (builders?.keyBuilder != null) {
      return builders!.keyBuilder!(context, node, defaultWidget);
    }

    return defaultWidget;
  }

  /// Builds the value widget, applying custom builder if provided.
  Widget _buildValue(BuildContext context) {
    final defaultWidget = JsonValueText(
      value: node.value,
      type: node.type,
      theme: theme,
      maxLength: config.maxDisplayStringLength,
      searchHighlight: searchResult?.matchType == JsonSearchMatchType.value ||
              searchResult?.matchType == JsonSearchMatchType.both
          ? searchResult?.matchText
          : null,
      highlightStart: searchResult?.matchStartIndex ?? 0,
      highlightLength: searchResult?.matchLength ?? 0,
    );

    if (builders?.valueBuilder != null) {
      return builders!.valueBuilder!(context, node, defaultWidget);
    }

    return defaultWidget;
  }
}
