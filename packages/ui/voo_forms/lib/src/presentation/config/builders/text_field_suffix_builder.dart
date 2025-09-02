import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';

/// Helper class for creating text field suffix widgets
class TextFieldSuffixBuilder {
  const TextFieldSuffixBuilder();

  Widget? build({
    required VooFormField field,
    bool obscureText = false,
    VoidCallback? onToggleObscureText,
  }) {
    if (field.type == VooFieldType.password && onToggleObscureText != null) {
      return IconButton(
        icon: Icon(
          obscureText 
              ? Icons.visibility_outlined 
              : Icons.visibility_off_outlined,
        ),
        onPressed: onToggleObscureText,
        tooltip: obscureText ? 'Show password' : 'Hide password',
      );
    }
    if (field.suffix != null) {
      return field.suffix;
    }
    if (field.suffixIcon != null) {
      return Icon(field.suffixIcon);
    }
    return null;
  }
}