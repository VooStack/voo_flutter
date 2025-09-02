import 'package:flutter/material.dart';
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