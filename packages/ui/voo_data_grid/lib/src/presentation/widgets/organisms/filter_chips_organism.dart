import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Filter chips organism for displaying active filters
class FilterChipsOrganism<T> extends StatelessWidget {
  final Map<String, VooDataFilter> filters;
  final List<VooDataColumn<T>> columns;
  final VooDataGridTheme theme;
  final void Function(String field) onRemoveFilter;
  
  const FilterChipsOrganism({
    super.key,
    required this.filters,
    required this.columns,
    required this.theme,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Container(
      padding: EdgeInsets.all(design.spacingSm),
      decoration: BoxDecoration(
        color: theme.rowBackgroundColor.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: Wrap(
        spacing: design.spacingSm,
        runSpacing: design.spacingSm,
        children: filters.entries.map((entry) {
          final column = columns.firstWhere(
            (c) => c.field == entry.key,
            orElse: () => VooDataColumn<T>(
              field: entry.key,
              label: entry.key,
            ),
          );
          return Chip(
            label: Text(
              '${column.label}: ${entry.value.value}',
              style: theme.cellTextStyle.copyWith(fontSize: 12),
            ),
            deleteIcon: Icon(Icons.close, size: design.iconSizeSm),
            onDeleted: () => onRemoveFilter(entry.key),
          );
        }).toList(),
      ),
    );
  }
}