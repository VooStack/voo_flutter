import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Selection header cell widget
class SelectionHeaderCell<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;

  const SelectionHeaderCell({super.key, required this.controller, required this.theme, required this.design});

  @override
  Widget build(BuildContext context) {
    final isAllSelected = controller.dataSource.selectedRows.length == controller.dataSource.rows.length && controller.dataSource.rows.isNotEmpty;

    return Container(
      width: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingSm),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.gridLineColor, width: controller.showGridLines ? 1 : 0),
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
}
