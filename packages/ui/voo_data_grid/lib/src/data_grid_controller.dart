import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/data_grid_column.dart';
import 'package:voo_data_grid/src/data_grid_source.dart';
import 'package:voo_data_grid/src/models/data_grid_constraints.dart';
import 'package:voo_data_grid/src/utils/synchronized_scroll_controller.dart';

/// Controller for VooDataGrid
/// 
/// Generic type parameter T represents the row data type.
/// Use dynamic if working with untyped Map data.
class VooDataGridController<T> extends ChangeNotifier {
  /// Data source
  final VooDataGridSource<T> dataSource;

  /// Columns configuration
  List<VooDataColumn<T>> _columns = [];
  List<VooDataColumn<T>> get columns => _columns;

  /// Visible columns (filtered by visible property)
  List<VooDataColumn<T>> get visibleColumns => _columns.where((col) => col.visible).toList();

  /// Frozen columns
  List<VooDataColumn<T>> get frozenColumns => visibleColumns.where((col) => col.frozen).toList();

  /// Scrollable columns
  List<VooDataColumn<T>> get scrollableColumns => visibleColumns.where((col) => !col.frozen).toList();

  /// Column widths map
  final Map<String, double> _columnWidths = {};

  /// Synchronized horizontal scroll controller for header, filter and body
  final SynchronizedScrollController horizontalSyncController = SynchronizedScrollController();
  
  /// Horizontal scroll controller for header
  final ScrollController horizontalScrollController = ScrollController();
  
  /// Horizontal scroll controller for filter row
  final ScrollController filterHorizontalScrollController = ScrollController();
  
  /// Horizontal scroll controller for body
  final ScrollController bodyHorizontalScrollController = ScrollController();

  /// Vertical scroll controller
  final ScrollController verticalScrollController = ScrollController();

  /// Row height
  double _rowHeight = 48.0;
  double get rowHeight => _rowHeight;

  /// Header height
  double _headerHeight = 56.0;
  double get headerHeight => _headerHeight;

  /// Show column filters
  bool _showFilters = false;
  bool get showFilters => _showFilters;

  /// Filter height
  double _filterHeight = 56.0;
  double get filterHeight => _filterHeight;

  /// Grid lines visibility
  bool _showGridLines = true;
  bool get showGridLines => _showGridLines;

  /// Alternating row colors
  bool _alternatingRowColors = false;
  bool get alternatingRowColors => _alternatingRowColors;

  /// Hover effect
  bool _showHoverEffect = true;
  bool get showHoverEffect => _showHoverEffect;

  /// Column resizing enabled
  bool _columnResizable = true;
  bool get columnResizable => _columnResizable;

  /// Column reordering enabled
  bool _columnReorderable = false;
  bool get columnReorderable => _columnReorderable;

  /// Data grid constraints
  VooDataGridConstraints _constraints = VooDataGridConstraints.singleSort;
  VooDataGridConstraints get constraints => _constraints;

  /// Field prefix for nested properties (e.g., "Site" for "Site.SiteNumber")
  String? _fieldPrefix;
  String? get fieldPrefix => _fieldPrefix;

  /// Constructor
  VooDataGridController({
    required this.dataSource,
    List<VooDataColumn<T>>? columns,
    double? rowHeight,
    double? headerHeight,
    double? filterHeight,
    bool? showFilters,
    bool? showGridLines,
    bool? alternatingRowColors,
    bool? showHoverEffect,
    bool? columnResizable,
    bool? columnReorderable,
    VooDataGridConstraints? constraints,
    String? fieldPrefix,
  }) {
    _columns = columns ?? [];
    _rowHeight = rowHeight ?? 48.0;
    _headerHeight = headerHeight ?? 56.0;
    _filterHeight = filterHeight ?? 56.0;
    _showFilters = showFilters ?? false;
    _showGridLines = showGridLines ?? true;
    _alternatingRowColors = alternatingRowColors ?? false;
    _showHoverEffect = showHoverEffect ?? true;
    _columnResizable = columnResizable ?? true;
    _columnReorderable = columnReorderable ?? false;
    _constraints = constraints ?? VooDataGridConstraints.singleSort;
    _fieldPrefix = fieldPrefix;

    // Listen to data source changes
    dataSource.addListener(_onDataSourceChanged);
    
    // Register scroll controllers for synchronization
    horizontalSyncController.registerController(horizontalScrollController);
    horizontalSyncController.registerController(filterHorizontalScrollController);
    horizontalSyncController.registerController(bodyHorizontalScrollController);
  }

  /// Set columns
  void setColumns(List<VooDataColumn<T>> columns) {
    _columns = columns;
    notifyListeners();
  }

  /// Update column
  void updateColumn(String field, VooDataColumn<T> column) {
    final index = _columns.indexWhere((col) => col.field == field);
    if (index >= 0) {
      _columns[index] = column;
      notifyListeners();
    }
  }

  /// Toggle column visibility
  void toggleColumnVisibility(String field) {
    final index = _columns.indexWhere((col) => col.field == field);
    if (index >= 0) {
      _columns[index] = _columns[index].copyWith(
        visible: !_columns[index].visible,
      );
      notifyListeners();
    }
  }

  /// Set visible columns for responsive behavior
  void setVisibleColumns(List<VooDataColumn<T>> visibleColumns) {
    for (var column in _columns) {
      final shouldBeVisible = visibleColumns.any((col) => col.field == column.field);
      if (column.visible != shouldBeVisible) {
        final index = _columns.indexWhere((col) => col.field == column.field);
        if (index >= 0) {
          _columns[index] = _columns[index].copyWith(visible: shouldBeVisible);
        }
      }
    }
    notifyListeners();
  }

  /// Resize column
  void resizeColumn(String field, double width) {
    _columnWidths[field] = width;
    notifyListeners();
  }

  /// Get column width
  double getColumnWidth(VooDataColumn<T> column) {
    if (_columnWidths.containsKey(column.field)) {
      return _columnWidths[column.field]!;
    }
    return column.width ?? _calculateFlexWidth(column);
  }

  /// Calculate flex width for column
  double _calculateFlexWidth(VooDataColumn<T> column) {
    // This will be calculated based on available space
    // For now, return a default width
    return 150.0;
  }

  /// Reorder columns
  void reorderColumns(int oldIndex, int newIndex) {
    if (!_columnReorderable) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final column = _columns.removeAt(oldIndex);
    _columns.insert(newIndex, column);
    notifyListeners();
  }

  /// Toggle filters visibility
  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  /// Set row height
  void setRowHeight(double height) {
    _rowHeight = height;
    notifyListeners();
  }

  /// Set header height
  void setHeaderHeight(double height) {
    _headerHeight = height;
    notifyListeners();
  }

  /// Set filter height
  void setFilterHeight(double height) {
    _filterHeight = height;
    notifyListeners();
  }

  /// Toggle grid lines
  void toggleGridLines() {
    _showGridLines = !_showGridLines;
    notifyListeners();
  }

  /// Toggle alternating row colors
  void toggleAlternatingRowColors() {
    _alternatingRowColors = !_alternatingRowColors;
    notifyListeners();
  }

  /// Toggle hover effect
  void toggleHoverEffect() {
    _showHoverEffect = !_showHoverEffect;
    notifyListeners();
  }

  /// Set field prefix for nested properties
  void setFieldPrefix(String? prefix) {
    _fieldPrefix = prefix;
    notifyListeners();
  }

  /// Sort column
  void sortColumn(String field) {
    final column = _columns.firstWhere((col) => col.field == field);
    if (!column.sortable) return;

    // Check if sorting is allowed
    if (!_constraints.allowSorting) return;

    final currentSort = dataSource.sorts.firstWhere(
      (sort) => sort.field == field,
      orElse: () => VooColumnSort(
        field: field,
        direction: VooSortDirection.none,
      ),
    );

    VooSortDirection newDirection;
    switch (currentSort.direction) {
      case VooSortDirection.none:
        newDirection = VooSortDirection.ascending;
        break;
      case VooSortDirection.ascending:
        newDirection = VooSortDirection.descending;
        break;
      case VooSortDirection.descending:
        newDirection = VooSortDirection.none;
        break;
    }

    // If single-sort mode is enabled, clear all other sorts
    if (!_constraints.allowMultiSort || _constraints.clearSortsOnNewSort) {
      dataSource.clearSorts();
    }

    // Check max sort columns constraint
    if (_constraints.maxSortColumns > 0 && 
        dataSource.sorts.length >= _constraints.maxSortColumns &&
        currentSort.direction == VooSortDirection.none) {
      // Remove the oldest sort if we're at the limit
      if (dataSource.sorts.isNotEmpty) {
        dataSource.sorts.removeAt(0);
      }
    }

    dataSource.applySort(field, newDirection);
  }

  /// Get sort direction for column
  VooSortDirection getSortDirection(String field) {
    final sort = dataSource.sorts.firstWhere(
      (sort) => sort.field == field,
      orElse: () => VooColumnSort(
        field: field,
        direction: VooSortDirection.none,
      ),
    );
    return sort.direction;
  }

  /// Data source changed handler
  void _onDataSourceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    dataSource.removeListener(_onDataSourceChanged);
    horizontalSyncController.dispose();
    horizontalScrollController.dispose();
    filterHorizontalScrollController.dispose();
    bodyHorizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.dispose();
  }
}
