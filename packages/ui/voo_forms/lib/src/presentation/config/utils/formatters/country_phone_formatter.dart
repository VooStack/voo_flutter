import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/country_code.dart';

/// Phone formatter that formats based on country code
class CountryPhoneFormatter extends TextInputFormatter {
  final CountryCode country;

  CountryPhoneFormatter({required this.country});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return TextEditingValue.empty;
    }

    // Limit to expected phone number length
    final truncated = digitsOnly.length > country.phoneLength ? digitsOnly.substring(0, country.phoneLength) : digitsOnly;

    // Format according to country pattern
    final formatted = _formatNumber(truncated, country.format);

    // Calculate cursor position
    int cursorPosition = formatted.length;

    // If we're in the middle of typing, try to maintain relative cursor position
    if (newValue.selection.baseOffset < newValue.text.length) {
      final digitsBeforeCursor = newValue.text.substring(0, newValue.selection.baseOffset).replaceAll(RegExp(r'[^\d]'), '').length;

      cursorPosition = _calculateCursorPosition(formatted, digitsBeforeCursor);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String _formatNumber(String digits, String pattern) {
    final buffer = StringBuffer();
    int digitIndex = 0;

    for (int i = 0; i < pattern.length && digitIndex < digits.length; i++) {
      if (pattern[i] == 'X') {
        buffer.write(digits[digitIndex]);
        digitIndex++;
      } else {
        // Add separator only if we have more digits to add
        if (digitIndex < digits.length || (digitIndex > 0 && _hasMoreDigitsInPattern(pattern, i))) {
          buffer.write(pattern[i]);
        }
      }
    }

    return buffer.toString();
  }

  bool _hasMoreDigitsInPattern(String pattern, int currentIndex) {
    // Check if there are more X's after the current position
    for (int i = currentIndex + 1; i < pattern.length; i++) {
      if (pattern[i] == 'X') return false;
    }
    return true;
  }

  int _calculateCursorPosition(String formatted, int targetDigitCount) {
    int digitsSeen = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        digitsSeen++;
        if (digitsSeen == targetDigitCount) {
          return i + 1;
        }
      }
    }
    return formatted.length;
  }

  /// Validate if phone number is complete
  bool isComplete(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length == country.phoneLength;
  }

  /// Get the formatted phone number with country code
  String getFullNumber(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return '';
    return '${country.dialCode} $text';
  }
}
