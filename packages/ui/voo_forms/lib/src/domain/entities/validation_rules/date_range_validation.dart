import 'package:voo_forms/src/domain/entities/validation_rules/voo_validation_rule.dart';

/// Validation rule for date range
class DateRangeValidation extends VooValidationRule<DateTime> {
  final DateTime? minDate;
  final DateTime? maxDate;

  const DateRangeValidation({
    this.minDate,
    this.maxDate,
    String? errorMessage,
  }) : super(errorMessage: errorMessage ?? 'Date is out of range');

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (minDate != null && value.isBefore(minDate!)) {
      return errorMessage;
    }
    if (maxDate != null && value.isAfter(maxDate!)) {
      return errorMessage;
    }
    return null;
  }

  @override
  List<Object?> get props => [errorMessage, minDate, maxDate];
}