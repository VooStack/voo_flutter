import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Collection of commonly used text input formatters
class VooFormatters {
  VooFormatters._();

  /// Phone number formatter (US format: (XXX) XXX-XXXX)
  static TextInputFormatter phoneUS() => _PhoneNumberFormatter();

  /// Credit card number formatter (XXXX XXXX XXXX XXXX)
  static TextInputFormatter creditCard() => _CreditCardFormatter();

  /// Date formatter (MM/DD/YYYY)
  static TextInputFormatter dateUS() => _DateFormatter(separator: '/');

  /// Date formatter (DD/MM/YYYY)
  static TextInputFormatter dateEU() => _DateFormatter(separator: '/', euFormat: true);

  /// Date formatter (YYYY-MM-DD)
  static TextInputFormatter dateISO() => _DateFormatter(separator: '-', isoFormat: true);

  /// Currency formatter with customizable symbol and decimal places
  static TextInputFormatter currency({
    String symbol = '\$',
    int decimalPlaces = 2,
    String thousandSeparator = ',',
    String decimalSeparator = '.',
  }) => _CurrencyFormatter(
    symbol: symbol,
    decimalPlaces: decimalPlaces,
    thousandSeparator: thousandSeparator,
    decimalSeparator: decimalSeparator,
  );

  /// Uppercase formatter
  static TextInputFormatter uppercase() => _CaseFormatter(toUpperCase: true);

  /// Lowercase formatter
  static TextInputFormatter lowercase() => _CaseFormatter(toUpperCase: false);

  /// Alphanumeric only formatter
  static TextInputFormatter alphanumeric({bool allowSpaces = false}) =>
      FilteringTextInputFormatter.allow(
        RegExp(allowSpaces ? r'[a-zA-Z0-9\s]' : r'[a-zA-Z0-9]'),
      );

  /// Letters only formatter
  static TextInputFormatter lettersOnly({bool allowSpaces = false}) =>
      FilteringTextInputFormatter.allow(
        RegExp(allowSpaces ? r'[a-zA-Z\s]' : r'[a-zA-Z]'),
      );

  /// Numbers only formatter
  static TextInputFormatter numbersOnly() =>
      FilteringTextInputFormatter.digitsOnly;

  /// Decimal number formatter
  static TextInputFormatter decimal({int decimalPlaces = 2}) =>
      FilteringTextInputFormatter.allow(
        RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}'),
      );

  /// SSN formatter (XXX-XX-XXXX)
  static TextInputFormatter ssn() => _SSNFormatter();

  /// ZIP code formatter (XXXXX or XXXXX-XXXX)
  static TextInputFormatter zipCode() => _ZipCodeFormatter();
  
  /// US postal code formatter (XXXXX or XXXXX-XXXX) - alias for zipCode
  static TextInputFormatter postalCodeUS() => _ZipCodeFormatter();
  
  /// International phone formatter
  static TextInputFormatter phoneInternational() => _InternationalPhoneFormatter();

  /// Percentage formatter (0-100)
  static TextInputFormatter percentage() => _PercentageFormatter();

  /// Custom pattern formatter
  static TextInputFormatter pattern({
    required String pattern,
    required Map<String, RegExp> patternMapping,
  }) => _PatternFormatter(pattern: pattern, patternMapping: patternMapping);

  /// Mask formatter (e.g., "###-##-####" for SSN)
  static TextInputFormatter mask(String mask, {String placeholder = '#'}) =>
      _MaskFormatter(mask: mask, placeholder: placeholder);
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 10; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  final String separator;
  final bool euFormat;
  final bool isoFormat;

  _DateFormatter({
    required this.separator,
    this.euFormat = false,
    this.isoFormat = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    if (isoFormat) {
      // YYYY-MM-DD
      for (int i = 0; i < text.length && i < 8; i++) {
        if (i == 4 || i == 6) buffer.write(separator);
        buffer.write(text[i]);
      }
    } else {
      // MM/DD/YYYY or DD/MM/YYYY
      for (int i = 0; i < text.length && i < 8; i++) {
        if (i == 2 || i == 4) buffer.write(separator);
        buffer.write(text[i]);
      }
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _CurrencyFormatter extends TextInputFormatter {
  final String symbol;
  final int decimalPlaces;
  final String thousandSeparator;
  final String decimalSeparator;

  _CurrencyFormatter({
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
    var text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
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

class _CaseFormatter extends TextInputFormatter {
  final bool toUpperCase;

  _CaseFormatter({required this.toUpperCase});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = toUpperCase 
        ? newValue.text.toUpperCase() 
        : newValue.text.toLowerCase();
    
    return TextEditingValue(
      text: text,
      selection: newValue.selection,
    );
  }
}

class _SSNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 9; i++) {
      if (i == 3 || i == 5) buffer.write('-');
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ZipCodeFormatter extends TextInputFormatter {
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

class _PercentageFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    final value = int.tryParse(text) ?? 0;
    if (value > 100) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: '$value%',
      selection: TextSelection.collapsed(offset: '$value%'.length - 1),
    );
  }
}

class _PatternFormatter extends TextInputFormatter {
  final String pattern;
  final Map<String, RegExp> patternMapping;

  _PatternFormatter({
    required this.pattern,
    required this.patternMapping,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    int textIndex = 0;

    for (int i = 0; i < pattern.length && textIndex < text.length; i++) {
      final char = pattern[i];
      final regex = patternMapping[char];
      
      if (regex != null) {
        if (textIndex < text.length && regex.hasMatch(text[textIndex])) {
          buffer.write(text[textIndex]);
          textIndex++;
        } else {
          break;
        }
      } else {
        buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _MaskFormatter extends TextInputFormatter {
  final String mask;
  final String placeholder;

  _MaskFormatter({
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

// International phone formatter implementation
class _InternationalPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9+]'), '');
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
