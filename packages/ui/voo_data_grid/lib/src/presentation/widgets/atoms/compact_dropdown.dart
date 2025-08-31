import 'package:flutter/material.dart';

/// Option data for dropdown items
class DropdownOptionData {
  final String label;
  final dynamic value;
  final IconData? icon;

  const DropdownOptionData({
    required this.label,
    this.value,
    this.icon,
  });
}

/// A compact dropdown widget for filter fields
class CompactDropdown<T> extends StatelessWidget {
  /// Current selected value
  final T? value;
  
  /// Available options
  final List<DropdownOptionData> options;
  
  /// Callback when value changes
  final ValueChanged<T?>? onChanged;
  
  /// Hint text when no value is selected
  final String? hintText;
  
  /// Label for "All" option
  final String allOptionLabel;
  
  /// Height of the dropdown
  final double? height;
  
  const CompactDropdown({
    super.key,
    this.value,
    required this.options,
    this.onChanged,
    this.hintText,
    this.allOptionLabel = 'All',
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: height ?? 32,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText ?? allOptionLabel,
            style: TextStyle(fontSize: 12, color: theme.hintColor),
            overflow: TextOverflow.ellipsis,
          ),
          items: [
            DropdownMenuItem<T>(
              child: Text(
                allOptionLabel,
                style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            ...options.map(
              (option) => DropdownMenuItem<T>(
                value: option.value as T?,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.icon != null) ...[
                      Icon(option.icon, size: 14),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        option.label,
                        style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
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
          icon: Icon(Icons.arrow_drop_down, size: 16, color: theme.iconTheme.color),
          selectedItemBuilder: (context) => [
            Text(
              allOptionLabel,
              style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
              overflow: TextOverflow.ellipsis,
            ),
            ...options.map(
              (option) => Text(
                option.label,
                style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}