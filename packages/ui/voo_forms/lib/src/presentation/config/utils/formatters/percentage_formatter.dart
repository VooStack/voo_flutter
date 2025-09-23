import 'package:flutter/services.dart';

/// Text input formatter for percentage values
///
/// Formats input as: XX%
/// - Accepts only numeric input (0-100)
/// - Automatically appends '%' symbol
/// - Prevents values greater than 100
/// - Cursor positioned before the '%' symbol
class PercentageFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      return TextEditingValue.empty;
    }

    final value = int.tryParse(text) ?? 0;
    if (value > 100) {
      return oldValue;
    }

    return TextEditingValue(
      text: '$value%',
      selection: TextSelection.collapsed(offset: '$value%'.length - 1),
    );
  }
}
