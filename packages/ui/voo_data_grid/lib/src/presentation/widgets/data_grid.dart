import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_core_organism.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Display mode for the data grid
enum VooDataGridDisplayMode {
  /// Standard table layout
  table,

  /// Card-based layout for mobile
  cards,

  /// Auto-detect based on screen size
  auto,
}

/// Breakpoints for responsive behavior
class VooDataGridBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

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
  });

  @override
  Widget build(BuildContext context) => DataGridCoreOrganism<T>(
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
      );
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

/// Mobile filter sheet for VooDataGrid
