import 'package:flutter/material.dart';
import 'package:voo_ui/src/data/data_grid_controller.dart';
import 'package:voo_ui/src/data/data_grid_header.dart';
import 'package:voo_ui/src/data/data_grid_row.dart';
import 'package:voo_ui/src/data/data_grid_filter.dart';
import 'package:voo_ui/src/data/data_grid_pagination.dart';
import 'package:voo_ui/src/foundations/design_system.dart';
import 'package:voo_ui/src/feedback/empty_state.dart';

/// A powerful data grid widget with remote filtering support
class VooDataGrid extends StatefulWidget {
  /// Controller for the data grid
  final VooDataGridController controller;

  /// Whether to show pagination controls
  final bool showPagination;

  /// Whether to show the toolbar
  final bool showToolbar;

  /// Custom toolbar widgets
  final List<Widget>? toolbarActions;

  /// Empty state widget
  final Widget? emptyStateWidget;

  /// Loading indicator widget
  final Widget? loadingWidget;

  /// Error widget builder
  final Widget Function(String error)? errorBuilder;

  /// Row tap callback
  final void Function(dynamic row)? onRowTap;

  /// Row double tap callback
  final void Function(dynamic row)? onRowDoubleTap;

  /// Row hover callback
  final void Function(dynamic)? onRowHover;

  /// Border decoration
  final BoxDecoration? decoration;

  /// Grid theme
  final VooDataGridTheme? theme;

  const VooDataGrid({
    super.key,
    required this.controller,
    this.showPagination = true,
    this.showToolbar = true,
    this.toolbarActions,
    this.emptyStateWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    this.decoration,
    this.theme,
  });

  @override
  State<VooDataGrid> createState() => _VooDataGridState();
}

class _VooDataGridState extends State<VooDataGrid> {
  dynamic _hoveredRow;
  late VooDataGridTheme _theme;

  @override
  void initState() {
    super.initState();
    widget.controller.dataSource.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooDataGridTheme.fromContext(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.controller,
        widget.controller.dataSource,
      ]),
      builder: (context, _) {
        return Container(
          decoration: widget.decoration ??
              BoxDecoration(
                border: Border.all(color: _theme.borderColor),
                borderRadius: BorderRadius.circular(design.radiusMd),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showToolbar) _buildToolbar(design),
              Expanded(
                child: _buildGridContent(design),
              ),
              if (widget.showPagination &&
                  !widget.controller.dataSource.isLoading)
                VooDataGridPagination(
                  currentPage: widget.controller.dataSource.currentPage,
                  totalPages: widget.controller.dataSource.totalPages,
                  pageSize: widget.controller.dataSource.pageSize,
                  totalRows: widget.controller.dataSource.totalRows,
                  onPageChanged: widget.controller.dataSource.changePage,
                  onPageSizeChanged:
                      widget.controller.dataSource.changePageSize,
                  theme: _theme,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolbar(VooDesignSystemData design) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        color: _theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: _theme.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: widget.controller.dataSource.refresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(widget.controller.showFilters
                ? Icons.filter_alt
                : Icons.filter_alt_outlined),
            onPressed: widget.controller.toggleFilters,
            tooltip: 'Toggle Filters',
          ),
          if (widget.controller.dataSource.filters.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.clear, size: 16),
              label: Text(
                  'Clear Filters (${widget.controller.dataSource.filters.length})'),
              onPressed: widget.controller.dataSource.clearFilters,
            ),
          const Spacer(),
          if (widget.toolbarActions != null) ...widget.toolbarActions!,
        ],
      ),
    );
  }

  Widget _buildGridContent(VooDesignSystemData design) {
    final dataSource = widget.controller.dataSource;

    if (dataSource.isLoading && dataSource.rows.isEmpty) {
      return Center(
        child: widget.loadingWidget ??
            const CircularProgressIndicator(),
      );
    }

    if (dataSource.error != null) {
      return Center(
        child: widget.errorBuilder?.call(dataSource.error!) ??
            VooEmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Data',
              message: dataSource.error!,
              action: TextButton(
                onPressed: dataSource.refresh,
                child: const Text('Retry'),
              ),
            ),
      );
    }

    if (dataSource.rows.isEmpty) {
      return Center(
        child: widget.emptyStateWidget ??
            const VooEmptyState(
              icon: Icons.table_rows_outlined,
              title: 'No Data',
              message: 'No rows to display',
            ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Header
            VooDataGridHeader(
              controller: widget.controller,
              theme: _theme,
              onSort: widget.controller.sortColumn,
            ),
            
            // Filters
            if (widget.controller.showFilters)
              VooDataGridFilterRow(
                controller: widget.controller,
                theme: _theme,
              ),
            
            // Data rows
            Expanded(
              child: _buildDataRows(design),
            ),
            
            // Loading overlay
            if (dataSource.isLoading && dataSource.rows.isNotEmpty)
              const LinearProgressIndicator(),
          ],
        );
      },
    );
  }

  Widget _buildDataRows(VooDesignSystemData design) {
    final rows = widget.controller.dataSource.rows;
    final selectedRows = widget.controller.dataSource.selectedRows;

    return Scrollbar(
      controller: widget.controller.verticalScrollController,
      child: SingleChildScrollView(
        controller: widget.controller.verticalScrollController,
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++)
              VooDataGridRow(
                row: rows[i],
                index: i,
                controller: widget.controller,
                theme: _theme,
                isSelected: selectedRows.contains(rows[i]),
                isHovered: _hoveredRow == rows[i],
                onTap: () {
                  widget.controller.dataSource.toggleRowSelection(rows[i]);
                  widget.onRowTap?.call(rows[i]);
                },
                onDoubleTap: () => widget.onRowDoubleTap?.call(rows[i]),
                onHover: (isHovered) {
                  setState(() {
                    _hoveredRow = isHovered ? rows[i] : null;
                  });
                  widget.onRowHover?.call(isHovered ? rows[i] : null);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Theme configuration for VooDataGrid
class VooDataGridTheme {
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color rowBackgroundColor;
  final Color alternateRowBackgroundColor;
  final Color selectedRowBackgroundColor;
  final Color hoveredRowBackgroundColor;
  final Color borderColor;
  final Color gridLineColor;
  final TextStyle headerTextStyle;
  final TextStyle cellTextStyle;
  final double borderWidth;

  const VooDataGridTheme({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.rowBackgroundColor,
    required this.alternateRowBackgroundColor,
    required this.selectedRowBackgroundColor,
    required this.hoveredRowBackgroundColor,
    required this.borderColor,
    required this.gridLineColor,
    required this.headerTextStyle,
    required this.cellTextStyle,
    this.borderWidth = 1.0,
  });

  factory VooDataGridTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return VooDataGridTheme(
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerTextColor: colorScheme.onSurface,
      rowBackgroundColor: colorScheme.surface,
      alternateRowBackgroundColor: colorScheme.surfaceContainerLowest,
      selectedRowBackgroundColor: colorScheme.primaryContainer,
      hoveredRowBackgroundColor: colorScheme.surfaceContainerHigh,
      borderColor: colorScheme.outline,
      gridLineColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
      headerTextStyle: theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      cellTextStyle: theme.textTheme.bodyMedium!,
    );
  }
}