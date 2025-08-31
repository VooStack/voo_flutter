import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
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
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: column.filterHint ?? 'Filter...',
                hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: InputBorder.none,
                suffixIcon: currentFilter != null
                    ? InkWell(
                        onTap: () {
                          controller.clear();
                          onFilterCleared();
                        },
                        child: const Icon(Icons.clear, size: 16),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
              ),
              style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
              onChanged: (value) => onFilterChanged(value.isEmpty ? null : value),
            ),
          ),
        ),
      ],
    );
  }
}