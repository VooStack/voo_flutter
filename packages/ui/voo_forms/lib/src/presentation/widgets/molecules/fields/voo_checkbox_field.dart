import 'package:flutter/material.dart';
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
    super.labelWidget,
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
  String? validate(bool? value) {
    // For checkboxes, required means it must be checked (true)
    if (this.required && value != true) {
      return '${label ?? name} must be accepted';
    }
    
    // Call base validation for custom validators
    if (validators != null) {
      for (final validator in validators!) {
        final error = validator.validate(value);
        if (error != null) return error;
      }
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final currentValue = value ?? initialValue ?? false;

    // Build the checkbox with label in a row
    final checkboxRow = InkWell(
      onTap: enabled && !readOnly && onChanged != null ? () => onChanged!(!currentValue) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            VooCheckboxInput(
              value: currentValue,
              onChanged: enabled && !readOnly ? (value) => onChanged?.call(value ?? false) : null,
              enabled: enabled && !readOnly,
              tristate: tristate,
            ),
            const SizedBox(width: 12),
            if (labelWidget != null || label != null || helper != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (labelWidget != null) 
                      labelWidget!
                    else if (label != null) 
                      buildLabel(context),
                    if (helper != null) ...[
                      if (labelWidget != null || label != null) const SizedBox(height: 4),
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

    return buildFieldContainer(context, checkboxRow);
  }
}
