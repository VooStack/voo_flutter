import 'package:flutter/services.dart';

/// Text input formatter that applies a mask pattern to user input
/// 
/// Creates formatted input by applying a mask with:
/// - A mask string defining the format structure
/// - A placeholder character that gets replaced with user input
/// - Fixed characters that appear in the formatted output
/// 
/// Example:
/// ```dart
/// MaskFormatter(mask: '###-##-####', placeholder: '#')
/// ```
/// This would format input like: 123-45-6789
class MaskFormatter extends TextInputFormatter {
  /// The mask pattern string
  final String mask;
  
  /// The placeholder character in the mask that gets replaced with input
  final String placeholder;

  /// Creates a mask formatter with the specified mask and placeholder
  /// 
  /// [mask] - Pattern string defining the format structure
  /// [placeholder] - Character in the mask to be replaced with user input
  MaskFormatter({
    required this.mask,
    required this.placeholder,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    int textIndex = 0;

    for (int i = 0; i < mask.length && textIndex < text.length; i++) {
      if (mask[i] == placeholder) {
        buffer.write(text[textIndex]);
        textIndex++;
      } else {
        buffer.write(mask[i]);
        if (textIndex < text.length && text[textIndex] == mask[i]) {
          textIndex++;
        }
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}