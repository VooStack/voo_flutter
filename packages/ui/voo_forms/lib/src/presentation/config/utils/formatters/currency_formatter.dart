import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Text input formatter for currency fields with automatic formatting
/// 
/// Automatically formats numeric input as currency with:
/// - Customizable currency symbol ($, €, £, ¥, etc.)
/// - Thousand separators (1,000.00)
/// - Fixed decimal places (2 for most currencies)
/// - Proper cursor positioning
class CurrencyFormatter extends TextInputFormatter {
  /// The currency symbol to display
  final String symbol;
  
  /// The number of decimal places (usually 2)
  final int decimalDigits;
  
  /// The locale for formatting (affects separators)
  final String locale;
  
  /// Whether symbol comes before amount
  final bool symbolBeforeAmount;
  
  /// Cached number formatter
  late final NumberFormat _formatter;
  
  /// Creates a currency formatter with the specified options
  CurrencyFormatter({
    this.symbol = '\$',
    this.decimalDigits = 2,
    this.locale = 'en_US',
    this.symbolBeforeAmount = true,
  }) {
    _formatter = NumberFormat.currency(
      locale: locale,
      symbol: '',  // We'll add symbol manually for better control
      decimalDigits: decimalDigits,
    );
  }
  
  /// Factory constructor for common currencies
  factory CurrencyFormatter.usd() => CurrencyFormatter();
      
  factory CurrencyFormatter.eur() => CurrencyFormatter(
        symbol: '€',
        locale: 'de_DE',
        symbolBeforeAmount: false,
      );
      
  factory CurrencyFormatter.gbp() => CurrencyFormatter(
        symbol: '£',
        locale: 'en_GB',
      );
      
  factory CurrencyFormatter.jpy() => CurrencyFormatter(
        symbol: '¥',
        decimalDigits: 0,
        locale: 'ja_JP',
      );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if this is a complete replacement (e.g., from tester.enterText or paste)
    // If the new text is all digits and doesn't contain formatting, it's a replacement
    final isReplacement = RegExp(r'^\d+$').hasMatch(newValue.text);
    
    // Handle deletion only if it's not a replacement
    if (!isReplacement && newValue.text.length < oldValue.text.length) {
      return _handleDeletion(oldValue, newValue);
    }
    
    // Extract numeric value from the input
    final digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    
    // Handle empty input
    if (digitsOnly.isEmpty) {
      return TextEditingValue.empty;
    }
    
    // Convert to double with proper decimal places
    final divisor = decimalDigits > 0 ? math.pow(10, decimalDigits) : 1;
    final double value = double.parse(digitsOnly) / divisor;
    
    // Format the number
    final formatted = _formatCurrency(value);
    
    // Calculate cursor position
    // For replacements or empty old value, put cursor at end
    final cursorPosition = isReplacement || oldValue.text.isEmpty
        ? formatted.length
        : _calculateCursorPosition(
            oldValue.text,
            formatted,
            newValue.selection.baseOffset,
          );
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
  
  TextEditingValue _handleDeletion(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If deleting from the end, just remove last digit
    if (newValue.selection.baseOffset == newValue.text.length) {
      final digitsOnly = oldValue.text.replaceAll(RegExp('[^0-9]'), '');
      if (digitsOnly.length <= 1) {
        return TextEditingValue.empty;
      }
      
      final newDigits = digitsOnly.substring(0, digitsOnly.length - 1);
      final divisor = decimalDigits > 0 ? math.pow(10, decimalDigits) : 1;
      final double value = double.parse(newDigits) / divisor;
      final formatted = _formatCurrency(value);
      
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    return newValue;
  }
  
  String _formatCurrency(double value) {
    final numberFormatted = _formatter.format(value);
    
    // Add currency symbol
    if (symbolBeforeAmount) {
      return '$symbol$numberFormatted';
    } else {
      return '$numberFormatted $symbol';
    }
  }
  
  int _calculateCursorPosition(
    String oldText,
    String newText,
    int oldPosition,
  ) {
    // Count digits before cursor in old text
    int digitsBeforeCursor = 0;
    for (int i = 0; i < oldPosition && i < oldText.length; i++) {
      if (RegExp('[0-9]').hasMatch(oldText[i])) {
        digitsBeforeCursor++;
      }
    }
    
    // Find position in new text with same number of digits
    int newPosition = 0;
    int digitCount = 0;
    for (int i = 0; i < newText.length; i++) {
      if (RegExp('[0-9]').hasMatch(newText[i])) {
        digitCount++;
        if (digitCount >= digitsBeforeCursor) {
          newPosition = i + 1;
          break;
        }
      }
      newPosition = i + 1;
    }
    
    // Make sure we don't go past the end
    return newPosition.clamp(0, newText.length);
  }
  
  /// Parse a formatted currency string back to a double value
  static double? parse(String text) {
    if (text.isEmpty) return null;
    
    // Remove all non-digit and non-decimal characters
    final cleaned = text.replaceAll(RegExp('[^0-9.]'), '');
    return double.tryParse(cleaned);
  }
}