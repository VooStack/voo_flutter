import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';

/// Helper class for creating text field prefix widgets
class TextFieldPrefixBuilder {
  const TextFieldPrefixBuilder();

  Widget? build(VooFormField field) {
    if (field.prefix != null) {
      return field.prefix;
    }
    if (field.prefixIcon != null) {
      return Icon(field.prefixIcon);
    }
    return null;
  }
}

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

/// Helper class for creating text field input formatters
class TextFieldFormattersBuilder {
  const TextFieldFormattersBuilder();

  List<TextInputFormatter> build(VooFormField field) {
    final List<TextInputFormatter> formatters = [];

    // Add custom formatters
    if (field.inputFormatters != null) {
      formatters.addAll(field.inputFormatters!);
    }

    // Add length formatter
    if (field.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(field.maxLength));
    }

    // Add type-specific formatters
    switch (field.type) {
      case VooFieldType.number:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9\.\-eE]')));
        break;
      case VooFieldType.phone:
        formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\(\)\s\.]')));
        break;
      default:
        break;
    }

    return formatters;
  }
}