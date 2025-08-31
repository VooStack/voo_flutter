import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for required fields
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