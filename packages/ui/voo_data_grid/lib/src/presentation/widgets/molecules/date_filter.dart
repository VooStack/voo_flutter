import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';

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
      () => TextEditingController(
        text: currentFilter?.value != null ? _formatDate(currentFilter!.value as DateTime) : '',
      ),
    );
    final theme = Theme.of(context);

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: column.filterHint ?? 'Select date',
          hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          border: InputBorder.none,
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
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
        ),
        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        readOnly: true,
      ),
    );
  }
}
