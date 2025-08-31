import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Data grid controller with ChangeNotifier for Provider/ChangeNotifierProvider
///
/// This controller can be used with Provider for those who prefer that approach.
/// For other state management solutions, use the appropriate adapter.
class VooDataGridStateController<T> extends ChangeNotifier {
  final VooDataGridDataSource<T> dataSource;
  VooDataGridState<T> _state;
  Timer? _debounceTimer;

  VooDataGridStateController({
    required this.dataSource,
    VooDataGridMode mode = VooDataGridMode.remote,
    int pageSize = 20,
  }) : _state = VooDataGridState<T>(
          mode: mode,
          pageSize: pageSize,
        );

  /// Get current state
  VooDataGridState<T> get state => _state;

  /// Convenience getters
  VooDataGridMode get mode => _state.mode;
  List<T> get allRows => _state.allRows;
  List<T> get rows => _state.rows;
  int get totalRows => _state.totalRows;
  int get currentPage => _state.currentPage;
  int get pageSize => _state.pageSize;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  Map<String, VooDataFilter> get filters => _state.filters;
  List<VooColumnSort> get sorts => _state.sorts;
  Set<T> get selectedRows => _state.selectedRows;
  VooSelectionMode get selectionMode => _state.selectionMode;
  int get totalPages => _state.totalPages;

  /// Set local data (for local mode)
  void setLocalData(List<T> data) {
    _state = _state.copyWith(allRows: data);
    _applyLocalFiltersAndSorts();
  }

  /// Set operation mode
  void setMode(VooDataGridMode newMode) {
    _state = _state.copyWith(mode: newMode);
    loadData();
  }

  /// Load data with current settings
  Future<void> loadData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      switch (_state.mode) {
        case VooDataGridMode.local:
          _applyLocalFiltersAndSorts();
          break;

        case VooDataGridMode.remote:
          final response = await dataSource.fetchRemoteData(
            page: _state.currentPage,
            pageSize: _state.pageSize,
            filters: _state.filters,
            sorts: _state.sorts,
          );
          _state = _state.copyWith(
            rows: response.rows,
            totalRows: response.totalRows,
            error: null,
          );
          break;

        case VooDataGridMode.mixed:
          // For mixed mode, fetch all data once then filter/sort locally
          if (_state.allRows.isEmpty) {
            final response = await dataSource.fetchRemoteData(
              page: 0,
              pageSize: 999999, // Get all data
              filters: {},
              sorts: [],
            );
            _state = _state.copyWith(allRows: response.rows);
          }
          _applyLocalFiltersAndSorts();
          break;
      }
    } catch (e) {
      _state = _state.copyWith(
        error: e.toString(),
        rows: [],
        totalRows: 0,
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  /// Apply local filtering and sorting
  void _applyLocalFiltersAndSorts() {
    var filteredData = List<T>.from(_state.allRows);

    // Apply filters
    for (final entry in _state.filters.entries) {
      final field = entry.key;
      final filter = entry.value;

      filteredData = filteredData.where((row) {
        final value = _getFieldValue(row, field);
        return _applyFilter(value, filter);
      }).toList();
    }

    // Apply sorts
    for (final sort in _state.sorts.reversed) {
      filteredData.sort((a, b) {
        final aValue = _getFieldValue(a, sort.field);
        final bValue = _getFieldValue(b, sort.field);

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

        return sort.direction == VooSortDirection.ascending ? comparison : -comparison;
      });
    }

    // Apply pagination
    final totalRows = filteredData.length;
    final startIndex = _state.currentPage * _state.pageSize;
    final endIndex = (startIndex + _state.pageSize).clamp(0, totalRows);
    final rows = filteredData
        .sublist(
          startIndex.clamp(0, filteredData.length),
          endIndex.clamp(0, filteredData.length),
        )
        .cast<T>();

    _state = _state.copyWith(
      rows: rows,
      totalRows: totalRows,
    );
  }

  /// Get field value from row object
  dynamic _getFieldValue(dynamic row, String field) {
    if (row is Map) {
      return row[field];
    }
    // For typed objects, users must provide valueGetter in column definition
    return null;
  }

  /// Apply a single filter to a value
  bool _applyFilter(dynamic value, VooDataFilter filter) {
    switch (filter.operator) {
      case VooFilterOperator.equals:
        return value == filter.value;
      case VooFilterOperator.notEquals:
        return value != filter.value;
      case VooFilterOperator.contains:
        if (value == null) return false;
        return value.toString().toLowerCase().contains(filter.value.toString().toLowerCase());
      case VooFilterOperator.notContains:
        if (value == null) return true;
        return !value.toString().toLowerCase().contains(filter.value.toString().toLowerCase());
      case VooFilterOperator.startsWith:
        if (value == null) return false;
        return value.toString().toLowerCase().startsWith(filter.value.toString().toLowerCase());
      case VooFilterOperator.endsWith:
        if (value == null) return false;
        return value.toString().toLowerCase().endsWith(filter.value.toString().toLowerCase());
      case VooFilterOperator.greaterThan:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value > (filter.value as num);
        }
        if (value is DateTime && filter.value is DateTime) {
          return value.isAfter(filter.value as DateTime);
        }
        return false;
      case VooFilterOperator.greaterThanOrEqual:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value >= (filter.value as num);
        }
        if (value is DateTime && filter.value is DateTime) {
          return !value.isBefore(filter.value as DateTime);
        }
        return false;
      case VooFilterOperator.lessThan:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value < (filter.value as num);
        }
        if (value is DateTime && filter.value is DateTime) {
          return value.isBefore(filter.value as DateTime);
        }
        return false;
      case VooFilterOperator.lessThanOrEqual:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value <= (filter.value as num);
        }
        if (value is DateTime && filter.value is DateTime) {
          return !value.isAfter(filter.value as DateTime);
        }
        return false;
      case VooFilterOperator.between:
        if (value == null || filter.value == null || filter.valueTo == null) {
          return false;
        }
        if (value is num && filter.value is num && filter.valueTo is num) {
          return value >= (filter.value as num) && value <= (filter.valueTo as num);
        }
        if (value is DateTime && filter.value is DateTime && filter.valueTo is DateTime) {
          return !value.isBefore(filter.value as DateTime) && !value.isAfter(filter.valueTo as DateTime);
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

  /// Apply filter to a column
  void applyFilter(String field, VooDataFilter? filter) {
    final newFilters = Map<String, VooDataFilter>.from(_state.filters);
    if (filter == null) {
      newFilters.remove(field);
    } else {
      newFilters[field] = filter;
    }
    _state = _state.copyWith(filters: newFilters, currentPage: 0);

    if (_state.mode == VooDataGridMode.remote) {
      _debouncedLoadData();
    } else {
      loadData();
    }
  }

  /// Clear all filters
  void clearFilters() {
    _state = _state.copyWith(filters: {}, currentPage: 0);
    loadData();
  }

  /// Apply sort to a column
  void applySort(String field, VooSortDirection direction) {
    final newSorts = List<VooColumnSort>.from(_state.sorts);
    if (direction == VooSortDirection.none) {
      newSorts.removeWhere((sort) => sort.field == field);
    } else {
      final existingIndex = newSorts.indexWhere((sort) => sort.field == field);
      final newSort = VooColumnSort(field: field, direction: direction);

      if (existingIndex >= 0) {
        newSorts[existingIndex] = newSort;
      } else {
        newSorts.add(newSort);
      }
    }
    _state = _state.copyWith(sorts: newSorts, currentPage: 0);
    loadData();
  }

  /// Clear all sorts
  void clearSorts() {
    _state = _state.copyWith(sorts: [], currentPage: 0);
    loadData();
  }

  /// Change page
  void changePage(int page) {
    if (page >= 0 && page < _state.totalPages) {
      _state = _state.copyWith(currentPage: page);
      if (_state.mode == VooDataGridMode.local || _state.mode == VooDataGridMode.mixed) {
        _applyLocalFiltersAndSorts();
        notifyListeners();
      } else {
        loadData();
      }
    }
  }

  /// Change page size
  void changePageSize(int size) {
    _state = _state.copyWith(pageSize: size, currentPage: 0);
    if (_state.mode == VooDataGridMode.local || _state.mode == VooDataGridMode.mixed) {
      _applyLocalFiltersAndSorts();
      notifyListeners();
    } else {
      loadData();
    }
  }

  /// Select/deselect a row
  void toggleRowSelection(T row) {
    if (_state.selectionMode == VooSelectionMode.none) return;

    final newSelection = Set<T>.from(_state.selectedRows);
    if (_state.selectionMode == VooSelectionMode.single) {
      newSelection.clear();
      if (!newSelection.contains(row)) {
        newSelection.add(row);
      }
    } else {
      if (newSelection.contains(row)) {
        newSelection.remove(row);
      } else {
        newSelection.add(row);
      }
    }
    _state = _state.copyWith(selectedRows: newSelection);
    notifyListeners();
  }

  /// Select all rows
  void selectAll() {
    if (_state.selectionMode == VooSelectionMode.multiple) {
      final newSelection = Set<T>.from(_state.rows);
      _state = _state.copyWith(selectedRows: newSelection);
      notifyListeners();
    }
  }

  /// Clear selection
  void clearSelection() {
    _state = _state.copyWith(selectedRows: {});
    notifyListeners();
  }

  /// Set selection mode
  void setSelectionMode(VooSelectionMode mode) {
    _state = _state.copyWith(selectionMode: mode);
    if (mode == VooSelectionMode.none) {
      clearSelection();
    }
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() => loadData();

  /// Debounced load data for filtering
  void _debouncedLoadData() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), loadData);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    dataSource.dispose();
    super.dispose();
  }
}
