import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Row widget for VooDataGrid
/// Manages its own hover state to prevent entire grid rebuilds
///
/// Generic type parameter T represents the row data type.
class VooDataGridRow<T> extends StatefulWidget {
  final T row;
  final int index;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final void Function(T row)? onRowHover;

  const VooDataGridRow({
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
  State<VooDataGridRow<T>> createState() => _VooDataGridRowState<T>();
}

class _VooDataGridRowState<T> extends State<VooDataGridRow<T>> {
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
                  _SelectionCell<T>(
                    controller: widget.controller,
                    theme: widget.theme,
                    design: design,
                    isSelected: widget.isSelected,
                    onTap: widget.onTap,
                  ),

                // Frozen columns
                for (final column in widget.controller.frozenColumns)
                  RepaintBoundary(
                    child: _DataCell<T>(
                      row: widget.row,
                      column: column,
                      controller: widget.controller,
                      theme: widget.theme,
                      design: design,
                    ),
                  ),

                // Scrollable columns
                for (final column in widget.controller.scrollableColumns)
                  RepaintBoundary(
                    child: _DataCell<T>(
                      row: widget.row,
                      column: column,
                      controller: widget.controller,
                      theme: widget.theme,
                      design: design,
                    ),
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
}

/// Selection cell widget
class _SelectionCell<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SelectionCell({
    required this.controller,
    required this.theme,
    required this.design,
    required this.isSelected,
    this.onTap,
  });

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
      ),
    );
  }
}

/// Data cell widget
class _DataCell<T> extends StatelessWidget {
  final T row;
  final VooDataColumn<T> column;
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;
  final VooDesignSystemData design;

  const _DataCell({
    required this.row,
    required this.column,
    required this.controller,
    required this.theme,
    required this.design,
  });

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
    return _alignmentCache[textAlign] ?? Alignment.centerLeft;
  }
}