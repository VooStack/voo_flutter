import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for maximum numeric value
class MaxValueValidation<T extends num> extends VooValidationRule<T> {
  final T maxValue;

  const MaxValueValidation({required this.maxValue, String? errorMessage}) : super(errorMessage: errorMessage ?? 'Value must be at most $maxValue');

  @override
  String? validate(T? value) {
    if (value != null && value > maxValue) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, maxValue];
}
