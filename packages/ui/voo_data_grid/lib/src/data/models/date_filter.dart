import 'package:voo_data_grid/src/data/models/base_filter.dart';
import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// Date filter implementation
class DateFilter extends BaseFilter {
  DateFilter({required super.fieldName, required DateTime value, required super.operator, super.secondaryFilter}) : super(value: value.toIso8601String());

  factory DateFilter.fromJson(Map<String, dynamic> json) => DateFilter(
    fieldName: json['fieldName'] as String,
    value: DateTime.parse(json['value'] as String),
    operator: json['operator'] as String,
    secondaryFilter: json['secondaryFilter'] != null ? SecondaryFilter.fromJson(json['secondaryFilter'] as Map<String, dynamic>) : null,
  );

  DateTime get dateValue => DateTime.parse(value as String);
}
