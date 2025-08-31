import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Text input formatter for currency fields with customizable formatting options
/// 
/// Automatically formats numeric input as currency with:
/// - Customizable currency symbol
/// - Configurable decimal places
/// - Thousand separators
/// - Decimal separators
class CurrencyFormatter extends TextInputFormatter {
  /// The currency symbol to display (e.g., '$', '€', '£')
  final String symbol;
  
  /// The number of decimal places to show
  final int decimalPlaces;
  
  /// The character used to separate thousands (e.g., ',')
  final String thousandSeparator;
  
  /// The character used as decimal separator (e.g., '.')
  final String decimalSeparator;

  /// Creates a currency formatter with the specified options
  CurrencyFormatter({
    required this.symbol,
    required this.decimalPlaces,
    required this.thousandSeparator,
    required this.decimalSeparator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      return TextEditingValue.empty;
    }

    // Convert to double and format
    final number = int.parse(text) / 100;
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    final formatted = formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}