import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/data_grid.dart';
import 'package:voo_data_grid/src/data_grid_column.dart';
import 'package:voo_data_grid/src/data_grid_controller.dart';
import 'package:voo_data_grid/src/data_grid_types.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Row widget for VooDataGrid
///
/// Generic type parameter T represents the row data type.
class VooDataGridRow<T> extends StatelessWidget {
  final T row;
  final int index;
  final VooDataGridController<T> controller;
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
        behavior: HitTestBehavior.opaque, // Make entire row clickable
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

              // Scrollable columns - these will be scrolled at the parent level
              for (final column in controller.scrollableColumns)
                _buildDataCell(context, column, design),
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
    VooDataColumn<T> column,
    VooDesignSystemData design,
  ) {
    final width = controller.getColumnWidth(column);

    // For typed objects, valueGetter MUST be provided.
    // Try column's valueGetter first, then fallback to bracket notation for Maps.
    dynamic value;

    try {
      if (column.valueGetter != null) {
        // Safely call valueGetter with error handling
        value = column.valueGetter!(row);
      } else if (row is Map) {
        value = (row as Map)[column.field];
      } else {
        // Typed object without valueGetter - this will cause errors
        // Log warning in debug mode
        debugPrint(
          '[VooDataGrid Warning] Column "${column.field}" requires a valueGetter for typed objects. '
          'Row type: ${row.runtimeType}. '
          'Please provide a valueGetter function in the VooDataColumn definition.',
        );
        assert(
          false,
          'VooDataGrid: Column "${column.field}" requires a valueGetter for typed objects. '
          'Provide a valueGetter function in the VooDataColumn definition.',
        );
        value = null;
      }
    } catch (e, stackTrace) {
      // Log detailed error information to help debugging
      debugPrint(
        '[VooDataGrid Error] Failed to get value for column "${column.field}":\n'
        'Error: $e\n'
        'Row type: ${row.runtimeType}\n'
        'Column field: ${column.field}\n'
        'ValueGetter type: ${column.valueGetter.runtimeType}\n'
        'Stack trace:\n$stackTrace',
      );

      // In production, show a placeholder instead of crashing
      value = null;
    }

    final displayValue =
        column.valueFormatter?.call(value) ?? value?.toString() ?? '';

    final cellContent = Align(
      alignment: _getAlignment(column.textAlign),
      child: column.cellBuilder?.call(context, value, row) ??
          Text(
            displayValue,
            style: theme.cellTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
    );

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
      child: column.onCellTap != null
          ? InkWell(
              onTap: () => column.onCellTap!(context, row, value),
              child: cellContent,
            )
          : cellContent,
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
