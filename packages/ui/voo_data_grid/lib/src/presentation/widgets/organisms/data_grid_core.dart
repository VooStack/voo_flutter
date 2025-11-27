import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_content_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_filter_chips_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/data_grid_pagination_section.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';
import 'package:voo_data_grid/src/presentation/widgets/organisms/mobile_filter_sheet.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Core widget that handles the main data grid layout and logic
/// This is the shared implementation used by both VooDataGrid and VooDataGridStateless
class DataGridCore<T> extends StatefulWidget {
  /// Controller for the data grid
  final VooDataGridController<T> controller;

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

  /// Whether to always show vertical scrollbar
  final bool alwaysShowVerticalScrollbar;

  /// Whether to always show horizontal scrollbar
  final bool alwaysShowHorizontalScrollbar;

  /// Primary filters configuration
  final List<PrimaryFilter>? primaryFilters;

  /// Currently selected primary filter
  final VooDataFilter? selectedPrimaryFilter;

  /// Callback when regular filter is changed
  final void Function(String field, VooDataFilter? filter)? onFilterChanged;

  /// Callback when primary filter is selected
  final void Function(String field, VooDataFilter? filter)? onPrimaryFilterChanged;

  /// Whether to show primary filters
  final bool showPrimaryFilters;

  /// Whether to combine primary filters with regular filters
  /// When true (default), primary filters are added to the filters map
  /// When false, primary filters are tracked separately
  final bool combineFiltersAndPrimaryFilters;

  /// Callback for refresh action
  final VoidCallback? onRefresh;

  /// Whether to show export button
  final bool showExportButton;

  /// Export configuration
  final ExportConfig? exportConfig;

  /// Company logo for PDF export
  final Uint8List? companyLogo;

  /// Callback when export completes
  final void Function(Uint8List data, String filename)? onExportComplete;

  const DataGridCore({
    super.key,
    required this.controller,
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
    this.onFilterChanged,
    this.onPrimaryFilterChanged,
    this.showPrimaryFilters = false,
    this.combineFiltersAndPrimaryFilters = true,
    this.onRefresh,
    this.showExportButton = false,
    this.exportConfig,
    this.companyLogo,
    this.onExportComplete,
  });

  @override
  State<DataGridCore<T>> createState() => _DataGridCoreState<T>();
}

class _DataGridCoreState<T> extends State<DataGridCore<T>> {
  late VooDataGridTheme _theme;
  late VooDataGridDisplayMode _effectiveDisplayMode;
  VooDataGridDisplayMode? _userSelectedMode;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    widget.controller.dataSource.loadData();
    // Listen to data source changes to detect errors
    widget.controller.dataSource.addListener(_handleDataSourceChange);
    // Check for initial error state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndNotifyError();
    });
  }

  @override
  void didUpdateWidget(DataGridCore<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check for error changes when widget updates (for VooDataGridStateless)
    _checkAndNotifyError();
  }

  @override
  void dispose() {
    widget.controller.dataSource.removeListener(_handleDataSourceChange);
    super.dispose();
  }

  void _handleDataSourceChange() {
    _checkAndNotifyError();
  }

  void _checkAndNotifyError() {
    final currentError = widget.controller.dataSource.error;
    // Call onError callback when error state changes
    if (currentError != null && currentError != _lastError) {
      widget.onError?.call(currentError);
      _lastError = currentError;
    } else if (currentError == null) {
      _lastError = null;
    }
  }

  VooDataGridDisplayMode _getEffectiveDisplayMode(ScreenInfo screenInfo) {
    // If user manually selected a mode, use that
    if (_userSelectedMode != null) {
      return _userSelectedMode!;
    }
    // Otherwise follow widget configuration
    if (widget.displayMode != VooDataGridDisplayMode.auto) {
      return widget.displayMode;
    }
    // Auto mode: cards on mobile, table on larger screens
    return screenInfo.isMobileLayout
        ? VooDataGridDisplayMode.cards
        : VooDataGridDisplayMode.table;
  }

  List<Widget>? _buildToolbarActions() {
    final actions = <Widget>[];

    // Add export button if enabled
    if (widget.showExportButton) {
      actions.add(IconButton(icon: const Icon(Icons.download), tooltip: 'Export data', onPressed: () => _showExportDialog(context)));
    }

    // Add any additional custom actions
    if (widget.toolbarActions != null) {
      actions.addAll(widget.toolbarActions!);
    }

    return actions.isEmpty ? null : actions;
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExportDialog<T>(controller: widget.controller, initialConfig: widget.exportConfig, companyLogo: widget.companyLogo),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = widget.theme ?? VooDataGridTheme.fromContext(context);

    return VooResponsiveBuilder(
      builder: (context, screenInfo) {
        _effectiveDisplayMode = _getEffectiveDisplayMode(screenInfo);
        final isMobile = screenInfo.isMobileLayout;

        return LayoutBuilder(
          builder: (context, constraints) => AnimatedBuilder(
              animation: Listenable.merge([
                widget.controller,
                widget.controller.dataSource,
              ]),
              builder: (context, _) => DecoratedBox(
                decoration: widget.decoration ??
                    BoxDecoration(
                      border: Border.all(color: _theme.borderColor),
                      borderRadius: BorderRadius.circular(
                        context.vooRadius.md,
                      ),
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showPrimaryFilters &&
                        widget.primaryFilters != null) ...[
                      PrimaryFiltersBar(
                        filters: widget.primaryFilters!,
                        selectedFilter: widget.selectedPrimaryFilter,
                        onFilterChanged: (field, filter) {
                          // Call primary filter callback
                          widget.onPrimaryFilterChanged?.call(field, filter);

                          // Also add to regular filters if combining
                          if (widget.combineFiltersAndPrimaryFilters) {
                            widget.onFilterChanged?.call(field, filter);
                          }
                        },
                      ),
                    ],
                    if (widget.showToolbar) ...[
                      Column(
                        children: [
                          DataGridToolbar(
                            onRefresh: widget.onRefresh ??
                                widget.controller.dataSource.refresh,
                            onFilterToggle:
                                isMobile ? null : widget.controller.toggleFilters,
                            filtersVisible: widget.controller.showFilters,
                            activeFilterCount:
                                widget.controller.dataSource.filters.length,
                            displayMode: _effectiveDisplayMode,
                            onDisplayModeChanged: isMobile
                                ? (mode) =>
                                    setState(() => _userSelectedMode = mode)
                                : null,
                            showViewModeToggle: isMobile &&
                                _effectiveDisplayMode ==
                                    VooDataGridDisplayMode.table,
                            additionalActions: _buildToolbarActions(),
                            backgroundColor: _theme.headerBackgroundColor,
                            borderColor: _theme.borderColor,
                            isMobile: isMobile,
                            onShowMobileFilters: isMobile
                                ? () => _showMobileFilterSheet(context)
                                : null,
                          ),
                          if (widget.controller.dataSource.filters
                              .isNotEmpty) ...[
                            DataGridFilterChipsSection<T>(
                              controller: widget.controller,
                              theme: _theme,
                            ),
                          ],
                        ],
                      ),
                    ],
                    Expanded(
                      child: DataGridContentSection<T>(
                        controller: widget.controller,
                        theme: _theme,
                        displayMode: _effectiveDisplayMode,
                        constraints: constraints,
                        loadingWidget: widget.loadingWidget,
                        emptyStateWidget: widget.emptyStateWidget,
                        errorBuilder: widget.errorBuilder,
                        cardBuilder: widget.cardBuilder,
                        onRowTap: widget.onRowTap,
                        onRowDoubleTap: widget.onRowDoubleTap,
                        onRowHover: widget.onRowHover,
                        mobilePriorityColumns: widget.mobilePriorityColumns,
                        alwaysShowVerticalScrollbar:
                            widget.alwaysShowVerticalScrollbar,
                        alwaysShowHorizontalScrollbar:
                            widget.alwaysShowHorizontalScrollbar,
                      ),
                    ),
                    if (widget.showPagination) ...[
                      DataGridPaginationSection<T>(
                        controller: widget.controller,
                        theme: _theme,
                        width: constraints.maxWidth,
                        isMobile: isMobile,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        );
      },
    );
  }

  void _showMobileFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.vooRadius.xl),
        ),
      ),
      builder: (context) => MobileFilterSheet(
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
