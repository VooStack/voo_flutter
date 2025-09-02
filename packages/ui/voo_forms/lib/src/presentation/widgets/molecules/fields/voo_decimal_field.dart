import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_number_field.dart';

/// Decimal field molecule - extends VooNumberField with decimal-specific defaults
/// Allows configurable number of decimal places
class VooDecimalField extends VooNumberField {
  VooDecimalField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    String? placeholder,
    double? super.initialValue,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    ValueChanged<double?>? onChanged,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.controller,
    super.focusNode,
    double? super.min,
    double? super.max,
    int super.maxDecimalPlaces = 2,
    super.allowNegative,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
  }) : super(
          placeholder: placeholder ?? '0.00',
          allowDecimals: true,
          onChanged: onChanged != null ? (num? value) => onChanged(value?.toDouble()) : null,
        );
}
