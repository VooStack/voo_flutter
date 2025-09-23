import 'package:voo_data_grid/voo_data_grid.dart';

/// Filter field configuration
class FilterFieldConfig {
  final String fieldName;
  final String displayName;
  final FilterType type;
  final List<String>? options; // For dropdown fields
  final String? defaultOperator;

  const FilterFieldConfig({required this.fieldName, required this.displayName, required this.type, this.options, this.defaultOperator});
}
