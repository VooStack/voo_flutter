import 'package:flutter/material.dart';

import 'package:voo_data_grid/src/domain/entities/data_grid_column.dart';
import 'package:voo_data_grid/src/domain/entities/data_grid_types.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_option.dart';
import 'package:voo_data_grid/src/domain/entities/voo_filter_widget_type.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/checkbox_filter_field.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/date_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/date_range_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/dropdown_filter_field.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/multi_select_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/number_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/number_range_filter.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/text_filter.dart';

/// A molecule component that renders the appropriate filter input based on column configuration
class FilterInput<T> extends StatelessWidget {
  /// The column configuration
  final VooDataColumn<T> column;
  
  /// The current filter value
  final VooDataFilter? currentFilter;
  
  /// Callback when filter value changes
  final void Function(dynamic) onFilterChanged;
  
  /// Callback to clear filter
  final void Function() onFilterCleared;
  
  /// Text controllers map for maintaining state
  final Map<String, TextEditingController> textControllers;
  
  /// Dropdown values map for maintaining state
  final Map<String, dynamic> dropdownValues;
  
  /// Checkbox values map for maintaining state
  final Map<String, bool> checkboxValues;
  
  /// Function to get filter options for dropdown/multiselect
  final List<VooFilterOption> Function(VooDataColumn<T>) getFilterOptions;

  const FilterInput({
    super.key,
    required this.column,
    this.currentFilter,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.textControllers,
    required this.dropdownValues,
    required this.checkboxValues,
    required this.getFilterOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Use custom filter builder if provided
    if (column.filterBuilder != null) {
      return column.filterBuilder!(
        context,
        column,
        currentFilter?.value,
        onFilterChanged,
      );
    }

    // Build filter based on widget type
    switch (column.effectiveFilterWidgetType) {
      case VooFilterWidgetType.textField:
        return TextFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          onFilterCleared: onFilterCleared,
          textControllers: textControllers,
        );

      case VooFilterWidgetType.numberField:
        return NumberFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          onFilterCleared: onFilterCleared,
          textControllers: textControllers,
        );

      case VooFilterWidgetType.numberRange:
        return NumberRangeFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          onFilterCleared: onFilterCleared,
          textControllers: textControllers,
        );

      case VooFilterWidgetType.datePicker:
        return DateFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          onFilterCleared: onFilterCleared,
          textControllers: textControllers,
        );

      case VooFilterWidgetType.dateRange:
        return DateRangeFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          onFilterCleared: onFilterCleared,
        );

      case VooFilterWidgetType.dropdown:
        // Initialize dropdown value from current filter if not already set
        if (!dropdownValues.containsKey(column.field) && currentFilter != null) {
          dropdownValues[column.field] = currentFilter!.value;
        }
        
        return DropdownFilterField<dynamic>(
          value: dropdownValues[column.field],
          options: getFilterOptions(column),
          hintText: column.filterHint,
          compactStyle: true,
          height: 32,
          onChanged: (value) {
            if (value == null) {
              dropdownValues.remove(column.field);
            } else {
              dropdownValues[column.field] = value;
            }
            onFilterChanged(value);
          },
        );

      case VooFilterWidgetType.multiSelect:
        return MultiSelectFilter<T>(
          column: column,
          currentFilter: currentFilter,
          onFilterChanged: onFilterChanged,
          getFilterOptions: getFilterOptions,
        );

      case VooFilterWidgetType.checkbox:
        // Initialize checkbox value from current filter if not already set
        if (!checkboxValues.containsKey(column.field) && currentFilter != null) {
          checkboxValues[column.field] = currentFilter!.value == true;
        }
        
        return CheckboxFilterField(
          value: checkboxValues[column.field] ?? false,
          compactStyle: true,
          height: 32,
          onChanged: (value) {
            if (value == null || value == false) {
              checkboxValues.remove(column.field);
            } else {
              checkboxValues[column.field] = value;
            }
            onFilterChanged(value);
          },
        );

      case VooFilterWidgetType.custom:
        return const SizedBox();
    }
  }
}