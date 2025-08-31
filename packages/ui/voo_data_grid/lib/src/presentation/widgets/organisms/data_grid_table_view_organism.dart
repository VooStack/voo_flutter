import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Table view organism for displaying data grid rows in a table format
class DataGridTableViewOrganism<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final Widget? loadingWidget;
  final Widget? emptyStateWidget;
  final Widget Function(String)? errorBuilder;
  final VooDataGridTheme theme;
  final void Function(T)? onRowTap;
  final void Function(T)? onRowDoubleTap;
  final void Function(T)? onRowHover;
  final double width;
  final bool alwaysShowVerticalScrollbar;
  final bool alwaysShowHorizontalScrollbar;
  final List<String>? mobilePriorityColumns;

  const DataGridTableViewOrganism({
    super.key,
    required this.controller,
    required this.theme,
    required this.width,
    this.loadingWidget,
    this.emptyStateWidget,
    this.errorBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    this.alwaysShowVerticalScrollbar = false,
    this.alwaysShowHorizontalScrollbar = false,
    this.mobilePriorityColumns,
  });

  bool _isMobile(double width) => width < 768;
  bool _isTablet(double width) => width >= 768 && width < 1024;
  bool _isDesktop(double width) => width >= 1024;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final dataSource = controller.dataSource;

    if (dataSource.isLoading && dataSource.rows.isEmpty) {
      return Center(
        child: loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    // Filter columns based on screen width - update controller after build
    final visibleColumns = _getVisibleColumnsForWidth(width);
    
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setVisibleColumns(visibleColumns);
    });

    // Don't show inline filters on mobile or tablet - use bottom sheet instead
    final showInlineFilters = controller.showFilters && !_isMobile(width) && !_isTablet(width);

    return Column(
      children: [
        // Header - Always show headers even when no data or error
        VooDataGridHeader<T>(
          controller: controller,
          theme: theme,
          onSort: controller.sortColumn,
        ),

        // Filters (only on desktop) - Keep visible even during errors
        if (showInlineFilters)
          VooDataGridFilterRow<T>(
            controller: controller,
            theme: theme,
          ),

        // Data rows, error state, or empty state
        Expanded(
          child: dataSource.error != null
              ? Center(
                  child: errorBuilder?.call(dataSource.error ?? 'Unknown error') ??
                      VooEmptyState(
                        icon: Icons.error_outline,
                        title: 'Error Loading Data',
                        message: dataSource.error!,
                        action: TextButton(
                          onPressed: dataSource.refresh,
                          child: const Text('Retry'),
                        ),
                      ),
                )
              : dataSource.rows.isEmpty
                  ? Center(
                      child: emptyStateWidget ??
                          const VooEmptyState(
                            icon: Icons.table_rows_outlined,
                            title: 'No Data',
                            message: 'No rows to display',
                          ),
                    )
                  : _DataGridRowsSection<T>(
                      controller: controller,
                      theme: theme,
                      design: design,
                      onRowTap: onRowTap,
                      onRowDoubleTap: onRowDoubleTap,
                      onRowHover: onRowHover,
                      alwaysShowVerticalScrollbar: alwaysShowVerticalScrollbar,
                      alwaysShowHorizontalScrollbar: alwaysShowHorizontalScrollbar,
                    ),
        ),

        // Loading overlay
        if (dataSource.isLoading && dataSource.rows.isNotEmpty) const LinearProgressIndicator(),
      ],
    );
  }

  List<VooDataColumn<T>> _getVisibleColumnsForWidth(double width) {
    final allColumns = controller.columns;

    if (_isDesktop(width)) {
      return allColumns;
    } else if (_isTablet(width)) {
      // Show frozen columns and high priority columns
      return allColumns.where((col) => col.frozen || col.visible).toList();
    } else {
      // Mobile: Show only priority columns
      return _getPriorityColumns();
    }
  }

  List<VooDataColumn<T>> _getPriorityColumns() {
    final allColumns = controller.columns;

    if (mobilePriorityColumns != null && mobilePriorityColumns!.isNotEmpty) {
      return allColumns.where((col) => mobilePriorityColumns!.contains(col.field)).toList();
    }

    // Default: show first 4 visible columns
    return allColumns.where((col) => col.visible).take(4).toList();
  }
}

/// Internal widget for data rows to avoid _build methods
class _DataGridRowsSection<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;
  final void Function(T)? onRowTap;
  final void Function(T)? onRowDoubleTap;
  final void Function(T)? onRowHover;
  final bool alwaysShowVerticalScrollbar;
  final bool alwaysShowHorizontalScrollbar;

  const _DataGridRowsSection({
    required this.controller,
    required this.theme,
    required this.design,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    required this.alwaysShowVerticalScrollbar,
    required this.alwaysShowHorizontalScrollbar,
  });

  @override
  Widget build(BuildContext context) {
    final rows = controller.dataSource.rows;
    final selectedRows = controller.dataSource.selectedRows;

    // Calculate total width needed for scrollable columns
    double scrollableWidth = 0;
    for (final column in controller.scrollableColumns) {
      scrollableWidth += controller.getColumnWidth(column);
    }

    // Calculate width for fixed columns
    double fixedWidth = 0;
    if (controller.dataSource.selectionMode != VooSelectionMode.none) {
      fixedWidth += 48; // Selection checkbox width
    }
    for (final column in controller.frozenColumns) {
      fixedWidth += controller.getColumnWidth(column);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsHorizontalScroll = (fixedWidth + scrollableWidth) > constraints.maxWidth;
        final totalWidth = fixedWidth + scrollableWidth;

        // Build rows
        final rowsList = List.generate(
          rows.length,
          (i) => VooDataGridRow<T>(
            row: rows[i],
            index: i,
            controller: controller,
            theme: theme,
            isSelected: selectedRows.contains(rows[i]),
            onTap: () {
              controller.dataSource.toggleRowSelection(rows[i]);
              onRowTap?.call(rows[i]);
            },
            onDoubleTap: () => onRowDoubleTap?.call(rows[i]),
            onRowHover: onRowHover,
          ),
        );

        // Build scrollable content with proper scrollbar visibility
        if (needsHorizontalScroll) {
          // Both horizontal and vertical scrolling needed
          return Scrollbar(
            controller: controller.verticalScrollController,
            thumbVisibility: alwaysShowVerticalScrollbar,
            trackVisibility: alwaysShowVerticalScrollbar,
            child: Scrollbar(
              controller: controller.bodyHorizontalScrollController,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              thumbVisibility: alwaysShowHorizontalScrollbar,
              trackVisibility: alwaysShowHorizontalScrollbar,
              notificationPredicate: (notification) => notification.depth == 1,
              child: SingleChildScrollView(
                controller: controller.verticalScrollController,
                child: SingleChildScrollView(
                  controller: controller.bodyHorizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(children: rowsList),
                  ),
                ),
              ),
            ),
          );
        }

        // Only vertical scrolling needed
        return Scrollbar(
          controller: controller.verticalScrollController,
          thumbVisibility: alwaysShowVerticalScrollbar,
          trackVisibility: alwaysShowVerticalScrollbar,
          child: SingleChildScrollView(
            controller: controller.verticalScrollController,
            child: Column(children: rowsList),
          ),
        );
      },
    );
  }
}