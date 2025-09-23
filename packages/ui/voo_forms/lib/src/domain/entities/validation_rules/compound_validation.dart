import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for combining multiple validation rules
class CompoundValidation<T> extends VooValidationRule<T> {
  final List<VooValidationRule<T>> rules;

  const CompoundValidation({required this.rules, super.errorMessage = 'Validation failed'});

  @override
  String? validate(T? value) {
    for (final rule in rules) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, rules];
}
