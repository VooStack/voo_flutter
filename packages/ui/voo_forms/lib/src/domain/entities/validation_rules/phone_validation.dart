import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for phone number format
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