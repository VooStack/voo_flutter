import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/validation_rule.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/inputs/voo_number_input.dart';
import 'package:voo_forms/src/utils/strict_number_formatter.dart';

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
    super.hint,
    super.helper,
    String? placeholder,
    super.initialValue,
    super.value,
    super.required,
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
    final numberInput = VooNumberInput(
      controller: controller,
      focusNode: focusNode,
      initialValue: value ?? initialValue,
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
      onChanged: (text) {
        if (onChanged != null) {
          final numValue = num.tryParse(text);
          onChanged!(numValue);
        }
      },
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      decoration: getInputDecoration(context),
      signed: allowNegative,
      decimal: allowDecimals,
    );

    // Compose with helper and error using base class methods
    return buildWithHelper(
      context,
      buildWithError(
        context,
        buildWithActions(
          context,
          numberInput,
        ),
      ),
    );
  }

  /// Factory constructor to create from VooFormField
  factory VooNumberField.fromFormField(VooFormField field) => VooNumberField(
        name: field.name,
        label: field.label,
        hint: field.hint,
        helper: field.helper,
        placeholder: field.placeholder,
        initialValue: field.initialValue is num ? field.initialValue as num : null,
        value: field.value is num ? field.value as num : null,
        required: field.required,
        enabled: field.enabled,
        readOnly: field.readOnly,
        validators: field.validators is List<VooValidationRule<num>> ? field.validators as List<VooValidationRule<num>> : null,
        onChanged: field.onChanged != null ? (value) => field.onChanged!(value) : null,
        actions: field.actions,
        prefixIcon: field.prefixIcon is IconData ? Icon(field.prefixIcon) : field.prefix,
        suffixIcon: field.suffixIcon is IconData ? Icon(field.suffixIcon) : field.suffix,
        min: field.min,
        max: field.max,
        step: field.step,
      );
}
