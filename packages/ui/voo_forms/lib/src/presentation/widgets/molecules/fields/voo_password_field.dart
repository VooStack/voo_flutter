import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';

/// Password field molecule - extends VooTextField with password-specific defaults
/// Automatically obscures text and adds lock icon
class VooPasswordField extends VooTextField {
  const VooPasswordField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
    super.initialValue,
    super.value,
    super.required,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    Widget? prefixIcon,
    Widget? suffixIcon,
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
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          prefixIcon: prefixIcon ?? const Icon(Icons.lock),
          suffixIcon: suffixIcon ?? const Icon(Icons.visibility),
          textInputAction: TextInputAction.done,
        );
}
