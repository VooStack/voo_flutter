import 'package:equatable/equatable.dart';

abstract class VooValidationRule<T> extends Equatable {
  final String errorMessage;
  
  const VooValidationRule({required this.errorMessage});
  
  String? validate(T? value);
  
  @override
  List<Object?> get props => [errorMessage];
}

class RequiredValidation<T> extends VooValidationRule<T> {
  const RequiredValidation({
    super.errorMessage = 'This field is required',
  });

  @override
  String? validate(T? value) {
    if (value == null) return errorMessage;
    if (value is String && value.isEmpty) return errorMessage;
    if (value is List && value.isEmpty) return errorMessage;
    if (value is Map && value.isEmpty) return errorMessage;
    return null;
  }
}

class MinLengthValidation extends VooValidationRule<String> {
  final int minLength;

  const MinLengthValidation({
    required this.minLength,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Minimum $minLength characters required');

  @override
  String? validate(String? value) {
    if (value == null || value.length < minLength) {
      return errorMessage;
    }
    return null;
  }
}

class MaxLengthValidation extends VooValidationRule<String> {
  final int maxLength;

  const MaxLengthValidation({
    required this.maxLength,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Maximum $maxLength characters allowed');

  @override
  String? validate(String? value) {
    if (value != null && value.length > maxLength) {
      return errorMessage;
    }
    return null;
  }
}

class EmailValidation extends VooValidationRule<String> {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  const EmailValidation({
    super.errorMessage = 'Please enter a valid email',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_emailRegExp.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class PhoneValidation extends VooValidationRule<String> {
  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{10,15}$',
  );

  const PhoneValidation({
    super.errorMessage = 'Please enter a valid phone number',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!_phoneRegExp.hasMatch(cleaned)) {
      return errorMessage;
    }
    return null;
  }
}

class UrlValidation extends VooValidationRule<String> {
  static final RegExp _urlRegExp = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$',
  );

  const UrlValidation({
    super.errorMessage = 'Please enter a valid URL',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_urlRegExp.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class PatternValidation extends VooValidationRule<String> {
  final RegExp pattern;
  
  PatternValidation({
    required String pattern,
    required super.errorMessage,
  }) : pattern = RegExp(pattern);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!pattern.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class MinValueValidation<T extends num> extends VooValidationRule<T> {
  final T minValue;

  const MinValueValidation({
    required this.minValue,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Value must be at least $minValue');

  @override
  String? validate(T? value) {
    if (value != null && value < minValue) {
      return errorMessage;
    }
    return null;
  }
}

class MaxValueValidation<T extends num> extends VooValidationRule<T> {
  final T maxValue;

  const MaxValueValidation({
    required this.maxValue,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Value must be at most $maxValue');

  @override
  String? validate(T? value) {
    if (value != null && value > maxValue) {
      return errorMessage;
    }
    return null;
  }
}

class RangeValidation<T extends num> extends VooValidationRule<T> {
  final T minValue;
  final T maxValue;

  const RangeValidation({
    required this.minValue,
    required this.maxValue,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Value must be between $minValue and $maxValue');

  @override
  String? validate(T? value) {
    if (value != null && (value < minValue || value > maxValue)) {
      return errorMessage;
    }
    return null;
  }
}

class DateRangeValidation extends VooValidationRule<DateTime> {
  final DateTime? minDate;
  final DateTime? maxDate;

  const DateRangeValidation({
    this.minDate,
    this.maxDate,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Date is out of range');

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (minDate != null && value.isBefore(minDate!)) {
      return errorMessage;
    }
    if (maxDate != null && value.isAfter(maxDate!)) {
      return errorMessage;
    }
    return null;
  }
}

class CustomValidation<T> extends VooValidationRule<T> {
  final String? Function(T?) validator;

  const CustomValidation({
    required this.validator,
    super.errorMessage = 'Invalid value',
  });

  @override
  String? validate(T? value) => validator(value);
}

class CompoundValidation<T> extends VooValidationRule<T> {
  final List<VooValidationRule<T>> rules;

  const CompoundValidation({
    required this.rules,
    super.errorMessage = 'Validation failed',
  });

  @override
  String? validate(T? value) {
    for (final rule in rules) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}