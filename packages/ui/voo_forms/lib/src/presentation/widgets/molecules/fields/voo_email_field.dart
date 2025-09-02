import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';

/// Email field molecule - extends VooTextField with email-specific defaults
/// Automatically sets email keyboard type and adds email icon
class VooEmailField extends VooTextField {
  const VooEmailField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
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
          placeholder: placeholder ?? 'user@example.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: prefixIcon ?? const Icon(Icons.email),
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.none,
        );

  @override
  String? validate(String? value) {
    // First check required validation
    final requiredError = super.validate(value);
    if (requiredError != null) return requiredError;

    // Check email format if value is not empty
    if (value != null && value.isNotEmpty) {
      // Basic email regex pattern
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }

    return null;
  }
}
