import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_checkbox_input.dart';

/// Checkbox field molecule that composes atoms to create a complete checkbox field
/// Uses VooCheckboxInput atom for the actual checkbox control
class VooCheckboxField extends VooFieldBase<bool> {
  final bool tristate;

  const VooCheckboxField({
    super.key,
    required super.name,
    super.label,
    super.helper,
    bool? initialValue,
    super.value,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.gridColumns,
    this.tristate = false,
  }) : super(
          initialValue: initialValue ?? false,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = value ?? initialValue ?? false;

    // Build the checkbox with label in a row
    final checkboxRow = InkWell(
      onTap: enabled && !readOnly && onChanged != null ? () => onChanged!(!currentValue) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            VooCheckboxInput(
              value: currentValue,
              onChanged: enabled && !readOnly ? (value) => onChanged?.call(value ?? false) : null,
              enabled: enabled && !readOnly,
              tristate: tristate,
            ),
            const SizedBox(width: 12),
            if (label != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLabel(context),
                    if (helper != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        helper!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(width: 8),
              ...actions!,
            ],
          ],
        ),
      ),
    );

    return checkboxRow;
  }

  /// Factory constructor to create from VooFormField
  factory VooCheckboxField.fromFormField(VooFormField field) => VooCheckboxField(
        name: field.name,
        label: field.label,
        helper: field.helper,
        initialValue: field.initialValue is bool ? field.initialValue as bool : false,
        value: field.value is bool ? field.value as bool : null,
        required: field.required,
        enabled: field.enabled,
        readOnly: field.readOnly,
        validators: field.validators.cast(),
        onChanged: field.onChanged != null ? (value) => field.onChanged!(value) : null,
        actions: field.actions,
      );
}
