import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

/// A molecule component for selecting filter operators
class OperatorSelector<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current filter value
  final VooDataFilter? currentFilter;
  
  /// Callback when operator changes
  final void Function(VooFilterOperator) onOperatorChanged;

  const OperatorSelector({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onOperatorChanged,
  });

  /// Get symbol representation for a filter operator
  String _getOperatorSymbol(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return '=';
      case VooFilterOperator.notEquals:
        return '≠';
      case VooFilterOperator.contains:
        return '∋';
      case VooFilterOperator.notContains:
        return '∌';
      case VooFilterOperator.startsWith:
        return '^';
      case VooFilterOperator.endsWith:
        return '\$';
      case VooFilterOperator.greaterThan:
        return '>';
      case VooFilterOperator.greaterThanOrEqual:
        return '≥';
      case VooFilterOperator.lessThan:
        return '<';
      case VooFilterOperator.lessThanOrEqual:
        return '≤';
      case VooFilterOperator.between:
        return '↔';
      case VooFilterOperator.inList:
        return '∈';
      case VooFilterOperator.notInList:
        return '∉';
      case VooFilterOperator.isNull:
        return '∅';
      case VooFilterOperator.isNotNull:
        return '!∅';
    }
  }

  @override
  Widget build(BuildContext context) {
    final operators = column.effectiveAllowedFilterOperators;
    final currentOperator = currentFilter?.operator ?? column.effectiveDefaultFilterOperator;
    final theme = Theme.of(context);

    return Container(
      width: 40,
      height: 32,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VooFilterOperator>(
          value: currentOperator,
          items: operators
              .map(
                (op) => DropdownMenuItem(
                  value: op,
                  child: Center(
                    child: Text(
                      _getOperatorSymbol(op),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (op) {
            if (op != null) {
              onOperatorChanged(op);
            }
          },
          isExpanded: true,
          isDense: true,
          icon: const SizedBox.shrink(),
        ),
      ),
    );
  }
}