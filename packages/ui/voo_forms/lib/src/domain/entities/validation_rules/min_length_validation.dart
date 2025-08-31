import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for minimum string length
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