import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_type.dart';

/// Converter for handling type conversions between UI representations and field values
/// This ensures type safety when dealing with form fields
abstract class FieldValueConverter<T> {
  /// Convert from string representation to the actual type
  T? fromString(String value);
  
  /// Convert from the actual type to string representation
  String toStringValue(T? value);
  
  /// Validate if a string can be converted to the target type
  bool canConvert(String value);
  
  /// Get error message when conversion fails
  String getConversionError(String value);
}

/// Number field value converter
class NumberFieldConverter extends FieldValueConverter<num> {
  @override
  num? fromString(String value) {
    if (value.isEmpty) return null;
    
    // Try to parse as int first, then as double
    final intValue = int.tryParse(value);
    if (intValue != null) return intValue;
    
    final doubleValue = double.tryParse(value);
    return doubleValue;
  }
  
  @override
  String toStringValue(num? value) {
    if (value == null) return '';
    
    // If it's a whole number, display without decimal places
    if (value is int || value == value.toInt()) {
      return value.toInt().toString();
    }
    
    return value.toString();
  }
  
  @override
  bool canConvert(String value) =>
      value.isEmpty || num.tryParse(value) != null;
  
  @override
  String getConversionError(String value) => 'Please enter a valid number';
}

/// Integer field value converter
class IntegerFieldConverter extends FieldValueConverter<int> {
  @override
  int? fromString(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }
  
  @override
  String toStringValue(int? value) => value?.toString() ?? '';
  
  @override
  bool canConvert(String value) =>
      value.isEmpty || int.tryParse(value) != null;
  
  @override
  String getConversionError(String value) => 'Please enter a valid integer';
}

/// Double field value converter
class DoubleFieldConverter extends FieldValueConverter<double> {
  @override
  double? fromString(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }
  
  @override
  String toStringValue(double? value) => value?.toString() ?? '';
  
  @override
  bool canConvert(String value) =>
      value.isEmpty || double.tryParse(value) != null;
  
  @override
  String getConversionError(String value) => 'Please enter a valid decimal number';
}

/// String field value converter (passthrough)
class StringFieldConverter extends FieldValueConverter<String> {
  @override
  String? fromString(String value) => value.isEmpty ? null : value;
  
  @override
  String toStringValue(String? value) => value ?? '';
  
  @override
  bool canConvert(String value) => true;
  
  @override
  String getConversionError(String value) => '';
}

/// Boolean field value converter
class BooleanFieldConverter extends FieldValueConverter<bool> {
  @override
  bool? fromString(String value) {
    if (value.isEmpty) return null;
    return value.toLowerCase() == 'true' || value == '1';
  }
  
  @override
  String toStringValue(bool? value) => value?.toString() ?? '';
  
  @override
  bool canConvert(String value) {
    if (value.isEmpty) return true;
    final lower = value.toLowerCase();
    return lower == 'true' || lower == 'false' || value == '0' || value == '1';
  }
  
  @override
  String getConversionError(String value) => 'Please enter true or false';
}

/// DateTime field value converter
class DateTimeFieldConverter extends FieldValueConverter<DateTime> {
  final String format;
  
  DateTimeFieldConverter({this.format = 'yyyy-MM-dd'});
  
  @override
  DateTime? fromString(String value) {
    if (value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  
  @override
  String toStringValue(DateTime? value) {
    if (value == null) return '';
    return value.toIso8601String().split('T').first;
  }
  
  @override
  bool canConvert(String value) {
    if (value.isEmpty) return true;
    try {
      DateTime.parse(value);
      return true;
    } catch (_) {
      return false;
    }
  }
  
  @override
  String getConversionError(String value) => 'Please enter a valid date';
}

/// TimeOfDay field value converter
class TimeOfDayFieldConverter extends FieldValueConverter<TimeOfDay> {
  @override
  TimeOfDay? fromString(String value) {
    if (value.isEmpty) return null;
    
    // Expected format: HH:MM
    final parts = value.split(':');
    if (parts.length != 2) return null;
    
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    
    return TimeOfDay(hour: hour, minute: minute);
  }
  
  @override
  String toStringValue(TimeOfDay? value) {
    if (value == null) return '';
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
  
  @override
  bool canConvert(String value) {
    if (value.isEmpty) return true;
    return fromString(value) != null;
  }
  
  @override
  String getConversionError(String value) => 'Please enter a valid time (HH:MM)';
}

/// Factory for creating field value converters based on type
class FieldValueConverterFactory {
  static FieldValueConverter<T> create<T>() {
    if (T == num) {
      return NumberFieldConverter() as FieldValueConverter<T>;
    } else if (T == int) {
      return IntegerFieldConverter() as FieldValueConverter<T>;
    } else if (T == double) {
      return DoubleFieldConverter() as FieldValueConverter<T>;
    } else if (T == String) {
      return StringFieldConverter() as FieldValueConverter<T>;
    } else if (T == bool) {
      return BooleanFieldConverter() as FieldValueConverter<T>;
    } else if (T == DateTime) {
      return DateTimeFieldConverter() as FieldValueConverter<T>;
    } else if (T == TimeOfDay) {
      return TimeOfDayFieldConverter() as FieldValueConverter<T>;
    }
    
    // Fallback to string converter for unknown types
    return StringFieldConverter() as FieldValueConverter<T>;
  }
  
  /// Create converter based on field type
  static FieldValueConverter<dynamic> createFromFieldType(VooFieldType type) {
    switch (type) {
      case VooFieldType.number:
        return NumberFieldConverter();
      case VooFieldType.date:
        return DateTimeFieldConverter();
      case VooFieldType.time:
        return TimeOfDayFieldConverter();
      case VooFieldType.boolean:
      case VooFieldType.checkbox:
        return BooleanFieldConverter();
      default:
        return StringFieldConverter();
    }
  }
}