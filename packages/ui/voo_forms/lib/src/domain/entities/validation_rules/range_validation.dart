import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for numeric value range
class RangeValidation<T extends num> extends VooValidationRule<T> {
  final T minValue;
  final T maxValue;

  const RangeValidation({required this.minValue, required this.maxValue, String? errorMessage})
    : super(errorMessage: errorMessage ?? 'Value must be between $minValue and $maxValue');

  @override
  String? validate(T? value) {
    if (value != null && (value < minValue || value > maxValue)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, minValue, maxValue];
}
