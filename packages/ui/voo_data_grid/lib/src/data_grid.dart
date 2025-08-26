import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data_grid_controller.dart';
import 'data_grid_header.dart';
import 'data_grid_row.dart';
import 'data_grid_filter.dart';
import 'data_grid_pagination.dart';
import 'data_grid_column.dart';
import 'data_grid_source.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Display mode for the data grid
enum VooDataGridDisplayMode {
  /// Standard table layout
  table,
  /// Card-based layout for mobile
  cards,
  /// Auto-detect based on screen size
  auto,
}

/// Breakpoints for responsive behavior
class VooDataGridBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// A powerful data grid widget with remote filtering support
class VooDataGrid extends StatefulWidget {
  /// Controller for the data grid
  final VooDataGridController controller;

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
  final void Function(dynamic row)? onRowTap;

  /// Row double tap callback
  final void Function(dynamic row)? onRowDoubleTap;

  /// Row hover callback
  final void Function(dynamic)? onRowHover;

  /// Border decoration
  final BoxDecoration? decoration;

  /// Grid theme
  final VooDataGridTheme? theme;

  /// Display mode for the grid
  final VooDataGridDisplayMode displayMode;

  /// Custom card builder for mobile layout
  final Widget Function(BuildContext context, dynamic row, int index)? cardBuilder;

  /// Priority columns to show on mobile (field names)
  final List<String>? mobilePriorityColumns;

  const VooDataGrid({
    super.key,
    required this.controller,
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
  });

  @override
  State<VooDataGrid> createState() => _VooDataGridState();
}

class _VooDataGridState extends State<VooDataGrid> {
  dynamic _hoveredRow;
  late VooDataGridTheme _theme;
  late VooDataGridDisplayMode _effectiveDisplayMode;
  VooDataGridDisplayMode? _userSelectedMode;
  final Map<String, TextEditingController> _filterControllers = {};

  @override
  void initState() {
    super.initState();
    widget.controller.dataSource.loadData();
  }

  @override
  void dispose() {
    for (final controller in _filterControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  VooDataGridDisplayMode _getEffectiveDisplayMode(double width) {
    // If user manually selected a mode, use that
    if (_userSelectedMode != null) {
      return _userSelectedMode!;
    }
    // Otherwise follow widget configuration
    if (widget.displayMode != VooDataGridDisplayMode.auto) {
      return widget.displayMode;
    }
    // Auto mode: cards on mobile, table on larger screens
    return width < VooDataGridBreakpoints.mobile
        ? VooDataGridDisplayMode.cards
        : VooDataGridDisplayMode.table;
  }

  bool _isMobile(double width) => width < VooDataGridBreakpoints.mobile;
  bool _isTablet(double width) => width >= VooDataGridBreakpoints.mobile && width < VooDataGridBreakpoints.tablet;
  bool _isDesktop(double width) => width >= VooDataGridBreakpoints.desktop;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    _theme = widget.theme ?? VooDataGridTheme.fromContext(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _effectiveDisplayMode = _getEffectiveDisplayMode(constraints.maxWidth);
        
        return AnimatedBuilder(
          animation: Listenable.merge([
            widget.controller,
            widget.controller.dataSource,
          ]),
          builder: (context, _) {
            return Container(
              decoration: widget.decoration ??
                  BoxDecoration(
                    border: Border.all(color: _theme.borderColor),
                    borderRadius: BorderRadius.circular(design.radiusMd),
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showToolbar) _buildResponsiveToolbar(design, constraints.maxWidth),
                  Expanded(
                    child: _effectiveDisplayMode == VooDataGridDisplayMode.cards
                        ? _buildCardView(design)
                        : _buildGridContent(design, constraints.maxWidth),
                  ),
                  if (widget.showPagination &&
                      !widget.controller.dataSource.isLoading)
                    _buildResponsivePagination(constraints.maxWidth),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveToolbar(VooDesignSystemData design, double width) {
    final isMobile = _isMobile(width);
    final isTablet = _isTablet(width);
    final hasActiveFilters = widget.controller.dataSource.filters.isNotEmpty;
    
    if (isMobile || isTablet) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(design.spacingSm),
            decoration: BoxDecoration(
              color: _theme.headerBackgroundColor,
              border: Border(bottom: BorderSide(color: _theme.borderColor)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: widget.controller.dataSource.refresh,
                      tooltip: 'Refresh',
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            hasActiveFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                            color: hasActiveFilters ? Theme.of(context).colorScheme.primary : null,
                          ),
                          onPressed: () => _showMobileFilterSheet(context),
                          tooltip: 'Filters',
                        ),
                        if (hasActiveFilters)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${widget.controller.dataSource.filters.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_effectiveDisplayMode == VooDataGridDisplayMode.table)
                      if (isMobile) // Only show view switcher on mobile
                        IconButton(
                          icon: Icon(
                            _effectiveDisplayMode == VooDataGridDisplayMode.table
                                ? Icons.view_agenda
                                : Icons.table_chart,
                          ),
                          onPressed: () {
                            setState(() {
                              _userSelectedMode = _effectiveDisplayMode == VooDataGridDisplayMode.table
                                  ? VooDataGridDisplayMode.cards
                                  : VooDataGridDisplayMode.table;
                            });
                          },
                          tooltip: _effectiveDisplayMode == VooDataGridDisplayMode.table
                              ? 'Switch to Card View'
                              : 'Switch to Table View',
                        ),
                    const Spacer(),
                    if (widget.toolbarActions != null && widget.toolbarActions!.isNotEmpty)
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => widget.toolbarActions!
                            .map((action) => PopupMenuItem(
                                  child: action,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (hasActiveFilters) _buildFilterChips(design),
        ],
      );
    }
    
    // Desktop toolbar
    return Column(
      children: [
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
          decoration: BoxDecoration(
            color: _theme.headerBackgroundColor,
            border: Border(bottom: BorderSide(color: _theme.borderColor)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: widget.controller.dataSource.refresh,
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: Icon(widget.controller.showFilters
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined),
                onPressed: widget.controller.toggleFilters,
                tooltip: 'Toggle Filters',
              ),
              if (widget.controller.dataSource.filters.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.clear, size: 16),
                  label: Text(
                      'Clear Filters (${widget.controller.dataSource.filters.length})'),
                  onPressed: widget.controller.dataSource.clearFilters,
                ),
              const Spacer(),
              if (widget.toolbarActions != null) ...widget.toolbarActions!,
            ],
          ),
        ),
        if (hasActiveFilters) _buildFilterChips(design),
      ],
    );
  }

  Widget _buildCardView(VooDesignSystemData design) {
    final dataSource = widget.controller.dataSource;

    if (dataSource.isLoading && dataSource.rows.isEmpty) {
      return Center(
        child: widget.loadingWidget ?? const CircularProgressIndicator(),
      );
    }

    if (dataSource.error != null) {
      return Center(
        child: widget.errorBuilder?.call(dataSource.error!) ??
            VooEmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Data',
              message: dataSource.error!,
              action: TextButton(
                onPressed: dataSource.refresh,
                child: const Text('Retry'),
              ),
            ),
      );
    }

    if (dataSource.rows.isEmpty) {
      return Center(
        child: widget.emptyStateWidget ??
            const VooEmptyState(
              icon: Icons.table_rows_outlined,
              title: 'No Data',
              message: 'No rows to display',
            ),
      );
    }

    final selectedRows = widget.controller.dataSource.selectedRows;
    final priorityColumns = _getPriorityColumns();

    return ListView.builder(
      padding: EdgeInsets.all(design.spacingMd),
      itemCount: dataSource.rows.length,
      itemBuilder: (context, index) {
        final row = dataSource.rows[index];
        final isSelected = selectedRows.contains(row);
        
        if (widget.cardBuilder != null) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacingMd),
            child: widget.cardBuilder!(context, row, index),
          );
        }
        
        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? _theme.selectedRowBackgroundColor : null,
          margin: EdgeInsets.only(bottom: design.spacingMd),
          child: InkWell(
            onTap: () {
              widget.controller.dataSource.toggleRowSelection(row);
              widget.onRowTap?.call(row);
            },
            onDoubleTap: () => widget.onRowDoubleTap?.call(row),
            borderRadius: BorderRadius.circular(design.radiusMd),
            child: Padding(
              padding: EdgeInsets.all(design.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final column in priorityColumns)
                    _buildCardField(context, column, row, design),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardField(BuildContext context, VooDataColumn column, dynamic row, VooDesignSystemData design) {
    final value = column.valueGetter?.call(row) ?? row[column.field];
    final displayValue = column.valueFormatter?.call(value) ?? value?.toString() ?? '';
    
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '${column.label}:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: column.cellBuilder?.call(context, value, row) ??
                Text(
                  displayValue,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
          ),
        ],
      ),
    );
  }

  List<VooDataColumn> _getPriorityColumns() {
    final allColumns = widget.controller.columns;
    
    if (widget.mobilePriorityColumns != null && widget.mobilePriorityColumns!.isNotEmpty) {
      return allColumns.where((col) => 
        widget.mobilePriorityColumns!.contains(col.field)
      ).toList();
    }
    
    // Default: show first 4 visible columns
    return allColumns.where((col) => col.visible).take(4).toList();
  }

  Widget _buildGridContent(VooDesignSystemData design, double width) {
    final dataSource = widget.controller.dataSource;

    if (dataSource.isLoading && dataSource.rows.isEmpty) {
      return Center(
        child: widget.loadingWidget ??
            const CircularProgressIndicator(),
      );
    }

    if (dataSource.error != null) {
      return Center(
        child: widget.errorBuilder?.call(dataSource.error!) ??
            VooEmptyState(
              icon: Icons.error_outline,
              title: 'Error Loading Data',
              message: dataSource.error!,
              action: TextButton(
                onPressed: dataSource.refresh,
                child: const Text('Retry'),
              ),
            ),
      );
    }

    if (dataSource.rows.isEmpty) {
      return Center(
        child: widget.emptyStateWidget ??
            const VooEmptyState(
              icon: Icons.table_rows_outlined,
              title: 'No Data',
              message: 'No rows to display',
            ),
      );
    }

    // Filter columns based on screen width
    final visibleColumns = _getVisibleColumnsForWidth(width);
    widget.controller.setVisibleColumns(visibleColumns);
    
    // Don't show inline filters on mobile or tablet - use bottom sheet instead
    final showInlineFilters = widget.controller.showFilters && !_isMobile(width) && !_isTablet(width);
    
    return Column(
      children: [
        // Header
        VooDataGridHeader(
          controller: widget.controller,
          theme: _theme,
          onSort: widget.controller.sortColumn,
        ),
        
        // Filters (only on desktop)
        if (showInlineFilters)
          VooDataGridFilterRow(
            controller: widget.controller,
            theme: _theme,
          ),
        
        // Data rows
        Expanded(
          child: _buildDataRows(design),
        ),
        
        // Loading overlay
        if (dataSource.isLoading && dataSource.rows.isNotEmpty)
          const LinearProgressIndicator(),
      ],
    );
  }

  List<VooDataColumn> _getVisibleColumnsForWidth(double width) {
    final allColumns = widget.controller.columns;
    
    if (_isDesktop(width)) {
      return allColumns;
    } else if (_isTablet(width)) {
      // Show frozen columns and high priority columns
      return allColumns.where((col) => 
        col.frozen || col.visible
      ).toList();
    } else {
      // Mobile: Show only priority columns
      return _getPriorityColumns();
    }
  }

  Widget _buildResponsivePagination(double width) {
    if (_isMobile(width)) {
      return VooDataGridMobilePagination(
        currentPage: widget.controller.dataSource.currentPage,
        totalPages: widget.controller.dataSource.totalPages,
        pageSize: widget.controller.dataSource.pageSize,
        totalRows: widget.controller.dataSource.totalRows,
        onPageChanged: widget.controller.dataSource.changePage,
        onPageSizeChanged: widget.controller.dataSource.changePageSize,
        theme: _theme,
      );
    }
    
    return VooDataGridPagination(
      currentPage: widget.controller.dataSource.currentPage,
      totalPages: widget.controller.dataSource.totalPages,
      pageSize: widget.controller.dataSource.pageSize,
      totalRows: widget.controller.dataSource.totalRows,
      onPageChanged: widget.controller.dataSource.changePage,
      onPageSizeChanged: widget.controller.dataSource.changePageSize,
      theme: _theme,
    );
  }

  Widget _buildDataRows(VooDesignSystemData design) {
    final rows = widget.controller.dataSource.rows;
    final selectedRows = widget.controller.dataSource.selectedRows;

    return Scrollbar(
      controller: widget.controller.verticalScrollController,
      child: SingleChildScrollView(
        controller: widget.controller.verticalScrollController,
        child: Column(
          children: [
            for (int i = 0; i < rows.length; i++)
              VooDataGridRow(
                row: rows[i],
                index: i,
                controller: widget.controller,
                theme: _theme,
                isSelected: selectedRows.contains(rows[i]),
                isHovered: _hoveredRow == rows[i],
                onTap: () {
                  widget.controller.dataSource.toggleRowSelection(rows[i]);
                  widget.onRowTap?.call(rows[i]);
                },
                onDoubleTap: () => widget.onRowDoubleTap?.call(rows[i]),
                onHover: (isHovered) {
                  setState(() {
                    _hoveredRow = isHovered ? rows[i] : null;
                  });
                  widget.onRowHover?.call(isHovered ? rows[i] : null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(VooDesignSystemData design) {
    final filters = widget.controller.dataSource.filters;
    if (filters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(color: _theme.borderColor, width: 0.5),
        ),
      ),
      child: Wrap(
        spacing: design.spacingXs,
        runSpacing: design.spacingXs,
        children: [
          ...filters.entries.map((entry) {
            final column = widget.controller.columns.firstWhere(
              (col) => col.field == entry.key,
            );
            final filter = entry.value;
            String label = column.label;
            if (filter.value != null) {
              final displayValue = column.valueFormatter?.call(filter.value) ?? filter.value.toString();
              label = '$label: $displayValue';
            }
            return InputChip(
              label: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                widget.controller.dataSource.applyFilter(entry.key, null);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          }),
          if (filters.length > 1)
            ActionChip(
              label: const Text(
                'Clear All',
                style: TextStyle(fontSize: 12),
              ),
              onPressed: widget.controller.dataSource.clearFilters,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  void _showMobileFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _MobileFilterSheet(
        controller: widget.controller,
        theme: _theme,
        onApply: () {
          Navigator.pop(context);
          widget.controller.dataSource.loadData();
        },
      ),
    );
  }
}

/// Theme configuration for VooDataGrid
class VooDataGridTheme {
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color rowBackgroundColor;
  final Color alternateRowBackgroundColor;
  final Color selectedRowBackgroundColor;
  final Color hoveredRowBackgroundColor;
  final Color borderColor;
  final Color gridLineColor;
  final TextStyle headerTextStyle;
  final TextStyle cellTextStyle;
  final double borderWidth;

  const VooDataGridTheme({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.rowBackgroundColor,
    required this.alternateRowBackgroundColor,
    required this.selectedRowBackgroundColor,
    required this.hoveredRowBackgroundColor,
    required this.borderColor,
    required this.gridLineColor,
    required this.headerTextStyle,
    required this.cellTextStyle,
    this.borderWidth = 1.0,
  });

  factory VooDataGridTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return VooDataGridTheme(
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerTextColor: colorScheme.onSurface,
      rowBackgroundColor: colorScheme.surface,
      alternateRowBackgroundColor: colorScheme.surfaceContainerLowest,
      selectedRowBackgroundColor: colorScheme.primaryContainer,
      hoveredRowBackgroundColor: colorScheme.surfaceContainerHigh,
      borderColor: colorScheme.outline,
      gridLineColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
      headerTextStyle: theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      cellTextStyle: theme.textTheme.bodyMedium!,
    );
  }
}

/// Mobile filter sheet for VooDataGrid
class _MobileFilterSheet extends StatefulWidget {
  final VooDataGridController controller;
  final VooDataGridTheme theme;
  final VoidCallback onApply;

  const _MobileFilterSheet({
    required this.controller,
    required this.theme,
    required this.onApply,
  });

  @override
  State<_MobileFilterSheet> createState() => _MobileFilterSheetState();
}

class _MobileFilterSheetState extends State<_MobileFilterSheet> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _tempFilters = {};

  @override
  void initState() {
    super.initState();
    // Copy existing filters to temporary map
    for (final entry in widget.controller.dataSource.filters.entries) {
      _tempFilters[entry.key] = entry.value.value;
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final filterableColumns = widget.controller.columns.where((col) => col.filterable).toList();
    final activeFilterCount = _tempFilters.values.where((v) => v != null).length;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: design.spacingMd),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(design.spacingLg),
            child: Row(
              children: [
                Text(
                  'Filters',
                  style: theme.textTheme.headlineSmall,
                ),
                if (activeFilterCount > 0) ...[  
                  SizedBox(width: design.spacingSm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacingSm,
                      vertical: design.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(design.radiusSm),
                    ),
                    child: Text(
                      '$activeFilterCount active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (activeFilterCount > 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _tempFilters.clear();
                        for (final controller in _textControllers.values) {
                          controller.clear();
                        }
                      });
                    },
                    child: const Text('Clear All'),
                  ),
              ],
            ),
          ),
          Divider(height: 1),
          // Filter list
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.all(design.spacingLg),
              itemCount: filterableColumns.length,
              separatorBuilder: (context, index) => SizedBox(height: design.spacingMd),
              itemBuilder: (context, index) {
                final column = filterableColumns[index];
                return _buildFilterField(column);
              },
            ),
          ),
          // Bottom buttons
          Container(
            padding: EdgeInsets.all(design.spacingLg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: design.spacingMd),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Apply filters
                      for (final entry in _tempFilters.entries) {
                        final column = widget.controller.columns.firstWhere(
                          (col) => col.field == entry.key,
                        );
                        if (entry.value != null) {
                          widget.controller.dataSource.applyFilter(
                            entry.key,
                            VooDataFilter(
                              operator: column.effectiveDefaultFilterOperator,
                              value: entry.value,
                            ),
                          );
                        } else {
                          widget.controller.dataSource.applyFilter(entry.key, null);
                        }
                      }
                      // Clear any filters that were removed
                      for (final key in widget.controller.dataSource.filters.keys) {
                        if (!_tempFilters.containsKey(key)) {
                          widget.controller.dataSource.applyFilter(key, null);
                        }
                      }
                      widget.onApply();
                    },
                    child: Text(
                      activeFilterCount > 0 
                        ? 'Apply $activeFilterCount Filter${activeFilterCount > 1 ? 's' : ''}'
                        : 'Apply',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField(VooDataColumn column) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.label,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: design.spacingSm),
        _buildFilterInput(column),
      ],
    );
  }

  Widget _buildFilterInput(VooDataColumn column) {
    // Use custom filter builder if provided
    if (column.filterBuilder != null) {
      return column.filterBuilder!(
        context,
        column,
        _tempFilters[column.field],
        (value) {
          setState(() {
            _tempFilters[column.field] = value;
          });
        },
      );
    }

    switch (column.effectiveFilterWidgetType) {
      case VooFilterWidgetType.textField:
        return _buildTextFilter(column);
      case VooFilterWidgetType.numberField:
      case VooFilterWidgetType.numberRange:
        return _buildNumberFilter(column);
      case VooFilterWidgetType.datePicker:
        return _buildDateFilter(column);
      case VooFilterWidgetType.dropdown:
        return _buildDropdownFilter(column);
      case VooFilterWidgetType.multiSelect:
        return _buildMultiSelectFilter(column);
      case VooFilterWidgetType.checkbox:
        return _buildCheckboxFilter(column);
      default:
        return _buildTextFilter(column);
    }
  }

  Widget _buildTextFilter(VooDataColumn column) {
    final controller = _textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: _tempFilters[column.field]?.toString() ?? ''),
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: column.filterHint ?? 'Enter ${column.label.toLowerCase()}...',
        border: const OutlineInputBorder(),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    _tempFilters[column.field] = null;
                  });
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {
          _tempFilters[column.field] = value.isEmpty ? null : value;
        });
      },
    );
  }

  Widget _buildNumberFilter(VooDataColumn column) {
    final controller = _textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: _tempFilters[column.field]?.toString() ?? ''),
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: column.filterHint ?? 'Enter number...',
        border: const OutlineInputBorder(),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    _tempFilters[column.field] = null;
                  });
                },
              )
            : null,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
      ],
      onChanged: (value) {
        setState(() {
          final number = num.tryParse(value);
          _tempFilters[column.field] = number;
        });
      },
    );
  }

  Widget _buildDateFilter(VooDataColumn column) {
    final currentValue = _tempFilters[column.field];
    final displayValue = currentValue != null && currentValue is DateTime
        ? '${currentValue.year}-${currentValue.month.toString().padLeft(2, '0')}-${currentValue.day.toString().padLeft(2, '0')}'
        : null;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: currentValue is DateTime ? currentValue : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _tempFilters[column.field] = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: column.filterHint ?? 'Select date...',
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (displayValue != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _tempFilters[column.field] = null;
                    });
                  },
                ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
        child: Text(displayValue ?? ''),
      ),
    );
  }

  Widget _buildDropdownFilter(VooDataColumn column) {
    final options = column.filterOptions ?? [];
    final currentValue = _tempFilters[column.field];

    return DropdownButtonFormField<dynamic>(
      initialValue: options.any((opt) => opt.value == currentValue) ? currentValue : null,
      decoration: InputDecoration(
        hintText: column.filterHint ?? 'Select ${column.label.toLowerCase()}...',
        border: const OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('All'),
        ),
        ...options.map((option) => DropdownMenuItem(
              value: option.value,
              child: Row(
                children: [
                  if (option.icon != null) ...[  
                    Icon(option.icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(option.label),
                ],
              ),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _tempFilters[column.field] = value;
        });
      },
    );
  }

  Widget _buildMultiSelectFilter(VooDataColumn column) {
    final options = column.filterOptions ?? [];
    final selectedValues = _tempFilters[column.field] is List 
        ? List.from(_tempFilters[column.field] as List)
        : [];

    return InkWell(
      onTap: () {
        _showMultiSelectDialog(column, options, selectedValues);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: column.filterHint ?? 'Select multiple...',
          border: const OutlineInputBorder(),
          suffixIcon: selectedValues.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _tempFilters[column.field] = null;
                    });
                  },
                )
              : null,
        ),
        child: Text(
          selectedValues.isEmpty
              ? ''
              : '${selectedValues.length} selected',
        ),
      ),
    );
  }

  Widget _buildCheckboxFilter(VooDataColumn column) {
    final currentValue = _tempFilters[column.field] == true;

    return CheckboxListTile(
      title: Text(column.filterHint ?? 'Enable'),
      value: currentValue,
      onChanged: (value) {
        setState(() {
          _tempFilters[column.field] = value;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showMultiSelectDialog(
    VooDataColumn column,
    List<VooFilterOption> options,
    List<dynamic> selectedValues,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${column.label}'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                final isSelected = selectedValues.contains(option.value);
                return CheckboxListTile(
                  title: Text(option.label),
                  value: isSelected,
                  onChanged: (checked) {
                    setDialogState(() {
                      if (checked == true) {
                        selectedValues.add(option.value);
                      } else {
                        selectedValues.remove(option.value);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _tempFilters[column.field] = selectedValues.isEmpty ? null : selectedValues;
              });
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}