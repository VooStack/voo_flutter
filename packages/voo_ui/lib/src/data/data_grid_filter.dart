import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_ui/src/data/data_grid_controller.dart';
import 'package:voo_ui/src/data/data_grid_column.dart';
import 'package:voo_ui/src/data/data_grid.dart';
import 'package:voo_ui/src/data/data_grid_source.dart';
import 'package:voo_ui/src/foundations/design_system.dart';
import 'package:voo_ui/src/inputs/dropdown.dart';

/// Filter row widget for VooDataGrid
class VooDataGridFilterRow extends StatefulWidget {
  final VooDataGridController controller;
  final VooDataGridTheme theme;

  const VooDataGridFilterRow({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  State<VooDataGridFilterRow> createState() => _VooDataGridFilterRowState();
}

class _VooDataGridFilterRowState extends State<VooDataGridFilterRow> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _filterValues = {};

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
          if (widget.controller.dataSource.selectionMode != VooSelectionMode.none)
            Container(width: 48),
          
          // Frozen column filters
          for (final column in widget.controller.frozenColumns)
            _buildFilterCell(context, column, design),
          
          // Scrollable column filters
          Expanded(
            child: SingleChildScrollView(
              controller: widget.controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final column in widget.controller.scrollableColumns)
                    _buildFilterCell(context, column, design),
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
    VooDataColumn column,
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
      padding: EdgeInsets.all(design.spacingXs),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: widget.theme.gridLineColor,
            width: widget.controller.showGridLines ? 1 : 0,
          ),
        ),
      ),
      child: _buildFilterInput(context, column, currentFilter, design),
    );
  }

  Widget _buildFilterInput(
    BuildContext context,
    VooDataColumn column,
    VooDataFilter? currentFilter,
    VooDesignSystemData design,
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

    return Row(
      children: [
        if (column.showFilterOperator)
          _buildOperatorSelector(column, currentFilter),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: column.filterHint ?? 'Filter...',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              suffixIcon: currentFilter != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () => _clearFilter(column),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 13),
            onChanged: (value) => _applyFilter(column, value.isEmpty ? null : value),
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

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: column.filterHint ?? 'Number...',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        suffixIcon: currentFilter != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () => _clearFilter(column),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            : null,
      ),
      style: const TextStyle(fontSize: 13),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
      ],
      onChanged: (value) {
        final numValue = num.tryParse(value);
        _applyFilter(column, numValue);
      },
    );
  }

  Widget _buildNumberRangeFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final minController = _textControllers.putIfAbsent(
      '${column.field}_min',
      () => TextEditingController(text: currentFilter?.value?.toString() ?? ''),
    );
    final maxController = _textControllers.putIfAbsent(
      '${column.field}_max',
      () => TextEditingController(text: currentFilter?.valueTo?.toString() ?? ''),
    );

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: minController,
            decoration: const InputDecoration(
              hintText: 'Min',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
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
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            controller: maxController,
            decoration: const InputDecoration(
              hintText: 'Max',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
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
        text: currentFilter?.value != null
            ? _formatDate(currentFilter!.value as DateTime)
            : '',
      ),
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: column.filterHint ?? 'Select date',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentFilter != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () => _clearFilter(column),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            IconButton(
              icon: const Icon(Icons.calendar_today, size: 16),
              onPressed: () async {
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      style: const TextStyle(fontSize: 13),
      readOnly: true,
    );
  }

  Widget _buildDateRangeFilter(
    BuildContext context,
    VooDataColumn column,
    VooDataFilter? currentFilter,
  ) {
    return Row(
      children: [
        Expanded(
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      currentFilter?.value != null && currentFilter?.valueTo != null
                          ? '${_formatDate(currentFilter!.value)} - ${_formatDate(currentFilter.valueTo)}'
                          : column.filterHint ?? 'Select range',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const Icon(Icons.date_range, size: 16),
                ],
              ),
            ),
          ),
        ),
        if (currentFilter != null)
          IconButton(
            icon: const Icon(Icons.clear, size: 16),
            onPressed: () => _clearFilter(column),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildDropdownFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final options = _getFilterOptions(column);
    
    return VooDropdown<dynamic>(
      value: currentFilter?.value,
      items: [
        const VooDropdownItem(value: null, label: 'All'),
        ...options.map(
          (option) => VooDropdownItem(
            value: option.value,
            label: option.label,
            icon: option.icon,
          ),
        ),
      ],
      onChanged: (value) => _applyFilter(column, value),
    );
  }

  Widget _buildMultiSelectFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    final options = _getFilterOptions(column);
    final selectedValues = currentFilter?.value is List
        ? List.from(currentFilter!.value as List)
        : [];

    return PopupMenuButton<dynamic>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedValues.isEmpty
                    ? column.filterHint ?? 'Select...'
                    : '${selectedValues.length} selected',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((option) {
        final isSelected = selectedValues.contains(option.value);
        return PopupMenuItem(
          value: option.value,
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) {},
              ),
              if (option.icon != null) ...[
                Icon(option.icon, size: 16),
                const SizedBox(width: 8),
              ],
              Text(option.label),
            ],
          ),
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedValues.remove(option.value);
              } else {
                selectedValues.add(option.value);
              }
              _applyFilter(
                column,
                selectedValues.isEmpty ? null : selectedValues,
              );
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    return DropdownButton<bool?>(
      value: currentFilter?.value as bool?,
      items: const [
        DropdownMenuItem(value: null, child: Text('All')),
        DropdownMenuItem(value: true, child: Text('Yes')),
        DropdownMenuItem(value: false, child: Text('No')),
      ],
      onChanged: (value) => _applyFilter(column, value),
      isExpanded: true,
      isDense: true,
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildOperatorSelector(VooDataColumn column, VooDataFilter? currentFilter) {
    final operators = column.effectiveAllowedFilterOperators;
    final currentOperator = currentFilter?.operator ?? column.effectiveDefaultFilterOperator;

    return Container(
      width: 40,
      margin: const EdgeInsets.only(right: 4),
      child: DropdownButton<VooFilterOperator>(
        value: currentOperator,
        items: operators.map((op) => DropdownMenuItem(
          value: op,
          child: Text(_getOperatorSymbol(op)),
        )).toList(),
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
        style: const TextStyle(fontSize: 12),
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
    for (final row in widget.controller.dataSource.allRows.isNotEmpty
        ? widget.controller.dataSource.allRows
        : widget.controller.dataSource.rows) {
      final value = column.valueGetter?.call(row) ?? 
                   (row is Map ? row[column.field] : null);
      if (value != null) {
        uniqueValues.add(value);
      }
    }

    return uniqueValues.map((value) => VooFilterOption(
      value: value,
      label: column.valueFormatter?.call(value) ?? value.toString(),
    )).toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  void _applyFilter(VooDataColumn column, dynamic value) {
    if (value == null) {
      _clearFilter(column);
      return;
    }

    final operator = widget.controller.dataSource.filters[column.field]?.operator ??
                     column.effectiveDefaultFilterOperator;

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
    _textControllers[column.field]?.clear();
    _textControllers['${column.field}_min']?.clear();
    _textControllers['${column.field}_max']?.clear();
    setState(() {
      _filterValues.remove(column.field);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getOperatorSymbol(VooFilterOperator op) {
    switch (op) {
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