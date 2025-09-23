import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Data cell widget for data grid rows
class RowDataCell<T> extends StatelessWidget {
  final T row;
  final VooDataColumn<T> column;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;

  const RowDataCell({super.key, required this.row, required this.column, required this.controller, required this.theme, required this.design});

  // Static method with const values for better performance
  static const Map<TextAlign, Alignment> _alignmentCache = {
    TextAlign.left: Alignment.centerLeft,
    TextAlign.start: Alignment.centerLeft,
    TextAlign.right: Alignment.centerRight,
    TextAlign.end: Alignment.centerRight,
    TextAlign.center: Alignment.center,
    TextAlign.justify: Alignment.centerLeft,
  };

  @override
  Widget build(BuildContext context) {
    final width = controller.getColumnWidth(column);

    // Get value from row
    dynamic value;
    try {
      if (column.valueGetter != null) {
        value = column.valueGetter!(row);
      } else if (row is Map) {
        value = (row as Map)[column.field];
      } else {
        debugPrint('[VooDataGrid Warning] Column "${column.field}" requires a valueGetter for typed objects.');
        value = null;
      }
    } catch (e) {
      debugPrint('[VooDataGrid Error] Failed to get value for column "${column.field}": $e');
      value = null;
    }

    final displayValue = column.valueFormatter?.call(value) ?? value?.toString() ?? '';

    // Use const where possible for better performance
    final cellContent = Align(
      alignment: _getAlignment(column.textAlign),
      child: column.cellBuilder?.call(context, value, row) ?? Text(displayValue, style: theme.cellTextStyle, overflow: TextOverflow.ellipsis),
    );

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.gridLineColor, width: controller.showGridLines ? 1 : 0),
          bottom: BorderSide(color: theme.gridLineColor, width: controller.showGridLines ? 1 : 0),
        ),
      ),
      child: column.onCellTap != null ? InkWell(onTap: () => column.onCellTap!(context, row, value), child: cellContent) : cellContent,
    );
  }

  Alignment _getAlignment(TextAlign textAlign) => _alignmentCache[textAlign] ?? Alignment.centerLeft;
}
