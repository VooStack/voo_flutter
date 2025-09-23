import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/header_cell.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/selection_header_cell.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Header widget for VooDataGrid showing column headers
class VooDataGridHeader<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final void Function(String field) onSort;

  const VooDataGridHeader({super.key, required this.controller, required this.theme, required this.onSort});

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      height: 56.0, // Default header height
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.borderColor, width: theme.borderWidth),
        ),
      ),
      child: Row(
        children: [
          // Selection checkbox column
          if (controller.dataSource.selectionMode != VooSelectionMode.none) SelectionHeaderCell<T>(controller: controller, theme: theme, design: design),

          // Frozen columns
          for (final column in controller.frozenColumns) HeaderCell<T>(column: column, controller: controller, theme: theme, design: design, onSort: onSort),

          // Scrollable columns - no scrollbar here, just synchronized scrolling
          Expanded(
            child: SingleChildScrollView(
              controller: controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final column in controller.scrollableColumns)
                    HeaderCell<T>(column: column, controller: controller, theme: theme, design: design, onSort: onSort),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
