import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';

/// A molecule component for date range picker filter input
class DateRangeFilterMolecule<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current filter value
  final VooDataFilter? currentFilter;
  
  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;
  
  /// Callback to clear filter
  final void Function() onFilterCleared;

  const DateRangeFilterMolecule({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
  });

  /// Format a DateTime as a string
  String _formatDate(DateTime date) => 
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (range != null) {
            onFilterChanged({
              'operator': VooFilterOperator.between,
              'value': range.start,
              'valueTo': range.end,
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currentFilter?.value != null && currentFilter?.valueTo != null
                      ? '${_formatDate(currentFilter!.value as DateTime)} - ${_formatDate(currentFilter!.valueTo as DateTime)}'
                      : column.filterHint ?? 'Select range',
                  style: TextStyle(
                    fontSize: 13,
                    color: currentFilter?.value != null 
                        ? theme.textTheme.bodyMedium?.color 
                        : theme.hintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.date_range, size: 16, color: theme.iconTheme.color),
            ],
          ),
        ),
      ),
    );
  }
}