import 'package:flutter/foundation.dart';
import 'package:voo_data_grid/src/domain/entities/voo_column_sort.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/domain/entities/voo_sort_direction.dart';

/// Data for isolate computation
class IsolateComputeData<T> {
  final List<T> data;
  final Map<String, VooDataFilter> filters;
  final List<VooColumnSort> sorts;
  final int currentPage;
  final int pageSize;
  final dynamic Function(T, String)? valueGetter;

  const IsolateComputeData({
    required this.data,
    required this.filters,
    required this.sorts,
    required this.currentPage,
    required this.pageSize,
    this.valueGetter,
  });
}

/// Result from isolate computation
class IsolateComputeResult<T> {
  final List<T> rows;
  final int totalRows;

  const IsolateComputeResult({
    required this.rows,
    required this.totalRows,
  });
}

/// Helper class for isolate computations
class IsolateComputeHelper {
  /// Process data in isolate for better performance
  static Future<IsolateComputeResult<T>> processDataInIsolate<T>(
    IsolateComputeData<T> data,
  ) async {
    // For small datasets, process synchronously to avoid overhead
    if (data.data.length < 100) {
      return _processData(data);
    }

    // For larger datasets, use compute to process in isolate
    return compute(_processData, data);
  }

  /// Process data (runs in isolate for large datasets)
  static IsolateComputeResult<T> _processData<T>(IsolateComputeData<T> data) {
    var filteredData = List<T>.from(data.data);

    // Apply filters
    for (final entry in data.filters.entries) {
      final field = entry.key;
      final filter = entry.value;

      filteredData = filteredData.where((row) {
        final value = _getFieldValue(row, field, data.valueGetter);
        return _applyFilter(value, filter);
      }).toList();
    }

    // Apply sorts
    for (final sort in data.sorts.reversed) {
      filteredData.sort((a, b) {
        final aValue = _getFieldValue(a, sort.field, data.valueGetter);
        final bValue = _getFieldValue(b, sort.field, data.valueGetter);

        int comparison;
        if (aValue == null && bValue == null) {
          comparison = 0;
        } else if (aValue == null) {
          comparison = 1;
        } else if (bValue == null) {
          comparison = -1;
        } else if (aValue is Comparable) {
          comparison = aValue.compareTo(bValue);
        } else {
          comparison = aValue.toString().compareTo(bValue.toString());
        }

        return sort.direction == VooSortDirection.ascending
            ? comparison
            : -comparison;
      });
    }

    // Apply pagination
    final totalRows = filteredData.length;
    final startIndex = data.currentPage * data.pageSize;
    final endIndex = (startIndex + data.pageSize).clamp(0, totalRows);
    final rows = filteredData
        .sublist(
          startIndex.clamp(0, filteredData.length),
          endIndex.clamp(0, filteredData.length),
        )
        .cast<T>();

    return IsolateComputeResult(
      rows: rows,
      totalRows: totalRows,
    );
  }

  /// Get field value from row object
  static dynamic _getFieldValue<T>(
    T row,
    String field, [
    dynamic Function(T, String)? valueGetter,
  ]) {
    if (valueGetter != null) {
      return valueGetter(row, field);
    }

    if (row is Map) {
      final parts = field.split('.');
      dynamic value = row;
      for (final part in parts) {
        if (value is Map) {
          value = value[part];
        } else {
          return null;
        }
      }
      return value;
    }

    // For typed objects, return null (requires valueGetter)
    return null;
  }

  /// Apply filter to a value
  static bool _applyFilter(dynamic value, VooDataFilter filter) {
    // Handle null values
    if (value == null) {
      return filter.operator == VooFilterOperator.isNull ||
          filter.operator == VooFilterOperator.notEquals;
    }

    switch (filter.operator) {
      case VooFilterOperator.equals:
        return value == filter.value;

      case VooFilterOperator.notEquals:
        return value != filter.value;

      case VooFilterOperator.contains:
        return value.toString().toLowerCase().contains(
              filter.value?.toString().toLowerCase() ?? '',
            );

      case VooFilterOperator.notContains:
        return !value.toString().toLowerCase().contains(
              filter.value?.toString().toLowerCase() ?? '',
            );

      case VooFilterOperator.startsWith:
        return value.toString().toLowerCase().startsWith(
              filter.value?.toString().toLowerCase() ?? '',
            );

      case VooFilterOperator.endsWith:
        return value.toString().toLowerCase().endsWith(
              filter.value?.toString().toLowerCase() ?? '',
            );

      case VooFilterOperator.greaterThan:
        if (value is Comparable && filter.value is Comparable) {
          return value.compareTo(filter.value) > 0;
        }
        return false;

      case VooFilterOperator.greaterThanOrEqual:
        if (value is Comparable && filter.value is Comparable) {
          return value.compareTo(filter.value) >= 0;
        }
        return false;

      case VooFilterOperator.lessThan:
        if (value is Comparable && filter.value is Comparable) {
          return value.compareTo(filter.value) < 0;
        }
        return false;

      case VooFilterOperator.lessThanOrEqual:
        if (value is Comparable && filter.value is Comparable) {
          return value.compareTo(filter.value) <= 0;
        }
        return false;

      case VooFilterOperator.between:
        if (value is Comparable &&
            filter.value is Comparable &&
            filter.valueTo is Comparable) {
          return value.compareTo(filter.value) >= 0 &&
              value.compareTo(filter.valueTo) <= 0;
        }
        return false;

      case VooFilterOperator.inList:
        if (filter.value is List) {
          return (filter.value as List).contains(value);
        }
        return false;

      case VooFilterOperator.notInList:
        if (filter.value is List) {
          return !(filter.value as List).contains(value);
        }
        return true;

      case VooFilterOperator.isNull:
        return value == null;

      case VooFilterOperator.isNotNull:
        return value != null;
    }
  }
}