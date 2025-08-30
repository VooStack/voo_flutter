import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A state-agnostic data grid widget that works with any state management solution
///
/// This widget accepts state directly and callbacks for state changes,
/// making it compatible with Cubit, BLoC, Riverpod, GetX, or any other
/// state management solution.
///
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class StatelessVooDataGrid<T> extends StatelessWidget {
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

  const StatelessVooDataGrid({
    super.key,
    required this.state,
    required this.columns,
    this.onPageChanged,
    this.onPageSizeChanged,
    this.onFilterChanged,
    this.onFiltersCleared,
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
  Widget build(BuildContext context) {
    // Create a temporary controller from the state for compatibility
    // with existing VooDataGrid implementation
    final controller = _StateBasedController<T>(
      state: state,
      columns: columns,
      onPageChanged: onPageChanged,
      onPageSizeChanged: onPageSizeChanged,
      onFilterChanged: onFilterChanged,
      onFiltersCleared: onFiltersCleared,
      onSortChanged: onSortChanged,
      onSortsCleared: onSortsCleared,
      onRowSelected: onRowSelected,
      onRowDeselected: onRowDeselected,
      onSelectAll: onSelectAll,
      onDeselectAll: onDeselectAll,
      onRefresh: onRefresh,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = _shouldUseMobileLayout(constraints);
        final bool showFilters = state.filtersVisible;

        if (isMobile) {
          return _buildMobileLayout(context, controller, showFilters);
        } else {
          return _buildDesktopLayout(context, controller, showFilters);
        }
      },
    );
  }

  bool _shouldUseMobileLayout(BoxConstraints constraints) {
    if (displayMode == VooDataGridDisplayMode.table) return false;
    if (displayMode == VooDataGridDisplayMode.cards) return true;
    return constraints.maxWidth < VooDataGridBreakpoints.mobile;
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    _StateBasedController<T> controller,
    bool showFilters,
  ) {
    final effectiveTheme = theme ?? VooDataGridTheme.fromContext(context);

    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showToolbar) _buildToolbar(context, controller),
          Expanded(
            child: _buildDataTable(context, controller, effectiveTheme, showFilters),
          ),
          if (showPagination && !state.isLoading) _buildPagination(context, controller, effectiveTheme),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    _StateBasedController<T> controller,
    bool showFilters,
  ) {
    final effectiveTheme = theme ?? VooDataGridTheme.fromContext(context);

    return DecoratedBox(
      decoration: decoration ?? const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showToolbar) _buildToolbar(context, controller),
          if (showFilters) _buildMobileFilters(context, controller),
          Expanded(
            child: _buildMobileCards(context, controller, effectiveTheme),
          ),
          if (showPagination && !state.isLoading) _buildPagination(context, controller, effectiveTheme),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, _StateBasedController<T> controller) => Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (state.selectionMode != VooSelectionMode.none) Text('${state.selectedRows.length} selected'),
            const Spacer(),
            if (toolbarActions != null) ...toolbarActions!,
            IconButton(
              icon: Icon(
                state.filtersVisible ? Icons.filter_list_off : Icons.filter_list,
              ),
              onPressed: controller.toggleFilters,
            ),
            if (onRefresh != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh,
              ),
          ],
        ),
      );

  Widget _buildDataTable(
    BuildContext context,
    _StateBasedController<T> controller,
    VooDataGridTheme effectiveTheme,
    bool showFilters,
  ) {
    if (state.isLoading && loadingWidget != null) {
      return Center(child: loadingWidget);
    }

    if (state.error != null && errorBuilder != null) {
      return Center(child: errorBuilder!(state.error!));
    }

    if (state.rows.isEmpty && emptyStateWidget != null) {
      return Center(child: emptyStateWidget);
    }

    return Column(
      children: [
        VooDataGridHeader<T>(
          controller: controller,
          theme: effectiveTheme,
          onSort: controller.sortColumn,
        ),
        if (showFilters)
          VooDataGridFilterRow<T>(
            controller: controller,
            theme: effectiveTheme,
          ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: alwaysShowVerticalScrollbar,
            child: ListView.builder(
              itemCount: state.rows.length,
              itemBuilder: (context, index) {
                final row = state.rows[index];
                final isSelected = state.selectedRows.contains(row);

                return VooDataGridRow<T>(
                  row: row,
                  index: index,
                  controller: controller,
                  theme: effectiveTheme,
                  isSelected: isSelected,
                  onTap: onRowTap != null ? () => onRowTap!(row) : null,
                  onDoubleTap: onRowDoubleTap != null ? () => onRowDoubleTap!(row) : null,
                  onHover: (hover) => onRowHover?.call(row),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFilters(
    BuildContext context,
    _StateBasedController<T> controller,
  ) =>
      Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: columns
              .where((c) => c.filterable)
              .map(
                (column) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: column.label,
                      suffixIcon: state.filters[column.field] != null
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
      );

  Widget _buildMobileCards(
    BuildContext context,
    _StateBasedController<T> controller,
    VooDataGridTheme effectiveTheme,
  ) {
    if (state.isLoading && loadingWidget != null) {
      return Center(child: loadingWidget);
    }

    if (state.error != null && errorBuilder != null) {
      return Center(child: errorBuilder!(state.error!));
    }

    if (state.rows.isEmpty && emptyStateWidget != null) {
      return Center(child: emptyStateWidget);
    }

    return ListView.builder(
      itemCount: state.rows.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final row = state.rows[index];

        if (cardBuilder != null) {
          return cardBuilder!(context, row, index);
        }

        // Default card layout
        final priorityColumns = mobilePriorityColumns != null ? columns.where((c) => mobilePriorityColumns!.contains(c.field)) : columns.take(3);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: onRowTap != null ? () => onRowTap!(row) : null,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: priorityColumns.map((column) {
                  final value = _getCellValue(row, column);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${column.label}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            column.valueFormatter?.call(value) ?? value?.toString() ?? '',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination(
    BuildContext context,
    _StateBasedController<T> controller,
    VooDataGridTheme effectiveTheme,
  ) =>
      VooDataGridPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        pageSize: state.pageSize,
        totalRows: state.totalRows,
        onPageChanged: controller.changePage,
        onPageSizeChanged: controller.changePageSize,
        theme: effectiveTheme,
      );

  dynamic _getCellValue(T row, VooDataColumn<T> column) {
    if (column.valueGetter != null) {
      return column.valueGetter!(row);
    }

    if (row is Map) {
      return row[column.field];
    }

    return null;
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
        _onSortChanged = onSortChanged,
        _onSortsCleared = onSortsCleared,
        _onRowSelected = onRowSelected,
        _onRowDeselected = onRowDeselected,
        _onSelectAll = onSelectAll,
        _onDeselectAll = onDeselectAll,
        _onRefresh = onRefresh,
        super(dataSource: _DummyDataSource<T>());

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

  void toggleFilters() {
    // This would need to be handled by the state management solution
    // For now, we can't toggle filters without a stateful wrapper
  }

  void refresh() {
    _onRefresh?.call();
  }
}

/// Dummy data source for compatibility
class _DummyDataSource<T> extends VooDataGridSource<T> {
  _DummyDataSource() : super(mode: VooDataGridMode.remote);

  @override
  Future<VooDataGridResponse<T>> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // This is never called as the state is managed externally
    return VooDataGridResponse<T>(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}
