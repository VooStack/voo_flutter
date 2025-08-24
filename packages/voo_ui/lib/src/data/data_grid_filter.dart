import 'package:flutter/material.dart';
import 'package:voo_ui/src/data/data_grid_controller.dart';
import 'package:voo_ui/src/data/data_grid_column.dart';
import 'package:voo_ui/src/data/data_grid.dart';
import 'package:voo_ui/src/data/data_grid_source.dart';
import 'package:voo_ui/src/foundations/design_system.dart';
import 'package:voo_ui/src/inputs/dropdown.dart';

/// Filter row widget for VooDataGrid
class VooDataGridFilterRow extends StatelessWidget {
  final VooDataGridController controller;
  final VooDataGridTheme theme;

  const VooDataGridFilterRow({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Container(
      height: controller.filterHeight,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Empty space for selection column
          if (controller.dataSource.selectionMode != VooSelectionMode.none) Container(width: 48),

          // Frozen column filters
          for (final column in controller.frozenColumns) _buildFilterCell(context, column, design),

          // Scrollable column filters
          Expanded(
            child: SingleChildScrollView(
              controller: controller.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final column in controller.scrollableColumns) _buildFilterCell(context, column, design),
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
        width: controller.getColumnWidth(column),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: theme.gridLineColor,
              width: controller.showGridLines ? 1 : 0,
            ),
          ),
        ),
      );
    }

    final width = controller.getColumnWidth(column);
    final currentFilter = controller.dataSource.filters[column.field];

    return Container(
      width: width,
      padding: EdgeInsets.all(design.spacingXs),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.gridLineColor,
            width: controller.showGridLines ? 1 : 0,
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
    switch (column.dataType) {
      case VooDataColumnType.text:
        return _buildTextFilter(column, currentFilter);

      case VooDataColumnType.number:
        return _buildNumberFilter(column, currentFilter);

      case VooDataColumnType.date:
        return _buildDateFilter(context, column, currentFilter);

      case VooDataColumnType.boolean:
        return _buildBooleanFilter(column, currentFilter);

      case VooDataColumnType.select:
        return _buildSelectFilter(column, currentFilter);

      case VooDataColumnType.multiSelect:
        return _buildMultiSelectFilter(column, currentFilter);

      case VooDataColumnType.custom:
        return const SizedBox();
    }
  }

  Widget _buildTextFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Filter...',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        suffixIcon: currentFilter != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  controller.dataSource.applyFilter(column.field, null);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            : null,
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.dataSource.applyFilter(column.field, null);
        } else {
          controller.dataSource.applyFilter(
            column.field,
            VooDataFilter(
              operator: VooFilterOperator.contains,
              value: value,
            ),
          );
        }
      },
    );
  }

  Widget _buildNumberFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Min',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final numValue = double.tryParse(value);
              if (numValue != null) {
                controller.dataSource.applyFilter(
                  column.field,
                  VooDataFilter(
                    operator: VooFilterOperator.greaterThanOrEqual,
                    value: numValue,
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Max',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final numValue = double.tryParse(value);
              if (numValue != null) {
                controller.dataSource.applyFilter(
                  '${column.field}_max',
                  VooDataFilter(
                    operator: VooFilterOperator.lessThanOrEqual,
                    value: numValue,
                  ),
                );
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
    return TextField(
      decoration: InputDecoration(
        hintText: 'Select date',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, size: 16),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              controller.dataSource.applyFilter(
                column.field,
                VooDataFilter(
                  operator: VooFilterOperator.equals,
                  value: date,
                ),
              );
            }
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      style: const TextStyle(fontSize: 13),
      readOnly: true,
      controller: TextEditingController(
        text: currentFilter?.value != null ? _formatDate(currentFilter!.value as DateTime) : '',
      ),
    );
  }

  Widget _buildBooleanFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    return DropdownButton<bool?>(
      value: currentFilter?.value as bool?,
      items: const [
        DropdownMenuItem(value: null, child: Text('All')),
        DropdownMenuItem(value: true, child: Text('Yes')),
        DropdownMenuItem(value: false, child: Text('No')),
      ],
      onChanged: (value) {
        if (value == null) {
          controller.dataSource.applyFilter(column.field, null);
        } else {
          controller.dataSource.applyFilter(
            column.field,
            VooDataFilter(
              operator: VooFilterOperator.equals,
              value: value,
            ),
          );
        }
      },
      isExpanded: true,
      isDense: true,
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildSelectFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    if (column.filterOptions == null || column.filterOptions!.isEmpty) {
      return const SizedBox();
    }

    return VooDropdown<dynamic>(
      value: currentFilter?.value,
      items: [
        const VooDropdownItem(value: null, label: 'All'),
        ...column.filterOptions!.map(
          (option) => VooDropdownItem(
            value: option.value,
            label: option.label,
            icon: option.icon,
          ),
        ),
      ],
      onChanged: (value) {
        if (value == null) {
          controller.dataSource.applyFilter(column.field, null);
        } else {
          controller.dataSource.applyFilter(
            column.field,
            VooDataFilter(
              operator: VooFilterOperator.equals,
              value: value,
            ),
          );
        }
      },
    );
  }

  Widget _buildMultiSelectFilter(VooDataColumn column, VooDataFilter? currentFilter) {
    // For simplicity, using a text field for now
    // In a real implementation, this would be a multi-select dropdown
    return _buildTextFilter(column, currentFilter);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
