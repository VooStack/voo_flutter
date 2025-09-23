import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';

/// Represents a primary filter option
class PrimaryFilter {
  /// Field name for the filter
  final String field;

  /// Display label for the filter
  final String label;

  /// The filter to apply when selected
  final VooDataFilter filter;

  /// Optional icon to display
  final IconData? icon;

  /// Optional count/badge value
  final int? count;

  const PrimaryFilter({required this.field, required this.label, required this.filter, this.icon, this.count});

  /// Legacy constructor for backward compatibility
  @Deprecated('Use the main constructor with VooDataFilter instead')
  factory PrimaryFilter.legacy({required String id, required String label, required dynamic value, IconData? icon, int? count}) => PrimaryFilter(
    field: id,
    label: label,
    filter: VooDataFilter(operator: VooFilterOperator.equals, value: value),
    icon: icon,
    count: count,
  );
}
