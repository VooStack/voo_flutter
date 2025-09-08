import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_switch_input.dart';
import 'package:voo_forms/voo_forms.dart';

/// Boolean field molecule that composes atoms to create a complete switch field
/// Uses VooSwitchInput atom for the actual switch control
class VooBooleanField extends VooFieldBase<bool> {
  const VooBooleanField({
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
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
  }) : super(
          initialValue: initialValue ?? false,
        );

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
        // Validate on change to clear any errors
        formController.setValue(name, value, validate: true);
      }
      // Call user's onChanged if provided
      onChanged?.call(value);
    }

    // Build the switch with label or labelWidget in a row
    final switchRow = Row(
      children: [
        if (labelWidget != null || label != null) ...[
          Expanded(
            child: GestureDetector(
              onTap: enabled && !effectiveReadOnly && onChanged != null ? () => handleChanged(!currentValue) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelWidget != null) labelWidget! else buildLabel(context),
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
          onChanged: enabled && !effectiveReadOnly ? handleChanged : null,
          enabled: enabled && !effectiveReadOnly,
        ),
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(width: 8),
          ...actions!,
        ],
      ],
    );

    // Wrap in a card-like container for better visual separation
    Widget container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: enabled ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: switchRow,
    );

    // Apply height constraints to the input container
    container = applyInputHeightConstraints(container);

    // Build with error if present
    Widget fieldWithError = container;
    if (fieldError != null && fieldError.isNotEmpty) {
      fieldWithError = buildWithError(context, container);
    }

    return buildFieldContainer(context, fieldWithError);
  }

  @override
  VooBooleanField copyWith({
    String? name,
    String? label,
    bool? initialValue,
    VooFieldLayout? layout,
    bool? readOnly,
  }) =>
      VooBooleanField(
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
      );
}
