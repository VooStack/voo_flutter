import 'package:flutter/material.dart';

/// Represents a column in the VooDataGrid
/// 
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class VooDataColumn<T> {
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
  final Widget Function(BuildContext context, VooDataColumn<T> column)? headerBuilder;

  /// Custom cell widget builder
  final Widget Function(BuildContext context, dynamic value, T row)? cellBuilder;

  /// Value getter from row data
  final dynamic Function(T row)? valueGetter;

  /// Value formatter for display
  final String Function(dynamic value)? valueFormatter;

  /// Whether the column is visible
  final bool visible;

  /// Whether the column is fixed/frozen
  final bool frozen;

  /// Column data type for filtering
  final VooDataColumnType dataType;

  /// Filter widget type (overrides default based on dataType)
  final VooFilterWidgetType? filterWidgetType;

  /// Custom filter widget builder
  final Widget Function(
    BuildContext context,
    VooDataColumn<T> column,
    dynamic currentValue,
    void Function(dynamic value) onChanged,
  )? filterBuilder;

  /// Custom filter options for select/multiselect columns
  final List<VooFilterOption>? filterOptions;

  /// Placeholder text for filter input
  final String? filterHint;

  /// Default filter operator for this column
  final VooFilterOperator? defaultFilterOperator;

  /// Allowed filter operators for this column
  final List<VooFilterOperator>? allowedFilterOperators;

  /// Flex value for flexible columns
  final int flex;

  /// Whether to show filter operator selector
  final bool showFilterOperator;

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
    this.filterWidgetType,
    this.filterBuilder,
    this.filterOptions,
    this.filterHint,
    this.defaultFilterOperator,
    this.allowedFilterOperators,
    this.flex = 1,
    this.showFilterOperator = false,
  });

  /// Get the effective filter widget type
  VooFilterWidgetType get effectiveFilterWidgetType {
    if (filterWidgetType != null) return filterWidgetType!;
    
    switch (dataType) {
      case VooDataColumnType.text:
        return VooFilterWidgetType.textField;
      case VooDataColumnType.number:
        return VooFilterWidgetType.numberRange;
      case VooDataColumnType.date:
        return VooFilterWidgetType.datePicker;
      case VooDataColumnType.boolean:
        return VooFilterWidgetType.dropdown;
      case VooDataColumnType.select:
        return VooFilterWidgetType.dropdown;
      case VooDataColumnType.multiSelect:
        return VooFilterWidgetType.multiSelect;
      case VooDataColumnType.custom:
        return VooFilterWidgetType.custom;
    }
  }

  /// Get default filter operator for this column type
  VooFilterOperator get effectiveDefaultFilterOperator {
    if (defaultFilterOperator != null) return defaultFilterOperator!;
    
    switch (dataType) {
      case VooDataColumnType.text:
        return VooFilterOperator.contains;
      case VooDataColumnType.number:
      case VooDataColumnType.date:
        return VooFilterOperator.equals;
      case VooDataColumnType.boolean:
      case VooDataColumnType.select:
        return VooFilterOperator.equals;
      case VooDataColumnType.multiSelect:
        return VooFilterOperator.inList;
      case VooDataColumnType.custom:
        return VooFilterOperator.equals;
    }
  }

  /// Get allowed filter operators for this column type
  List<VooFilterOperator> get effectiveAllowedFilterOperators {
    if (allowedFilterOperators != null) return allowedFilterOperators!;
    
    switch (dataType) {
      case VooDataColumnType.text:
        return [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.contains,
          VooFilterOperator.notContains,
          VooFilterOperator.startsWith,
          VooFilterOperator.endsWith,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];
      case VooDataColumnType.number:
      case VooDataColumnType.date:
        return [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.greaterThan,
          VooFilterOperator.greaterThanOrEqual,
          VooFilterOperator.lessThan,
          VooFilterOperator.lessThanOrEqual,
          VooFilterOperator.between,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];
      case VooDataColumnType.boolean:
        return [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];
      case VooDataColumnType.select:
        return [
          VooFilterOperator.equals,
          VooFilterOperator.notEquals,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];
      case VooDataColumnType.multiSelect:
        return [
          VooFilterOperator.inList,
          VooFilterOperator.notInList,
          VooFilterOperator.isNull,
          VooFilterOperator.isNotNull,
        ];
      case VooDataColumnType.custom:
        return VooFilterOperator.values;
    }
  }

  /// Creates a copy with optional overrides
  VooDataColumn<T> copyWith({
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
  }) {
    return VooDataColumn<T>(
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
      filterWidgetType: filterWidgetType ?? this.filterWidgetType,
      filterBuilder: filterBuilder ?? this.filterBuilder,
      filterOptions: filterOptions ?? this.filterOptions,
      filterHint: filterHint ?? this.filterHint,
      defaultFilterOperator: defaultFilterOperator ?? this.defaultFilterOperator,
      allowedFilterOperators: allowedFilterOperators ?? this.allowedFilterOperators,
      flex: flex ?? this.flex,
      showFilterOperator: showFilterOperator ?? this.showFilterOperator,
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

/// Filter widget types
enum VooFilterWidgetType {
  textField,
  numberField,
  numberRange,
  datePicker,
  dateRange,
  dropdown,
  multiSelect,
  checkbox,
  custom,
}

/// Filter option for select/multiselect columns
class VooFilterOption {
  final dynamic value;
  final String label;
  final IconData? icon;
  final Widget? child;

  const VooFilterOption({
    required this.value,
    required this.label,
    this.icon,
    this.child,
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

/// Filter operators
enum VooFilterOperator {
  equals,
  notEquals,
  contains,
  notContains,
  startsWith,
  endsWith,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
  between,
  inList,
  notInList,
  isNull,
  isNotNull,
}