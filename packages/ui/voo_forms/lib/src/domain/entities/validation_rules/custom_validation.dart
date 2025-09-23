import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for custom validation logic
class CustomValidation<T> extends VooValidationRule<T> {
  final String? Function(T?) validator;

  const CustomValidation({required this.validator, super.errorMessage = 'Invalid value'});

  @override
  String? validate(T? value) => validator(value);

  @override
  List<Object?> get props => [errorMessage, validator];
}
