import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../foundations/design_system.dart';

/// Simple date and time picker using Flutter's built-in pickers
/// TODO: Replace with full VooCalendar-based implementation when voo_calendar is added as dependency
class VooDateTimePicker extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? label;
  final String? hintText;
  final bool enabled;
  final bool showTime;
  
  const VooDateTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.label,
    this.hintText,
    this.enabled = true,
    this.showTime = false,
  });

  @override
  State<VooDateTimePicker> createState() => _VooDateTimePickerState();
}

class _VooDateTimePickerState extends State<VooDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final dateFormat = widget.showTime 
        ? DateFormat('MMM dd, yyyy HH:mm')
        : DateFormat('MMM dd, yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: design.spacingSm),
        ],
        InkWell(
          onTap: widget.enabled ? () => _selectDateTime(context) : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Select date${widget.showTime ? ' and time' : ''}',
              enabled: widget.enabled,
              suffixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(design.radiusMd),
              ),
            ),
            child: Text(
              widget.value != null ? dateFormat.format(widget.value!) : '',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.value ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    
    if (!mounted) return;
    
    if (pickedDate != null) {
      if (widget.showTime) {
        if (!context.mounted) return;
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(widget.value ?? DateTime.now()),
        );
        
        if (!mounted) return;
        
        if (pickedTime != null) {
          final combined = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          widget.onChanged?.call(combined);
        }
      } else {
        widget.onChanged?.call(pickedDate);
      }
    }
  }
}

/// Simple date range picker
class VooDateRangePicker extends StatelessWidget {
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? label;
  final String? hintText;
  final bool enabled;
  
  const VooDateRangePicker({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.label,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelMedium,
          ),
          SizedBox(height: design.spacingSm),
        ],
        InkWell(
          onTap: enabled ? () => _selectDateRange(context) : null,
          borderRadius: BorderRadius.circular(design.radiusMd),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hintText ?? 'Select date range',
              enabled: enabled,
              suffixIcon: const Icon(Icons.date_range),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(design.radiusMd),
              ),
            ),
            child: Text(
              value != null 
                  ? '${dateFormat.format(value!.start)} - ${dateFormat.format(value!.end)}'
                  : '',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: value,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
    
    if (picked != null) {
      onChanged?.call(picked);
    }
  }
}