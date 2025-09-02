import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

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
    final minController = textControllers.putIfAbsent(
      '${column.field}_min',
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final maxController = textControllers.putIfAbsent(
      '${column.field}_max',
      () => TextEditingController(text: currentFilter?.valueTo?.toString() ?? ''),
    );
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: minController,
              decoration: InputDecoration(
                hintText: 'Min',
                hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
              ],
              onChanged: (value) {
                final min = num.tryParse(value);
                final max = num.tryParse(maxController.text);
                if (min != null || max != null) {
                  onFilterChanged({
                    'operator': VooFilterOperator.between,
                    'value': min,
                    'valueTo': max,
                  });
                } else {
                  onFilterCleared();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: maxController,
              decoration: InputDecoration(
                hintText: 'Max',
                hintStyle: TextStyle(fontSize: 12, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
              ],
              onChanged: (value) {
                final min = num.tryParse(minController.text);
                final max = num.tryParse(value);
                if (min != null || max != null) {
                  onFilterChanged({
                    'operator': VooFilterOperator.between,
                    'value': min,
                    'valueTo': max,
                  });
                } else {
                  onFilterCleared();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}