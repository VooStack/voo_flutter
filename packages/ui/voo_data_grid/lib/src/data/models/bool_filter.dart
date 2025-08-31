import 'package:voo_data_grid/src/data/models/base_filter.dart';
import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// Boolean filter implementation
class BoolFilter extends BaseFilter {
  const BoolFilter({
    required super.fieldName,
    required bool super.value,
    super.operator = 'Equals',
    super.secondaryFilter,
  });

  factory BoolFilter.fromJson(Map<String, dynamic> json) => BoolFilter(
      fieldName: json['fieldName'] as String,
      value: json['value'] is bool
          ? json['value'] as bool
          : json['value'].toString().toLowerCase() == 'true',
      operator: (json['operator'] as String?) ?? 'Equals',
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'] as Map<String, dynamic>)
          : null,
    );
}