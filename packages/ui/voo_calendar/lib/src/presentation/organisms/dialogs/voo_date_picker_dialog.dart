import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_selection_mode.dart';
import 'package:voo_calendar/src/presentation/organisms/voo_calendar_widget.dart';
import 'package:voo_calendar/src/voo_calendar_controller.dart';

/// Date picker dialog
class VooDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;

  const VooDatePickerDialog({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
  });

  @override
  State<VooDatePickerDialog> createState() => _VooDatePickerDialogState();
}

class _VooDatePickerDialogState extends State<VooDatePickerDialog> {
  late VooCalendarController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = VooCalendarController(
      initialDate: widget.initialDate,
      selectionMode: VooCalendarSelectionMode.single,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(design.spacingLg),
              child: Text(
                'Select Date',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: VooCalendar(
                controller: _controller,
                initialDate: widget.initialDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                theme: widget.calendarTheme,
                showHeader: false,
                showViewSwitcher: false,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(design.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: design.spacingMd),
                  FilledButton(
                    onPressed: _selectedDate != null
                        ? () => Navigator.of(context).pop(_selectedDate)
                        : null,
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
