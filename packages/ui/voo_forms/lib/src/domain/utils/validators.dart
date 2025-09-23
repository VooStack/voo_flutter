import 'package:voo_forms/src/domain/entities/validation_rule.dart';

/// Simple validation API with commonly used validators
class VooValidator {
  VooValidator._();

  /// Required field validator
  static VooValidationRule<T> required<T>([String? message]) => RequiredValidation<T>(errorMessage: message ?? 'This field is required');

  /// Email validator
  static VooValidationRule<String> email([String? message]) => EmailValidation(errorMessage: message ?? 'Please enter a valid email address');

  /// Phone number validator
  static VooValidationRule<String> phone([String? message]) => PhoneValidation(errorMessage: message ?? 'Please enter a valid phone number');

  /// URL validator
  static VooValidationRule<String> url([String? message]) => UrlValidation(errorMessage: message ?? 'Please enter a valid URL');

  /// Minimum length validator
  static VooValidationRule<String> minLength(int length, [String? message]) =>
      MinLengthValidation(minLength: length, errorMessage: message ?? 'Minimum $length characters required');

  /// Maximum length validator
  static VooValidationRule<String> maxLength(int length, [String? message]) =>
      MaxLengthValidation(maxLength: length, errorMessage: message ?? 'Maximum $length characters allowed');

  /// Length range validator
  static VooValidationRule<String> lengthRange(int min, int max, [String? message]) =>
      CompoundValidation<String>(rules: [minLength(min), maxLength(max)], errorMessage: message ?? 'Must be between $min and $max characters');

  /// Minimum value validator
  static VooValidationRule<T> min<T extends num>(T value, [String? message]) =>
      MinValueValidation<T>(minValue: value, errorMessage: message ?? 'Must be at least $value');

  /// Maximum value validator
  static VooValidationRule<T> max<T extends num>(T value, [String? message]) =>
      MaxValueValidation<T>(maxValue: value, errorMessage: message ?? 'Must be at most $value');

  /// Range validator
  static VooValidationRule<T> range<T extends num>(T min, T max, [String? message]) =>
      RangeValidation<T>(minValue: min, maxValue: max, errorMessage: message ?? 'Must be between $min and $max');

  /// Pattern validator
  static VooValidationRule<String> pattern(String pattern, String message) => PatternValidation(pattern: pattern, errorMessage: message);

  /// Matches validator - ensures field matches another value
  static VooValidationRule<T> matches<T>(T value, String message) => CustomValidation<T>(validator: (v) => v == value ? null : message, errorMessage: message);

  /// Password strength validator
  static VooValidationRule<String> password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
    String? message,
  }) => CustomValidation<String>(
    validator: (value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < minLength) {
        return message ?? 'Password must be at least $minLength characters';
      }

      if (requireUppercase && !value.contains(RegExp('[A-Z]'))) {
        return message ?? 'Password must contain uppercase letters';
      }

      if (requireLowercase && !value.contains(RegExp('[a-z]'))) {
        return message ?? 'Password must contain lowercase letters';
      }

      if (requireNumbers && !value.contains(RegExp('[0-9]'))) {
        return message ?? 'Password must contain numbers';
      }

      if (requireSpecialChars && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return message ?? 'Password must contain special characters';
      }

      return null;
    },
    errorMessage: message ?? 'Password does not meet requirements',
  );

  /// Credit card validator
  static VooValidationRule<String> creditCard([String? message]) => CustomValidation<String>(
    validator: (value) {
      if (value == null || value.isEmpty) return null;

      // Remove spaces and dashes
      final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

      // Check if all characters are digits
      if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
        return message ?? 'Invalid credit card number';
      }

      // Check length
      if (cardNumber.length < 13 || cardNumber.length > 19) {
        return message ?? 'Invalid credit card number';
      }

      // Luhn algorithm
      int sum = 0;
      bool alternate = false;
      for (int i = cardNumber.length - 1; i >= 0; i--) {
        int digit = int.parse(cardNumber[i]);
        if (alternate) {
          digit *= 2;
          if (digit > 9) {
            digit = (digit % 10) + 1;
          }
        }
        sum += digit;
        alternate = !alternate;
      }

      if (sum % 10 != 0) {
        return message ?? 'Invalid credit card number';
      }

      return null;
    },
    errorMessage: message ?? 'Invalid credit card number',
  );

  /// Date range validator
  static VooValidationRule<DateTime> dateRange({DateTime? after, DateTime? before, String? message}) =>
      DateRangeValidation(minDate: after, maxDate: before, errorMessage: message ?? 'Date is out of range');

  /// Age validator
  static VooValidationRule<DateTime> age({int minAge = 0, int maxAge = 150, String? message}) => CustomValidation<DateTime>(
    validator: (value) {
      if (value == null) return null;

      final now = DateTime.now();
      int age = now.year - value.year;
      if (now.month < value.month || (now.month == value.month && now.day < value.day)) {
        age--;
      }

      if (age < minAge) {
        return message ?? 'Must be at least $minAge years old';
      }

      if (age > maxAge) {
        return message ?? 'Must be at most $maxAge years old';
      }

      return null;
    },
    errorMessage: message ?? 'Invalid age',
  );

  /// SSN validator (US)
  static VooValidationRule<String> ssn([String? message]) => CustomValidation<String>(
    validator: (value) {
      if (value == null || value.isEmpty) return null;

      // Remove dashes
      final ssn = value.replaceAll('-', '');

      // Check format
      if (!RegExp(r'^\d{9}$').hasMatch(ssn)) {
        return message ?? 'Invalid SSN format';
      }

      // Check for invalid SSNs
      if (ssn.substring(0, 3) == '000' || ssn.substring(3, 5) == '00' || ssn.substring(5, 9) == '0000') {
        return message ?? 'Invalid SSN';
      }

      return null;
    },
    errorMessage: message ?? 'Invalid SSN',
  );

  /// ZIP code validator (US)
  static VooValidationRule<String> zipCode([String? message]) => PatternValidation(pattern: r'^\d{5}(-\d{4})?$', errorMessage: message ?? 'Invalid ZIP code');

  /// Postal code validator (US) - alias for zipCode
  static VooValidationRule<String> postalCode([String? message]) => zipCode(message);

  /// Alpha-only validator
  static VooValidationRule<String> alpha({bool allowSpaces = false, String? message}) {
    final pattern = allowSpaces ? r'^[a-zA-Z\s]+$' : r'^[a-zA-Z]+$';
    return PatternValidation(pattern: pattern, errorMessage: message ?? 'Only letters are allowed');
  }

  /// Alphanumeric validator
  static VooValidationRule<String> alphanumeric({bool allowSpaces = false, String? message}) {
    final pattern = allowSpaces ? r'^[a-zA-Z0-9\s]+$' : r'^[a-zA-Z0-9]+$';
    return PatternValidation(pattern: pattern, errorMessage: message ?? 'Only letters and numbers are allowed');
  }

  /// Numeric validator
  static VooValidationRule<String> numeric([String? message]) => PatternValidation(pattern: r'^\d+$', errorMessage: message ?? 'Only numbers are allowed');

  /// Decimal validator
  static VooValidationRule<String> decimal({int? decimalPlaces, String? message}) {
    final pattern = decimalPlaces != null ? '^\\d+\\.?\\d{0,$decimalPlaces}\$' : r'^\d+\.?\d*$';
    return PatternValidation(pattern: pattern, errorMessage: message ?? 'Invalid decimal number');
  }

  /// Custom validator
  static VooValidationRule<T> custom<T>({required String? Function(T?) validator, String errorMessage = 'Validation failed'}) =>
      CustomValidation<T>(validator: validator, errorMessage: errorMessage);

  /// Combine multiple validators
  static VooValidationRule<T> all<T>(List<VooValidationRule<T>> validators) => CompoundValidation<T>(rules: validators);

  /// At least one validator must pass
  static VooValidationRule<T> any<T>(List<VooValidationRule<T>> validators, {String? message}) => CustomValidation<T>(
    validator: (value) {
      for (final validator in validators) {
        if (validator.validate(value) == null) {
          return null;
        }
      }
      return message ?? 'Validation failed';
    },
    errorMessage: message ?? 'Validation failed',
  );
}
