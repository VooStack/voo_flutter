import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/header_resize_handle.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/header_sort_icon.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Individual header cell widget
class HeaderCell<T> extends StatelessWidget {
  final VooDataColumn<T> column;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;
  final void Function(String field) onSort;

  const HeaderCell({
    super.key,
    required this.column,
    required this.controller,
    required this.theme,
    required this.design,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final sortDirection = controller.getSortDirection(column.field);
    final width = controller.getColumnWidth(column);

    return GestureDetector(
      onTap: column.sortable && !column.excludeFromApi ? () => onSort(column.field) : null,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: theme.gridLineColor,
              width: controller.showGridLines ? 1 : 0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: column.headerBuilder?.call(context, column) ??
                  Text(
                    column.label,
                    style: theme.headerTextStyle,
                    textAlign: column.textAlign,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            if (column.sortable && !column.excludeFromApi)
              HeaderSortIcon(
                direction: sortDirection,
                theme: theme,
              ),
            if (controller.columnResizable)
              HeaderResizeHandle<T>(
                column: column,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }
}
