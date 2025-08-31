import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/filter_chip_list.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A section widget that displays filter chips for active filters
class DataGridFilterChipsSection<T> extends StatelessWidget {
  /// The data grid controller
  final VooDataGridController<T> controller;
  
  /// The theme configuration
  final VooDataGridTheme theme;
  
  const DataGridFilterChipsSection({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final filters = controller.dataSource.filters;
    if (filters.isEmpty) return const SizedBox.shrink();

    // Prepare filter data for the molecule
    final filterData = <String, FilterChipData>{};
    for (final entry in filters.entries) {
      final column = controller.columns.firstWhere(
        (col) => col.field == entry.key,
      );
      final filter = entry.value;
      final displayValue = filter.value != null 
          ? (column.valueFormatter?.call(filter.value) ?? filter.value?.toString() ?? '') 
          : null;

      filterData[entry.key] = FilterChipData(
        label: column.label,
        value: filter.value,
        displayValue: displayValue,
      );
    }

    return FilterChipList(
      filters: filterData,
      onFilterRemoved: (String field) {
        controller.dataSource.applyFilter(field, null);
      },
      onClearAll: controller.dataSource.clearFilters,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderColor: theme.borderColor,
    );
  }
}