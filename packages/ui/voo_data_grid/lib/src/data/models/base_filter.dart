import 'package:voo_data_grid/src/data/models/secondary_filter.dart';

/// Base class for all filter types
abstract class BaseFilter {
  final String fieldName;
  final dynamic value;
  final String operator;
  final SecondaryFilter? secondaryFilter;

  const BaseFilter({
    required this.fieldName,
    required this.value,
    required this.operator,
    this.secondaryFilter,
  });

  Map<String, dynamic> toJson() => {
        'fieldName': fieldName,
        'value': value,
        'operator': operator,
        if (secondaryFilter != null)
          'secondaryFilter': secondaryFilter!.toJson(),
      };
}