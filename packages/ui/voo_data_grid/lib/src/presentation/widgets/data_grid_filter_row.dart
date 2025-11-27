import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_column_type.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_grid_theme.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_operator.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_option.dart';
import 'package:voo_data_grid/src/presentation/controllers/data_grid_controller.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/filter_cell.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/voo_data_grid_filter.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Filter row widget for VooDataGrid
///
/// Generic type parameter T represents the row data type.
class VooDataGridFilterRow<T> extends StatefulWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;

  const VooDataGridFilterRow({super.key, required this.controller, required this.theme});

  @override
  State<VooDataGridFilterRow<T>> createState() => _VooDataGridFilterRowState<T>();
}

class _VooDataGridFilterRowState<T> extends State<VooDataGridFilterRow<T>> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _dropdownValues = {};
  final Map<String, bool> _checkboxValues = {};

  @override
  void initState() {
    super.initState();
    // Listen to data source changes to update filters when cleared
    widget.controller.dataSource.addListener(_onDataSourceChanged);
  }

  @override
  void dispose() {
    widget.controller.dataSource.removeListener(_onDataSourceChanged);
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onDataSourceChanged() {
    // Update controllers when filters are cleared externally
    setState(() {
      // Clear text controllers for removed filters
      for (final column in widget.controller.columns) {
        if (!widget.controller.dataSource.filters.containsKey(column.field)) {
          // Clear text controllers
          _textControllers[column.field]?.clear();
          _textControllers['${column.field}_min']?.clear();
          _textControllers['${column.field}_max']?.clear();
          // Clear dropdown values
          _dropdownValues.remove(column.field);
          // Clear checkbox values
          _checkboxValues.remove(column.field);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        height: widget.controller.filterHeight,
        decoration: BoxDecoration(
          color: widget.theme.headerBackgroundColor.withValues(alpha: 0.5),
          border: Border(
            bottom: BorderSide(color: widget.theme.borderColor, width: widget.theme.borderWidth),
          ),
        ),
        child: Row(
          children: [
            if (widget.controller.dataSource.selectionMode != VooSelectionMode.none) Container(width: 48),
            for (final column in widget.controller.frozenColumns)
              FilterCell<T>(
                column: column,
                width: widget.controller.getColumnWidth(column),
                gridLineColor: widget.theme.gridLineColor,
                showGridLines: widget.controller.showGridLines,
                horizontalPadding: context.vooSpacing.xs,
                child: VooDataGridFilter<T>(
                  column: column,
                  currentFilter: widget.controller.dataSource.filters[column.field],
                  onFilterChanged: (value) => _applyFilter(column, value),
                  onFilterCleared: () => _clearFilter(column),
                  textControllers: _textControllers,
                  dropdownValues: _dropdownValues,
                  checkboxValues: _checkboxValues,
                  getFilterOptions: _getFilterOptions,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.controller.filterHorizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final column in widget.controller.scrollableColumns)
                      FilterCell<T>(
                        column: column,
                        width: widget.controller.getColumnWidth(column),
                        gridLineColor: widget.theme.gridLineColor,
                        showGridLines: widget.controller.showGridLines,
                        horizontalPadding: context.vooSpacing.xs,
                        child: VooDataGridFilter<T>(
                          column: column,
                          currentFilter: widget.controller.dataSource.filters[column.field],
                          onFilterChanged: (value) => _applyFilter(column, value),
                          onFilterCleared: () => _clearFilter(column),
                          textControllers: _textControllers,
                          dropdownValues: _dropdownValues,
                          checkboxValues: _checkboxValues,
                          getFilterOptions: _getFilterOptions,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  List<VooFilterOption> _getFilterOptions(VooDataColumn<T> column) {
    if (column.filterOptions != null) {
      return column.filterOptions!;
    }

    // For boolean columns, provide default options
    if (column.dataType == VooDataColumnType.boolean) {
      return const [VooFilterOption(value: true, label: 'Yes'), VooFilterOption(value: false, label: 'No')];
    }

    // Try to extract unique values from current data
    final uniqueValues = <dynamic>{};
    for (final row in widget.controller.dataSource.allRows.isNotEmpty ? widget.controller.dataSource.allRows : widget.controller.dataSource.rows) {
      dynamic value;
      try {
        value = column.valueGetter?.call(row) ?? (row is Map ? row[column.field] : null);
      } catch (e) {
        debugPrint(
          '[VooDataGrid Warning] Failed to get value for column "${column.field}" '
          'when building filter options: $e',
        );
        value = null;
      }
      if (value != null) {
        uniqueValues.add(value);
      }
    }

    return uniqueValues.map((value) => VooFilterOption(value: value, label: column.valueFormatter?.call(value) ?? value.toString())).toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  void _applyFilter(VooDataColumn<T> column, dynamic value) {
    if (value == null) {
      _clearFilter(column);
      return;
    }

    // Handle complex filter objects from molecular components
    if (value is Map && value.containsKey('operator')) {
      final operator = value['operator'] as VooFilterOperator? ?? column.effectiveDefaultFilterOperator;
      widget.controller.dataSource.applyFilter(
        column.field,
        VooDataFilter(operator: operator, value: value['value'], valueTo: value['valueTo'], odataCollectionProperty: column.odataCollectionProperty),
      );
      return;
    }

    final operator = widget.controller.dataSource.filters[column.field]?.operator ?? column.effectiveDefaultFilterOperator;

    widget.controller.dataSource.applyFilter(
      column.field,
      VooDataFilter(operator: operator, value: value, odataCollectionProperty: column.odataCollectionProperty),
    );
  }

  void _clearFilter(VooDataColumn column) {
    widget.controller.dataSource.applyFilter(column.field, null);
  }
}
