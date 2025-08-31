import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A molecule component for dropdown filter input
class DropdownFilterFieldMolecule<T> extends StatelessWidget {
  /// The current selected value
  final T? value;
  
  /// Callback when value changes
  final void Function(T?) onChanged;
  
  /// Available options
  final List<FilterOption<T>> options;
  
  /// Hint text for the field
  final String? hintText;
  
  /// Label for the field
  final String? label;
  
  /// Whether to show an "All" option
  final bool showAllOption;
  
  /// Label for the "All" option
  final String allOptionLabel;
  
  const DropdownFilterFieldMolecule({
    super.key,
    this.value,
    required this.onChanged,
    required this.options,
    this.hintText,
    this.label,
    this.showAllOption = true,
    this.allOptionLabel = 'All',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: options.any((opt) => opt.value == value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? 'Select option...',
        border: const OutlineInputBorder(),
      ),
      items: [
        if (showAllOption)
          DropdownMenuItem<T>(
            value: null,
            child: Text(allOptionLabel),
          ),
        ...options.map(
          (option) => DropdownMenuItem<T>(
            value: option.value,
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(option.icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(option.label),
              ],
            ),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}