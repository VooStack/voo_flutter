import 'package:flutter/services.dart';

/// Strict number formatter that only allows valid numeric input
/// Prevents users from typing invalid characters in number fields
class StrictNumberFormatter extends TextInputFormatter {
  final bool allowDecimals;
  final bool allowNegative;
  final int? maxDecimalPlaces;
  final num? minValue;
  final num? maxValue;
  
  StrictNumberFormatter({
    this.allowDecimals = true,
    this.allowNegative = true,
    this.maxDecimalPlaces,
    this.minValue,
    this.maxValue,
  });
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Empty string is always allowed
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Build regex pattern based on options
    String pattern;
    if (allowNegative && allowDecimals) {
      pattern = r'^-?[0-9]*\.?[0-9]*$';
    } else if (allowNegative && !allowDecimals) {
      pattern = r'^-?[0-9]*$';
    } else if (!allowNegative && allowDecimals) {
      pattern = r'^[0-9]*\.?[0-9]*$';
    } else {
      pattern = r'^[0-9]*$';
    }
    
    // Check if the new value matches the pattern
    final regex = RegExp(pattern);
    if (!regex.hasMatch(newValue.text)) {
      return oldValue;
    }
    
    // Prevent multiple decimal points
    if (allowDecimals && newValue.text.split('.').length > 2) {
      return oldValue;
    }
    
    // Prevent "-" not at the beginning
    if (newValue.text.contains('-')) {
      if (!allowNegative || !newValue.text.startsWith('-')) {
        return oldValue;
      }
    }
    
    // Prevent multiple negative signs
    if (allowNegative && newValue.text.split('-').length > 2) {
      return oldValue;
    }
    
    // Check decimal places limit
    if (maxDecimalPlaces != null && newValue.text.contains('.')) {
      final parts = newValue.text.split('.');
      if (parts.length > 1 && parts[1].length > maxDecimalPlaces!) {
        return oldValue;
      }
    }
    
    // Check if we're typing a negative number when min is non-negative
    if (newValue.text.startsWith('-') && minValue != null && minValue! >= 0) {
      return oldValue;
    }
    
    // Validate min/max values if the input is complete
    if (newValue.text != '-' && 
        !newValue.text.endsWith('.') && 
        newValue.text != '-.') {
      final value = num.tryParse(newValue.text);
      if (value != null) {
        if (minValue != null && value < minValue!) {
          // Allow typing if it could lead to a valid value
          // For example, typing "1" when min is 10
          final couldBeValid = _couldLeadToValidValue(newValue.text, minValue!, maxValue);
          if (!couldBeValid) {
            return oldValue;
          }
        }
        if (maxValue != null && value > maxValue!) {
          return oldValue;
        }
      }
    }
    
    return newValue;
  }
  
  /// Check if partial input could lead to a valid value
  bool _couldLeadToValidValue(String text, num minValue, num? maxValue) {
    // For positive minimum values, check if adding digits could reach min
    if (minValue > 0) {
      final currentValue = num.tryParse(text) ?? 0;
      // If current value is less than min, allow if it's a prefix of min
      if (currentValue < minValue) {
        final minStr = minValue.toString();
        // Allow if text could be a prefix of a valid number
        return minStr.startsWith(text) || text.length < minStr.length;
      }
    }
    return true;
  }
}

/// Integer-only formatter
class StrictIntegerFormatter extends StrictNumberFormatter {
  StrictIntegerFormatter({
    super.allowNegative,
    int? super.minValue,
    int? super.maxValue,
  }) : super(
    allowDecimals: false,
  );
}

/// Positive number formatter
class PositiveNumberFormatter extends StrictNumberFormatter {
  PositiveNumberFormatter({
    super.allowDecimals,
    super.maxDecimalPlaces,
    super.maxValue,
  }) : super(
    allowNegative: false,
    minValue: 0,
  );
}

/// Currency formatter
class CurrencyFormatter extends StrictNumberFormatter {
  CurrencyFormatter({
    super.maxValue,
  }) : super(
    allowDecimals: true,
    allowNegative: false,
    maxDecimalPlaces: 2,
    minValue: 0,
  );
}

/// Percentage formatter (0-100)
class PercentageFormatter extends StrictNumberFormatter {
  PercentageFormatter({
    super.allowDecimals,
  }) : super(
    allowNegative: false,
    maxDecimalPlaces: allowDecimals ? 2 : null,
    minValue: 0,
    maxValue: 100,
  );
}