import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_number_field.dart';

/// Percentage field molecule - extends VooNumberField with percentage-specific defaults
/// Automatically constrains values between 0 and 100 with percent icon
class VooPercentageField extends VooNumberField {
  VooPercentageField({
    super.key,
    required super.name,
    super.label,
    super.hint,
    super.helper,
    String? placeholder,
    double? super.initialValue,
    double? super.value,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    ValueChanged<double?>? onChanged,
    super.actions,
    super.prefixIcon,
    Widget? suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.controller,
    super.focusNode,
    super.allowDecimals,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
  }) : super(
          placeholder: placeholder ?? (allowDecimals ? '0.00' : '0'),
          min: 0,
          max: 100,
          maxDecimalPlaces: allowDecimals ? 2 : 0,
          allowNegative: false,
          suffixIcon: suffixIcon ?? const Icon(Icons.percent),
          onChanged: onChanged != null ? (num? value) => onChanged(value?.toDouble()) : null,
        );
}
