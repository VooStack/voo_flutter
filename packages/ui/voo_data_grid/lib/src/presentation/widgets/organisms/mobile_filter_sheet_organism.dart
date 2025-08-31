import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';

/// Mobile filter sheet organism for filtering data on mobile devices
class MobileFilterSheetOrganism extends StatefulWidget {
  final VooDataGridController controller;
  final VooDataGridTheme theme;
  final VoidCallback onApply;

  const MobileFilterSheetOrganism({
    super.key,
    required this.controller,
    required this.theme,
    required this.onApply,
  });

  @override
  State<MobileFilterSheetOrganism> createState() => _MobileFilterSheetOrganismState();
}

class _MobileFilterSheetOrganismState extends State<MobileFilterSheetOrganism> {
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

          const Divider(height: 1),

          // Filter list
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.all(design.spacingLg),
              itemCount: filterableColumns.length,
              separatorBuilder: (context, index) => SizedBox(height: design.spacingMd),
              itemBuilder: (context, index) {
                final column = filterableColumns[index];
                return _MobileFilterField(
                  column: column,
                  tempFilters: _tempFilters,
                  textControllers: _textControllers,
                  onFilterChanged: (field, value) {
                    setState(() {
                      _tempFilters[field] = value;
                    });
                  },
                );
              },
            ),
          ),

          // Bottom buttons
          Container(
            padding: EdgeInsets.all(design.spacingLg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      // Apply filters
                      for (final entry in _tempFilters.entries) {
                        if (entry.value != null) {
                          widget.controller.dataSource.applyFilter(
                            entry.key,
                            VooDataFilter(
                              value: entry.value,
                              operator: VooFilterOperator.equals,
                            ),
                          );
                        } else {
                          widget.controller.dataSource.applyFilter(entry.key, null);
                        }
                      }
                      
                      // Clear filters that were removed
                      final tempKeys = _tempFilters.keys.toSet();
                      for (final existingKey in widget.controller.dataSource.filters.keys) {
                        if (!tempKeys.contains(existingKey)) {
                          widget.controller.dataSource.applyFilter(existingKey, null);
                        }
                      }
                      
                      widget.onApply();
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual mobile filter field widget
class _MobileFilterField extends StatelessWidget {
  final VooDataColumn column;
  final Map<String, dynamic> tempFilters;
  final Map<String, TextEditingController> textControllers;
  final void Function(String field, dynamic value) onFilterChanged;

  const _MobileFilterField({
    required this.column,
    required this.tempFilters,
    required this.textControllers,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.label,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: design.spacingXs),
        _MobileFilterInput(
          column: column,
          tempFilters: tempFilters,
          textControllers: textControllers,
          onFilterChanged: onFilterChanged,
        ),
      ],
    );
  }
}

/// Mobile filter input widget that selects the appropriate input type
class _MobileFilterInput extends StatelessWidget {
  final VooDataColumn column;
  final Map<String, dynamic> tempFilters;
  final Map<String, TextEditingController> textControllers;
  final void Function(String field, dynamic value) onFilterChanged;

  const _MobileFilterInput({
    required this.column,
    required this.tempFilters,
    required this.textControllers,
    required this.onFilterChanged,
  });

  TextEditingController _getController(String field) => textControllers.putIfAbsent(field, () {
      final controller = TextEditingController();
      final existingValue = tempFilters[field];
      if (existingValue != null && existingValue is! bool) {
        controller.text = existingValue.toString();
      }
      return controller;
    });

  @override
  Widget build(BuildContext context) {
    final filterOptions = column.filterOptions;

    // Use dropdown if filter options are provided
    if (filterOptions != null && filterOptions.isNotEmpty) {
      if (filterOptions.any((opt) => opt.value is bool)) {
        // Checkbox filter for boolean options
        return CheckboxFilterFieldMolecule(
          label: column.label,
          value: tempFilters[column.field] == true,
          onChanged: (value) => onFilterChanged(column.field, value),
        );
      } else {
        // Dropdown filter for other options
        return DropdownFilterFieldMolecule(
          value: tempFilters[column.field],
          options: filterOptions,
          onChanged: (value) => onFilterChanged(column.field, value),
        );
      }
    }

    // Determine input type based on data type
    switch (column.dataType) {
      case VooDataColumnType.text:
        return TextFilterFieldMolecule(
          controller: _getController(column.field),
          onChanged: (value) => onFilterChanged(column.field, value?.isEmpty == true ? null : value),
        );

      case VooDataColumnType.number:
        return NumberFilterFieldMolecule(
          controller: _getController(column.field),
          onChanged: (value) => onFilterChanged(column.field, value),
        );

      case VooDataColumnType.date:
        return DateFilterFieldMolecule(
          value: tempFilters[column.field] != null 
              ? DateTime.tryParse(tempFilters[column.field].toString())
              : null,
          onChanged: (date) => onFilterChanged(column.field, date?.toIso8601String()),
        );

      case VooDataColumnType.boolean:
        return CheckboxFilterFieldMolecule(
          label: column.label,
          value: tempFilters[column.field] == true,
          onChanged: (value) => onFilterChanged(column.field, value),
        );
        
      case VooDataColumnType.select:
      case VooDataColumnType.multiSelect:
      case VooDataColumnType.custom:
        // Fallback to text filter for now
        return TextFilterFieldMolecule(
          controller: _getController(column.field),
          onChanged: (value) => onFilterChanged(column.field, value?.isEmpty == true ? null : value),
        );
    }
  }
}