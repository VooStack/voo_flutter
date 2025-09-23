import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Resize handle widget for column headers
class HeaderResizeHandle<T> extends StatelessWidget {
  final VooDataColumn<T> column;
  final VooDataGridController<T> controller;

  const HeaderResizeHandle({super.key, required this.column, required this.controller});

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.resizeColumn,
    child: GestureDetector(
      onHorizontalDragUpdate: (details) {
        final currentWidth = controller.getColumnWidth(column);
        final newWidth = (currentWidth + details.delta.dx).clamp(column.minWidth, column.maxWidth ?? double.infinity);
        controller.resizeColumn(column.field, newWidth);
      },
      child: Container(width: 4, height: double.infinity, color: Colors.transparent),
    ),
  );
}
