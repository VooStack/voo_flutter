import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// A molecule component for dropdown filter input with data grid styling
class DropdownFilterFieldMolecule<T> extends StatelessWidget {
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
  
  const DropdownFilterFieldMolecule({
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
    final theme = Theme.of(context);
    
    if (compactStyle) {
      return _buildCompactDropdown(theme);
    }
    
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
  
  Widget _buildCompactDropdown(ThemeData theme) {
    return Container(
      height: height ?? 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<T>(
            value: value,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                hintText ?? allOptionLabel,
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
            ),
            items: [
              DropdownMenuItem(
                child: Text(
                  allOptionLabel,
                  style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                ),
              ),
              ...options.map(
                (option) => DropdownMenuItem(
                  value: option.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (option.icon != null) ...[
                        Icon(option.icon, size: 14),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          option.label,
                          style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: onChanged,
            isExpanded: true,
            isDense: true,
            icon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.arrow_drop_down, size: 18, color: theme.iconTheme.color),
            ),
            selectedItemBuilder: (context) => [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  allOptionLabel,
                  style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                ),
              ),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    option.label,
                    style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
            dropdownColor: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}