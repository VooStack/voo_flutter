import 'package:flutter/services.dart';

/// Text input formatter for converting text case
///
/// Automatically converts input text to either:
/// - UPPERCASE
/// - lowercase
class CaseFormatter extends TextInputFormatter {
  /// Whether to convert to uppercase (true) or lowercase (false)
  final bool toUpperCase;

  /// Creates a case formatter
  ///
  /// [toUpperCase] - If true, converts to uppercase; if false, converts to lowercase
  CaseFormatter({required this.toUpperCase});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = toUpperCase ? newValue.text.toUpperCase() : newValue.text.toLowerCase();

    return TextEditingValue(text: text, selection: newValue.selection);
  }
}
