import 'package:flutter/material.dart';
import 'package:voo_ui/src/data/data_grid_controller.dart';
import 'package:voo_ui/src/data/data_grid_column.dart';
import 'package:voo_ui/src/data/data_grid.dart';
import 'package:voo_ui/src/data/data_grid_source.dart';
import 'package:voo_ui/src/foundations/design_system.dart';

/// Row widget for VooDataGrid
class VooDataGridRow extends StatelessWidget {
  final dynamic row;
  final int index;
  final VooDataGridController controller;
  final VooDataGridTheme theme;
  final bool isSelected;
  final bool isHovered;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final void Function(bool isHovered)? onHover;

  const VooDataGridRow({
    super.key,
    required this.row,
    required this.index,
    required this.controller,
    required this.theme,
    this.isSelected = false,
    this.isHovered = false,
    this.onTap,
    this.onDoubleTap,
    this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = theme.selectedRowBackgroundColor;
    } else if (isHovered && controller.showHoverEffect) {
      backgroundColor = theme.hoveredRowBackgroundColor;
    } else if (controller.alternatingRowColors && index.isOdd) {
      backgroundColor = theme.alternateRowBackgroundColor;
    } else {
      backgroundColor = theme.rowBackgroundColor;
    }
    
    return MouseRegion(
      onEnter: (_) => onHover?.call(true),
      onExit: (_) => onHover?.call(false),
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Container(
          height: controller.rowHeight,
          color: backgroundColor,
          child: Row(
            children: [
              // Selection checkbox column
              if (controller.dataSource.selectionMode != VooSelectionMode.none)
                _buildSelectionCell(design),
              
              // Frozen columns
              for (final column in controller.frozenColumns)
                _buildDataCell(context, column, design),
              
              // Scrollable columns
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final column in controller.scrollableColumns)
                        _buildDataCell(context, column, design),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCell(VooDesignSystemData design) {
    return Container(
      width: 48,
      padding: EdgeInsets.symmetric(horizontal: design.spacingSm),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
          ),
          bottom: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: controller.dataSource.selectionMode == VooSelectionMode.single
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => onTap?.call(),
              shape: const CircleBorder(),
            )
          : Checkbox(
              value: isSelected,
              onChanged: (_) => onTap?.call(),
            ),
    );
  }

  Widget _buildDataCell(
    BuildContext context,
    VooDataColumn column,
    VooDesignSystemData design,
  ) {
    final width = controller.getColumnWidth(column);
    final value = column.valueGetter?.call(row) ?? row[column.field];
    final displayValue = column.valueFormatter?.call(value) ?? value?.toString() ?? '';
    
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
          ),
          bottom: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: Align(
        alignment: _getAlignment(column.textAlign),
        child: column.cellBuilder?.call(context, value, row) ??
            Text(
              displayValue,
              style: theme.cellTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  Alignment _getAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.justify:
        return Alignment.centerLeft;
    }
  }
}