import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for maximum string length
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

  @override
  List<Object?> get props => [errorMessage, maxLength];
}