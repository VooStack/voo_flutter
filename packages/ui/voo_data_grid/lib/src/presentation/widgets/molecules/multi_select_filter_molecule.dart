import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';

/// A molecule component for multi-select filter input
class MultiSelectFilterMolecule<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current filter value
  final VooDataFilter? currentFilter;
  
  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;
  
  /// Function to get filter options for the column
  final List<VooFilterOption> Function(VooDataColumn<T>) getFilterOptions;

  const MultiSelectFilterMolecule({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.getFilterOptions,
  });

  @override
  Widget build(BuildContext context) {
    final options = getFilterOptions(column);
    final selectedValues = currentFilter?.value is List 
        ? List<dynamic>.from(currentFilter!.value as List) 
        : <dynamic>[];
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
                  selectedValues.isEmpty 
                      ? column.filterHint ?? 'Select...' 
                      : '${selectedValues.length} selected',
                  style: TextStyle(
                    fontSize: 13, 
                    color: selectedValues.isEmpty 
                        ? theme.hintColor 
                        : theme.textTheme.bodyMedium?.color
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 18, color: theme.iconTheme.color),
            ],
          ),
        ),
        itemBuilder: (context) => options.map((option) {
          final isSelected = selectedValues.contains(option.value);
          return PopupMenuItem<dynamic>(
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
                  onFilterChanged(selectedValues.isEmpty ? null : selectedValues);
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
}