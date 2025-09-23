import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Selection cell widget for data grid rows
class RowSelectionCell<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;
  final bool isSelected;
  final VoidCallback? onTap;

  const RowSelectionCell({super.key, required this.controller, required this.theme, required this.design, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Use const width for better performance
    const cellWidth = 48.0;

    return SizedBox(
      width: cellWidth,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: design.spacingSm),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: theme.gridLineColor, width: controller.showGridLines ? 1 : 0),
            bottom: BorderSide(color: theme.gridLineColor, width: controller.showGridLines ? 1 : 0),
          ),
        ),
        child: controller.dataSource.selectionMode == VooSelectionMode.single
            ? Checkbox(value: isSelected, onChanged: (_) => onTap?.call(), shape: const CircleBorder())
            : Checkbox(value: isSelected, onChanged: (_) => onTap?.call()),
      ),
    );
  }
}
