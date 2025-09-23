import 'package:flutter/services.dart';

/// Text input formatter for date fields with customizable format
///
/// Supports different date formats:
/// - US format: MM/DD/YYYY
/// - EU format: DD/MM/YYYY
/// - ISO format: YYYY-MM-DD
class DateFormatter extends TextInputFormatter {
  /// The separator character to use between date components
  final String separator;

  /// Whether to use European date format (DD/MM/YYYY)
  final bool euFormat;

  /// Whether to use ISO date format (YYYY-MM-DD)
  final bool isoFormat;

  /// Creates a date formatter with the specified format options
  DateFormatter({required this.separator, this.euFormat = false, this.isoFormat = false});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    if (isoFormat) {
      // YYYY-MM-DD
      for (int i = 0; i < text.length && i < 8; i++) {
        if (i == 4 || i == 6) buffer.write(separator);
        buffer.write(text[i]);
      }
    } else {
      // MM/DD/YYYY or DD/MM/YYYY
      for (int i = 0; i < text.length && i < 8; i++) {
        if (i == 2 || i == 4) buffer.write(separator);
        buffer.write(text[i]);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
