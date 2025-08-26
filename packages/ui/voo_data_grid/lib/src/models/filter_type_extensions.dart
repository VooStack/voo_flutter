import 'package:flutter/material.dart';
import '../advanced_remote_data_source.dart';

/// Extension methods for FilterType enum
extension FilterTypeExtensions on FilterType {
  /// Get available operators for this filter type
  List<String> get operators {
    switch (this) {
      case FilterType.string:
        return [
          'Equals',
          'NotEquals',
          'Contains',
          'NotContains',
          'StartsWith',
          'EndsWith',
        ];
      case FilterType.int:
      case FilterType.decimal:
        return [
          'Equals',
          'NotEquals',
          'GreaterThan',
          'GreaterThanOrEqual',
          'LessThan',
          'LessThanOrEqual',
          'Between',
        ];
      case FilterType.date:
      case FilterType.dateTime:
        return [
          'Equals',
          'NotEquals',
          'After',
          'AfterOrEqual',
          'Before',
          'BeforeOrEqual',
          'Between',
        ];
      case FilterType.bool:
        return [
          'Equals',
          'NotEquals',
        ];
    }
  }

  /// Get the default operator for this filter type
  String get defaultOperator {
    switch (this) {
      case FilterType.string:
        return 'Contains';
      case FilterType.int:
      case FilterType.decimal:
        return 'Equals';
      case FilterType.date:
      case FilterType.dateTime:
        return 'Equals';
      case FilterType.bool:
        return 'Equals';
    }
  }

  /// Get the input widget type for this filter
  FilterInputType get inputType {
    switch (this) {
      case FilterType.string:
        return FilterInputType.text;
      case FilterType.int:
        return FilterInputType.number;
      case FilterType.decimal:
        return FilterInputType.decimal;
      case FilterType.date:
        return FilterInputType.datePicker;
      case FilterType.dateTime:
        return FilterInputType.dateTimePicker;
      case FilterType.bool:
        return FilterInputType.checkbox;
    }
  }

  /// Check if this filter type supports range operations
  bool get supportsRange {
    switch (this) {
      case FilterType.int:
      case FilterType.decimal:
      case FilterType.date:
      case FilterType.dateTime:
        return true;
      case FilterType.string:
      case FilterType.bool:
        return false;
    }
  }

  /// Get the icon for this filter type
  IconData get icon {
    switch (this) {
      case FilterType.string:
        return Icons.text_fields;
      case FilterType.int:
        return Icons.numbers;
      case FilterType.decimal:
        return Icons.attach_money;
      case FilterType.date:
        return Icons.calendar_today;
      case FilterType.dateTime:
        return Icons.access_time;
      case FilterType.bool:
        return Icons.check_box;
    }
  }

  /// Get display name for this filter type
  String get displayName {
    switch (this) {
      case FilterType.string:
        return 'Text';
      case FilterType.int:
        return 'Integer';
      case FilterType.decimal:
        return 'Decimal';
      case FilterType.date:
        return 'Date';
      case FilterType.dateTime:
        return 'Date & Time';
      case FilterType.bool:
        return 'Boolean';
    }
  }

  /// Parse a value for this filter type
  dynamic parseValue(String value) {
    switch (this) {
      case FilterType.string:
        return value;
      case FilterType.int:
        return int.tryParse(value) ?? 0;
      case FilterType.decimal:
        return double.tryParse(value) ?? 0.0;
      case FilterType.date:
      case FilterType.dateTime:
        return DateTime.tryParse(value) ?? DateTime.now();
      case FilterType.bool:
        return value.toLowerCase() == 'true';
    }
  }

  /// Format a value for display
  String formatValue(dynamic value) {
    if (value == null) return '';
    
    switch (this) {
      case FilterType.string:
        return value.toString();
      case FilterType.int:
        return value.toString();
      case FilterType.decimal:
        final num = value is double ? value : double.tryParse(value.toString()) ?? 0.0;
        return num.toStringAsFixed(2);
      case FilterType.date:
        if (value is DateTime) {
          return '${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}/${value.year}';
        }
        return value.toString();
      case FilterType.dateTime:
        if (value is DateTime) {
          return '${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}/${value.year} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
        }
        return value.toString();
      case FilterType.bool:
        return value ? 'Yes' : 'No';
    }
  }

  /// Validate a value for this filter type
  bool isValidValue(dynamic value) {
    if (value == null) return false;
    
    switch (this) {
      case FilterType.string:
        return value is String && value.isNotEmpty;
      case FilterType.int:
        return value is int || (value is String && int.tryParse(value) != null);
      case FilterType.decimal:
        return value is double || value is int || 
               (value is String && double.tryParse(value) != null);
      case FilterType.date:
      case FilterType.dateTime:
        return value is DateTime || 
               (value is String && DateTime.tryParse(value) != null);
      case FilterType.bool:
        return value is bool || 
               (value is String && (value == 'true' || value == 'false'));
    }
  }
}

/// Input types for filter widgets
enum FilterInputType {
  text,
  number,
  decimal,
  datePicker,
  dateTimePicker,
  checkbox,
  dropdown,
  multiSelect,
  range,
  slider,
}

/// Extension methods for filter operators
extension FilterOperatorExtensions on String {
  /// Get the SQL-like operator equivalent
  String get sqlOperator {
    switch (this) {
      case 'Equals':
        return '=';
      case 'NotEquals':
        return '!=';
      case 'GreaterThan':
      case 'After':
        return '>';
      case 'GreaterThanOrEqual':
      case 'AfterOrEqual':
        return '>=';
      case 'LessThan':
      case 'Before':
        return '<';
      case 'LessThanOrEqual':
      case 'BeforeOrEqual':
        return '<=';
      case 'Contains':
        return 'LIKE';
      case 'NotContains':
        return 'NOT LIKE';
      case 'StartsWith':
        return 'STARTS WITH';
      case 'EndsWith':
        return 'ENDS WITH';
      case 'Between':
        return 'BETWEEN';
      default:
        return '=';
    }
  }

  /// Check if this operator requires a secondary value (for range operations)
  bool get requiresSecondaryValue {
    return this == 'Between';
  }

  /// Get display text for the operator
  String get displayText {
    switch (this) {
      case 'Equals':
        return 'equals';
      case 'NotEquals':
        return 'not equals';
      case 'GreaterThan':
        return 'greater than';
      case 'GreaterThanOrEqual':
        return 'greater than or equal';
      case 'LessThan':
        return 'less than';
      case 'LessThanOrEqual':
        return 'less than or equal';
      case 'Contains':
        return 'contains';
      case 'NotContains':
        return 'does not contain';
      case 'StartsWith':
        return 'starts with';
      case 'EndsWith':
        return 'ends with';
      case 'After':
        return 'after';
      case 'AfterOrEqual':
        return 'after or equal';
      case 'Before':
        return 'before';
      case 'BeforeOrEqual':
        return 'before or equal';
      case 'Between':
        return 'between';
      default:
        return this.toLowerCase();
    }
  }

  /// Apply this operator to compare two values
  bool apply(dynamic value1, dynamic value2) {
    if (value1 == null || value2 == null) return false;
    
    switch (this) {
      case 'Equals':
        return value1 == value2;
      case 'NotEquals':
        return value1 != value2;
      case 'GreaterThan':
      case 'After':
        if (value1 is num && value2 is num) return value1 > value2;
        if (value1 is DateTime && value2 is DateTime) return value1.isAfter(value2);
        return false;
      case 'GreaterThanOrEqual':
      case 'AfterOrEqual':
        if (value1 is num && value2 is num) return value1 >= value2;
        if (value1 is DateTime && value2 is DateTime) {
          return value1.isAfter(value2) || value1.isAtSameMomentAs(value2);
        }
        return false;
      case 'LessThan':
      case 'Before':
        if (value1 is num && value2 is num) return value1 < value2;
        if (value1 is DateTime && value2 is DateTime) return value1.isBefore(value2);
        return false;
      case 'LessThanOrEqual':
      case 'BeforeOrEqual':
        if (value1 is num && value2 is num) return value1 <= value2;
        if (value1 is DateTime && value2 is DateTime) {
          return value1.isBefore(value2) || value1.isAtSameMomentAs(value2);
        }
        return false;
      case 'Contains':
        return value1.toString().toLowerCase().contains(value2.toString().toLowerCase());
      case 'NotContains':
        return !value1.toString().toLowerCase().contains(value2.toString().toLowerCase());
      case 'StartsWith':
        return value1.toString().toLowerCase().startsWith(value2.toString().toLowerCase());
      case 'EndsWith':
        return value1.toString().toLowerCase().endsWith(value2.toString().toLowerCase());
      default:
        return false;
    }
  }
}