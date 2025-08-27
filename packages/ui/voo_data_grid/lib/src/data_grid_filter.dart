import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data_grid_controller.dart';
import 'data_grid_column.dart';
import 'data_grid.dart';
import 'data_grid_source.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Filter row widget for VooDataGrid
/// 
/// Generic type parameter T represents the row data type.
class VooDataGridFilterRow<T> extends StatefulWidget {
  final VooDataGridController<T> controller;
  final VooDataGridTheme theme;

  const VooDataGridFilterRow({
    super.key,
    required this.controller,
    required this.theme,
  });

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
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      height: widget.controller.filterHeight,
      decoration: BoxDecoration(
        color: widget.theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: widget.theme.borderColor,
            width: widget.theme.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Empty space for selection column
          if (widget.controller.dataSource.selectionMode != VooSelectionMode.none) Container(width: 48),

          // Frozen column filters
          for (final column in widget.controller.frozenColumns) _buildFilterCell(context, column, design),

          // Scrollable column filters
          Expanded(
            child: SingleChildScrollView(
              controller: widget.controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final column in widget.controller.scrollableColumns) _buildFilterCell(context, column, design),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCell(
    BuildContext context,
    VooDataColumn<T> column,
    VooDesignSystemData design,
  ) {
    if (!column.filterable) {
      return Container(
        width: widget.controller.getColumnWidth(column),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: widget.theme.gridLineColor,
              width: widget.controller.showGridLines ? 1 : 0,
            ),
          ),
        ),
      );
    }

    final width = widget.controller.getColumnWidth(column);
    final currentFilter = widget.controller.dataSource.filters[column.field];

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: design.spacingXs, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: widget.theme.gridLineColor,
            width: widget.controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: _buildFilterInput(context, column, currentFilter),
    );
  }

  Widget _buildFilterInput(
    BuildContext context,
    VooDataColumn column,
    VooDataFilter? currentFilter,
  ) {
    // Use custom filter builder if provided
    if (column.filterBuilder != null) {
      return column.filterBuilder!(
        context,
        column,
        currentFilter?.value,
        (value) => _applyFilter(column, value),
      );
    }

    // Build filter based on widget type
    switch (column.effectiveFilterWidgetType) {
      case VooFilterWidgetType.textField:
        return _buildTextFilter(column, currentFilter);

      case VooFilterWidgetType.numberField:
        return _buildNumberFilter(column, currentFilter);

      case VooFilterWidgetType.numberRange:
        return _buildNumberRangeFilter(column, currentFilter);

      case VooFilterWidgetType.datePicker:
        return _buildDateFilter(context, column, currentFilter);

      case VooFilterWidgetType.dateRange:
        return _buildDateRangeFilter(context, column, currentFilter);

      case VooFilterWidgetType.dropdown:
        return _buildDropdownFilter(column, currentFilter);

      case VooFilterWidgetType.multiSelect:
        return _buildMultiSelectFilter(column, currentFilter);

      case VooFilterWidgetType.checkbox:
        return _buildCheckboxFilter(column, currentFilter);

      case VooFilterWidgetType.custom:
        return const SizedBox();
    }
  }

  Widget _buildTextFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final controller = _textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final theme = Theme.of(context);

    return Row(
      children: [
        if (column.showFilterOperator) _buildOperatorSelector(column, currentFilter),
        Expanded(
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: column.filterHint ?? 'Filter...',
                hintStyle: TextStyle(fontSize: 13, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: InputBorder.none,
                suffixIcon: currentFilter != null
                    ? InkWell(
                        onTap: () {
                          controller.clear();
                          _clearFilter(column);
                        },
                        child: const Icon(Icons.clear, size: 16),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
              ),
              style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
              onChanged: (value) => _applyFilter(column, value.isEmpty ? null : value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final controller = _textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: column.filterHint ?? 'Number...',
          hintStyle: TextStyle(fontSize: 13, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: InputBorder.none,
          suffixIcon: currentFilter != null
              ? InkWell(
                  onTap: () {
                    controller.clear();
                    _clearFilter(column);
                  },
                  child: const Icon(Icons.clear, size: 16),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
        ),
        style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
        ],
        onChanged: (value) {
          final number = num.tryParse(value);
          _applyFilter(column, number);
        },
      ),
    );
  }

  Widget _buildNumberRangeFilter(
    VooDataColumn column,
    VooDataFilter? currentFilter,
  ) {
    final minController = _textControllers.putIfAbsent(
      '${column.field}_min',
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final maxController = _textControllers.putIfAbsent(
      '${column.field}_max',
      () => TextEditingController(text: currentFilter?.valueTo?.toString() ?? ''),
    );
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: minController,
              decoration: InputDecoration(
                hintText: 'Min',
                hintStyle: TextStyle(fontSize: 13, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              ],
              onChanged: (value) {
                final min = num.tryParse(value);
                final max = num.tryParse(maxController.text);
                if (min != null || max != null) {
                  widget.controller.dataSource.applyFilter(
                    column.field,
                    VooDataFilter(
                      operator: VooFilterOperator.between,
                      value: min,
                      valueTo: max,
                    ),
                  );
                } else {
                  _clearFilter(column);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: maxController,
              decoration: InputDecoration(
                hintText: 'Max',
                hintStyle: TextStyle(fontSize: 13, color: theme.hintColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              ],
              onChanged: (value) {
                final min = num.tryParse(minController.text);
                final max = num.tryParse(value);
                if (min != null || max != null) {
                  widget.controller.dataSource.applyFilter(
                    column.field,
                    VooDataFilter(
                      operator: VooFilterOperator.between,
                      value: min,
                      valueTo: max,
                    ),
                  );
                } else {
                  _clearFilter(column);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    VooDataColumn column,
    VooDataFilter? currentFilter,
  ) {
    final controller = _textControllers.putIfAbsent(
      column.field,
      () => TextEditingController(
        text: currentFilter?.value != null ? _formatDate(currentFilter!.value as DateTime) : '',
      ),
    );
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: column.filterHint ?? 'Select date',
          hintStyle: TextStyle(fontSize: 13, color: theme.hintColor),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: InputBorder.none,
          suffixIcon: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: currentFilter?.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                controller.text = _formatDate(date);
                _applyFilter(column, date);
              }
            },
            child: const Icon(Icons.calendar_today, size: 16),
          ),
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, maxHeight: 32),
        ),
        style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
        readOnly: true,
      ),
    );
  }

  Widget _buildDateRangeFilter(
    BuildContext context,
    VooDataColumn column,
    VooDataFilter? currentFilter,
  ) {
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (range != null) {
            widget.controller.dataSource.applyFilter(
              column.field,
              VooDataFilter(
                operator: VooFilterOperator.between,
                value: range.start,
                valueTo: range.end,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  currentFilter?.value != null && currentFilter?.valueTo != null
                      ? '${_formatDate(currentFilter!.value as DateTime)} - ${_formatDate(currentFilter.valueTo as DateTime)}'
                      : column.filterHint ?? 'Select range',
                  style: TextStyle(
                    fontSize: 13,
                    color: currentFilter?.value != null ? theme.textTheme.bodyMedium?.color : theme.hintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.date_range, size: 16, color: theme.iconTheme.color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final options = _getFilterOptions(column);
    final theme = Theme.of(context);
    
    // Initialize dropdown value from current filter if not already set
    if (!_dropdownValues.containsKey(column.field) && currentFilter != null) {
      _dropdownValues[column.field] = currentFilter.value;
    }
    
    final selectedValue = _dropdownValues[column.field];

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<dynamic>(
            value: selectedValue,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                column.filterHint ?? 'All',
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('All', style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color)),
              ),
              ...options.map((option) => DropdownMenuItem(
                    value: option.value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (option.icon != null) ...[
                          Icon(option.icon, size: 14),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            option.label,
                            style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            onChanged: (value) {
              setState(() {
                if (value == null) {
                  _dropdownValues.remove(column.field);
                } else {
                  _dropdownValues[column.field] = value;
                }
              });
              _applyFilter(column, value);
            },
            isExpanded: true,
            isDense: true,
            icon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.arrow_drop_down, size: 18, color: theme.iconTheme.color),
            ),
            selectedItemBuilder: (context) => [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('All', style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color)),
              ),
              ...options.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      option.label,
                      style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
            style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
            dropdownColor: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final options = _getFilterOptions(column);
    final selectedValues = currentFilter?.value is List ? List.from(currentFilter!.value as List) : [];
    final theme = Theme.of(context);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: PopupMenuButton<dynamic>(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedValues.isEmpty ? column.filterHint ?? 'Select...' : '${selectedValues.length} selected',
                  style: TextStyle(fontSize: 13, color: selectedValues.isEmpty ? theme.hintColor : theme.textTheme.bodyMedium?.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 18, color: theme.iconTheme.color),
            ],
          ),
        ),
        itemBuilder: (context) => options.map((option) {
          final isSelected = selectedValues.contains(option.value);
          return PopupMenuItem(
            child: StatefulBuilder(
              builder: (context, setState) => CheckboxListTile(
                value: isSelected,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedValues.add(option.value);
                    } else {
                      selectedValues.remove(option.value);
                    }
                  });
                  _applyFilter(column, selectedValues.isEmpty ? null : selectedValues);
                },
                title: Text(option.label, style: const TextStyle(fontSize: 13)),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCheckboxFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    // Initialize checkbox value from current filter if not already set
    if (!_checkboxValues.containsKey(column.field) && currentFilter != null) {
      _checkboxValues[column.field] = currentFilter.value == true;
    }
    
    final isChecked = _checkboxValues[column.field] ?? false;
    
    return SizedBox(
      height: 32,
      child: Center(
        child: Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              if (value == null || value == false) {
                _checkboxValues.remove(column.field);
              } else {
                _checkboxValues[column.field] = value;
              }
            });
            _applyFilter(column, value);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildOperatorSelector(VooDataColumn column, VooDataFilter? currentFilter) {
    final operators = column.effectiveAllowedFilterOperators;
    final currentOperator = currentFilter?.operator ?? column.effectiveDefaultFilterOperator;
    final theme = Theme.of(context);

    return Container(
      width: 40,
      height: 32,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VooFilterOperator>(
          value: currentOperator,
          items: operators
              .map((op) => DropdownMenuItem(
                    value: op,
                    child: Center(child: Text(_getOperatorSymbol(op), style: const TextStyle(fontSize: 11))),
                  ))
              .toList(),
          onChanged: (op) {
            if (op != null) {
              widget.controller.dataSource.applyFilter(
                column.field,
                VooDataFilter(
                  operator: op,
                  value: currentFilter?.value,
                  valueTo: currentFilter?.valueTo,
                ),
              );
            }
          },
          isExpanded: true,
          isDense: true,
          icon: const SizedBox.shrink(),
        ),
      ),
    );
  }

  List<VooFilterOption> _getFilterOptions(VooDataColumn column) {
    if (column.filterOptions != null) {
      return column.filterOptions!;
    }

    // For boolean columns, provide default options
    if (column.dataType == VooDataColumnType.boolean) {
      return const [
        VooFilterOption(value: true, label: 'Yes'),
        VooFilterOption(value: false, label: 'No'),
      ];
    }

    // Try to extract unique values from current data
    final uniqueValues = <dynamic>{};
    for (final row in widget.controller.dataSource.allRows.isNotEmpty ? widget.controller.dataSource.allRows : widget.controller.dataSource.rows) {
      final value = column.valueGetter?.call(row) ?? (row is Map ? row[column.field] : null);
      if (value != null) {
        uniqueValues.add(value);
      }
    }

    return uniqueValues
        .map((value) => VooFilterOption(
              value: value,
              label: column.valueFormatter?.call(value) ?? value.toString(),
            ))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  void _applyFilter(VooDataColumn column, dynamic value) {
    if (value == null) {
      _clearFilter(column);
      return;
    }

    final operator = widget.controller.dataSource.filters[column.field]?.operator ?? column.effectiveDefaultFilterOperator;

    widget.controller.dataSource.applyFilter(
      column.field,
      VooDataFilter(
        operator: operator,
        value: value,
      ),
    );
  }

  void _clearFilter(VooDataColumn column) {
    widget.controller.dataSource.applyFilter(column.field, null);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getOperatorSymbol(VooFilterOperator operator) {
    switch (operator) {
      case VooFilterOperator.equals:
        return '=';
      case VooFilterOperator.notEquals:
        return '≠';
      case VooFilterOperator.contains:
        return '∋';
      case VooFilterOperator.notContains:
        return '∌';
      case VooFilterOperator.startsWith:
        return '^';
      case VooFilterOperator.endsWith:
        return '\$';
      case VooFilterOperator.greaterThan:
        return '>';
      case VooFilterOperator.greaterThanOrEqual:
        return '≥';
      case VooFilterOperator.lessThan:
        return '<';
      case VooFilterOperator.lessThanOrEqual:
        return '≤';
      case VooFilterOperator.between:
        return '↔';
      case VooFilterOperator.inList:
        return '∈';
      case VooFilterOperator.notInList:
        return '∉';
      case VooFilterOperator.isNull:
        return '∅';
      case VooFilterOperator.isNotNull:
        return '!∅';
    }
  }
}
