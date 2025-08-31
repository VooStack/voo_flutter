import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Card view widget for displaying data in card format
class CardView<T> extends StatelessWidget {
  final VooDataGridState<T> state;
  final List<VooDataColumn<T>> columns;
  final VooDataGridTheme theme;
  final ScrollController verticalScrollController;
  final Widget? loadingWidget;
  final Widget? emptyStateWidget;
  final Widget Function(String)? errorBuilder;
  final Widget Function(BuildContext, T, int)? cardBuilder;
  final List<String>? mobilePriorityColumns;
  final void Function(T)? onRowTap;
  final void Function(T)? onRowDoubleTap;
  
  const CardView({
    super.key,
    required this.state,
    required this.columns,
    required this.theme,
    required this.verticalScrollController,
    this.loadingWidget,
    this.emptyStateWidget,
    this.errorBuilder,
    this.cardBuilder,
    this.mobilePriorityColumns,
    this.onRowTap,
    this.onRowDoubleTap,
  });

  dynamic _getCellValue(T row, VooDataColumn<T> column) {
    if (column.valueGetter != null) {
      return column.valueGetter!(row);
    }

    if (row is Map) {
      return row[column.field];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    if (state.isLoading && loadingWidget != null) {
      return Center(child: loadingWidget);
    }

    if (state.error != null && errorBuilder != null) {
      return Center(child: errorBuilder!(state.error!));
    }

    if (state.rows.isEmpty) {
      return Center(
        child: emptyStateWidget ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: theme.headerTextColor.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: theme.cellTextStyle.copyWith(
                    fontSize: 16,
                    color: theme.headerTextColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
      );
    }

    return ListView.builder(
      controller: verticalScrollController,
      itemCount: state.rows.length,
      padding: EdgeInsets.all(design.spacingMd),
      itemBuilder: (context, index) {
        final row = state.rows[index];

        if (cardBuilder != null) {
          return cardBuilder!(context, row, index);
        }

        // Default card layout
        final priorityColumns = mobilePriorityColumns != null
            ? columns.where((c) => mobilePriorityColumns!.contains(c.field))
            : columns.take(3);

        return Card(
          margin: EdgeInsets.only(bottom: design.spacingMd),
          elevation: 2,
          child: InkWell(
            onTap: onRowTap != null ? () => onRowTap!(row) : null,
            onDoubleTap: onRowDoubleTap != null ? () => onRowDoubleTap!(row) : null,
            borderRadius: BorderRadius.circular(design.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(design.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: priorityColumns.map((column) {
                  final value = _getCellValue(row, column);
                  return Padding(
                    padding: EdgeInsets.only(bottom: design.spacingSm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${column.label}: ',
                          style: theme.headerTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            column.valueFormatter?.call(value) ?? value?.toString() ?? '',
                            style: theme.cellTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}