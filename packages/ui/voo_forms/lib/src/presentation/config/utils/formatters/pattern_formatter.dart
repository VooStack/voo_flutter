import 'package:flutter/services.dart';

/// Text input formatter that applies custom patterns using regex mappings
/// 
/// Allows creating complex input formatting by defining:
/// - A pattern string with placeholder characters
/// - A mapping of placeholder characters to regex patterns
/// 
/// Example:
/// ```dart
/// PatternFormatter(
///   pattern: 'AAA-999',
///   patternMapping: {
///     'A': RegExp(r'[A-Z]'),
///     '9': RegExp(r'[0-9]'),
///   },
/// )
/// ```
/// This would format input like: ABC-123
class PatternFormatter extends TextInputFormatter {
  /// The pattern string with placeholder characters
  final String pattern;
  
  /// Mapping of placeholder characters to their corresponding regex patterns
  final Map<String, RegExp> patternMapping;

  /// Creates a pattern formatter with the specified pattern and mappings
  /// 
  /// [pattern] - String containing the desired format with placeholders
  /// [patternMapping] - Map linking placeholder characters to regex patterns
  PatternFormatter({
    required this.pattern,
    required this.patternMapping,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    int textIndex = 0;

    for (int i = 0; i < pattern.length && textIndex < text.length; i++) {
      final char = pattern[i];
      final regex = patternMapping[char];
      
      if (regex != null) {
        if (textIndex < text.length && regex.hasMatch(text[textIndex])) {
          buffer.write(text[textIndex]);
          textIndex++;
        } else {
          break;
        }
      } else {
        buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}