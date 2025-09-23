import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_number_field.dart';

/// Integer field molecule - extends VooNumberField with integer-only constraints
/// Does not allow decimal input
class VooIntegerField extends VooNumberField {
  VooIntegerField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    String? placeholder,
    int? super.initialValue,
    super.enabled,
    super.readOnly,
    super.validators,
    ValueChanged<int?>? onChanged,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
    super.controller,
    super.focusNode,
    int? super.min,
    int? super.max,
    super.allowNegative,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
  }) : super(placeholder: placeholder ?? '0', allowDecimals: false, onChanged: onChanged != null ? (num? value) => onChanged(value?.toInt()) : null);
}
