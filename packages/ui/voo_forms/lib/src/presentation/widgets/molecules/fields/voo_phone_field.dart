import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';

/// Phone field molecule - extends VooTextField with phone-specific defaults
/// Automatically sets phone keyboard type and adds phone icon
class VooPhoneField extends VooTextField {
  const VooPhoneField({
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
    Widget? prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.controller,
    super.focusNode,
    super.inputFormatters,
    super.onEditingComplete,
    super.onSubmitted,
    super.autofocus,
  }) : super(
          placeholder: placeholder ?? '(555) 123-4567',
          keyboardType: TextInputType.phone,
          prefixIcon: prefixIcon ?? const Icon(Icons.phone),
          autocorrect: false,
          enableSuggestions: false,
        );
}
