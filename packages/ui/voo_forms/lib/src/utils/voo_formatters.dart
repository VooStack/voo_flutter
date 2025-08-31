import 'package:flutter/services.dart';
import 'package:voo_forms/src/utils/formatters/case_formatter.dart';
import 'package:voo_forms/src/utils/formatters/credit_card_formatter.dart';
import 'package:voo_forms/src/utils/formatters/currency_formatter.dart';
import 'package:voo_forms/src/utils/formatters/date_formatter.dart';
import 'package:voo_forms/src/utils/formatters/international_phone_formatter.dart';
import 'package:voo_forms/src/utils/formatters/mask_formatter.dart';
import 'package:voo_forms/src/utils/formatters/pattern_formatter.dart';
import 'package:voo_forms/src/utils/formatters/percentage_formatter.dart';
import 'package:voo_forms/src/utils/formatters/phone_number_formatter.dart';
import 'package:voo_forms/src/utils/formatters/ssn_formatter.dart';
import 'package:voo_forms/src/utils/formatters/zip_code_formatter.dart';

/// Collection of commonly used text input formatters
class VooFormatters {
  VooFormatters._();

  /// Phone number formatter (US format: (XXX) XXX-XXXX)
  static TextInputFormatter phoneUS() => PhoneNumberFormatter();

  /// Credit card number formatter (XXXX XXXX XXXX XXXX)
  static TextInputFormatter creditCard() => CreditCardFormatter();

  /// Date formatter (MM/DD/YYYY)
  static TextInputFormatter dateUS() => DateFormatter(separator: '/');

  /// Date formatter (DD/MM/YYYY)
  static TextInputFormatter dateEU() => DateFormatter(separator: '/', euFormat: true);

  /// Date formatter (YYYY-MM-DD)
  static TextInputFormatter dateISO() => DateFormatter(separator: '-', isoFormat: true);

  /// Currency formatter with customizable symbol and decimal places
  static TextInputFormatter currency({
    String symbol = '\$',
    int decimalPlaces = 2,
    String thousandSeparator = ',',
    String decimalSeparator = '.',
  }) => CurrencyFormatter(
    symbol: symbol,
    decimalPlaces: decimalPlaces,
    thousandSeparator: thousandSeparator,
    decimalSeparator: decimalSeparator,
  );

  /// Uppercase formatter
  static TextInputFormatter uppercase() => CaseFormatter(toUpperCase: true);

  /// Lowercase formatter
  static TextInputFormatter lowercase() => CaseFormatter(toUpperCase: false);

  /// Alphanumeric only formatter
  static TextInputFormatter alphanumeric({bool allowSpaces = false}) =>
      FilteringTextInputFormatter.allow(
        RegExp(allowSpaces ? '[a-zA-Z0-9\\s]' : '[a-zA-Z0-9]'),
      );

  /// Letters only formatter
  static TextInputFormatter lettersOnly({bool allowSpaces = false}) =>
      FilteringTextInputFormatter.allow(
        RegExp(allowSpaces ? r'[a-zA-Z\s]' : '[a-zA-Z]'),
      );

  /// Numbers only formatter
  static TextInputFormatter numbersOnly() =>
      FilteringTextInputFormatter.digitsOnly;

  /// Decimal number formatter
  static TextInputFormatter decimal({int decimalPlaces = 2}) =>
      FilteringTextInputFormatter.allow(
        RegExp('^\\d*\\.?\\d{0,$decimalPlaces}'),
      );

  /// SSN formatter (XXX-XX-XXXX)
  static TextInputFormatter ssn() => SSNFormatter();

  /// ZIP code formatter (XXXXX or XXXXX-XXXX)
  static TextInputFormatter zipCode() => ZipCodeFormatter();
  
  /// US postal code formatter (XXXXX or XXXXX-XXXX) - alias for zipCode
  static TextInputFormatter postalCodeUS() => ZipCodeFormatter();
  
  /// International phone formatter
  static TextInputFormatter phoneInternational() => InternationalPhoneFormatter();

  /// Percentage formatter (0-100)
  static TextInputFormatter percentage() => PercentageFormatter();

  /// Custom pattern formatter
  static TextInputFormatter pattern({
    required String pattern,
    required Map<String, RegExp> patternMapping,
  }) => PatternFormatter(pattern: pattern, patternMapping: patternMapping);

  /// Mask formatter (e.g., "###-##-####" for SSN)
  static TextInputFormatter mask(String mask, {String placeholder = '#'}) =>
      MaskFormatter(mask: mask, placeholder: placeholder);
}