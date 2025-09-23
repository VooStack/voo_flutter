import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';

/// A molecule component for number range filter input (min/max)
class NumberRangeFilter<T> extends StatelessWidget {
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

  const NumberRangeFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
  });

  @override
  Widget build(BuildContext context) {
    final minController = textControllers.putIfAbsent('${column.field}_min', () => TextEditingController(text: currentFilter?.value?.toString() ?? ''));
    final maxController = textControllers.putIfAbsent('${column.field}_max', () => TextEditingController(text: currentFilter?.valueTo?.toString() ?? ''));
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: minController,
            decoration: FilterInputDecoration.standard(context: context, hintText: 'Min'),
            style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
            onChanged: (value) {
              final min = num.tryParse(value);
              final max = num.tryParse(maxController.text);
              // Always update the filter, even with partial values
              // Don't clear the filter row when one field is empty
              onFilterChanged({'operator': VooFilterOperator.between, 'value': min, 'valueTo': max});
            },
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            controller: maxController,
            decoration: FilterInputDecoration.standard(context: context, hintText: 'Max'),
            style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
            onChanged: (value) {
              final min = num.tryParse(minController.text);
              final max = num.tryParse(value);
              // Always update the filter, even with partial values
              // Don't clear the filter row when one field is empty
              onFilterChanged({'operator': VooFilterOperator.between, 'value': min, 'valueTo': max});
            },
          ),
        ),
      ],
    );
  }
}
