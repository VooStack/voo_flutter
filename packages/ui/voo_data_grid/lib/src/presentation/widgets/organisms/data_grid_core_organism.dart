import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_card_view_organism.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_table_view_organism.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/mobile_filter_sheet_organism.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Core organism that handles the main data grid layout and logic
/// This is the shared implementation used by both VooDataGrid and VooDataGridStateless
class DataGridCoreOrganism<T> extends StatefulWidget {
  /// Controller for the data grid
  final VooDataGridController<T> controller;

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
  final void Function(T row)? onRowTap;

  /// Row double tap callback
  final void Function(T row)? onRowDoubleTap;

  /// Row hover callback
  final void Function(T)? onRowHover;

  /// Border decoration
  final BoxDecoration? decoration;

  /// Grid theme
  final VooDataGridTheme? theme;

  /// Display mode for the grid
  final VooDataGridDisplayMode displayMode;

  /// Custom card builder for mobile layout
  final Widget Function(BuildContext context, T row, int index)? cardBuilder;

  /// Priority columns to show on mobile (field names)
  final List<String>? mobilePriorityColumns;

  /// Whether to always show vertical scrollbar
  final bool alwaysShowVerticalScrollbar;

  /// Whether to always show horizontal scrollbar
  final bool alwaysShowHorizontalScrollbar;

  /// Primary filters configuration
  final List<PrimaryFilter>? primaryFilters;

  /// Currently selected primary filter
  final String? selectedPrimaryFilterId;

  /// Callback when primary filter is selected
  final void Function(String? filterId)? onPrimaryFilterSelected;

  /// Whether to show primary filters
  final bool showPrimaryFilters;

  const DataGridCoreOrganism({
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
    this.displayMode = VooDataGridDisplayMode.auto,
    this.cardBuilder,
    this.mobilePriorityColumns,
    this.alwaysShowVerticalScrollbar = false,
    this.alwaysShowHorizontalScrollbar = false,
    this.primaryFilters,
    this.selectedPrimaryFilterId,
    this.onPrimaryFilterSelected,
    this.showPrimaryFilters = false,
  });

  @override
  State<DataGridCoreOrganism<T>> createState() => _DataGridCoreOrganismState<T>();
}

class _DataGridCoreOrganismState<T> extends State<DataGridCoreOrganism<T>> {
  late VooDataGridTheme _theme;
  late VooDataGridDisplayMode _effectiveDisplayMode;
  VooDataGridDisplayMode? _userSelectedMode;

  @override
  void initState() {
    super.initState();
    widget.controller.dataSource.loadData();
  }

  VooDataGridDisplayMode _getEffectiveDisplayMode(double width) {
    // If user manually selected a mode, use that
    if (_userSelectedMode != null) {
      return _userSelectedMode!;
    }
    // Otherwise follow widget configuration
    if (widget.displayMode != VooDataGridDisplayMode.auto) {
      return widget.displayMode;
    }
    // Auto mode: cards on mobile, table on larger screens
    return width < VooDataGridBreakpoints.mobile ? VooDataGridDisplayMode.cards : VooDataGridDisplayMode.table;
  }

  bool _isMobile(double width) => width < VooDataGridBreakpoints.mobile;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooDataGridTheme.fromContext(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _effectiveDisplayMode = _getEffectiveDisplayMode(constraints.maxWidth);

        return AnimatedBuilder(
          animation: Listenable.merge([
            widget.controller,
            widget.controller.dataSource,
          ]),
          builder: (context, _) => DecoratedBox(
            decoration: widget.decoration ??
                BoxDecoration(
                  border: Border.all(color: _theme.borderColor),
                  borderRadius: BorderRadius.circular(design.radiusMd),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showPrimaryFilters && widget.primaryFilters != null) ...[
                  PrimaryFiltersBarMolecule(
                    filters: widget.primaryFilters!,
                    selectedFilterId: widget.selectedPrimaryFilterId,
                    onFilterSelected: (filterId) {
                      widget.onPrimaryFilterSelected?.call(filterId);
                    },
                  ),
                ],
                if (widget.showToolbar) ...[
                  Column(
                    children: [
                      DataGridToolbar(
                        onRefresh: widget.controller.dataSource.refresh,
                        onFilterToggle: _isMobile(constraints.maxWidth) ? null : widget.controller.toggleFilters,
                        filtersVisible: widget.controller.showFilters,
                        activeFilterCount: widget.controller.dataSource.filters.length,
                        displayMode: _effectiveDisplayMode,
                        onDisplayModeChanged: _isMobile(constraints.maxWidth) ? (mode) => setState(() => _userSelectedMode = mode) : null,
                        showViewModeToggle: _isMobile(constraints.maxWidth) && _effectiveDisplayMode == VooDataGridDisplayMode.table,
                        additionalActions: widget.toolbarActions,
                        backgroundColor: _theme.headerBackgroundColor,
                        borderColor: _theme.borderColor,
                        isMobile: _isMobile(constraints.maxWidth),
                        onShowMobileFilters: _isMobile(constraints.maxWidth) ? () => _showMobileFilterSheet(context) : null,
                      ),
                      if (widget.controller.dataSource.filters.isNotEmpty) ...[
                        _buildFilterChips(),
                      ],
                    ],
                  ),
                ],
                Expanded(
                  child: _buildContent(constraints),
                ),
                if (widget.showPagination && !widget.controller.dataSource.isLoading) ...[
                  _buildPagination(constraints.maxWidth),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final filters = widget.controller.dataSource.filters;
    if (filters.isEmpty) return const SizedBox.shrink();

    // Prepare filter data for the molecule
    final filterData = <String, FilterChipData>{};
    for (final entry in filters.entries) {
      final column = widget.controller.columns.firstWhere(
        (col) => col.field == entry.key,
      );
      final filter = entry.value;
      final displayValue = filter.value != null ? (column.valueFormatter?.call(filter.value) ?? filter.value?.toString() ?? '') : null;

      filterData[entry.key] = FilterChipData(
        label: column.label,
        value: filter.value,
        displayValue: displayValue,
      );
    }

    return FilterChipListMolecule(
      filters: filterData,
      onFilterRemoved: (field) {
        widget.controller.dataSource.applyFilter(field, null);
      },
      onClearAll: widget.controller.dataSource.clearFilters,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderColor: _theme.borderColor,
    );
  }

  Widget _buildContent(BoxConstraints constraints) => _effectiveDisplayMode == VooDataGridDisplayMode.cards
      ? DataGridCardViewOrganism<T>(
          controller: widget.controller,
          theme: _theme,
          loadingWidget: widget.loadingWidget,
          emptyStateWidget: widget.emptyStateWidget,
          errorBuilder: widget.errorBuilder,
          cardBuilder: widget.cardBuilder,
          onRowTap: widget.onRowTap,
          onRowDoubleTap: widget.onRowDoubleTap,
          mobilePriorityColumns: widget.mobilePriorityColumns,
        )
      : DataGridTableViewOrganism<T>(
          controller: widget.controller,
          theme: _theme,
          width: constraints.maxWidth,
          loadingWidget: widget.loadingWidget,
          emptyStateWidget: widget.emptyStateWidget,
          errorBuilder: widget.errorBuilder,
          onRowTap: widget.onRowTap,
          onRowDoubleTap: widget.onRowDoubleTap,
          onRowHover: widget.onRowHover,
          alwaysShowVerticalScrollbar: widget.alwaysShowVerticalScrollbar,
          alwaysShowHorizontalScrollbar: widget.alwaysShowHorizontalScrollbar,
          mobilePriorityColumns: widget.mobilePriorityColumns,
        );

  Widget _buildPagination(double width) {
    if (_isMobile(width)) {
      return VooDataGridMobilePagination(
        currentPage: widget.controller.dataSource.currentPage,
        totalPages: widget.controller.dataSource.totalPages,
        pageSize: widget.controller.dataSource.pageSize,
        totalRows: widget.controller.dataSource.totalRows,
        onPageChanged: widget.controller.dataSource.changePage,
        onPageSizeChanged: widget.controller.dataSource.changePageSize,
        theme: _theme,
      );
    } else {
      return VooDataGridPagination(
        currentPage: widget.controller.dataSource.currentPage,
        totalPages: widget.controller.dataSource.totalPages,
        pageSize: widget.controller.dataSource.pageSize,
        totalRows: widget.controller.dataSource.totalRows,
        onPageChanged: widget.controller.dataSource.changePage,
        onPageSizeChanged: widget.controller.dataSource.changePageSize,
        theme: _theme,
      );
    }
  }

  void _showMobileFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MobileFilterSheetOrganism(
        controller: widget.controller,
        theme: _theme,
        onApply: () {
          Navigator.pop(context);
          widget.controller.dataSource.loadData();
        },
      ),
    );
  }
}
