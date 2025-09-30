import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/data_grid_core.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A state-agnostic data grid widget that works with any state management solution
///
/// This widget accepts state directly and callbacks for state changes,
/// making it compatible with Cubit, BLoC, Riverpod, GetX, or any other
/// state management solution.
///
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class VooDataGridStateless<T> extends StatelessWidget {
  /// The current state of the data grid
  final VooDataGridState<T> state;

  /// The columns to display
  final List<VooDataColumn<T>> columns;

  /// Callback when page changes
  final void Function(int page)? onPageChanged;

  /// Callback when page size changes
  final void Function(int pageSize)? onPageSizeChanged;

  /// Callback when a filter is applied
  final void Function(String field, VooDataFilter? filter)? onFilterChanged;

  /// Callback when filters are cleared
  final VoidCallback? onFiltersCleared;

  /// Callback when filters are toggled
  final VoidCallback? onToggleFilters;

  /// Callback when a sort is applied
  final void Function(String field, VooSortDirection direction)? onSortChanged;

  /// Callback when sorts are cleared
  final VoidCallback? onSortsCleared;

  /// Callback when a row is selected
  final void Function(T row)? onRowSelected;

  /// Callback when a row is deselected
  final void Function(T row)? onRowDeselected;

  /// Callback when all rows are selected
  final VoidCallback? onSelectAll;

  /// Callback when all rows are deselected
  final VoidCallback? onDeselectAll;

  /// Callback to refresh data
  final VoidCallback? onRefresh;

  /// Whether to show pagination controls
  final bool showPagination;

  /// Whether to show the toolbar
  final bool showToolbar;

  /// Custom toolbar widgets
  final List<Widget>? toolbarActions;

  /// Empty state widget
  final Widget? emptyStateWidget;

  /// Loading indicator widget
  final Widget? loadingWidget;

  /// Error widget builder
  final Widget Function(String error)? errorBuilder;

  /// Callback when an error occurs
  /// Called when the error state transitions from null to non-null
  /// or when the error message changes
  final void Function(String error)? onError;

  /// Row tap callback
  final void Function(T row)? onRowTap;

  /// Row double tap callback
  final void Function(T row)? onRowDoubleTap;

  /// Row hover callback
  final void Function(T)? onRowHover;

  /// Border decoration
  final BoxDecoration? decoration;

  /// Grid theme
  final VooDataGridTheme? theme;

  /// Display mode for the grid
  final VooDataGridDisplayMode displayMode;

  /// Custom card builder for mobile layout
  final Widget Function(BuildContext context, T row, int index)? cardBuilder;

  /// Priority columns to show on mobile (field names)
  final List<String>? mobilePriorityColumns;

  /// Whether to always show vertical scrollbar.
  final bool alwaysShowVerticalScrollbar;

  /// Whether to always show horizontal scrollbar.
  final bool alwaysShowHorizontalScrollbar;

  /// Primary filters configuration
  final List<PrimaryFilter>? primaryFilters;

  /// Currently selected primary filter
  final VooDataFilter? selectedPrimaryFilter;

  /// Whether to show primary filters
  final bool showPrimaryFilters;

  /// Callback when primary filter is selected
  final void Function(String field, VooDataFilter? filter)? onPrimaryFilterChanged;

  /// Whether to combine primary filters with regular filters
  /// When true (default), primary filters are added to the filters map
  /// When false, primary filters are tracked separately
  final bool combineFiltersAndPrimaryFilters;

  /// Whether to show export button
  final bool showExportButton;

  /// Export configuration
  final ExportConfig? exportConfig;

  /// Company logo for PDF export
  final Uint8List? companyLogo;

  /// Callback when export completes
  final void Function(Uint8List data, String filename)? onExportComplete;

  const VooDataGridStateless({
    super.key,
    required this.state,
    required this.columns,
    this.onPageChanged,
    this.onPageSizeChanged,
    this.onFilterChanged,
    this.onFiltersCleared,
    this.onToggleFilters,
    this.onSortChanged,
    this.onSortsCleared,
    this.onRowSelected,
    this.onRowDeselected,
    this.onSelectAll,
    this.onDeselectAll,
    this.onRefresh,
    this.showPagination = true,
    this.showToolbar = true,
    this.toolbarActions,
    this.emptyStateWidget,
    this.loadingWidget,
    this.errorBuilder,
    this.onError,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowHover,
    this.decoration,
    this.theme,
    this.displayMode = VooDataGridDisplayMode.auto,
    this.cardBuilder,
    this.mobilePriorityColumns,
    this.alwaysShowVerticalScrollbar = false,
    this.alwaysShowHorizontalScrollbar = false,
    this.primaryFilters,
    this.selectedPrimaryFilter,
    this.showPrimaryFilters = false,
    this.onPrimaryFilterChanged,
    this.combineFiltersAndPrimaryFilters = true,
    this.showExportButton = false,
    this.exportConfig,
    this.companyLogo,
    this.onExportComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Create a controller wrapper that bridges state and callbacks
    final controller = _StateBasedController<T>(
      state: state,
      columns: columns,
      onPageChanged: onPageChanged,
      onPageSizeChanged: onPageSizeChanged,
      onFilterChanged: onFilterChanged,
      onFiltersCleared: onFiltersCleared,
      onToggleFilters: onToggleFilters,
      onSortChanged: onSortChanged,
      onSortsCleared: onSortsCleared,
      onRowSelected: onRowSelected,
      onRowDeselected: onRowDeselected,
      onSelectAll: onSelectAll,
      onDeselectAll: onDeselectAll,
      onRefresh: onRefresh,
    );

    // Delegate to the core organism
    return DataGridCore<T>(
      controller: controller,
      showPagination: showPagination,
      showToolbar: showToolbar,
      toolbarActions: toolbarActions,
      emptyStateWidget: emptyStateWidget,
      loadingWidget: loadingWidget,
      errorBuilder: errorBuilder,
      onError: onError,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowHover: onRowHover,
      decoration: decoration,
      theme: theme,
      displayMode: displayMode,
      cardBuilder: cardBuilder,
      mobilePriorityColumns: mobilePriorityColumns,
      alwaysShowVerticalScrollbar: alwaysShowVerticalScrollbar,
      alwaysShowHorizontalScrollbar: alwaysShowHorizontalScrollbar,
      primaryFilters: primaryFilters,
      selectedPrimaryFilter: selectedPrimaryFilter,
      onFilterChanged: onFilterChanged,
      onPrimaryFilterChanged: onPrimaryFilterChanged,
      showPrimaryFilters: showPrimaryFilters,
      combineFiltersAndPrimaryFilters: combineFiltersAndPrimaryFilters,
      onRefresh: onRefresh,
      showExportButton: showExportButton,
      exportConfig: exportConfig,
      companyLogo: companyLogo,
      onExportComplete: onExportComplete,
    );
  }
}

/// Internal controller that wraps state and callbacks
/// to work with existing VooDataGrid components
class _StateBasedController<T> extends VooDataGridController<T> {
  final VooDataGridState<T> _state;
  final List<VooDataColumn<T>> _columns;
  final void Function(int page)? _onPageChanged;
  final void Function(int pageSize)? _onPageSizeChanged;
  final void Function(String field, VooDataFilter? filter)? _onFilterChanged;
  final VoidCallback? _onFiltersCleared;
  final VoidCallback? _onToggleFilters;
  final void Function(String field, VooSortDirection direction)? _onSortChanged;
  final VoidCallback? _onSortsCleared;
  final void Function(T row)? _onRowSelected;
  final void Function(T row)? _onRowDeselected;
  final VoidCallback? _onSelectAll;
  final VoidCallback? _onDeselectAll;
  final VoidCallback? _onRefresh;

  _StateBasedController({
    required VooDataGridState<T> state,
    required List<VooDataColumn<T>> columns,
    void Function(int page)? onPageChanged,
    void Function(int pageSize)? onPageSizeChanged,
    void Function(String field, VooDataFilter? filter)? onFilterChanged,
    VoidCallback? onFiltersCleared,
    VoidCallback? onToggleFilters,
    void Function(String field, VooSortDirection direction)? onSortChanged,
    VoidCallback? onSortsCleared,
    void Function(T row)? onRowSelected,
    void Function(T row)? onRowDeselected,
    VoidCallback? onSelectAll,
    VoidCallback? onDeselectAll,
    VoidCallback? onRefresh,
  }) : _state = state,
       _columns = columns,
       _onPageChanged = onPageChanged,
       _onPageSizeChanged = onPageSizeChanged,
       _onFilterChanged = onFilterChanged,
       _onFiltersCleared = onFiltersCleared,
       _onToggleFilters = onToggleFilters,
       _onSortChanged = onSortChanged,
       _onSortsCleared = onSortsCleared,
       _onRowSelected = onRowSelected,
       _onRowDeselected = onRowDeselected,
       _onSelectAll = onSelectAll,
       _onDeselectAll = onDeselectAll,
       _onRefresh = onRefresh,
       super(dataSource: _DummyDataSource<T>(), columns: columns);

  // Override all getters to return state values
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

  bool get filtersVisible => _state.filtersVisible;

  @override
  bool get showFilters => _state.filtersVisible;

  @override
  List<VooDataColumn<T>> get columns => _columns;

  int get totalPages => _state.totalPages;

  // Cache the dataSource instance
  _DummyDataSource<T>? _dataSource;

  // Override dataSource to provide state data
  @override
  VooDataGridSource<T> get dataSource {
    if (_dataSource == null) {
      _dataSource = _DummyDataSource<T>();
      _dataSource!._setController = this;
    }
    // Set the state data on the dummy source
    _dataSource!._setState = _state;
    return _dataSource!;
  }

  // Override methods required by header and row components
  @override
  VooSortDirection getSortDirection(String field) {
    final sort = sorts.firstWhere(
      (s) => s.field == field,
      orElse: () => VooColumnSort(field: field, direction: VooSortDirection.none),
    );
    return sort.direction;
  }

  // Override action methods to call callbacks
  void changePage(int page) {
    _onPageChanged?.call(page);
  }

  void changePageSize(int pageSize) {
    _onPageSizeChanged?.call(pageSize);
  }

  void applyFilter(String field, VooDataFilter? filter) {
    _onFilterChanged?.call(field, filter);
  }

  void clearFilters() {
    _onFiltersCleared?.call();
  }

  @override
  void sortColumn(String field) {
    final existingSort = sorts.firstWhere(
      (s) => s.field == field,
      orElse: () => VooColumnSort(field: field, direction: VooSortDirection.none),
    );

    final newDirection = switch (existingSort.direction) {
      VooSortDirection.none => VooSortDirection.ascending,
      VooSortDirection.ascending => VooSortDirection.descending,
      VooSortDirection.descending => VooSortDirection.none,
    };

    _onSortChanged?.call(field, newDirection);
  }

  void clearSorts() {
    _onSortsCleared?.call();
  }

  void toggleRowSelection(T row) {
    if (selectedRows.contains(row)) {
      _onRowDeselected?.call(row);
    } else {
      _onRowSelected?.call(row);
    }
  }

  void selectAll() {
    _onSelectAll?.call();
  }

  void deselectAll() {
    _onDeselectAll?.call();
  }

  @override
  void toggleFilters() {
    _onToggleFilters?.call();
  }

  void refresh() {
    _onRefresh?.call();
  }
}

/// Dummy data source for compatibility
class _DummyDataSource<T> extends VooDataGridSource<T> {
  VooDataGridState<T>? _state;
  _StateBasedController<T>? _controller;

  _DummyDataSource() : super(mode: VooDataGridMode.remote);

  set _setState(VooDataGridState<T> state) {
    _state = state;
  }

  set _setController(_StateBasedController<T> controller) {
    _controller = controller;
  }

  @override
  Future<void> loadData() async {
    // No-op: Data is already provided via state
    // The parent class expects loadData to notify listeners
    notifyListeners();
  }

  @override
  List<T> get rows => _state?.rows ?? [];

  @override
  int get totalRows => _state?.totalRows ?? 0;

  @override
  int get currentPage => _state?.currentPage ?? 0;

  @override
  int get pageSize => _state?.pageSize ?? 20;

  @override
  bool get isLoading => _state?.isLoading ?? false;

  @override
  String? get error => _state?.error;

  @override
  Map<String, VooDataFilter> get filters => _state?.filters ?? {};

  @override
  List<VooColumnSort> get sorts => _state?.sorts ?? [];

  @override
  Set<T> get selectedRows => _state?.selectedRows ?? {};

  @override
  VooSelectionMode get selectionMode => _state?.selectionMode ?? VooSelectionMode.none;

  @override
  List<T> get allRows => _state?.rows ?? [];

  @override
  int get totalPages => _state?.totalPages ?? 1;

  @override
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async =>
      // This is never called as the state is managed externally
      VooDataGridResponse<T>(rows: _state?.rows ?? [], totalRows: _state?.totalRows ?? 0, page: page, pageSize: pageSize);

  @override
  void applyFilter(String field, VooDataFilter? filter) {
    // Forward to controller callback
    _controller?.applyFilter(field, filter);
  }

  @override
  void applySort(String field, VooSortDirection direction) {
    // Sorts are managed by the state externally - would be handled by controller
  }

  @override
  void clearFilters() {
    // Forward to controller callback
    _controller?.clearFilters();
  }

  @override
  void clearSorts() {
    // Sorts are managed by the state externally - would be handled by controller
  }

  @override
  void selectAll() {
    // Forward to controller callback
    _controller?.selectAll();
  }

  @override
  void clearSelection() {
    // Forward to controller callback
    _controller?.deselectAll();
  }

  @override
  void changePage(int page) {
    // Forward to controller callback
    _controller?.changePage(page);
  }

  @override
  void changePageSize(int pageSize) {
    // Forward to controller callback
    _controller?.changePageSize(pageSize);
  }

  @override
  void toggleRowSelection(T row) {
    // Forward to controller callback
    _controller?.toggleRowSelection(row);
  }
}
