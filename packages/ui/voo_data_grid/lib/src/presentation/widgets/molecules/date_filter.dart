import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';

/// A molecule component for date picker filter input
class DateFilter<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;

  /// The current filter value
  final VooDataFilter? currentFilter;

  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;

  /// Callback to clear filter
  final void Function() onFilterCleared;

  /// Text controllers map for maintaining state
  final Map<String, TextEditingController> textControllers;

  const DateFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
  });

  /// Format a DateTime as a string
  String _formatDate(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final controller = textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: currentFilter?.value != null ? _formatDate(currentFilter!.value as DateTime) : ''),
    );
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      decoration: FilterInputDecoration.standard(
        context: context,
        hintText: column.filterHint ?? 'Select date',
        suffixIcon: InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: currentFilter?.value is DateTime ? currentFilter!.value as DateTime : DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              controller.text = _formatDate(date);
              onFilterChanged(date);
            }
          },
          child: Icon(Icons.calendar_today, size: 16, color: theme.iconTheme.color),
        ),
      ),
      style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
      readOnly: true,
    );
  }
}
