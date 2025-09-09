import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_number_input.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Number field molecule that composes atoms to create a complete numeric input field
/// Supports both integer and decimal numbers with configurable constraints
class VooNumberField extends VooFieldBase<num> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final num? min;
  final num? max;
  final num? step;
  final bool allowDecimals;
  final bool allowNegative;
  final int? maxDecimalPlaces;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  const VooNumberField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    String? placeholder,
    super.initialValue,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    this.controller,
    this.focusNode,
    this.min,
    this.max,
    this.step,
    this.allowDecimals = true,
    this.allowNegative = true,
    this.maxDecimalPlaces,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
  }) : super(placeholder: placeholder ?? '0');

  @override
  String? validate(num? value) {
    // Call base validation first for required check
    final baseError = super.validate(value);
    if (baseError != null) return baseError;

    // Check min/max constraints
    if (value != null) {
      if (min != null && value < min!) {
        return '${label ?? name} must be at least $min';
      }
      if (max != null && value > max!) {
        return '${label ?? name} must be at most $max';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    final formController = formScope?.controller;

    // If read-only, show VooReadOnlyField for better UX
    if (effectiveReadOnly) {
      String displayValue = '';
      if (initialValue != null) {
        // Format the number appropriately
        if (!allowDecimals || initialValue!.toInt() == initialValue) {
          displayValue = initialValue!.toInt().toString();
        } else {
          displayValue = initialValue.toString();
        }
      }
      
      Widget readOnlyContent = VooReadOnlyField(
        value: displayValue,
        icon: prefixIcon ?? suffixIcon,
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }

    // Use provided focus node or get one from form controller if available
    FocusNode? effectiveFocusNode = focusNode;
    if (effectiveFocusNode == null && formController != null) {
      effectiveFocusNode = formController.getFocusNode(name);
    }

    // Create wrapped onChanged that updates both controller and calls user callback
    void handleChanged(String text) {
      final numValue = num.tryParse(text);
      // Update form controller if available
      if (formController != null) {
        formController.setValue(name, numValue, validate: true);
      }
      // Call user's onChanged if provided
      onChanged?.call(numValue);
    }

    final numberInput = VooNumberInput(
      controller: controller,
      focusNode: effectiveFocusNode,
      initialValue: initialValue,
      placeholder: placeholder,
      inputFormatters: [
        StrictNumberFormatter(
          allowDecimals: allowDecimals,
          allowNegative: allowNegative,
          maxDecimalPlaces: maxDecimalPlaces,
          minValue: min,
          maxValue: max,
        ),
      ],
      onChanged: handleChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      decoration: getInputDecoration(context),
      signed: allowNegative,
      decimal: allowDecimals,
    );

    // Compose with label, helper, error and actions using base class methods
    return buildFieldContainer(
      context,
      buildWithLabel(
        context,
        buildWithError(
          context,
          buildWithHelper(
            context,
            buildWithActions(
              context,
              numberInput,
            ),
          ),
        ),
      ),
    );
  }

  @override
  VooNumberField copyWith({
    num? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooNumberField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        hint: hint,
        helper: helper,
        placeholder: placeholder,
        initialValue: initialValue ?? this.initialValue,
        enabled: enabled,
        readOnly: readOnly ?? this.readOnly,
        validators: validators,
        onChanged: onChanged,
        actions: actions,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        error: error,
        showError: showError,
        controller: controller,
        focusNode: focusNode,
        min: min,
        max: max,
        step: step,
        allowDecimals: allowDecimals,
        allowNegative: allowNegative,
        maxDecimalPlaces: maxDecimalPlaces,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
      );
}
