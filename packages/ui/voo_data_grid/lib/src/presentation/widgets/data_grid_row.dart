import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/row_data_cell.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/row_selection_cell.dart';
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
                  RowSelectionCell<T>(controller: widget.controller, theme: widget.theme, design: design, isSelected: widget.isSelected, onTap: widget.onTap),

                // Frozen columns
                for (final column in widget.controller.frozenColumns)
                  RepaintBoundary(
                    child: RowDataCell<T>(row: widget.row, column: column, controller: widget.controller, theme: widget.theme, design: design),
                  ),

                // Scrollable columns
                for (final column in widget.controller.scrollableColumns)
                  RepaintBoundary(
                    child: RowDataCell<T>(row: widget.row, column: column, controller: widget.controller, theme: widget.theme, design: design),
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
