import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Header widget for VooDataGrid
///
/// Generic type parameter T represents the row data type.
class VooDataGridHeader<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final void Function(String field) onSort;

  const VooDataGridHeader({
    super.key,
    required this.controller,
    required this.theme,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      height: controller.headerHeight,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Selection checkbox column
          if (controller.dataSource.selectionMode != VooSelectionMode.none) _buildSelectionHeader(design),

          // Frozen columns
          for (final column in controller.frozenColumns) _buildHeaderCell(context, column, design),

          // Scrollable columns - no scrollbar here, just synchronized scrolling
          Expanded(
            child: SingleChildScrollView(
              controller: controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final column in controller.scrollableColumns) _buildHeaderCell(context, column, design),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader(VooDesignSystemData design) {
    final isAllSelected = controller.dataSource.selectedRows.length == controller.dataSource.rows.length && controller.dataSource.rows.isNotEmpty;

    return Container(
      width: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingSm),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: controller.dataSource.selectionMode == VooSelectionMode.multiple
          ? Checkbox(
              value: isAllSelected,
              tristate: controller.dataSource.selectedRows.isNotEmpty && !isAllSelected,
              onChanged: (value) {
                if (value == true) {
                  controller.dataSource.selectAll();
                } else {
                  controller.dataSource.clearSelection();
                }
              },
            )
          : null,
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    VooDataColumn<T> column,
    VooDesignSystemData design,
  ) {
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
            if (column.sortable && !column.excludeFromApi) _buildSortIcon(sortDirection),
            if (controller.columnResizable) _buildResizeHandle(column),
          ],
        ),
      ),
    );
  }

  Widget _buildSortIcon(VooSortDirection direction) {
    IconData icon;
    Color? color;

    switch (direction) {
      case VooSortDirection.ascending:
        icon = Icons.arrow_upward;
        color = theme.headerTextColor;
        break;
      case VooSortDirection.descending:
        icon = Icons.arrow_downward;
        color = theme.headerTextColor;
        break;
      case VooSortDirection.none:
        icon = Icons.unfold_more;
        color = theme.headerTextColor.withValues(alpha: 0.3);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  Widget _buildResizeHandle(VooDataColumn<T> column) => MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            final currentWidth = controller.getColumnWidth(column);
            final newWidth = (currentWidth + details.delta.dx).clamp(column.minWidth, column.maxWidth ?? double.infinity);
            controller.resizeColumn(column.field, newWidth);
          },
          child: Container(
            width: 4,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
      );
}
