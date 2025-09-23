import 'package:voo_data_grid/src/data/models/base_filter.dart';
import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// Decimal filter implementation
class DecimalFilter extends BaseFilter {
  const DecimalFilter({required super.fieldName, required double super.value, required super.operator, super.secondaryFilter});

  factory DecimalFilter.fromJson(Map<String, dynamic> json) => DecimalFilter(
    fieldName: json['fieldName'] as String,
    value: json['value'] is double ? json['value'] as double : double.parse(json['value'].toString()),
    operator: json['operator'] as String,
    secondaryFilter: json['secondaryFilter'] != null ? SecondaryFilter.fromJson(json['secondaryFilter'] as Map<String, dynamic>) : null,
  );
}
