import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/voo_data_filter.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_option.dart';

/// A molecule component for multi-select filter input
class MultiSelectFilter<T> extends StatefulWidget {
  /// The column configuration
  final VooDataColumn<T> column;

  /// The current filter value
  final VooDataFilter? currentFilter;

  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;

  /// Function to get filter options for the column
  final List<VooFilterOption> Function(VooDataColumn<T>) getFilterOptions;

  const MultiSelectFilter({super.key, required this.column, this.currentFilter, required this.onFilterChanged, required this.getFilterOptions});

  @override
  State<MultiSelectFilter<T>> createState() => _MultiSelectFilterState<T>();
}

class _MultiSelectFilterState<T> extends State<MultiSelectFilter<T>> {
  late List<dynamic> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.currentFilter?.value is List ? List<dynamic>.from(widget.currentFilter!.value as List) : <dynamic>[];
  }

  @override
  void didUpdateWidget(MultiSelectFilter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selectedValues when currentFilter changes from outside
    if (widget.currentFilter != oldWidget.currentFilter) {
      selectedValues = widget.currentFilter?.value is List ? List<dynamic>.from(widget.currentFilter!.value as List) : <dynamic>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.getFilterOptions(widget.column);
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
                  selectedValues.isEmpty ? widget.column.filterHint ?? 'Select...' : '${selectedValues.length} selected',
                  style: TextStyle(fontSize: 12, color: selectedValues.isEmpty ? theme.hintColor : theme.textTheme.bodyMedium?.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 18, color: theme.iconTheme.color),
            ],
          ),
        ),
        itemBuilder: (context) => options
            .map(
              (option) => PopupMenuItem<dynamic>(
                onTap: () {
                  // Prevent menu from closing
                  // We handle the state change manually
                },
                child: StatefulBuilder(
                  builder: (context, setMenuState) {
                    final isSelected = selectedValues.contains(option.value);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedValues.add(option.value);
                          } else {
                            selectedValues.remove(option.value);
                          }
                        });
                        setMenuState(() {}); // Update checkbox in menu
                        widget.onFilterChanged(selectedValues.isEmpty ? null : selectedValues);
                      },
                      title: Text(option.label, style: const TextStyle(fontSize: 12)),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
