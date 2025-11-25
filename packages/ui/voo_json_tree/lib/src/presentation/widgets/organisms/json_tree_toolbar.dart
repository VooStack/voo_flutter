import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';
import 'package:voo_json_tree/src/presentation/widgets/molecules/json_search_bar.dart';

/// A toolbar with search and tree controls.
class JsonTreeToolbar extends StatelessWidget {
  /// Creates a new [JsonTreeToolbar].
  const JsonTreeToolbar({
    super.key,
    required this.theme,
    this.showSearch = true,
    this.showExpandAll = true,
    this.showCollapseAll = true,
    this.onSearch,
    this.onSearchClear,
    this.onNextResult,
    this.onPreviousResult,
    this.onExpandAll,
    this.onCollapseAll,
    this.searchResultCount = 0,
    this.currentSearchIndex = 0,
    this.additionalActions,
  });

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// Whether to show the search bar.
  final bool showSearch;

  /// Whether to show expand all button.
  final bool showExpandAll;

  /// Whether to show collapse all button.
  final bool showCollapseAll;

  /// Callback when search query changes.
  final ValueChanged<String>? onSearch;

  /// Callback when search is cleared.
  final VoidCallback? onSearchClear;

  /// Callback to go to next search result.
  final VoidCallback? onNextResult;

  /// Callback to go to previous search result.
  final VoidCallback? onPreviousResult;

  /// Callback to expand all nodes.
  final VoidCallback? onExpandAll;

  /// Callback to collapse all nodes.
  final VoidCallback? onCollapseAll;

  /// Number of search results.
  final int searchResultCount;

  /// Current search result index.
  final int currentSearchIndex;

  /// Additional action widgets.
  final List<Widget>? additionalActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.indentGuideColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search bar
          if (showSearch)
            Expanded(
              child: JsonSearchBar(
                theme: theme,
                onSearch: onSearch,
                onClear: onSearchClear,
                onNext: onNextResult,
                onPrevious: onPreviousResult,
                resultCount: searchResultCount,
                currentIndex: currentSearchIndex,
              ),
            ),

          if (showSearch && (showExpandAll || showCollapseAll))
            const SizedBox(width: 8),

          // Expand/Collapse buttons
          if (showExpandAll)
            _ToolbarButton(
              icon: Icons.unfold_more,
              tooltip: 'Expand all',
              onPressed: onExpandAll,
              color: theme.expandIconColor,
            ),

          if (showCollapseAll)
            _ToolbarButton(
              icon: Icons.unfold_less,
              tooltip: 'Collapse all',
              onPressed: onCollapseAll,
              color: theme.expandIconColor,
            ),

          // Additional actions
          if (additionalActions != null) ...additionalActions!,
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}
