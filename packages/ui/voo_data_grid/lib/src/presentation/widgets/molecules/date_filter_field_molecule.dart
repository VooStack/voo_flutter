import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A molecule component for date filter input
class DateFilterFieldMolecule extends StatelessWidget {
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
  
  const DateFilterFieldMolecule({
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
    
    return InkWell(
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
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText ?? 'Select date...',
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showClearButton && displayValue != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
        child: Text(displayValue ?? ''),
      ),
    );
  }
}