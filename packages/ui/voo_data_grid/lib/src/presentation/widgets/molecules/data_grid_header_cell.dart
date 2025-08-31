import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/sort_indicator.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/resize_handle.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A molecule component for data grid header cells
class DataGridHeaderCell<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current sort direction for this column
  final VooSortDirection sortDirection;
  
  /// Callback when the header is tapped for sorting
  final VoidCallback? onSort;
  
  /// Width of the cell
  final double? width;
  
  /// Whether to show grid lines
  final bool showGridLines;
  
  /// Grid line color
  final Color? gridLineColor;
  
  /// Header text style
  final TextStyle? headerTextStyle;
  
  /// Whether column resizing is enabled
  final bool resizable;
  
  /// Callback for column resize
  final void Function(double delta)? onResize;
  
  const DataGridHeaderCell({
    super.key,
    required this.column,
    required this.sortDirection,
    this.onSort,
    this.width,
    this.showGridLines = true,
    this.gridLineColor,
    this.headerTextStyle,
    this.resizable = false,
    this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final isSortable = column.sortable && !column.excludeFromApi;
    
    return GestureDetector(
      onTap: isSortable ? onSort : null,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: gridLineColor ?? theme.dividerColor,
              width: showGridLines ? 1 : 0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: column.headerBuilder?.call(context, column) ??
                  Text(
                    column.label,
                    style: headerTextStyle ?? theme.textTheme.titleSmall,
                    textAlign: column.textAlign,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            if (isSortable)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: SortIndicator(
                  direction: sortDirection,
                ),
              ),
            if (resizable) 
              ResizeHandle(
                onResize: onResize,
              ),
          ],
        ),
      ),
    );
  }
}