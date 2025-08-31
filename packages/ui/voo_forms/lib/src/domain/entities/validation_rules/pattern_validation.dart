import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for custom pattern matching
class PatternValidation extends VooValidationRule<String> {
  final RegExp pattern;
  
  PatternValidation({
    required String pattern,
    required super.errorMessage,
  }) : pattern = RegExp(pattern);

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!pattern.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, pattern.pattern];
}