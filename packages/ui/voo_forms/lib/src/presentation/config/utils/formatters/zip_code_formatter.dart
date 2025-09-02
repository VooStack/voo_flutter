import 'package:flutter/services.dart';

/// Text input formatter for US ZIP codes
/// 
/// Formats input as:
/// - XXXXX (5-digit ZIP code)
/// - XXXXX-XXXX (9-digit ZIP+4 code)
/// 
/// - Accepts only numeric input
/// - Automatically adds dash after 5th digit
/// - Limits input to 9 digits maximum
class ZipCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 9; i++) {
      if (i == 5) buffer.write('-');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}