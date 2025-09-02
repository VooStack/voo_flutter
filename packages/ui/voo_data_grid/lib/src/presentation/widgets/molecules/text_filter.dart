import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/filter_input_decoration.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/operator_selector.dart';

/// A molecule component for text filter input with operator selector support
class TextFilter<T> extends StatelessWidget {
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

  const TextFilter({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
  });

  @override
  Widget build(BuildContext context) {
    final controller = textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final theme = Theme.of(context);

    return Row(
      children: [
        if (column.showFilterOperator)
          OperatorSelector<T>(
            column: column,
            currentFilter: currentFilter,
            onOperatorChanged: (operator) {
              // Apply filter with new operator but keep current value
              onFilterChanged({
                'operator': operator,
                'value': currentFilter?.value,
                'valueTo': currentFilter?.valueTo,
              });
            },
          ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: FilterInputDecoration.standard(
              context: context,
              hintText: column.filterHint ?? 'Filter...',
              suffixIcon: currentFilter != null
                  ? InkWell(
                      onTap: () {
                        controller.clear();
                        onFilterCleared();
                      },
                      child: Icon(Icons.clear, size: 16, color: theme.iconTheme.color),
                    )
                  : null,
            ),
            style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
            onChanged: (value) => onFilterChanged(value.isEmpty ? null : value),
          ),
        ),
      ],
    );
  }
}
