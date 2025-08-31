import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Card view organism for displaying data grid rows as cards
class DataGridCardViewOrganism<T> extends StatelessWidget {
  final VooDataGridController<T> controller;
  final Widget? loadingWidget;
  final Widget? emptyStateWidget;
  final Widget Function(String)? errorBuilder;
  final VooDataGridTheme theme;
  final Widget Function(BuildContext, T, int)? cardBuilder;
  final void Function(T)? onRowTap;
  final void Function(T)? onRowDoubleTap;
  final List<String>? mobilePriorityColumns;

  const DataGridCardViewOrganism({
    super.key,
    required this.controller,
    required this.theme,
    this.loadingWidget,
    this.emptyStateWidget,
    this.errorBuilder,
    this.cardBuilder,
    this.onRowTap,
    this.onRowDoubleTap,
    this.mobilePriorityColumns,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final dataSource = controller.dataSource;

    if (dataSource.isLoading && dataSource.rows.isEmpty) {
      return Center(
        child: loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    // Handle error state but still allow filtering to remain visible
    if (dataSource.error != null) {
      return Center(
        child: errorBuilder?.call(dataSource.error ?? 'Unknown error') ??
            VooEmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Data',
              message: dataSource.error!,
              action: TextButton(
                onPressed: dataSource.refresh,
                child: const Text('Retry'),
              ),
            ),
      );
    }

    if (dataSource.rows.isEmpty) {
      return Center(
        child: emptyStateWidget ??
            const VooEmptyState(
              icon: Icons.table_rows_outlined,
              title: 'No Data',
              message: 'No rows to display',
            ),
      );
    }

    final selectedRows = controller.dataSource.selectedRows;
    final priorityColumns = _getPriorityColumns();

    return ListView.builder(
      padding: EdgeInsets.all(design.spacingMd),
      itemCount: dataSource.rows.length,
      itemBuilder: (context, index) {
        final row = dataSource.rows[index];
        final isSelected = selectedRows.contains(row);

        if (cardBuilder != null) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingMd),
            child: cardBuilder!(context, row, index),
          );
        }

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? theme.selectedRowBackgroundColor : null,
          margin: EdgeInsets.only(bottom: design.spacingMd),
          child: InkWell(
            onTap: () {
              controller.dataSource.toggleRowSelection(row);
              onRowTap?.call(row);
            },
            onDoubleTap: () => onRowDoubleTap?.call(row),
            borderRadius: BorderRadius.circular(design.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(design.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final column in priorityColumns) 
                    _DataGridCardField<T>(
                      column: column,
                      row: row,
                      design: design,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<VooDataColumn<T>> _getPriorityColumns() {
    final allColumns = controller.columns;

    if (mobilePriorityColumns != null && mobilePriorityColumns!.isNotEmpty) {
      return allColumns.where((col) => mobilePriorityColumns!.contains(col.field)).toList();
    }

    // Default: show first 4 visible columns
    return allColumns.where((col) => col.visible).take(4).toList();
  }
}

/// Individual card field widget to avoid _build methods
class _DataGridCardField<T> extends StatelessWidget {
  final VooDataColumn<T> column;
  final T row;
  final VooDesignSystemData design;

  const _DataGridCardField({
    required this.column,
    required this.row,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
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
        '[VooDataGrid Error] Failed to get value for column "${column.field}" in card view:\n'
        'Error: $e\n'
        'Row type: ${row.runtimeType}\n'
        'Column field: ${column.field}\n'
        'ValueGetter type: ${column.valueGetter.runtimeType}\n'
        'Stack trace:\n$stackTrace',
      );

      // In production, show a placeholder instead of crashing
      value = null;
    }

    final displayValue = column.valueFormatter?.call(value) ?? value?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '${column.label}:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: column.cellBuilder?.call(context, value, row) ??
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
          ),
        ],
      ),
    );
  }
}