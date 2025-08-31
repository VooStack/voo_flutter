import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for URL format
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