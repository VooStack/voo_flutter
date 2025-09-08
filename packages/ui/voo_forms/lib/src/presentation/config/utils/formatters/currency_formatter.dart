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
  
  /// Include spacing between symbol and amount
  final bool includeSpacing;
  
  /// Maximum value allowed (null for no limit)
  final double? maxValue;
  
  /// Minimum value allowed (null for no limit)
  final double? minValue;
  
  /// Cached number formatter
  late final NumberFormat _formatter;
  
  /// Creates a currency formatter with the specified options
  CurrencyFormatter({
    this.symbol = '\$',
    this.decimalDigits = 2,
    this.locale = 'en_US',
    this.symbolBeforeAmount = true,
    this.includeSpacing = false,
    this.maxValue,
    this.minValue,
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
    // Handle empty or cleared input
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }
    
    // Extract only digits from the input
    final digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    
    // If no digits, return empty
    if (digitsOnly.isEmpty) {
      return TextEditingValue.empty;
    }
    
    // Parse the raw number
    final rawNumber = int.tryParse(digitsOnly) ?? 0;
    
    // Convert to actual value based on decimal places
    final divisor = decimalDigits > 0 ? math.pow(10, decimalDigits) : 1;
    final double value = rawNumber / divisor;
    
    // Apply min/max constraints
    final constrainedValue = _applyConstraints(value);
    
    // Format the currency
    final formatted = _formatCurrency(constrainedValue);
    
    // Calculate the new cursor position
    final newCursorPosition = _calculateCursorPosition(
      oldValue,
      newValue,
      formatted,
    );
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
  
  /// Apply min/max constraints to a value
  double _applyConstraints(double value) {
    double result = value;
    if (minValue != null && result < minValue!) {
      result = minValue!;
    }
    if (maxValue != null && result > maxValue!) {
      result = maxValue!;
    }
    return result;
  }
  
  /// Calculate the appropriate cursor position after formatting
  int _calculateCursorPosition(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    String formatted,
  ) {
    // If text was cleared or this is the initial input, position at end
    if (oldValue.text.isEmpty || newValue.text.isEmpty) {
      return formatted.length;
    }
    
    // Count digits before cursor in the new unformatted text
    final digitsBeforeCursor = newValue.text
        .substring(0, math.min(newValue.selection.baseOffset, newValue.text.length))
        .replaceAll(RegExp('[^0-9]'), '')
        .length;
    
    // Find position in formatted text with same number of digits
    int digitCount = 0;
    int position = 0;
    
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp('[0-9]').hasMatch(formatted[i])) {
        digitCount++;
        if (digitCount == digitsBeforeCursor) {
          position = i + 1;
          break;
        }
      }
      position = i + 1;
    }
    
    // Ensure position doesn't exceed formatted text length
    return math.min(position, formatted.length);
  }
  
  String _formatCurrency(double value) {
    // Ensure value has correct decimal places
    final numberFormatted = _formatter.format(value);
    
    // Build the formatted string with symbol
    final space = includeSpacing ? ' ' : '';
    
    if (symbolBeforeAmount) {
      return '$symbol$space$numberFormatted';
    } else {
      return '$numberFormatted$space$symbol';
    }
  }
  
  /// Parse a formatted currency string back to a double value
  static double? parse(String text, {String? symbol}) {
    if (text.isEmpty) return null;
    
    // Remove currency symbol if provided
    String cleaned = text;
    if (symbol != null) {
      cleaned = cleaned.replaceAll(symbol, '');
    }
    
    // Remove common currency symbols
    cleaned = cleaned.replaceAll(RegExp(r'[\$€£¥₹¢]'), '');
    
    // Remove thousand separators but keep decimal points
    cleaned = cleaned.replaceAll(',', '');
    
    // Trim whitespace
    cleaned = cleaned.trim();
    
    // Handle different decimal separators (some locales use comma)
    if (cleaned.contains(',') && !cleaned.contains('.')) {
      cleaned = cleaned.replaceAll(',', '.');
    }
    
    return double.tryParse(cleaned);
  }
  
  /// Extract numeric value from a formatted currency string
  double extractNumericValue(String text) => parse(text, symbol: symbol) ?? 0.0;
}