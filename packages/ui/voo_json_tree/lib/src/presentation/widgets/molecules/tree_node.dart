import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_node.dart';
import 'package:voo_json_tree/src/domain/entities/json_node_type.dart';
import 'package:voo_json_tree/src/domain/entities/json_search_result.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_builders.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_config.dart';
import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/copy_button.dart';
import 'package:voo_json_tree/src/presentation/widgets/atoms/expand_icon.dart' as atoms;
import 'package:voo_json_tree/src/presentation/widgets/atoms/indent_guide.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/tree_node_content.dart';

/// A complete tree node row with indentation, expand icon, and content.
class TreeNode extends StatelessWidget {
  /// Creates a new [TreeNode].
  const TreeNode({
    super.key,
    required this.node,
    required this.theme,
    required this.config,
    this.builders,
    this.isExpanded = false,
    this.isSelected = false,
    this.isHovered = false,
    this.searchResult,
    this.onToggle,
    this.onSelect,
    this.onHover,
    this.onCopy,
  });

  /// The node to display.
  final JsonNode node;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The configuration.
  final JsonTreeConfig config;

  /// Custom builders for rendering.
  final JsonTreeBuilders? builders;

  /// Whether the node is expanded.
  final bool isExpanded;

  /// Whether the node is selected.
  final bool isSelected;

  /// Whether the node is being hovered.
  final bool isHovered;

  /// Search result for highlighting (if any).
  final JsonSearchResult? searchResult;

  /// Callback when the expand/collapse is toggled.
  final VoidCallback? onToggle;

  /// Callback when the node is selected.
  final VoidCallback? onSelect;

  /// Callback when hover state changes.
  final ValueChanged<bool>? onHover;

  /// Callback when copy is triggered.
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final rowHeight = theme.fontSize * theme.lineHeight + theme.nodeSpacing * 2;

    return MouseRegion(
      onEnter: config.enableHover ? (_) => onHover?.call(true) : null,
      onExit: config.enableHover ? (_) => onHover?.call(false) : null,
      child: GestureDetector(
        onTap: config.enableSelection ? onSelect : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: rowHeight,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
          ),
          child: Row(
            children: [
              // Indentation with guides
              IndentGuide(
                depth: node.depth,
                theme: theme,
                height: rowHeight,
              ),

              // Expand/collapse icon or spacer
              SizedBox(
                width: 20,
                child: node.isExpandable
                    ? atoms.ExpandIcon(
                        isExpanded: isExpanded,
                        onPressed: () => onToggle?.call(),
                        color: theme.expandIconColor,
                        size: 16,
                        duration: config.animateExpansion
                            ? config.expansionAnimationDuration
                            : Duration.zero,
                      )
                    : const SizedBox.shrink(),
              ),

              // Node content
              Expanded(
                child: TreeNodeContent(
                  node: node,
                  theme: theme,
                  config: config,
                  builders: builders,
                  isExpanded: isExpanded,
                  searchResult: searchResult,
                ),
              ),

              // Copy button (shown on hover)
              if (config.enableCopy && isHovered)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CopyButton(
                    content: _getCopyContent(),
                    color: theme.expandIconColor,
                    size: 14,
                    tooltip: 'Copy value',
                    onCopied: onCopy,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color? _getBackgroundColor() {
    if (isSelected) return theme.selectedColor;
    if (isHovered) return theme.hoverColor;
    if (searchResult != null) return theme.searchMatchColor.withOpacity(0.2);
    return null;
  }

  String _getCopyContent() {
    if (node.type.isPrimitive) {
      return node.value?.toString() ?? 'null';
    }
    // For containers, copy the full JSON
    return _formatJson(node.value);
  }

  String _formatJson(dynamic value, [int indent = 0]) {
    const indentStr = '  ';
    final currentIndent = indentStr * indent;
    final nextIndent = indentStr * (indent + 1);

    if (value is Map) {
      if (value.isEmpty) return '{}';
      final entries = value.entries.map((e) {
        final val = _formatJson(e.value, indent + 1);
        return '$nextIndent"${e.key}": $val';
      }).join(',\n');
      return '{\n$entries\n$currentIndent}';
    }

    if (value is List) {
      if (value.isEmpty) return '[]';
      final items = value.map((e) {
        final val = _formatJson(e, indent + 1);
        return '$nextIndent$val';
      }).join(',\n');
      return '[\n$items\n$currentIndent]';
    }

    if (value is String) {
      final escaped = value
          .replaceAll('\\', '\\\\')
          .replaceAll('"', '\\"')
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return '"$escaped"';
    }

    if (value == null) return 'null';
    return value.toString();
  }
}
