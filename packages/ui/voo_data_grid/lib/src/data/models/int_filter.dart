import 'package:voo_data_grid/src/data/models/base_filter.dart';
import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// Integer filter implementation
class IntFilter extends BaseFilter {
  const IntFilter({
    required super.fieldName,
    required int super.value,
    required super.operator,
    super.secondaryFilter,
  });

  factory IntFilter.fromJson(Map<String, dynamic> json) => IntFilter(
      fieldName: json['fieldName'] as String,
      value: json['value'] is int
          ? json['value'] as int
          : int.parse(json['value'].toString()),
      operator: json['operator'] as String,
      secondaryFilter: json['secondaryFilter'] != null
          ? SecondaryFilter.fromJson(json['secondaryFilter'] as Map<String, dynamic>)
          : null,
    );
}