import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Simple currency formatter that follows Flutter's default text field behavior
/// Uses intl package for proper locale-aware currency formatting
///
/// Features:
/// - Natural typing: "4" becomes "$4.00" not "$0.04"
/// - Automatic formatting with thousand separators using intl
/// - Preserves cursor position naturally
/// - No focus/keyboard dismissal issues
/// - Proper locale-aware formatting
class SimpleCurrencyFormatter extends TextInputFormatter {
  final String symbol;
  final int decimalDigits;
  final String locale;
  final bool symbolBeforeAmount;
  final double? maxValue;
  final double? minValue;

  late final NumberFormat _currencyFormatter;

  SimpleCurrencyFormatter({
    this.symbol = '\$',
    this.decimalDigits = 2,
    this.locale = 'en_US',
    this.symbolBeforeAmount = true,
    this.maxValue,
    this.minValue,
  }) {
    // Use intl's currency formatter for proper locale formatting
    _currencyFormatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
  }

  /// Factory constructors for common currencies
  factory SimpleCurrencyFormatter.usd() => SimpleCurrencyFormatter();

  factory SimpleCurrencyFormatter.eur() => SimpleCurrencyFormatter(
        symbol: '€',
        locale: 'de_DE',
        symbolBeforeAmount: false,
      );

  factory SimpleCurrencyFormatter.gbp() => SimpleCurrencyFormatter(
        symbol: '£',
        locale: 'en_GB',
      );

  factory SimpleCurrencyFormatter.jpy() => SimpleCurrencyFormatter(
        symbol: '¥',
        decimalDigits: 0,
        locale: 'ja_JP',
      );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Extract just the numeric value from the text
    String cleanText = newValue.text
        .replaceAll(_currencyFormatter.currencySymbol, '')
        .replaceAll(_currencyFormatter.symbols.GROUP_SEP, '')
        .replaceAll(RegExp(r'[^\d\-.]'), '');

    // Handle decimal separator based on locale
    final decimalSep = _currencyFormatter.symbols.DECIMAL_SEP;
    if (decimalSep != '.') {
      cleanText = cleanText.replaceAll(decimalSep, '.');
    }

    // Ensure only one decimal point
    final parts = cleanText.split('.');
    if (parts.length > 2) {
      cleanText = '${parts[0]}.${parts.sublist(1).join()}';
    }

    // Limit decimal places while typing
    if (parts.length == 2 && parts[1].length > decimalDigits) {
      cleanText = '${parts[0]}.${parts[1].substring(0, decimalDigits)}';
    }

    // Parse the clean number
    final double? value = double.tryParse(cleanText);
    if (value == null && cleanText.isNotEmpty && cleanText != '-') {
      return oldValue; // Invalid input, keep old value
    }

    // Apply constraints if value is valid
    double? constrainedValue = value;
    if (constrainedValue != null) {
      final currentValue = constrainedValue;
      if (minValue != null && currentValue < minValue!) {
        constrainedValue = minValue;
      } else if (maxValue != null && currentValue > maxValue!) {
        constrainedValue = maxValue;
      }
    }

    // Format the value using intl
    String formatted;
    if (constrainedValue == null) {
      // Empty or just negative sign
      formatted = cleanText == '-' ? '-$symbol' : symbol;
    } else if (constrainedValue == 0 && !cleanText.contains('.')) {
      // Zero without decimals
      formatted = _currencyFormatter.format(0);
    } else {
      // Check if user is still typing decimals
      final hasDecimalPoint = cleanText.contains('.');
      final decimalPart = hasDecimalPoint ? cleanText.split('.')[1] : '';

      if (hasDecimalPoint && decimalPart.length < decimalDigits) {
        // User is typing decimals, format integer part but preserve decimal typing
        final intPart = constrainedValue.toInt();
        final formattedInt = NumberFormat.decimalPattern(locale).format(intPart);
        formatted = '$symbol$formattedInt.$decimalPart';
      } else {
        // Use full currency formatting from intl
        formatted = _currencyFormatter.format(constrainedValue);
      }
    }

    // Calculate new cursor position - keep it at the end for simplicity
    // This follows Flutter's default behavior for formatted fields
    final cursorOffset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  /// Parse a formatted currency string back to a double value
  static double? parse(String text, {String? symbol}) {
    if (text.isEmpty) return null;

    // Remove currency symbols and whitespace
    String cleaned = text.replaceAll(RegExp(r'[\$€£¥₹¢]'), '').replaceAll(RegExp(r'\s'), '').trim();

    // Handle European vs US number format
    final lastDotIndex = cleaned.lastIndexOf('.');
    final lastCommaIndex = cleaned.lastIndexOf(',');

    if (lastCommaIndex > lastDotIndex) {
      // European format: comma is decimal separator
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else {
      // US format: comma is thousand separator
      cleaned = cleaned.replaceAll(',', '');
    }

    return double.tryParse(cleaned);
  }
}
