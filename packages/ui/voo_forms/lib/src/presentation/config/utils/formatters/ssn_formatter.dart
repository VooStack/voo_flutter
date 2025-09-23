import 'package:flutter/services.dart';

/// Text input formatter for US Social Security Numbers (SSN)
///
/// Formats input as: XXX-XX-XXXX
/// - Accepts only numeric input
/// - Automatically adds dashes at appropriate positions
/// - Limits input to 9 digits maximum
class SSNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 9; i++) {
      if (i == 3 || i == 5) buffer.write('-');
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
