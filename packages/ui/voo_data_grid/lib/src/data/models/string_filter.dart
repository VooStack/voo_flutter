import 'package:voo_data_grid/src/data/models/base_filter.dart';
import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// String filter implementation
class StringFilter extends BaseFilter {
  const StringFilter({
    required super.fieldName,
    required String super.value,
    required super.operator,
    super.secondaryFilter,
  });

  factory StringFilter.fromJson(Map<String, dynamic> json) => StringFilter(
      fieldName: json['fieldName'] as String,
      value: json['value'] as String,
      operator: json['operator'] as String,
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'] as Map<String, dynamic>)
          : null,
    );
}