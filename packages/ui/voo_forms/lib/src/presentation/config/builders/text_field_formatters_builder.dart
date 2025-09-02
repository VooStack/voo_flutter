import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';

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