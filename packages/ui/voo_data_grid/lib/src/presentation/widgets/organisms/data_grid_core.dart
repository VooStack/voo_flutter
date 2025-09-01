import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_content_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_filter_chips_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_pagination_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/mobile_filter_sheet.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Core widget that handles the main data grid layout and logic
/// This is the shared implementation used by both VooDataGrid and VooDataGridStateless
class DataGridCore<T> extends StatefulWidget {
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
  final VooDataFilter? selectedPrimaryFilter;

  /// Callback when regular filter is changed
  final void Function(String field, VooDataFilter? filter)? onFilterChanged;

  /// Callback when primary filter is selected
  final void Function(String field, VooDataFilter? filter)? onPrimaryFilterChanged;

  /// Whether to show primary filters
  final bool showPrimaryFilters;

  /// Whether to combine primary filters with regular filters
  /// When true (default), primary filters are added to the filters map
  /// When false, primary filters are tracked separately
  final bool combineFiltersAndPrimaryFilters;

  const DataGridCore({
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
    this.selectedPrimaryFilter,
    this.onFilterChanged,
    this.onPrimaryFilterChanged,
    this.showPrimaryFilters = false,
    this.combineFiltersAndPrimaryFilters = true,
  });

  @override
  State<DataGridCore<T>> createState() => _DataGridCoreState<T>();
}

class _DataGridCoreState<T> extends State<DataGridCore<T>> {
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
                  PrimaryFiltersBar(
                    filters: widget.primaryFilters!,
                    selectedFilter: widget.selectedPrimaryFilter,
                    onFilterChanged: (field, filter) {
                      // Call primary filter callback
                      widget.onPrimaryFilterChanged?.call(field, filter);
                      
                      // Also add to regular filters if combining
                      if (widget.combineFiltersAndPrimaryFilters) {
                        widget.onFilterChanged?.call(field, filter);
                      }
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
                        DataGridFilterChipsSection<T>(
                          controller: widget.controller,
                          theme: _theme,
                        ),
                      ],
                    ],
                  ),
                ],
                Expanded(
                  child: DataGridContentSection<T>(
                    controller: widget.controller,
                    theme: _theme,
                    displayMode: _effectiveDisplayMode,
                    constraints: constraints,
                    loadingWidget: widget.loadingWidget,
                    emptyStateWidget: widget.emptyStateWidget,
                    errorBuilder: widget.errorBuilder,
                    cardBuilder: widget.cardBuilder,
                    onRowTap: widget.onRowTap,
                    onRowDoubleTap: widget.onRowDoubleTap,
                    onRowHover: widget.onRowHover,
                    mobilePriorityColumns: widget.mobilePriorityColumns,
                    alwaysShowVerticalScrollbar: widget.alwaysShowVerticalScrollbar,
                    alwaysShowHorizontalScrollbar: widget.alwaysShowHorizontalScrollbar,
                  ),
                ),
                if (widget.showPagination) ...[
                  DataGridPaginationSection<T>(
                    controller: widget.controller,
                    theme: _theme,
                    width: constraints.maxWidth,
                    isMobile: _isMobile(constraints.maxWidth),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }


  void _showMobileFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MobileFilterSheet(
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