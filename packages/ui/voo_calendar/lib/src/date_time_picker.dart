import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'package:voo_calendar/src/calendar.dart';
import 'package:voo_calendar/src/calendar_theme.dart';

/// Date and time picker mode
enum VooDateTimePickerMode {
  /// Date only picker
  date,

  /// Time only picker
  time,

  /// Date and time picker
  dateTime,

  /// Date range picker
  dateRange,
}

/// Material 3 date/time picker using VooCalendar
class VooDateTimePicker extends StatefulWidget {
  /// Mode of the picker
  final VooDateTimePickerMode mode;

  /// Initial date/time
  final DateTime? initialDateTime;

  /// Initial date range
  final DateTimeRange? initialDateRange;

  /// First selectable date
  final DateTime? firstDate;

  /// Last selectable date
  final DateTime? lastDate;

  /// Value changed callback for single date/time
  final void Function(DateTime? dateTime)? onDateTimeChanged;

  /// Value changed callback for date range
  final void Function(DateTimeRange? range)? onDateRangeChanged;

  /// Whether to show as a field with dropdown or inline
  final bool isInline;

  /// Field decoration
  final InputDecoration? decoration;

  /// Calendar theme
  final VooCalendarTheme? calendarTheme;

  /// Time picker interval in minutes
  final int minuteInterval;

  /// Use 24 hour format
  final bool use24HourFormat;

  /// Custom date format
  final String? dateFormat;

  /// Custom time format
  final String? timeFormat;

  /// Enable field
  final bool enabled;

  /// Field hint text
  final String? hintText;

  /// Field label text
  final String? labelText;

  /// Field helper text
  final String? helperText;

  /// Field error text
  final String? errorText;

  /// Clear button icon
  final Widget? clearIcon;

  /// Calendar icon
  final Widget? calendarIcon;

  /// Clock icon
  final Widget? clockIcon;

  const VooDateTimePicker({
    super.key,
    this.mode = VooDateTimePickerMode.date,
    this.initialDateTime,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.onDateTimeChanged,
    this.onDateRangeChanged,
    this.isInline = false,
    this.decoration,
    this.calendarTheme,
    this.minuteInterval = 1,
    this.use24HourFormat = false,
    this.dateFormat,
    this.timeFormat,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.clearIcon,
    this.calendarIcon,
    this.clockIcon,
  });

  @override
  State<VooDateTimePicker> createState() => _VooDateTimePickerState();
}

class _VooDateTimePickerState extends State<VooDateTimePicker> {
  late TextEditingController _controller;
  DateTime? _selectedDateTime;
  DateTimeRange? _selectedDateRange;
  late VooCalendarController _calendarController;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.mode == VooDateTimePickerMode.dateRange) {
      _selectedDateRange = widget.initialDateRange;
      _updateControllerText();
    } else {
      _selectedDateTime = widget.initialDateTime;
      _selectedTime = widget.initialDateTime != null
          ? TimeOfDay.fromDateTime(widget.initialDateTime!)
          : null;
      _updateControllerText();
    }

    _calendarController = VooCalendarController(
      initialDate: widget.initialDateTime,
      selectionMode: widget.mode == VooDateTimePickerMode.dateRange
          ? VooCalendarSelectionMode.range
          : VooCalendarSelectionMode.single,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _updateControllerText() {
    String text = '';

    switch (widget.mode) {
      case VooDateTimePickerMode.date:
        if (_selectedDateTime != null) {
          final format = widget.dateFormat ?? 'MMM d, yyyy';
          text = DateFormat(format).format(_selectedDateTime!);
        }
        break;
      case VooDateTimePickerMode.time:
        if (_selectedTime != null) {
          final format =
              widget.timeFormat ??
              (widget.use24HourFormat ? 'HH:mm' : 'h:mm a');
          final dateTime = DateTime(
            2024,
            1,
            1,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
          text = DateFormat(format).format(dateTime);
        }
        break;
      case VooDateTimePickerMode.dateTime:
        if (_selectedDateTime != null) {
          final dateFormat = widget.dateFormat ?? 'MMM d, yyyy';
          final timeFormat =
              widget.timeFormat ??
              (widget.use24HourFormat ? 'HH:mm' : 'h:mm a');
          text =
              '${DateFormat(dateFormat).format(_selectedDateTime!)} ${DateFormat(timeFormat).format(_selectedDateTime!)}';
        }
        break;
      case VooDateTimePickerMode.dateRange:
        if (_selectedDateRange != null) {
          final format = widget.dateFormat ?? 'MMM d, yyyy';
          text =
              '${DateFormat(format).format(_selectedDateRange!.start)} - ${DateFormat(format).format(_selectedDateRange!.end)}';
        }
        break;
    }

    _controller.text = text;
  }

  Future<void> _showPicker() async {
    switch (widget.mode) {
      case VooDateTimePickerMode.date:
        await _showDatePicker();
        break;
      case VooDateTimePickerMode.time:
        await _showTimePicker();
        break;
      case VooDateTimePickerMode.dateTime:
        await _showDateTimePicker();
        break;
      case VooDateTimePickerMode.dateRange:
        await _showDateRangePicker();
        break;
    }
  }

  Future<void> _showDatePicker() async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => _DatePickerDialog(
        initialDate: _selectedDateTime,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        calendarTheme: widget.calendarTheme,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDateTime = result;
        _updateControllerText();
      });
      widget.onDateTimeChanged?.call(result);
    }
  }

  Future<void> _showTimePicker() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
        _selectedDateTime = DateTime(
          _selectedDateTime?.year ?? DateTime.now().year,
          _selectedDateTime?.month ?? DateTime.now().month,
          _selectedDateTime?.day ?? DateTime.now().day,
          result.hour,
          result.minute,
        );
        _updateControllerText();
      });
      widget.onDateTimeChanged?.call(_selectedDateTime);
    }
  }

  Future<void> _showDateTimePicker() async {
    // First show date picker
    final dateResult = await showDialog<DateTime>(
      context: context,
      builder: (context) => _DatePickerDialog(
        initialDate: _selectedDateTime,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        calendarTheme: widget.calendarTheme,
      ),
    );

    if (dateResult != null && mounted) {
      // Then show time picker
      final timeResult = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );

      if (timeResult != null) {
        setState(() {
          _selectedDateTime = DateTime(
            dateResult.year,
            dateResult.month,
            dateResult.day,
            timeResult.hour,
            timeResult.minute,
          );
          _selectedTime = timeResult;
          _updateControllerText();
        });
        widget.onDateTimeChanged?.call(_selectedDateTime);
      }
    }
  }

  Future<void> _showDateRangePicker() async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => _DateRangePickerDialog(
        initialRange: _selectedDateRange,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        calendarTheme: widget.calendarTheme,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
        _updateControllerText();
      });
      widget.onDateRangeChanged?.call(result);
    }
  }

  void _clear() {
    setState(() {
      _selectedDateTime = null;
      _selectedDateRange = null;
      _selectedTime = null;
      _controller.clear();
    });

    if (widget.mode == VooDateTimePickerMode.dateRange) {
      widget.onDateRangeChanged?.call(null);
    } else {
      widget.onDateTimeChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInline) {
      return _buildInlineCalendar();
    }

    final hasValue = _controller.text.isNotEmpty;

    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? _showPicker : null,
      decoration:
          widget.decoration ??
          InputDecoration(
            hintText: widget.hintText ?? _getDefaultHintText(),
            labelText: widget.labelText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            border: const OutlineInputBorder(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasValue && widget.enabled)
                  IconButton(
                    icon: widget.clearIcon ?? const Icon(Icons.clear),
                    onPressed: _clear,
                    tooltip: 'Clear',
                  ),
                IconButton(
                  icon: _getIcon(),
                  onPressed: widget.enabled ? _showPicker : null,
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildInlineCalendar() {
    return VooCalendar(
      controller: _calendarController,
      initialDate: widget.initialDateTime,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      selectionMode: widget.mode == VooDateTimePickerMode.dateRange
          ? VooCalendarSelectionMode.range
          : VooCalendarSelectionMode.single,
      theme: widget.calendarTheme,
      compact: true,
      showViewSwitcher: false,
      onDateSelected: (date) {
        setState(() {
          _selectedDateTime = date;
          _updateControllerText();
        });
        widget.onDateTimeChanged?.call(date);
      },
      onRangeSelected: (start, end) {
        if (start != null && end != null) {
          final range = DateTimeRange(start: start, end: end);
          setState(() {
            _selectedDateRange = range;
            _updateControllerText();
          });
          widget.onDateRangeChanged?.call(range);
        }
      },
    );
  }

  Widget _getIcon() {
    switch (widget.mode) {
      case VooDateTimePickerMode.date:
      case VooDateTimePickerMode.dateRange:
        return widget.calendarIcon ?? const Icon(Icons.calendar_today);
      case VooDateTimePickerMode.time:
        return widget.clockIcon ?? const Icon(Icons.access_time);
      case VooDateTimePickerMode.dateTime:
        return widget.calendarIcon ?? const Icon(Icons.event);
    }
  }

  String _getDefaultHintText() {
    switch (widget.mode) {
      case VooDateTimePickerMode.date:
        return 'Select date';
      case VooDateTimePickerMode.time:
        return 'Select time';
      case VooDateTimePickerMode.dateTime:
        return 'Select date and time';
      case VooDateTimePickerMode.dateRange:
        return 'Select date range';
    }
  }
}

/// Date picker dialog
class _DatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;

  const _DatePickerDialog({
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
  });

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
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

/// Date range picker dialog
class _DateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;

  const _DateRangePickerDialog({
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
  });

  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
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
