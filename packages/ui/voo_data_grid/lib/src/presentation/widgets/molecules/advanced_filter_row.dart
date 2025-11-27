import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/default_filter_secondary_input.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/default_filter_value_input.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A molecule component for an advanced filter row
class AdvancedFilterRow extends StatelessWidget {
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

  const AdvancedFilterRow({
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

    return Card(
      margin: EdgeInsets.only(bottom: context.vooSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(context.vooSpacing.sm),
        child: Row(
          children: [
            // Field selector
            Expanded(
              flex: 2,
              child: Container(
                height: context.vooSize.buttonHeightSmall,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(context.vooRadius.sm),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<FilterFieldConfig>(
                      value: filter.field,
                      hint: Text(
                        'Select field',
                        style: context.vooTypography.labelSmall.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      icon: Icon(
                        filter.field != null
                            ? filter.field!.type.icon
                            : Icons.arrow_drop_down,
                        size: context.vooSize.iconSmall,
                      ),
                      isExpanded: true,
                      isDense: true,
                      style: context.vooTypography.labelSmall.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      items: fields
                          .map(
                            (field) => DropdownMenuItem(
                              value: field,
                              child: Text(
                                field.displayName,
                                style: context.vooTypography.labelSmall,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: onFieldChanged,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.vooSpacing.sm),

            // Operator selector
            if (filter.field != null) ...[
              Expanded(
                flex: 2,
                child: Container(
                  height: context.vooSize.buttonHeightSmall,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(context.vooRadius.sm),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: filter.operator,
                        hint: Text(
                          'Operator',
                          style: context.vooTypography.labelSmall.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: context.vooSize.iconSmall,
                        ),
                        isExpanded: true,
                        isDense: true,
                        style: context.vooTypography.labelSmall.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        items: filter.field!.type.operators
                            .map(
                              (op) => DropdownMenuItem(
                                value: op,
                                child: Text(
                                  op.displayText,
                                  style: context.vooTypography.labelSmall,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: onOperatorChanged,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.vooSpacing.sm),
            ],

            // Value input
            if (filter.field != null && filter.operator != null) ...[
              Expanded(
                flex: 3,
                child: valueInputBuilder?.call(filter) ??
                    DefaultFilterValueInput(
                      filter: filter,
                      onChanged: onValueChanged != null
                          ? (value) => onValueChanged!(value)
                          : null,
                    ),
              ),
              SizedBox(width: context.vooSpacing.sm),
            ],

            // Secondary value for range operations
            if (filter.operator?.requiresSecondaryValue == true) ...[
              Expanded(
                flex: 3,
                child: secondaryValueInputBuilder?.call(filter) ??
                    DefaultFilterSecondaryInput(
                      filter: filter,
                      onChanged: onSecondaryValueChanged != null
                          ? (value) => onSecondaryValueChanged!(value)
                          : null,
                    ),
              ),
              SizedBox(width: context.vooSpacing.sm),
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
}

/// Data model for filter field type
class FilterFieldType {
  final IconData icon;
  final List<String> operators;
  final String defaultOperator;

  const FilterFieldType({required this.icon, required this.operators, required this.defaultOperator});

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

  static const boolean = FilterFieldType(icon: Icons.check_box, operators: ['equals'], defaultOperator: 'equals');
}
