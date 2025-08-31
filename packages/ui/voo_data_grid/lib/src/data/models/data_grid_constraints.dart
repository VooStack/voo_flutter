/// Constraints for VooDataGrid behavior
class VooDataGridConstraints {
  /// Maximum number of columns that can be sorted simultaneously
  /// Set to 1 for single column sorting only
  final int maxSortColumns;

  /// Maximum number of filters that can be applied simultaneously
  /// Set to null for unlimited filters
  final int? maxActiveFilters;

  /// Whether to allow multi-column sorting
  final bool allowMultiSort;

  /// Whether to allow column reordering
  final bool allowColumnReordering;

  /// Whether to allow column resizing
  final bool allowColumnResizing;

  /// Whether to allow row selection
  final bool allowRowSelection;

  /// Maximum number of rows that can be selected
  /// Set to null for unlimited selection
  final int? maxSelectedRows;

  /// Whether to allow export functionality
  final bool allowExport;

  /// Whether to allow column filtering
  final bool allowFiltering;

  /// Whether to allow column sorting
  final bool allowSorting;

  /// Whether to clear other sorts when a new sort is applied
  final bool clearSortsOnNewSort;

  /// Whether to clear filters when data source changes
  final bool clearFiltersOnDataChange;

  /// Minimum column width in pixels
  final double minColumnWidth;

  /// Maximum column width in pixels
  final double maxColumnWidth;

  /// Whether to allow horizontal scrolling
  final bool allowHorizontalScroll;

  /// Whether to allow vertical scrolling  
  final bool allowVerticalScroll;

  /// Whether to allow pagination
  final bool allowPagination;

  /// Available page sizes for pagination
  final List<int> availablePageSizes;

  /// Default page size
  final int defaultPageSize;

  const VooDataGridConstraints({
    this.maxSortColumns = 1,
    this.maxActiveFilters,
    this.allowMultiSort = false,
    this.allowColumnReordering = true,
    this.allowColumnResizing = true,
    this.allowRowSelection = true,
    this.maxSelectedRows,
    this.allowExport = true,
    this.allowFiltering = true,
    this.allowSorting = true,
    this.clearSortsOnNewSort = true,
    this.clearFiltersOnDataChange = false,
    this.minColumnWidth = 50.0,
    this.maxColumnWidth = 500.0,
    this.allowHorizontalScroll = true,
    this.allowVerticalScroll = true,
    this.allowPagination = true,
    this.availablePageSizes = const [10, 20, 50, 100],
    this.defaultPageSize = 20,
  });

  /// Creates a copy of this constraints with the given fields replaced
  VooDataGridConstraints copyWith({
    int? maxSortColumns,
    int? maxActiveFilters,
    bool? allowMultiSort,
    bool? allowColumnReordering,
    bool? allowColumnResizing,
    bool? allowRowSelection,
    int? maxSelectedRows,
    bool? allowExport,
    bool? allowFiltering,
    bool? allowSorting,
    bool? clearSortsOnNewSort,
    bool? clearFiltersOnDataChange,
    double? minColumnWidth,
    double? maxColumnWidth,
    bool? allowHorizontalScroll,
    bool? allowVerticalScroll,
    bool? allowPagination,
    List<int>? availablePageSizes,
    int? defaultPageSize,
  }) => VooDataGridConstraints(
      maxSortColumns: maxSortColumns ?? this.maxSortColumns,
      maxActiveFilters: maxActiveFilters ?? this.maxActiveFilters,
      allowMultiSort: allowMultiSort ?? this.allowMultiSort,
      allowColumnReordering: allowColumnReordering ?? this.allowColumnReordering,
      allowColumnResizing: allowColumnResizing ?? this.allowColumnResizing,
      allowRowSelection: allowRowSelection ?? this.allowRowSelection,
      maxSelectedRows: maxSelectedRows ?? this.maxSelectedRows,
      allowExport: allowExport ?? this.allowExport,
      allowFiltering: allowFiltering ?? this.allowFiltering,
      allowSorting: allowSorting ?? this.allowSorting,
      clearSortsOnNewSort: clearSortsOnNewSort ?? this.clearSortsOnNewSort,
      clearFiltersOnDataChange: clearFiltersOnDataChange ?? this.clearFiltersOnDataChange,
      minColumnWidth: minColumnWidth ?? this.minColumnWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      allowHorizontalScroll: allowHorizontalScroll ?? this.allowHorizontalScroll,
      allowVerticalScroll: allowVerticalScroll ?? this.allowVerticalScroll,
      allowPagination: allowPagination ?? this.allowPagination,
      availablePageSizes: availablePageSizes ?? this.availablePageSizes,
      defaultPageSize: defaultPageSize ?? this.defaultPageSize,
    );

  /// Preset for single sort mode (most common)
  static const VooDataGridConstraints singleSort = VooDataGridConstraints(
    
  );

  /// Preset for multi-sort mode
  static const VooDataGridConstraints multiSort = VooDataGridConstraints(
    maxSortColumns: 3,
    allowMultiSort: true,
    clearSortsOnNewSort: false,
  );

  /// Preset for read-only grid
  static const VooDataGridConstraints readOnly = VooDataGridConstraints(
    allowColumnReordering: false,
    allowColumnResizing: false,
    allowRowSelection: false,
    allowExport: false,
  );

  /// Preset for minimal grid
  static const VooDataGridConstraints minimal = VooDataGridConstraints(
    allowColumnReordering: false,
    allowColumnResizing: false,
    allowFiltering: false,
    allowSorting: false,
    allowPagination: false,
    allowExport: false,
  );

  /// Preset for mobile-optimized grid
  static const VooDataGridConstraints mobile = VooDataGridConstraints(
    allowColumnReordering: false,
    allowColumnResizing: false,
    minColumnWidth: 80.0,
    maxColumnWidth: 200.0,
    defaultPageSize: 10,
    availablePageSizes: [5, 10, 20],
  );
}