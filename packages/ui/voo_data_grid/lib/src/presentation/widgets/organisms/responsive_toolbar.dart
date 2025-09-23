import 'package:flutter/material.dart';

import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Responsive toolbar widget for the data grid
class ResponsiveToolbar<T> extends StatelessWidget {
  final double width;
  final VooDataGridState<T> state;
  final VooDataGridTheme theme;
  final VoidCallback? onRefresh;
  final List<Widget>? toolbarActions;
  final VooDataGridDisplayMode displayMode;
  final VooDataGridDisplayMode? userSelectedMode;
  final void Function(VooDataGridDisplayMode) onDisplayModeChanged;
  final void Function() onToggleFilters;
  final void Function() onClearFilters;
  final void Function(BuildContext, dynamic) onShowMobileFilterSheet;

  const ResponsiveToolbar({
    super.key,
    required this.width,
    required this.state,
    required this.theme,
    required this.displayMode,
    required this.onToggleFilters,
    required this.onClearFilters,
    required this.onShowMobileFilterSheet,
    required this.onDisplayModeChanged,
    this.onRefresh,
    this.toolbarActions,
    this.userSelectedMode,
  });

  bool _isMobile(double width) => width < 600;
  bool _isTablet(double width) => width >= 600 && width < 1024;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final isMobile = _isMobile(width);
    final isTablet = _isTablet(width);
    final hasActiveFilters = state.filters.isNotEmpty;

    if (isMobile || isTablet) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(design.spacingSm),
            decoration: BoxDecoration(
              color: theme.headerBackgroundColor,
              border: Border(bottom: BorderSide(color: theme.borderColor)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh, tooltip: 'Refresh'),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            hasActiveFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                            color: hasActiveFilters ? Theme.of(context).colorScheme.primary : null,
                          ),
                          onPressed: () => onShowMobileFilterSheet(context, null),
                          tooltip: 'Filters',
                        ),
                        if (hasActiveFilters)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                              child: Text(
                                '${state.filters.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (displayMode == VooDataGridDisplayMode.table)
                      if (isMobile) // Only show view switcher on mobile
                        IconButton(
                          icon: Icon(displayMode == VooDataGridDisplayMode.table ? Icons.view_agenda : Icons.table_chart),
                          onPressed: () {
                            onDisplayModeChanged(displayMode == VooDataGridDisplayMode.table ? VooDataGridDisplayMode.cards : VooDataGridDisplayMode.table);
                          },
                          tooltip: displayMode == VooDataGridDisplayMode.table ? 'Switch to Card View' : 'Switch to Table View',
                        ),
                    const Spacer(),
                    if (toolbarActions != null && toolbarActions!.isNotEmpty)
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => toolbarActions!.map((action) => PopupMenuItem<Widget>(child: action)).toList(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Desktop toolbar
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh, tooltip: 'Refresh'),
          IconButton(
            icon: Icon(hasActiveFilters ? Icons.filter_alt : Icons.filter_alt_outlined, color: hasActiveFilters ? Theme.of(context).colorScheme.primary : null),
            onPressed: onToggleFilters,
            tooltip: 'Toggle Filters',
          ),
          if (hasActiveFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(label: Text('${state.filters.length} filters'), deleteIcon: const Icon(Icons.clear, size: 18), onDeleted: onClearFilters),
            ),
          const Spacer(),
          if (toolbarActions != null) ...toolbarActions!,
        ],
      ),
    );
  }
}
