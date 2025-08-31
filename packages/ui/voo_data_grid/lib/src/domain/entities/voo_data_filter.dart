import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

/// Data filter for a column
class VooDataFilter {
  /// The filter operator to apply
  final VooFilterOperator operator;
  
  /// The primary filter value
  final dynamic value;
  
  /// Optional second value for range filters (e.g., between operator)
  final dynamic valueTo;

  const VooDataFilter({
    required this.operator,
    required this.value,
    this.valueTo,
  });
}