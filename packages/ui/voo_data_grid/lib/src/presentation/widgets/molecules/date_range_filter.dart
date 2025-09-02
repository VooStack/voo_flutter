import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';

/// A molecule component for date range picker filter input
class DateRangeFilter<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current filter value
  final VooDataFilter? currentFilter;
  
  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;
  
  /// Callback to clear filter
  final void Function() onFilterCleared;

  const DateRangeFilter({
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
    final displayText = currentFilter?.value != null && currentFilter?.valueTo != null
        ? '${_formatDate(currentFilter!.value as DateTime)} - ${_formatDate(currentFilter!.valueTo as DateTime)}'
        : '';

    return TextField(
      controller: TextEditingController(text: displayText),
      decoration: FilterInputDecoration.standard(
        context: context,
        hintText: column.filterHint ?? 'Select range',
        suffixIcon: InkWell(
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
          child: Icon(Icons.date_range, size: 16, color: theme.iconTheme.color),
        ),
      ),
      style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
      readOnly: true,
    );
  }
}