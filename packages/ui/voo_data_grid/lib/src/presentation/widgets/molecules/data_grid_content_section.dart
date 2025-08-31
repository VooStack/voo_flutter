import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_card_view.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_table_view.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A section widget that displays the main content of the data grid
class DataGridContentSection<T> extends StatelessWidget {
  /// The data grid controller
  final VooDataGridController<T> controller;

  /// The theme configuration
  final VooDataGridTheme theme;

  /// The display mode
  final VooDataGridDisplayMode displayMode;

  /// Box constraints for the widget
  final BoxConstraints constraints;

  /// Loading widget
  final Widget? loadingWidget;

  /// Empty state widget
  final Widget? emptyStateWidget;

  /// Error builder
  final Widget Function(String error)? errorBuilder;

  /// Card builder for card view mode
  final Widget Function(BuildContext context, T row, int index)? cardBuilder;

  /// Row tap callback
  final void Function(T row)? onRowTap;

  /// Row double tap callback
  final void Function(T row)? onRowDoubleTap;

  /// Row hover callback
  final void Function(T row)? onRowHover;

  /// Mobile priority columns
  final List<String>? mobilePriorityColumns;

  /// Always show vertical scrollbar
  final bool alwaysShowVerticalScrollbar;

  /// Always show horizontal scrollbar
  final bool alwaysShowHorizontalScrollbar;

  const DataGridContentSection({
    super.key,
    required this.controller,
    required this.theme,
    required this.displayMode,
    required this.constraints,
    this.loadingWidget,
    this.emptyStateWidget,
    this.errorBuilder,
    this.cardBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    this.mobilePriorityColumns,
    this.alwaysShowVerticalScrollbar = false,
    this.alwaysShowHorizontalScrollbar = false,
  });

  @override
  Widget build(BuildContext context) => displayMode == VooDataGridDisplayMode.cards
      ? DataGridCardView<T>(
          controller: controller,
          theme: theme,
          loadingWidget: loadingWidget,
          emptyStateWidget: emptyStateWidget,
          errorBuilder: errorBuilder,
          cardBuilder: cardBuilder,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          mobilePriorityColumns: mobilePriorityColumns,
        )
      : DataGridTableView<T>(
          controller: controller,
          theme: theme,
          width: constraints.maxWidth,
          loadingWidget: loadingWidget,
          emptyStateWidget: emptyStateWidget,
          errorBuilder: errorBuilder,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowHover: onRowHover,
          alwaysShowVerticalScrollbar: alwaysShowVerticalScrollbar,
          alwaysShowHorizontalScrollbar: alwaysShowHorizontalScrollbar,
          mobilePriorityColumns: mobilePriorityColumns,
        );
}
