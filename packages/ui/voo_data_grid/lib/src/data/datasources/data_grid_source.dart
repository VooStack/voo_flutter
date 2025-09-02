import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
import 'package:voo_data_grid/src/domain/entities/voo_column_sort.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_grid_response.dart';
import 'package:voo_data_grid/src/domain/entities/voo_sort_direction.dart';
import 'package:voo_data_grid/src/utils/isolate_compute_helper.dart';

/// Abstract data source for VooDataGrid
///
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
/// For typed objects (non-Map), you MUST provide a valueGetter function
/// in your VooDataColumn definitions to extract field values.
abstract class VooDataGridSource<T> extends ChangeNotifier {
  /// Operation mode
  VooDataGridMode _mode = VooDataGridMode.remote;
  VooDataGridMode get mode => _mode;

  /// All data (for local mode)
  List<T> _allRows = [];
  List<T> get allRows => _allRows;

  /// Current page of data (filtered/sorted)
  List<T> _rows = [];
  List<T> get rows => _rows;

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
  final Set<T> _selectedRows = {};
  Set<T> get selectedRows => _selectedRows;

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
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Default implementation for local mode
    throw UnimplementedError(
      'fetchRemoteData must be implemented for remote/mixed modes',
    );
  }

  /// Set local data (for local mode)
  void setLocalData(List<T> data) {
    _allRows = List.from(data);
    // Schedule the async processing for next frame to avoid blocking
    Future.microtask(_applyLocalFiltersAndSorts);
  }
  
  /// Set local data and wait for processing (for tests)
  Future<void> setLocalDataAsync(List<T> data) async {
    _allRows = List.from(data);
    await _applyLocalFiltersAndSorts();
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
          await _applyLocalFiltersAndSorts();
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
          await _applyLocalFiltersAndSorts();
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
  Future<void> _applyLocalFiltersAndSorts() async {
    // Use isolate helper for better performance
    final computeData = IsolateComputeData<T>(
      data: _allRows,
      filters: _filters,
      sorts: _sorts,
      currentPage: _currentPage,
      pageSize: _pageSize,
    );

    final result = await IsolateComputeHelper.processDataInIsolate(computeData);
    
    _rows = result.rows;
    _totalRows = result.totalRows;
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
  void toggleRowSelection(T row) {
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

  /// Select all rows (alias for selectAll)
  void selectAllRows() => selectAll();

  /// Clear selection
  void clearSelection() {
    _selectedRows.clear();
    notifyListeners();
  }

  /// Deselect all rows (alias for clearSelection)
  void deselectAllRows() => clearSelection();

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
