import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Text input formatter for currency fields with automatic formatting
/// 
/// This formatter works like a calculator - typing digits adds them from right to left
/// For example, typing "5" then "5" gives:
/// - First "5": $0.05
/// - Second "5": $0.55 (not $50.05)
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
  
  /// Internal tracking of the raw cents value (for USD, or smallest unit for other currencies)
  int _rawValue = 0;
  
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
      _rawValue = 0;
      return TextEditingValue.empty;
    }
    
    // Determine if this is a deletion or addition
    final oldDigits = oldValue.text.replaceAll(RegExp('[^0-9]'), '');
    final newDigits = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    
    if (newDigits.isEmpty) {
      _rawValue = 0;
      return TextEditingValue.empty;
    }
    
    // Check if we should treat this as incremental typing or complete replacement
    // If the new digits don't start with the old digits, it's likely a replacement
    // (e.g., user selected all text and typed new value, or test called enterText)
    final bool isIncrementalTyping = oldDigits.isEmpty || newDigits.startsWith(oldDigits);
    
    if (!isIncrementalTyping && newDigits.isNotEmpty) {
      // Complete replacement - reset and parse all digits
      _rawValue = int.tryParse(newDigits) ?? 0;
    } else if (newDigits.length < oldDigits.length) {
      // User deleted a digit - remove from the right
      _rawValue = _rawValue ~/ 10;
      if (_rawValue == 0 && newDigits.isEmpty) {
        return TextEditingValue.empty;
      }
    } else if (newDigits.length > oldDigits.length) {
      // User added digit(s) - calculator style (right to left)
      // Get the difference in digits
      final digitDiff = newDigits.length - oldDigits.length;
      
      // For each new digit, shift left and add
      for (int i = 0; i < digitDiff; i++) {
        // Get the new digit at the appropriate position
        final newDigitIndex = oldDigits.length + i;
        if (newDigitIndex < newDigits.length) {
          final digit = int.tryParse(newDigits[newDigitIndex]) ?? 0;
          _rawValue = _rawValue * 10 + digit;
        }
      }
    } else {
      // Same length - might be a replacement or the raw value from initial parse
      // This can happen on first input or when text is pasted
      _rawValue = int.tryParse(newDigits) ?? 0;
    }
    
    // Convert to actual value based on decimal places
    final divisor = decimalDigits > 0 ? math.pow(10, decimalDigits) : 1;
    final double value = _rawValue / divisor;
    
    // Apply min/max constraints
    final constrainedValue = _applyConstraints(value);
    if (constrainedValue != value) {
      // If constrained, update raw value to match
      _rawValue = (constrainedValue * divisor).round();
    }
    
    // Format the currency
    final formatted = _formatCurrency(constrainedValue);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
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
    
    // Trim whitespace and non-breaking spaces
    cleaned = cleaned.replaceAll('\u00A0', ' ').trim();
    
    // Detect format: if there's a comma after a dot, it's European format (1.234,56)
    // Otherwise it's US format (1,234.56)
    bool isEuropeanFormat = false;
    final int lastDotIndex = cleaned.lastIndexOf('.');
    final int lastCommaIndex = cleaned.lastIndexOf(',');
    
    if (lastCommaIndex > lastDotIndex) {
      // European format: dot is thousand separator, comma is decimal
      isEuropeanFormat = true;
    }
    
    if (isEuropeanFormat) {
      // Remove dots (thousand separators) and replace comma with dot (decimal)
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else {
      // US format: remove commas (thousand separators)
      cleaned = cleaned.replaceAll(',', '');
    }
    
    return double.tryParse(cleaned);
  }
  
  /// Extract numeric value from a formatted currency string
  double extractNumericValue(String text) => parse(text, symbol: symbol) ?? 0.0;
  
  /// Reset the internal state (useful when switching between fields)
  void reset() {
    _rawValue = 0;
  }
  
  /// Set initial value from a double
  void setInitialValue(double value) {
    final divisor = decimalDigits > 0 ? math.pow(10, decimalDigits) : 1;
    _rawValue = (value * divisor).round();
  }
}