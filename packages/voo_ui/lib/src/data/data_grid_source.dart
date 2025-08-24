import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_ui/src/data/data_grid_column.dart';

/// Abstract data source for VooDataGrid
abstract class VooDataGridSource extends ChangeNotifier {
  /// Current page of data
  List<dynamic> _rows = [];
  List<dynamic> get rows => _rows;

  /// Total number of rows (for pagination)
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

  /// Fetch data from remote source
  Future<VooDataGridResponse> fetchData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  });

  /// Load data with current settings
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await fetchData(
        page: _currentPage,
        pageSize: _pageSize,
        filters: _filters,
        sorts: _sorts,
      );

      _rows = response.rows;
      _totalRows = response.totalRows;
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

  /// Apply filter to a column
  void applyFilter(String field, VooDataFilter? filter) {
    if (filter == null) {
      _filters.remove(field);
    } else {
      _filters[field] = filter;
    }
    _currentPage = 0;
    _debouncedLoadData();
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
      loadData();
    }
  }

  /// Change page size
  void changePageSize(int size) {
    _pageSize = size;
    _currentPage = 0;
    loadData();
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

/// Selection mode for data grid
enum VooSelectionMode {
  none,
  single,
  multiple,
}