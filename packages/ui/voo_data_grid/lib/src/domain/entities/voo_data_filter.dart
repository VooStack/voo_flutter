import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

/// Data filter for a column
class VooDataFilter {
  /// The filter operator to apply
  final VooFilterOperator operator;

  /// The primary filter value
  final dynamic value;

  /// Optional second value for range filters (e.g., between operator)
  final dynamic valueTo;

  /// For OData collection navigation properties, specify the property to filter on
  /// Example: 'id' will generate roles/any(r: r/id in (...)) for a 'roles' field
  /// Leave null for non-collection properties
  final String? odataCollectionProperty;

  const VooDataFilter({required this.operator, required this.value, this.valueTo, this.odataCollectionProperty});
}
