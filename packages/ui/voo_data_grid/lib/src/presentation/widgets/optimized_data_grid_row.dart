import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Optimized row widget that manages its own hover state
/// This prevents the entire grid from rebuilding when a row is hovered
///
/// Generic type parameter T represents the row data type.
class OptimizedDataGridRow<T> extends StatefulWidget {
  final T row;
  final int index;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final void Function(T row)? onRowHover;

  const OptimizedDataGridRow({
    super.key,
    required this.row,
    required this.index,
    required this.controller,
    required this.theme,
    this.isSelected = false,
    this.onTap,
    this.onDoubleTap,
    this.onRowHover,
  });

  @override
  State<OptimizedDataGridRow<T>> createState() => _OptimizedDataGridRowState<T>();
}

class _OptimizedDataGridRowState<T> extends State<OptimizedDataGridRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    // Calculate background color based on state
    final backgroundColor = _getBackgroundColor();

    // Wrap in RepaintBoundary to isolate repaints to this row only
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
          widget.onRowHover?.call(widget.row);
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: widget.controller.rowHeight,
            color: backgroundColor,
            child: Row(
              children: [
                // Selection checkbox column
                if (widget.controller.dataSource.selectionMode != VooSelectionMode.none)
                  _buildSelectionCell(design),

                // Frozen columns
                for (final column in widget.controller.frozenColumns)
                  RepaintBoundary(
                    child: _buildDataCell(context, column, design),
                  ),

                // Scrollable columns
                for (final column in widget.controller.scrollableColumns)
                  RepaintBoundary(
                    child: _buildDataCell(context, column, design),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isSelected) {
      return widget.theme.selectedRowBackgroundColor;
    } else if (_isHovered && widget.controller.showHoverEffect) {
      return widget.theme.hoveredRowBackgroundColor;
    } else if (widget.controller.alternatingRowColors && widget.index.isOdd) {
      return widget.theme.alternateRowBackgroundColor;
    } else {
      return widget.theme.rowBackgroundColor;
    }
  }

  Widget _buildSelectionCell(VooDesignSystemData design) {
    // Use const width for better performance
    const cellWidth = 48.0;
    
    return SizedBox(
      width: cellWidth,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: design.spacingSm),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: widget.theme.gridLineColor,
              width: widget.controller.showGridLines ? 1 : 0,
            ),
            bottom: BorderSide(
              color: widget.theme.gridLineColor,
              width: widget.controller.showGridLines ? 1 : 0,
            ),
          ),
        ),
        child: widget.controller.dataSource.selectionMode == VooSelectionMode.single
            ? Checkbox(
                value: widget.isSelected,
                onChanged: (_) => widget.onTap?.call(),
                shape: const CircleBorder(),
              )
            : Checkbox(
                value: widget.isSelected,
                onChanged: (_) => widget.onTap?.call(),
              ),
      ),
    );
  }

  Widget _buildDataCell(
    BuildContext context,
    VooDataColumn<T> column,
    VooDesignSystemData design,
  ) {
    final width = widget.controller.getColumnWidth(column);

    // Get value from row
    dynamic value;
    try {
      if (column.valueGetter != null) {
        value = column.valueGetter!(widget.row);
      } else if (widget.row is Map) {
        value = (widget.row as Map)[column.field];
      } else {
        debugPrint(
          '[VooDataGrid Warning] Column "${column.field}" requires a valueGetter for typed objects.',
        );
        value = null;
      }
    } catch (e) {
      debugPrint(
        '[VooDataGrid Error] Failed to get value for column "${column.field}": $e',
      );
      value = null;
    }

    final displayValue = column.valueFormatter?.call(value) ?? value?.toString() ?? '';

    // Use const where possible for better performance
    final cellContent = Align(
      alignment: _getAlignment(column.textAlign),
      child: column.cellBuilder?.call(context, value, widget.row) ??
          Text(
            displayValue,
            style: widget.theme.cellTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
    );

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: widget.theme.gridLineColor,
            width: widget.controller.showGridLines ? 1 : 0,
          ),
          bottom: BorderSide(
            color: widget.theme.gridLineColor,
            width: widget.controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: column.onCellTap != null
          ? InkWell(
              onTap: () => column.onCellTap!(context, widget.row, value),
              child: cellContent,
            )
          : cellContent,
    );
  }

  // Static method with const values for better performance
  static const Map<TextAlign, Alignment> _alignmentCache = {
    TextAlign.left: Alignment.centerLeft,
    TextAlign.start: Alignment.centerLeft,
    TextAlign.right: Alignment.centerRight,
    TextAlign.end: Alignment.centerRight,
    TextAlign.center: Alignment.center,
    TextAlign.justify: Alignment.centerLeft,
  };

  Alignment _getAlignment(TextAlign textAlign) {
    return _alignmentCache[textAlign] ?? Alignment.centerLeft;
  }
}