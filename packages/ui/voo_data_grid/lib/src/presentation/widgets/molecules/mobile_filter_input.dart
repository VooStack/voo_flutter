import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/molecules/molecules.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Mobile filter input widget that selects the appropriate input type
class MobileFilterInput extends StatelessWidget {
  final VooDataColumn column;
  final Map<String, dynamic> tempFilters;
  final Map<String, TextEditingController> textControllers;
  final void Function(String field, dynamic value) onFilterChanged;

  const MobileFilterInput({super.key, required this.column, required this.tempFilters, required this.textControllers, required this.onFilterChanged});

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
        return CheckboxFilterField(
          label: column.label,
          value: tempFilters[column.field] == true,
          onChanged: (bool? value) => onFilterChanged(column.field, value),
        );
      } else {
        // Dropdown filter for other options
        return DropdownFilterField(
          value: tempFilters[column.field],
          options: filterOptions,
          onChanged: (dynamic value) => onFilterChanged(column.field, value),
        );
      }
    }

    // Determine input type based on data type
    switch (column.dataType) {
      case VooDataColumnType.text:
        return TextFilterField(
          controller: _getController(column.field),
          onChanged: (String? value) => onFilterChanged(column.field, value?.isEmpty == true ? null : value),
        );

      case VooDataColumnType.number:
        return NumberFilterField(controller: _getController(column.field), onChanged: (num? value) => onFilterChanged(column.field, value));

      case VooDataColumnType.date:
        return DateFilterField(
          value: tempFilters[column.field] != null ? DateTime.tryParse(tempFilters[column.field].toString()) : null,
          onChanged: (DateTime? date) => onFilterChanged(column.field, date?.toIso8601String()),
        );

      case VooDataColumnType.boolean:
        return CheckboxFilterField(
          label: column.label,
          value: tempFilters[column.field] == true,
          onChanged: (bool? value) => onFilterChanged(column.field, value),
        );

      case VooDataColumnType.select:
      case VooDataColumnType.multiSelect:
      case VooDataColumnType.custom:
        // Fallback to text filter for now
        return TextFilterField(
          controller: _getController(column.field),
          onChanged: (String? value) => onFilterChanged(column.field, value?.isEmpty == true ? null : value),
        );
    }
  }
}
