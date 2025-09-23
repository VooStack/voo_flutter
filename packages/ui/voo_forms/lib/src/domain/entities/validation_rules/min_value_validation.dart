import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for minimum numeric value
class MinValueValidation<T extends num> extends VooValidationRule<T> {
  final T minValue;

  const MinValueValidation({required this.minValue, String? errorMessage}) : super(errorMessage: errorMessage ?? 'Value must be at least $minValue');

  @override
  String? validate(T? value) {
    if (value != null && value < minValue) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, minValue];
}
