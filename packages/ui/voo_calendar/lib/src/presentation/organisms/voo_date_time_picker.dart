import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:voo_calendar/src/calendar_theme.dart';
import 'package:voo_calendar/src/domain/enums/voo_calendar_selection_mode.dart';
import 'package:voo_calendar/src/domain/enums/voo_date_time_picker_mode.dart';
import 'package:voo_calendar/src/presentation/organisms/dialogs/voo_date_picker_dialog.dart';
import 'package:voo_calendar/src/presentation/organisms/dialogs/voo_date_range_picker_dialog.dart';
import 'package:voo_calendar/src/presentation/organisms/voo_calendar_widget.dart';
import 'package:voo_calendar/src/voo_calendar_controller.dart';

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
      builder: (context) => VooDatePickerDialog(
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
      builder: (context) => VooDatePickerDialog(
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
      builder: (context) => VooDateRangePickerDialog(
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
