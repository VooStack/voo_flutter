import 'dart:async';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
import 'package:voo_data_grid/src/domain/entities/voo_column_sort.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_grid_response.dart';

// Re-export types for convenience
export 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
export 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
export 'package:voo_data_grid/src/domain/entities/voo_data_grid_response.dart';

/// State-management agnostic data source interface for VooDataGrid
///
/// This abstract class defines the contract for data sources without
/// forcing any specific state management approach. Implementations can
/// work with Cubit, BLoC, Provider, Riverpod, or any other state management.
///
/// Generic type parameter T represents the row data type.
abstract class VooDataGridDataSource<T> {
  /// Fetch data from remote source (required for remote and mixed modes)
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  });

  /// Optional: Clean up resources when done
  void dispose() {}
}

/// Data grid state that can be used with any state management solution
class VooDataGridState<T> {
  /// Operation mode
  final VooDataGridMode mode;

  /// All data (for local mode)
  final List<T> allRows;

  /// Current page of data (filtered/sorted)
  final List<T> rows;

  /// Total number of rows (after filtering)
  final int totalRows;

  /// Current page number (0-indexed)
  final int currentPage;

  /// Rows per page
  final int pageSize;

  /// Loading state
  final bool isLoading;

  /// Error state
  final String? error;

  /// Current filters
  final Map<String, VooDataFilter> filters;

  /// Current sort
  final List<VooColumnSort> sorts;

  /// Selected rows
  final Set<T> selectedRows;

  /// Selection mode
  final VooSelectionMode selectionMode;

  /// Whether filters are visible
  final bool filtersVisible;

  /// Currently selected primary filter field
  final String? primaryFilterField;

  /// Currently selected primary filter
  final VooDataFilter? primaryFilter;

  const VooDataGridState({
    this.mode = VooDataGridMode.remote,
    this.allRows = const [],
    this.rows = const [],
    this.totalRows = 0,
    this.currentPage = 0,
    this.pageSize = 20,
    this.isLoading = false,
    this.error,
    this.filters = const {},
    this.sorts = const [],
    this.selectedRows = const {},
    this.selectionMode = VooSelectionMode.none,
    this.filtersVisible = false,
    this.primaryFilterField,
    this.primaryFilter,
  });

  /// Create a copy with updated values
  ///
  /// For nullable fields (error, primaryFilterField, primaryFilter):
  /// - Not passing the parameter keeps the current value
  /// - Passing null explicitly will set it to null
  /// - Use [clearError] as a convenience method to clear the error
  VooDataGridState<T> copyWith({
    VooDataGridMode? mode,
    List<T>? allRows,
    List<T>? rows,
    int? totalRows,
    int? currentPage,
    int? pageSize,
    bool? isLoading,
    Object? error = const _Unset(),
    Map<String, VooDataFilter>? filters,
    List<VooColumnSort>? sorts,
    Set<T>? selectedRows,
    VooSelectionMode? selectionMode,
    bool? filtersVisible,
    Object? primaryFilterField = const _Unset(),
    Object? primaryFilter = const _Unset(),
  }) => VooDataGridState<T>(
    mode: mode ?? this.mode,
    allRows: allRows ?? this.allRows,
    rows: rows ?? this.rows,
    totalRows: totalRows ?? this.totalRows,
    currentPage: currentPage ?? this.currentPage,
    pageSize: pageSize ?? this.pageSize,
    isLoading: isLoading ?? this.isLoading,
    error: error is _Unset ? this.error : error as String?,
    filters: filters ?? this.filters,
    sorts: sorts ?? this.sorts,
    selectedRows: selectedRows ?? this.selectedRows,
    selectionMode: selectionMode ?? this.selectionMode,
    filtersVisible: filtersVisible ?? this.filtersVisible,
    primaryFilterField: primaryFilterField is _Unset ? this.primaryFilterField : primaryFilterField as String?,
    primaryFilter: primaryFilter is _Unset ? this.primaryFilter : primaryFilter as VooDataFilter?,
  );

  /// Convenience method to clear the error state
  VooDataGridState<T> clearError() => copyWith(error: null);

  /// Get total number of pages
  int get totalPages => pageSize > 0 ? (totalRows / pageSize).ceil() : 0;
}

/// Sentinel class to detect unset optional parameters in copyWith
class _Unset {
  const _Unset();
}
