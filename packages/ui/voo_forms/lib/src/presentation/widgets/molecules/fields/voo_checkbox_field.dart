import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_checkbox_input.dart';
import 'package:voo_forms/voo_forms.dart';

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
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
    this.tristate = false,
  }) : super(
          initialValue: initialValue ?? false,
        );

  @override
  String? validate(bool? value) {
    // For checkboxes, required means it must be checked (true)
    if (isRequired && value != true) {
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
    final currentValue = initialValue ?? false;
    final effectiveReadOnly = getEffectiveReadOnly(context);

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;
    
    // Get the error for this field using the base class method
    final fieldError = getFieldError(context);

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(bool? value) {
      // Update form controller if available
      if (formController != null) {
        formController.setValue(name, value);
      }
      // Call user's onChanged if provided
      onChanged?.call(value);
    }

    // Build the checkbox with label in a row
    Widget checkboxRow = InkWell(
      onTap: enabled && !effectiveReadOnly && onChanged != null ? () => handleChanged(!currentValue) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            VooCheckboxInput(
              value: currentValue,
              onChanged: enabled && !effectiveReadOnly ? (value) => handleChanged(value ?? false) : null,
              enabled: enabled && !effectiveReadOnly,
              tristate: tristate,
            ),
            const SizedBox(width: 12),
            if (labelWidget != null || label != null || helper != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (labelWidget != null) labelWidget! else if (label != null) buildLabel(context),
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

    // Apply height constraints to the checkbox row
    checkboxRow = applyInputHeightConstraints(checkboxRow);

    // Build with error if present
    Widget fieldWithError = checkboxRow;
    if (fieldError != null && fieldError.isNotEmpty) {
      fieldWithError = buildWithError(context, checkboxRow);
    }

    return buildFieldContainer(context, fieldWithError);
  }

  @override
  VooCheckboxField copyWith({
    String? name,
    String? label,
    bool? initialValue,
    VooFieldLayout? layout,
    bool? readOnly,
  }) =>
      VooCheckboxField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        helper: helper,
        initialValue: initialValue ?? this.initialValue,
        enabled: enabled,
        readOnly: readOnly ?? this.readOnly,
        validators: validators,
        onChanged: onChanged,
        actions: actions,
        gridColumns: gridColumns,
        layout: layout ?? this.layout,
        isHidden: isHidden,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
        tristate: tristate,
      );
}
