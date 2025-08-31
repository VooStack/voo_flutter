import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for email format
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