import 'package:flutter/material.dart';

import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_data_grid/src/presentation/widgets/organisms/card_view_organism.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/filter_chips_organism.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/grid_content_organism.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/responsive_toolbar_organism.dart';

/// A state-agnostic data grid widget that works with any state management solution
///
/// This widget accepts state directly and callbacks for state changes,
/// making it compatible with Cubit, BLoC, Riverpod, GetX, or any other
/// state management solution.
///
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class VooDataGridStateless<T> extends StatefulWidget {
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
  });

  @override
  State<VooDataGridStateless<T>> createState() => _VooDataGridStatelessState<T>();
}

class _VooDataGridStatelessState<T> extends State<VooDataGridStateless<T>> {
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;
  late VooDataGridTheme _theme;
  VooDataGridDisplayMode _effectiveDisplayMode = VooDataGridDisplayMode.auto;
  VooDataGridDisplayMode? _userSelectedMode;

  @override
  void initState() {
    super.initState();
    _verticalScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  // Responsive helpers
  bool _isMobile(double width) => width < VooDataGridBreakpoints.mobile;
  bool _isTablet(double width) => width >= VooDataGridBreakpoints.mobile && width < VooDataGridBreakpoints.tablet;

  VooDataGridDisplayMode _getEffectiveDisplayMode(double width) {
    if (_userSelectedMode != null) return _userSelectedMode!;
    if (widget.displayMode != VooDataGridDisplayMode.auto) return widget.displayMode;
    return _isMobile(width) ? VooDataGridDisplayMode.cards : VooDataGridDisplayMode.table;
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooDataGridTheme.fromContext(context);

    // Create a temporary controller from the state for compatibility
    // with existing VooDataGrid implementation
    final controller = _StateBasedController<T>(
      state: widget.state,
      columns: widget.columns,
      onPageChanged: widget.onPageChanged,
      onPageSizeChanged: widget.onPageSizeChanged,
      onFilterChanged: widget.onFilterChanged,
      onFiltersCleared: widget.onFiltersCleared,
      onToggleFilters: widget.onToggleFilters,
      onSortChanged: widget.onSortChanged,
      onSortsCleared: widget.onSortsCleared,
      onRowSelected: widget.onRowSelected,
      onRowDeselected: widget.onRowDeselected,
      onSelectAll: widget.onSelectAll,
      onDeselectAll: widget.onDeselectAll,
      onRefresh: widget.onRefresh,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        _effectiveDisplayMode = _getEffectiveDisplayMode(constraints.maxWidth);

        return DecoratedBox(
          decoration: widget.decoration ??
              BoxDecoration(
                border: Border.all(color: _theme.borderColor),
                borderRadius: BorderRadius.circular(design.radiusMd),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showToolbar) 
                Column(
                  children: [
                    ResponsiveToolbarOrganism<T>(
                      width: constraints.maxWidth,
                      state: widget.state,
                      theme: _theme,
                      displayMode: _effectiveDisplayMode,
                      userSelectedMode: _userSelectedMode,
                      onDisplayModeChanged: (mode) {
                        setState(() {
                          _userSelectedMode = mode;
                        });
                      },
                      onToggleFilters: controller.toggleFilters,
                      onClearFilters: controller.clearFilters,
                      onShowMobileFilterSheet: (context, _) => _showMobileFilterSheet(context, controller),
                      onRefresh: widget.onRefresh,
                      toolbarActions: widget.toolbarActions,
                    ),
                    if (widget.state.filters.isNotEmpty) 
                      FilterChipsOrganism<T>(
                        filters: widget.state.filters,
                        columns: widget.columns,
                        theme: _theme,
                        onRemoveFilter: (field) => controller.applyFilter(field, null),
                      ),
                  ],
                ),
              Expanded(
                child: _effectiveDisplayMode == VooDataGridDisplayMode.cards
                    ? CardViewOrganism<T>(
                        state: widget.state,
                        columns: widget.columns,
                        theme: _theme,
                        verticalScrollController: _verticalScrollController,
                        loadingWidget: widget.loadingWidget,
                        emptyStateWidget: widget.emptyStateWidget,
                        errorBuilder: widget.errorBuilder,
                        cardBuilder: widget.cardBuilder,
                        mobilePriorityColumns: widget.mobilePriorityColumns,
                        onRowTap: widget.onRowTap,
                        onRowDoubleTap: widget.onRowDoubleTap,
                      )
                    : GridContentOrganism<T>(
                        state: widget.state,
                        controller: controller,
                        theme: _theme,
                        verticalScrollController: _verticalScrollController,
                        loadingWidget: widget.loadingWidget,
                        emptyStateWidget: widget.emptyStateWidget,
                        errorBuilder: widget.errorBuilder,
                        onRowTap: widget.onRowTap,
                        onRowDoubleTap: widget.onRowDoubleTap,
                        onRowHover: widget.onRowHover,
                        alwaysShowVerticalScrollbar: widget.alwaysShowVerticalScrollbar,
                      ),
              ),
              if (widget.showPagination && !widget.state.isLoading)
                VooDataGridPagination(
                  currentPage: widget.state.currentPage,
                  totalPages: widget.state.totalPages,
                  pageSize: widget.state.pageSize,
                  totalRows: widget.state.totalRows,
                  onPageChanged: controller.changePage,
                  onPageSizeChanged: controller.changePageSize,
                  theme: _theme,
                ),
            ],
          ),
        );
      },
    );
  }


  void _showMobileFilterSheet(
    BuildContext context,
    _StateBasedController<T> controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) => Column(
              children: [
                AppBar(
                  title: const Text('Filters'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        controller.clearFilters();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: widget.columns
                        .where((c) => c.filterable)
                        .map(
                          (column) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: column.label,
                                suffixIcon: widget.state.filters[column.field] != null
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () => controller.applyFilter(column.field, null),
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  controller.applyFilter(column.field, null);
                                } else {
                                  controller.applyFilter(
                                    column.field,
                                    VooDataFilter(
                                      value: value,
                                      operator: VooFilterOperator.contains,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
        ),
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
  })  : _state = state,
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
  List<VooDataColumn<T>> get columns => _columns;

  int get totalPages => _state.totalPages;

  // Cache the dataSource instance
  _DummyDataSource<T>? _dataSource;

  // Override dataSource to provide state data
  @override
  VooDataGridSource<T> get dataSource {
    if (_dataSource == null) {
      _dataSource = _DummyDataSource<T>();
      _dataSource!._setController(this);
    }
    // Set the state data on the dummy source
    _dataSource!._setState(_state);
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

  void _setState(VooDataGridState<T> state) {
    _state = state;
  }

  void _setController(_StateBasedController<T> controller) {
    _controller = controller;
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
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // This is never called as the state is managed externally
    return VooDataGridResponse<T>(
      rows: _state?.rows ?? [],
      totalRows: _state?.totalRows ?? 0,
      page: page,
      pageSize: pageSize,
    );
  }

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
}
