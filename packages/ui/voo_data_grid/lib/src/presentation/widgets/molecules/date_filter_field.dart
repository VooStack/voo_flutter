import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A molecule component for date filter input
class DateFilterField extends StatelessWidget {
  /// The current date value
  final DateTime? value;
  
  /// Callback when date changes
  final void Function(DateTime?) onChanged;
  
  /// Hint text for the field
  final String? hintText;
  
  /// Label for the field
  final String? label;
  
  /// Date format for display
  final DateFormat? dateFormat;
  
  /// First selectable date
  final DateTime? firstDate;
  
  /// Last selectable date
  final DateTime? lastDate;
  
  /// Whether to show clear button
  final bool showClearButton;
  
  const DateFilterField({
    super.key,
    this.value,
    required this.onChanged,
    this.hintText,
    this.label,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final format = dateFormat ?? DateFormat('yyyy-MM-dd');
    final displayValue = value != null ? format.format(value!) : null;
    final theme = Theme.of(context);
    
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(2000),
            lastDate: lastDate ?? DateTime(2100),
          );
          if (date != null) {
            onChanged(date);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  displayValue ?? hintText ?? 'Select date...',
                  style: TextStyle(
                    fontSize: 12, 
                    color: displayValue != null 
                        ? theme.textTheme.bodyMedium?.color 
                        : theme.hintColor,
                  ),
                ),
              ),
            ),
            if (showClearButton && displayValue != null)
              InkWell(
                onTap: () => onChanged(null),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.clear, size: 16),
                ),
              ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.calendar_today, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}