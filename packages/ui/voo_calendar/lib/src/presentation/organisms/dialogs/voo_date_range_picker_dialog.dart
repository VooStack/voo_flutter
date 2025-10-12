import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_selection_mode.dart';
import 'package:voo_calendar/src/presentation/organisms/voo_calendar_widget.dart';
import 'package:voo_calendar/src/voo_calendar_controller.dart';

/// Date range picker dialog
class VooDateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;

  const VooDateRangePickerDialog({
    super.key,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
  });

  @override
  State<VooDateRangePickerDialog> createState() => _VooDateRangePickerDialogState();
}

class _VooDateRangePickerDialogState extends State<VooDateRangePickerDialog> {
  late VooCalendarController _controller;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange?.start;
    _endDate = widget.initialRange?.end;
    _controller = VooCalendarController(
      initialDate: widget.initialRange?.start,
      selectionMode: VooCalendarSelectionMode.range,
    );
    if (_startDate != null) {
      _controller.selectDate(_startDate!);
      if (_endDate != null) {
        _controller.selectDate(_endDate!);
      }
    }
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
              child: Column(
                children: [
                  Text(
                    'Select Date Range',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (_controller.rangeStart != null ||
                      _controller.rangeEnd != null) ...[
                    SizedBox(height: design.spacingMd),
                    Text(
                      _getRangeText(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: VooCalendar(
                controller: _controller,
                initialDate: widget.initialRange?.start,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                selectionMode: VooCalendarSelectionMode.range,
                theme: widget.calendarTheme,
                showHeader: false,
                showViewSwitcher: false,
                onRangeSelected: (start, end) {
                  setState(() {
                    _startDate = start;
                    _endDate = end;
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
                    onPressed: _startDate != null && _endDate != null
                        ? () => Navigator.of(context).pop(
                            DateTimeRange(start: _startDate!, end: _endDate!),
                          )
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

  String _getRangeText() {
    if (_controller.rangeStart != null && _controller.rangeEnd != null) {
      final format = DateFormat('MMM d, yyyy');
      return '${format.format(_controller.rangeStart!)} - ${format.format(_controller.rangeEnd!)}';
    } else if (_controller.rangeStart != null) {
      final format = DateFormat('MMM d, yyyy');
      return 'Start: ${format.format(_controller.rangeStart!)}';
    }
    return '';
  }
}
