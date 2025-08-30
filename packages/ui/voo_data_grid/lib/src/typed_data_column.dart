import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/data_grid_column.dart';

/// A typed version of VooDataColumn that provides type safety for column values
/// 
/// Generic type parameter T represents the row data type.
/// Generic type parameter V represents the column value type.
/// 
/// Example usage:
/// ```dart
/// TypedVooDataColumn<User, String>(
///   field: 'name',
///   label: 'Name',
///   valueGetter: (user) => user.name,
///   valueFormatter: (name) => name.toUpperCase(), // name is typed as String
/// )
/// ```
class TypedVooDataColumn<T, V> extends VooDataColumn<T> {
  /// Type-safe value getter from row data
  final V Function(T row)? typedValueGetter;

  /// Type-safe value formatter for display
  final String Function(V value)? typedValueFormatter;

  /// Type-safe cell builder
  final Widget Function(BuildContext context, V value, T row)? typedCellBuilder;

  /// Type-safe callback when a cell is tapped
  final void Function(BuildContext context, T row, V value)? typedOnCellTap;

  TypedVooDataColumn({
    required super.field,
    required super.label,
    super.width,
    super.minWidth,
    super.maxWidth,
    super.sortable,
    super.filterable,
    super.textAlign,
    super.headerBuilder,
    this.typedValueGetter,
    this.typedValueFormatter,
    this.typedCellBuilder,
    this.typedOnCellTap,
    super.visible,
    super.frozen,
    super.dataType,
    super.filterWidgetType,
    super.filterBuilder,
    super.filterOptions,
    super.filterHint,
    super.defaultFilterOperator,
    super.allowedFilterOperators,
    super.flex,
    super.showFilterOperator,
    super.excludeFromApi,
  }) : super(
          // Convert typed functions to dynamic versions
          valueGetter: typedValueGetter,
          valueFormatter: typedValueFormatter != null
              ? (dynamic value) {
                  if (value is V) {
                    return typedValueFormatter(value);
                  }
                  // Fallback for unexpected types
                  return value?.toString() ?? '';
                }
              : null,
          cellBuilder: typedCellBuilder != null
              ? (context, dynamic value, row) {
                  if (value is V) {
                    return typedCellBuilder(context, value, row);
                  }
                  // Fallback widget for unexpected types
                  return Text(value?.toString() ?? '');
                }
              : null,
          onCellTap: typedOnCellTap != null
              ? (context, row, dynamic value) {
                  if (value is V) {
                    typedOnCellTap(context, row, value);
                  }
                }
              : null,
        );

  /// Creates a typed copy with optional overrides
  @override
  TypedVooDataColumn<T, V> copyWith({
    String? field,
    String? label,
    double? width,
    double? minWidth,
    double? maxWidth,
    bool? sortable,
    bool? filterable,
    TextAlign? textAlign,
    Widget Function(BuildContext context, VooDataColumn<T> column)? headerBuilder,
    Widget Function(BuildContext context, dynamic value, T row)? cellBuilder,
    dynamic Function(T row)? valueGetter,
    String Function(dynamic value)? valueFormatter,
    bool? visible,
    bool? frozen,
    VooDataColumnType? dataType,
    VooFilterWidgetType? filterWidgetType,
    Widget Function(
      BuildContext context,
      VooDataColumn<T> column,
      dynamic currentValue,
      void Function(dynamic value) onChanged,
    )? filterBuilder,
    List<VooFilterOption>? filterOptions,
    String? filterHint,
    VooFilterOperator? defaultFilterOperator,
    List<VooFilterOperator>? allowedFilterOperators,
    int? flex,
    bool? showFilterOperator,
    bool? excludeFromApi,
    void Function(BuildContext context, T row, dynamic value)? onCellTap,
    // Typed versions
    V Function(T row)? typedValueGetter,
    String Function(V value)? typedValueFormatter,
    Widget Function(BuildContext context, V value, T row)? typedCellBuilder,
    void Function(BuildContext context, T row, V value)? typedOnCellTap,
  }) {
    return TypedVooDataColumn<T, V>(
      field: field ?? this.field,
      label: label ?? this.label,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      sortable: sortable ?? this.sortable,
      filterable: filterable ?? this.filterable,
      textAlign: textAlign ?? this.textAlign,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      typedValueGetter: typedValueGetter ?? this.typedValueGetter,
      typedValueFormatter: typedValueFormatter ?? this.typedValueFormatter,
      typedCellBuilder: typedCellBuilder ?? this.typedCellBuilder,
      typedOnCellTap: typedOnCellTap ?? this.typedOnCellTap,
      visible: visible ?? this.visible,
      frozen: frozen ?? this.frozen,
      dataType: dataType ?? this.dataType,
      filterWidgetType: filterWidgetType ?? this.filterWidgetType,
      filterBuilder: filterBuilder ?? this.filterBuilder,
      filterOptions: filterOptions ?? this.filterOptions,
      filterHint: filterHint ?? this.filterHint,
      defaultFilterOperator: defaultFilterOperator ?? this.defaultFilterOperator,
      allowedFilterOperators: allowedFilterOperators ?? this.allowedFilterOperators,
      flex: flex ?? this.flex,
      showFilterOperator: showFilterOperator ?? this.showFilterOperator,
      excludeFromApi: excludeFromApi ?? this.excludeFromApi,
    );
  }
}