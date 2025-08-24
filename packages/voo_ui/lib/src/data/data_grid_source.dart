import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_ui/src/data/data_grid_column.dart';

/// Data grid operation mode
enum VooDataGridMode {
  /// All operations (filtering, sorting, pagination) are handled locally
  local,
  /// All operations are handled remotely via API
  remote,
  /// Filtering and sorting are local, but data fetching is remote
  mixed,
}

/// Abstract data source for VooDataGrid
abstract class VooDataGridSource extends ChangeNotifier {
  /// Operation mode
  VooDataGridMode _mode = VooDataGridMode.remote;
  VooDataGridMode get mode => _mode;

  /// All data (for local mode)
  List<dynamic> _allRows = [];
  List<dynamic> get allRows => _allRows;

  /// Current page of data (filtered/sorted)
  List<dynamic> _rows = [];
  List<dynamic> get rows => _rows;

  /// Total number of rows (after filtering)
  int _totalRows = 0;
  int get totalRows => _totalRows;

  /// Current page number (0-indexed)
  int _currentPage = 0;
  int get currentPage => _currentPage;

  /// Rows per page
  int _pageSize = 20;
  int get pageSize => _pageSize;

  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Error state
  String? _error;
  String? get error => _error;

  /// Current filters
  final Map<String, VooDataFilter> _filters = {};
  Map<String, VooDataFilter> get filters => _filters;

  /// Current sort
  final List<VooColumnSort> _sorts = [];
  List<VooColumnSort> get sorts => _sorts;

  /// Selected rows
  final Set<dynamic> _selectedRows = {};
  Set<dynamic> get selectedRows => _selectedRows;

  /// Selection mode
  VooSelectionMode _selectionMode = VooSelectionMode.none;
  VooSelectionMode get selectionMode => _selectionMode;

  /// Debounce timer for remote filtering
  Timer? _debounceTimer;

  /// Constructor
  VooDataGridSource({VooDataGridMode mode = VooDataGridMode.remote}) {
    _mode = mode;
  }

  /// Fetch data from remote source (required for remote and mixed modes)
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Default implementation for local mode
    throw UnimplementedError('fetchRemoteData must be implemented for remote/mixed modes');
  }

  /// Set local data (for local mode)
  void setLocalData(List<dynamic> data) {
    _allRows = List.from(data);
    _applyLocalFiltersAndSorts();
  }

  /// Set operation mode
  void setMode(VooDataGridMode newMode) {
    _mode = newMode;
    loadData();
  }

  /// Load data with current settings
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      switch (_mode) {
        case VooDataGridMode.local:
          _applyLocalFiltersAndSorts();
          break;
        
        case VooDataGridMode.remote:
          final response = await fetchRemoteData(
            page: _currentPage,
            pageSize: _pageSize,
            filters: _filters,
            sorts: _sorts,
          );
          _rows = response.rows;
          _totalRows = response.totalRows;
          break;
        
        case VooDataGridMode.mixed:
          // For mixed mode, fetch all data once then filter/sort locally
          if (_allRows.isEmpty) {
            final response = await fetchRemoteData(
              page: 0,
              pageSize: 999999, // Get all data
              filters: {},
              sorts: [],
            );
            _allRows = response.rows;
          }
          _applyLocalFiltersAndSorts();
          break;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _rows = [];
      _totalRows = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply local filtering and sorting
  void _applyLocalFiltersAndSorts() {
    var filteredData = List.from(_allRows);

    // Apply filters
    for (final entry in _filters.entries) {
      final field = entry.key;
      final filter = entry.value;
      
      filteredData = filteredData.where((row) {
        final value = _getFieldValue(row, field);
        return _applyFilter(value, filter);
      }).toList();
    }

    // Apply sorts
    for (final sort in _sorts.reversed) {
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
        
        return sort.direction == VooSortDirection.ascending
            ? comparison
            : -comparison;
      });
    }

    // Apply pagination
    _totalRows = filteredData.length;
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _totalRows);
    _rows = filteredData.sublist(
      startIndex.clamp(0, filteredData.length),
      endIndex.clamp(0, filteredData.length),
    );
  }

  /// Get field value from row object
  dynamic _getFieldValue(dynamic row, String field) {
    if (row is Map) {
      return row[field];
    }
    // For objects, try to use reflection or assume a getter
    try {
      return row[field];
    } catch (_) {
      return null;
    }
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
        return value.toString().toLowerCase().contains(
          filter.value.toString().toLowerCase()
        );
      
      case VooFilterOperator.notContains:
        if (value == null) return true;
        return !value.toString().toLowerCase().contains(
          filter.value.toString().toLowerCase()
        );
      
      case VooFilterOperator.startsWith:
        if (value == null) return false;
        return value.toString().toLowerCase().startsWith(
          filter.value.toString().toLowerCase()
        );
      
      case VooFilterOperator.endsWith:
        if (value == null) return false;
        return value.toString().toLowerCase().endsWith(
          filter.value.toString().toLowerCase()
        );
      
      case VooFilterOperator.greaterThan:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value > filter.value;
        }
        if (value is DateTime && filter.value is DateTime) {
          return value.isAfter(filter.value);
        }
        return false;
      
      case VooFilterOperator.greaterThanOrEqual:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value >= filter.value;
        }
        if (value is DateTime && filter.value is DateTime) {
          return !value.isBefore(filter.value);
        }
        return false;
      
      case VooFilterOperator.lessThan:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value < filter.value;
        }
        if (value is DateTime && filter.value is DateTime) {
          return value.isBefore(filter.value);
        }
        return false;
      
      case VooFilterOperator.lessThanOrEqual:
        if (value == null || filter.value == null) return false;
        if (value is num && filter.value is num) {
          return value <= filter.value;
        }
        if (value is DateTime && filter.value is DateTime) {
          return !value.isAfter(filter.value);
        }
        return false;
      
      case VooFilterOperator.between:
        if (value == null || filter.value == null || filter.valueTo == null) {
          return false;
        }
        if (value is num && filter.value is num && filter.valueTo is num) {
          return value >= filter.value && value <= filter.valueTo;
        }
        if (value is DateTime && filter.value is DateTime && filter.valueTo is DateTime) {
          return !value.isBefore(filter.value) && !value.isAfter(filter.valueTo);
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
    if (filter == null) {
      _filters.remove(field);
    } else {
      _filters[field] = filter;
    }
    _currentPage = 0;
    
    if (_mode == VooDataGridMode.remote) {
      _debouncedLoadData();
    } else {
      loadData();
    }
  }

  /// Clear all filters
  void clearFilters() {
    _filters.clear();
    _currentPage = 0;
    loadData();
  }

  /// Apply sort to a column
  void applySort(String field, VooSortDirection direction) {
    if (direction == VooSortDirection.none) {
      _sorts.removeWhere((sort) => sort.field == field);
    } else {
      final existingIndex = _sorts.indexWhere((sort) => sort.field == field);
      final newSort = VooColumnSort(field: field, direction: direction);
      
      if (existingIndex >= 0) {
        _sorts[existingIndex] = newSort;
      } else {
        _sorts.add(newSort);
      }
    }
    _currentPage = 0;
    loadData();
  }

  /// Clear all sorts
  void clearSorts() {
    _sorts.clear();
    _currentPage = 0;
    loadData();
  }

  /// Change page
  void changePage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      if (_mode == VooDataGridMode.local || _mode == VooDataGridMode.mixed) {
        _applyLocalFiltersAndSorts();
        notifyListeners();
      } else {
        loadData();
      }
    }
  }

  /// Change page size
  void changePageSize(int size) {
    _pageSize = size;
    _currentPage = 0;
    if (_mode == VooDataGridMode.local || _mode == VooDataGridMode.mixed) {
      _applyLocalFiltersAndSorts();
      notifyListeners();
    } else {
      loadData();
    }
  }

  /// Get total number of pages
  int get totalPages => (_totalRows / _pageSize).ceil();

  /// Select/deselect a row
  void toggleRowSelection(dynamic row) {
    if (_selectionMode == VooSelectionMode.none) return;

    if (_selectionMode == VooSelectionMode.single) {
      _selectedRows.clear();
      if (!_selectedRows.contains(row)) {
        _selectedRows.add(row);
      }
    } else {
      if (_selectedRows.contains(row)) {
        _selectedRows.remove(row);
      } else {
        _selectedRows.add(row);
      }
    }
    notifyListeners();
  }

  /// Select all rows
  void selectAll() {
    if (_selectionMode == VooSelectionMode.multiple) {
      _selectedRows.addAll(_rows);
      notifyListeners();
    }
  }

  /// Clear selection
  void clearSelection() {
    _selectedRows.clear();
    notifyListeners();
  }

  /// Set selection mode
  void setSelectionMode(VooSelectionMode mode) {
    _selectionMode = mode;
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
    super.dispose();
  }
}

/// Response from data source
class VooDataGridResponse {
  final List<dynamic> rows;
  final int totalRows;
  final int page;
  final int pageSize;

  const VooDataGridResponse({
    required this.rows,
    required this.totalRows,
    required this.page,
    required this.pageSize,
  });
}

/// Data filter for a column
class VooDataFilter {
  final VooFilterOperator operator;
  final dynamic value;
  final dynamic valueTo; // For range filters

  const VooDataFilter({
    required this.operator,
    required this.value,
    this.valueTo,
  });
}

/// Selection mode for data grid
enum VooSelectionMode {
  none,
  single,
  multiple,
}