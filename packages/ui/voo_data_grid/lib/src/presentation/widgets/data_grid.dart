import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_core.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A powerful data grid widget with remote filtering support
///
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class VooDataGrid<T> extends StatelessWidget {
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

  /// Whether to always show vertical scrollbar.
  /// When true, the vertical scrollbar thumb and track will always be visible,
  /// even when the content doesn't overflow vertically.
  final bool alwaysShowVerticalScrollbar;

  /// Whether to always show horizontal scrollbar.
  /// When true, the horizontal scrollbar thumb and track will always be visible,
  /// even when the content doesn't overflow horizontally.
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
  Widget build(BuildContext context) => DataGridCore<T>(
        controller: controller,
        showPagination: showPagination,
        showToolbar: showToolbar,
        toolbarActions: toolbarActions,
        emptyStateWidget: emptyStateWidget,
        loadingWidget: loadingWidget,
        errorBuilder: errorBuilder,
        onRowTap: onRowTap,
        onRowDoubleTap: onRowDoubleTap,
        onRowHover: onRowHover,
        decoration: decoration,
        theme: theme,
        displayMode: displayMode,
        cardBuilder: cardBuilder,
        mobilePriorityColumns: mobilePriorityColumns,
        alwaysShowVerticalScrollbar: alwaysShowVerticalScrollbar,
        alwaysShowHorizontalScrollbar: alwaysShowHorizontalScrollbar,
        primaryFilters: primaryFilters,
        selectedPrimaryFilter: selectedPrimaryFilter,
        onFilterChanged: onFilterChanged,
        onPrimaryFilterChanged: onPrimaryFilterChanged,
        showPrimaryFilters: showPrimaryFilters,
        combineFiltersAndPrimaryFilters: combineFiltersAndPrimaryFilters,
      );
}
