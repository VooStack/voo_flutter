import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A molecule component for an advanced filter row
class AdvancedFilterRowMolecule extends StatelessWidget {
  /// The filter entry being edited
  final FilterEntry filter;
  
  /// Available fields for filtering
  final List<FilterFieldConfig> fields;
  
  /// Callback when field changes
  final void Function(FilterFieldConfig?)? onFieldChanged;
  
  /// Callback when operator changes
  final void Function(String?)? onOperatorChanged;
  
  /// Callback when primary value changes
  final void Function(dynamic)? onValueChanged;
  
  /// Callback when secondary value changes (for range operations)
  final void Function(dynamic)? onSecondaryValueChanged;
  
  /// Callback to remove this filter
  final VoidCallback? onRemove;
  
  /// Widget builder for value input
  final Widget Function(FilterEntry filter)? valueInputBuilder;
  
  /// Widget builder for secondary value input
  final Widget Function(FilterEntry filter)? secondaryValueInputBuilder;
  
  const AdvancedFilterRowMolecule({
    super.key,
    required this.filter,
    required this.fields,
    this.onFieldChanged,
    this.onOperatorChanged,
    this.onValueChanged,
    this.onSecondaryValueChanged,
    this.onRemove,
    this.valueInputBuilder,
    this.secondaryValueInputBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.vooDesign;
    
    return Card(
      margin: EdgeInsets.only(bottom: design.spacingSm),
      child: Padding(
        padding: EdgeInsets.all(design.spacingSm),
        child: Row(
          children: [
            // Field selector
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<FilterFieldConfig>(
                decoration: InputDecoration(
                  labelText: 'Field',
                  border: const OutlineInputBorder(),
                  prefixIcon: filter.field != null 
                      ? Icon(filter.field!.type.icon)
                      : null,
                ),
                value: filter.field,
                items: fields
                    .map(
                      (field) => DropdownMenuItem(
                        value: field,
                        child: Text(field.displayName),
                      ),
                    )
                    .toList(),
                onChanged: onFieldChanged,
              ),
            ),
            SizedBox(width: design.spacingSm),
            
            // Operator selector
            if (filter.field != null) ...[
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Operator',
                    border: OutlineInputBorder(),
                  ),
                  value: filter.operator,
                  items: filter.field!.type.operators
                      .map(
                        (op) => DropdownMenuItem(
                          value: op,
                          child: Text(op.displayText),
                        ),
                      )
                      .toList(),
                  onChanged: onOperatorChanged,
                ),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Value input
            if (filter.field != null && filter.operator != null) ...[
              Expanded(
                flex: 3,
                child: valueInputBuilder?.call(filter) ?? 
                    _buildDefaultValueInput(filter),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Secondary value for range operations
            if (filter.operator?.requiresSecondaryValue == true) ...[
              Expanded(
                flex: 3,
                child: secondaryValueInputBuilder?.call(filter) ??
                    _buildDefaultSecondaryValueInput(filter),
              ),
              SizedBox(width: design.spacingSm),
            ],
            
            // Remove button
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: theme.colorScheme.error,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDefaultValueInput(FilterEntry filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
      ),
      onChanged: onValueChanged,
    );
  }
  
  Widget _buildDefaultSecondaryValueInput(FilterEntry filter) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'To',
        border: OutlineInputBorder(),
      ),
      onChanged: onSecondaryValueChanged,
    );
  }
}

/// Extension for filter operator display text
extension FilterOperatorExtension on String {
  String get displayText {
    switch (this) {
      case 'equals':
        return 'Equals';
      case 'not_equals':
        return 'Not Equals';
      case 'contains':
        return 'Contains';
      case 'starts_with':
        return 'Starts With';
      case 'ends_with':
        return 'Ends With';
      case 'greater_than':
        return 'Greater Than';
      case 'less_than':
        return 'Less Than';
      case 'between':
        return 'Between';
      case 'in':
        return 'In';
      case 'not_in':
        return 'Not In';
      case 'is_null':
        return 'Is Null';
      case 'is_not_null':
        return 'Is Not Null';
      default:
        return this;
    }
  }
  
  bool get requiresSecondaryValue {
    return this == 'between';
  }
}

/// Data model for filter field type
class FilterFieldType {
  final IconData icon;
  final List<String> operators;
  final String defaultOperator;
  
  const FilterFieldType({
    required this.icon,
    required this.operators,
    required this.defaultOperator,
  });
  
  static const text = FilterFieldType(
    icon: Icons.text_fields,
    operators: ['equals', 'not_equals', 'contains', 'starts_with', 'ends_with'],
    defaultOperator: 'contains',
  );
  
  static const number = FilterFieldType(
    icon: Icons.numbers,
    operators: ['equals', 'not_equals', 'greater_than', 'less_than', 'between'],
    defaultOperator: 'equals',
  );
  
  static const date = FilterFieldType(
    icon: Icons.calendar_today,
    operators: ['equals', 'not_equals', 'greater_than', 'less_than', 'between'],
    defaultOperator: 'equals',
  );
  
  static const boolean = FilterFieldType(
    icon: Icons.check_box,
    operators: ['equals'],
    defaultOperator: 'equals',
  );
}