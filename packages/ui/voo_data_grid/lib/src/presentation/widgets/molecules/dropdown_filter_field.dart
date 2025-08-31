import 'package:flutter/material.dart';
import 'package:voo_data_grid/src/presentation/widgets/atoms/compact_dropdown.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A molecule component for dropdown filter input with data grid styling
class DropdownFilterField<T> extends StatelessWidget {
  /// The current selected value
  final T? value;

  /// Callback when value changes
  final void Function(T?) onChanged;

  /// Available options
  final List<VooFilterOption> options;

  /// Hint text for the field
  final String? hintText;

  /// Label for the field
  final String? label;

  /// Whether to show an "All" option
  final bool showAllOption;

  /// Label for the "All" option
  final String allOptionLabel;

  /// Custom height for filter styling
  final double? height;

  /// Whether to use compact filter styling
  final bool compactStyle;

  const DropdownFilterField({
    super.key,
    this.value,
    required this.onChanged,
    required this.options,
    this.hintText,
    this.label,
    this.showAllOption = true,
    this.allOptionLabel = 'All',
    this.height,
    this.compactStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compactStyle) {
      return CompactDropdown<T>(
        value: value,
        options: options
            .map(
              (opt) => DropdownOptionData(
                label: opt.label,
                value: opt.value,
                icon: opt.icon,
              ),
            )
            .toList(),
        onChanged: onChanged,
        hintText: hintText,
        allOptionLabel: allOptionLabel,
        height: height,
      );
    }

    return DropdownButtonFormField<T>(
      initialValue: options.any((opt) => opt.value == value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? 'Select option...',
        border: const OutlineInputBorder(),
      ),
      items: [
        if (showAllOption)
          DropdownMenuItem<T>(
            child: Text(allOptionLabel),
          ),
        ...options.map(
          (option) => DropdownMenuItem<T>(
            value: option.value as T?,
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
