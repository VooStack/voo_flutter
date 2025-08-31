import 'package:flutter/services.dart';

/// Text input formatter for international phone numbers
/// 
/// Handles international phone number formatting with:
/// - Support for country codes with '+' prefix
/// - Automatic filtering of non-numeric characters (except '+')
/// - Ensures '+' only appears at the beginning
/// - Reasonable length limits for international numbers
class InternationalPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp('[^0-9+]'), '');
    if (text.isEmpty) return newValue.copyWith(text: '');
    
    // Allow + only at the beginning
    String formatted = text;
    if (text.startsWith('+')) {
      final digits = text.substring(1).replaceAll('+', '');
      formatted = '+$digits';
    } else {
      formatted = text.replaceAll('+', '');
    }
    
    // Limit to reasonable phone number length
    if (formatted.length > 15) {
      formatted = formatted.substring(0, 15);
    }
    
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}