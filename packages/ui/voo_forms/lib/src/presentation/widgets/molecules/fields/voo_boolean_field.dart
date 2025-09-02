import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_switch_input.dart';

/// Boolean field molecule that composes atoms to create a complete switch field
/// Uses VooSwitchInput atom for the actual switch control
class VooBooleanField extends VooFieldBase<bool> {
  const VooBooleanField({
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
  }) : super(
          initialValue: initialValue ?? false,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentValue = value ?? initialValue ?? false;

    // Build the switch with label in a row
    final switchRow = Row(
      children: [
        if (label != null) ...[
          Expanded(
            child: GestureDetector(
              onTap: enabled && !readOnly && onChanged != null ? () => onChanged!(!currentValue) : null,
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
          ),
        ],
        VooSwitchInput(
          value: currentValue,
          onChanged: enabled && !readOnly ? onChanged : null,
          enabled: enabled && !readOnly,
        ),
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: 8),
          ...actions!,
        ],
      ],
    );

    // Wrap in a card-like container for better visual separation
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: switchRow,
    );
  }

  /// Factory constructor to create from VooFormField
  factory VooBooleanField.fromFormField(VooFormField field) => VooBooleanField(
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
