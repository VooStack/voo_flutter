import 'package:flutter/material.dart';

/// Represents a column in the VooDataGrid
class VooDataColumn {
  /// The unique identifier for this column
  final String field;

  /// The display label for the column header
  final String label;

  /// Width of the column (null for flexible width)
  final double? width;

  /// Minimum width for the column
  final double minWidth;

  /// Maximum width for the column  
  final double? maxWidth;

  /// Whether this column is sortable
  final bool sortable;

  /// Whether this column is filterable
  final bool filterable;

  /// Text alignment for this column
  final TextAlign textAlign;

  /// Custom header widget builder
  final Widget Function(BuildContext context, VooDataColumn column)? headerBuilder;

  /// Custom cell widget builder
  final Widget Function(BuildContext context, dynamic value, dynamic row)? cellBuilder;

  /// Value getter from row data
  final dynamic Function(dynamic row)? valueGetter;

  /// Value formatter for display
  final String Function(dynamic value)? valueFormatter;

  /// Whether the column is visible
  final bool visible;

  /// Whether the column is fixed/frozen
  final bool frozen;

  /// Column data type for filtering
  final VooDataColumnType dataType;

  /// Custom filter options for this column
  final List<VooFilterOption>? filterOptions;

  /// Flex value for flexible columns
  final int flex;

  const VooDataColumn({
    required this.field,
    required this.label,
    this.width,
    this.minWidth = 50.0,
    this.maxWidth,
    this.sortable = true,
    this.filterable = true,
    this.textAlign = TextAlign.left,
    this.headerBuilder,
    this.cellBuilder,
    this.valueGetter,
    this.valueFormatter,
    this.visible = true,
    this.frozen = false,
    this.dataType = VooDataColumnType.text,
    this.filterOptions,
    this.flex = 1,
  });

  /// Creates a copy with optional overrides
  VooDataColumn copyWith({
    String? field,
    String? label,
    double? width,
    double? minWidth,
    double? maxWidth,
    bool? sortable,
    bool? filterable,
    TextAlign? textAlign,
    Widget Function(BuildContext context, VooDataColumn column)? headerBuilder,
    Widget Function(BuildContext context, dynamic value, dynamic row)? cellBuilder,
    dynamic Function(dynamic row)? valueGetter,
    String Function(dynamic value)? valueFormatter,
    bool? visible,
    bool? frozen,
    VooDataColumnType? dataType,
    List<VooFilterOption>? filterOptions,
    int? flex,
  }) {
    return VooDataColumn(
      field: field ?? this.field,
      label: label ?? this.label,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      sortable: sortable ?? this.sortable,
      filterable: filterable ?? this.filterable,
      textAlign: textAlign ?? this.textAlign,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      valueGetter: valueGetter ?? this.valueGetter,
      valueFormatter: valueFormatter ?? this.valueFormatter,
      visible: visible ?? this.visible,
      frozen: frozen ?? this.frozen,
      dataType: dataType ?? this.dataType,
      filterOptions: filterOptions ?? this.filterOptions,
      flex: flex ?? this.flex,
    );
  }
}

/// Column data types for filtering
enum VooDataColumnType {
  text,
  number,
  date,
  boolean,
  select,
  multiSelect,
  custom,
}

/// Filter option for select/multiselect columns
class VooFilterOption {
  final dynamic value;
  final String label;
  final IconData? icon;

  const VooFilterOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Sort direction for columns
enum VooSortDirection {
  ascending,
  descending,
  none,
}

/// Column sort state
class VooColumnSort {
  final String field;
  final VooSortDirection direction;

  const VooColumnSort({
    required this.field,
    required this.direction,
  });
}