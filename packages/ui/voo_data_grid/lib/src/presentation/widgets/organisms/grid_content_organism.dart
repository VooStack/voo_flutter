import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Grid content organism for displaying the main table/grid content
class GridContentOrganism<T> extends StatelessWidget {
  final VooDataGridState<T> state;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final ScrollController verticalScrollController;
  final Widget? loadingWidget;
  final Widget? emptyStateWidget;
  final Widget Function(String)? errorBuilder;
  final void Function(T)? onRowTap;
  final void Function(T)? onRowDoubleTap;
  final void Function(T)? onRowHover;
  final bool alwaysShowVerticalScrollbar;
  
  const GridContentOrganism({
    super.key,
    required this.state,
    required this.controller,
    required this.theme,
    required this.verticalScrollController,
    this.loadingWidget,
    this.emptyStateWidget,
    this.errorBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    this.alwaysShowVerticalScrollbar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && loadingWidget != null) {
      return Center(child: loadingWidget);
    }

    if (state.error != null && errorBuilder != null) {
      return Center(child: errorBuilder!(state.error!));
    }

    if (state.rows.isEmpty) {
      return Center(
        child: emptyStateWidget ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: theme.headerTextColor.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: theme.cellTextStyle.copyWith(
                    fontSize: 16,
                    color: theme.headerTextColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
      );
    }

    return Column(
      children: [
        VooDataGridHeader<T>(
          controller: controller,
          theme: theme,
          onSort: controller.sortColumn,
        ),
        if (state.filtersVisible)
          VooDataGridFilterRow<T>(
            controller: controller,
            theme: theme,
          ),
        Expanded(
          child: Scrollbar(
            controller: verticalScrollController,
            thumbVisibility: alwaysShowVerticalScrollbar,
            child: ListView.builder(
              controller: verticalScrollController,
              itemCount: state.rows.length,
              itemBuilder: (context, index) {
                final row = state.rows[index];
                final isSelected = state.selectedRows.contains(row);

                return VooDataGridRow<T>(
                  row: row,
                  index: index,
                  controller: controller,
                  theme: theme,
                  isSelected: isSelected,
                  onTap: onRowTap != null ? () => onRowTap!(row) : null,
                  onDoubleTap: onRowDoubleTap != null ? () => onRowDoubleTap!(row) : null,
                  onHover: (hover) => onRowHover?.call(row),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}