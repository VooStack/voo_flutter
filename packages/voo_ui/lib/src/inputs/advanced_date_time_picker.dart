import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voo_ui/src/inputs/calendar.dart';
import 'package:voo_ui/src/inputs/calendar_theme.dart';
import 'package:voo_ui/src/foundations/design_system.dart';

/// Advanced date and time picker selection modes
enum VooDateTimeSelectionMode {
  /// Year only (e.g., 2024)
  year,
  /// Year and month (e.g., January 2024)
  yearMonth,
  /// Year, month, and day (e.g., January 15, 2024)
  yearMonthDay,
  /// Month and day only (e.g., January 15)
  monthDay,
  /// Day and time (e.g., 15th at 3:30 PM)
  dayTime,
  /// Full date and time (e.g., January 15, 2024 at 3:30 PM)
  yearMonthDayTime,
  /// Time only (e.g., 3:30 PM)
  time,
  /// Date range (start and end dates)
  dateRange,
  /// Date and time range (start and end with times)
  dateTimeRange,
}

/// Configuration for what components are selectable
class VooDateTimeComponents {
  final bool year;
  final bool month;
  final bool day;
  final bool hour;
  final bool minute;
  final bool second;
  
  const VooDateTimeComponents({
    this.year = true,
    this.month = true,
    this.day = true,
    this.hour = false,
    this.minute = false,
    this.second = false,
  });
  
  /// Preset for year only selection
  static const yearOnly = VooDateTimeComponents(
    year: true,
    month: false,
    day: false,
  );
  
  /// Preset for year and month selection
  static const yearMonth = VooDateTimeComponents(
    year: true,
    month: true,
    day: false,
  );
  
  /// Preset for full date selection
  static const date = VooDateTimeComponents(
    year: true,
    month: true,
    day: true,
  );
  
  /// Preset for month and day only
  static const monthDay = VooDateTimeComponents(
    year: false,
    month: true,
    day: true,
  );
  
  /// Preset for time only
  static const time = VooDateTimeComponents(
    year: false,
    month: false,
    day: false,
    hour: true,
    minute: true,
  );
  
  /// Preset for day and time
  static const dayTime = VooDateTimeComponents(
    year: false,
    month: false,
    day: true,
    hour: true,
    minute: true,
  );
  
  /// Preset for full date and time
  static const dateTime = VooDateTimeComponents(
    year: true,
    month: true,
    day: true,
    hour: true,
    minute: true,
  );
}

/// Advanced Material 3 date/time picker
class VooAdvancedDateTimePicker extends StatefulWidget {
  /// Selection mode
  final VooDateTimeSelectionMode mode;
  
  /// Components that are selectable
  final VooDateTimeComponents? components;
  
  /// Initial value
  final DateTime? initialValue;
  
  /// Initial range value
  final DateTimeRange? initialRange;
  
  /// First selectable date
  final DateTime? firstDate;
  
  /// Last selectable date
  final DateTime? lastDate;
  
  /// Value changed callback
  final void Function(DateTime? value)? onChanged;
  
  /// Range changed callback
  final void Function(DateTimeRange? range)? onRangeChanged;
  
  /// Whether to show as inline or field
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
  
  /// Whether to show seconds in time picker
  final bool showSeconds;
  
  /// Custom year range (if not specified, uses current year ± 50)
  final int? yearRangeStart;
  final int? yearRangeEnd;
  
  const VooAdvancedDateTimePicker({
    super.key,
    this.mode = VooDateTimeSelectionMode.yearMonthDay,
    this.components,
    this.initialValue,
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onRangeChanged,
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
    this.showSeconds = false,
    this.yearRangeStart,
    this.yearRangeEnd,
  });

  @override
  State<VooAdvancedDateTimePicker> createState() => _VooAdvancedDateTimePickerState();
}

class _VooAdvancedDateTimePickerState extends State<VooAdvancedDateTimePicker> {
  late TextEditingController _controller;
  DateTime? _selectedValue;
  DateTimeRange? _selectedRange;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    
    if (_isRangeMode) {
      _selectedRange = widget.initialRange;
    } else {
      _selectedValue = widget.initialValue;
    }
    
    _updateControllerText();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  bool get _isRangeMode =>
      widget.mode == VooDateTimeSelectionMode.dateRange ||
      widget.mode == VooDateTimeSelectionMode.dateTimeRange;
  
  VooDateTimeComponents get _components {
    if (widget.components != null) return widget.components!;
    
    switch (widget.mode) {
      case VooDateTimeSelectionMode.year:
        return VooDateTimeComponents.yearOnly;
      case VooDateTimeSelectionMode.yearMonth:
        return VooDateTimeComponents.yearMonth;
      case VooDateTimeSelectionMode.yearMonthDay:
      case VooDateTimeSelectionMode.dateRange:
        return VooDateTimeComponents.date;
      case VooDateTimeSelectionMode.monthDay:
        return VooDateTimeComponents.monthDay;
      case VooDateTimeSelectionMode.dayTime:
        return VooDateTimeComponents.dayTime;
      case VooDateTimeSelectionMode.yearMonthDayTime:
      case VooDateTimeSelectionMode.dateTimeRange:
        return VooDateTimeComponents.dateTime;
      case VooDateTimeSelectionMode.time:
        return VooDateTimeComponents.time;
    }
  }
  
  void _updateControllerText() {
    String text = '';
    
    if (_isRangeMode && _selectedRange != null) {
      final format = _getDateFormat();
      text = '${format.format(_selectedRange!.start)} - ${format.format(_selectedRange!.end)}';
    } else if (_selectedValue != null) {
      text = _getDateFormat().format(_selectedValue!);
    }
    
    _controller.text = text;
  }
  
  DateFormat _getDateFormat() {
    if (widget.dateFormat != null) {
      return DateFormat(widget.dateFormat!);
    }
    
    final c = _components;
    String pattern = '';
    
    if (c.year) pattern += 'yyyy';
    if (c.month) {
      if (pattern.isNotEmpty) pattern += ' ';
      pattern += 'MMM';
    }
    if (c.day) {
      if (pattern.isNotEmpty) pattern += ' ';
      pattern += 'd';
    }
    if (c.hour || c.minute) {
      if (pattern.isNotEmpty) pattern += ' ';
      if (widget.use24HourFormat) {
        pattern += 'HH:mm';
      } else {
        pattern += 'h:mm a';
      }
      if (c.second || widget.showSeconds) {
        pattern = pattern.replaceAll(':mm', ':mm:ss');
      }
    }
    
    if (pattern.isEmpty) pattern = 'yyyy-MM-dd';
    
    return DateFormat(pattern);
  }
  
  Future<void> _showPicker() async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (context) => _buildPickerDialog(),
    );
    
    if (result != null) {
      setState(() {
        if (_isRangeMode) {
          _selectedRange = result as DateTimeRange;
          widget.onRangeChanged?.call(_selectedRange);
        } else {
          _selectedValue = result as DateTime;
          widget.onChanged?.call(_selectedValue);
        }
        _updateControllerText();
      });
    }
  }
  
  Widget _buildPickerDialog() {
    switch (widget.mode) {
      case VooDateTimeSelectionMode.year:
        return _YearPickerDialog(
          initialYear: _selectedValue?.year,
          yearRangeStart: widget.yearRangeStart ?? DateTime.now().year - 50,
          yearRangeEnd: widget.yearRangeEnd ?? DateTime.now().year + 50,
        );
      case VooDateTimeSelectionMode.yearMonth:
        return _YearMonthPickerDialog(
          initialValue: _selectedValue,
          yearRangeStart: widget.yearRangeStart ?? DateTime.now().year - 50,
          yearRangeEnd: widget.yearRangeEnd ?? DateTime.now().year + 50,
        );
      case VooDateTimeSelectionMode.monthDay:
        return _MonthDayPickerDialog(
          initialValue: _selectedValue,
        );
      case VooDateTimeSelectionMode.dayTime:
        return _DayTimePickerDialog(
          initialValue: _selectedValue,
          use24HourFormat: widget.use24HourFormat,
          minuteInterval: widget.minuteInterval,
        );
      case VooDateTimeSelectionMode.yearMonthDay:
        return _FullDatePickerDialog(
          initialDate: _selectedValue,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          calendarTheme: widget.calendarTheme,
        );
      case VooDateTimeSelectionMode.yearMonthDayTime:
        return _DateTimePickerDialog(
          initialValue: _selectedValue,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          calendarTheme: widget.calendarTheme,
          use24HourFormat: widget.use24HourFormat,
          minuteInterval: widget.minuteInterval,
        );
      case VooDateTimeSelectionMode.time:
        return _TimeOnlyPickerDialog(
          initialTime: _selectedValue != null
              ? TimeOfDay.fromDateTime(_selectedValue!)
              : null,
          use24HourFormat: widget.use24HourFormat,
          minuteInterval: widget.minuteInterval,
        );
      case VooDateTimeSelectionMode.dateRange:
        return _DateRangePickerDialog(
          initialRange: _selectedRange,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          calendarTheme: widget.calendarTheme,
        );
      case VooDateTimeSelectionMode.dateTimeRange:
        return _DateTimeRangePickerDialog(
          initialRange: _selectedRange,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          calendarTheme: widget.calendarTheme,
          use24HourFormat: widget.use24HourFormat,
        );
    }
  }
  
  void _clear() {
    setState(() {
      _selectedValue = null;
      _selectedRange = null;
      _controller.clear();
    });
    
    if (_isRangeMode) {
      widget.onRangeChanged?.call(null);
    } else {
      widget.onChanged?.call(null);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.isInline) {
      return _buildInlineView();
    }
    
    final hasValue = _controller.text.isNotEmpty;
    
    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? _showPicker : null,
      decoration: widget.decoration ?? InputDecoration(
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
                icon: const Icon(Icons.clear),
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
  
  Widget _buildInlineView() {
    // Simplified inline view - could be expanded based on mode
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText ?? _getDefaultHintText(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: widget.enabled ? _showPicker : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _controller.text.isEmpty
                            ? (_getDefaultHintText())
                            : _controller.text,
                        style: _controller.text.isEmpty
                            ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).hintColor,
                                )
                            : Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    _getIcon(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _getIcon() {
    if (_components.hour || _components.minute) {
      if (_components.year || _components.month || _components.day) {
        return const Icon(Icons.event);
      }
      return const Icon(Icons.access_time);
    }
    return const Icon(Icons.calendar_today);
  }
  
  String _getDefaultHintText() {
    switch (widget.mode) {
      case VooDateTimeSelectionMode.year:
        return 'Select year';
      case VooDateTimeSelectionMode.yearMonth:
        return 'Select year and month';
      case VooDateTimeSelectionMode.yearMonthDay:
        return 'Select date';
      case VooDateTimeSelectionMode.monthDay:
        return 'Select month and day';
      case VooDateTimeSelectionMode.dayTime:
        return 'Select day and time';
      case VooDateTimeSelectionMode.yearMonthDayTime:
        return 'Select date and time';
      case VooDateTimeSelectionMode.time:
        return 'Select time';
      case VooDateTimeSelectionMode.dateRange:
        return 'Select date range';
      case VooDateTimeSelectionMode.dateTimeRange:
        return 'Select date and time range';
    }
  }
}

/// Year picker dialog following Material 3 design
class _YearPickerDialog extends StatefulWidget {
  final int? initialYear;
  final int yearRangeStart;
  final int yearRangeEnd;
  
  const _YearPickerDialog({
    this.initialYear,
    required this.yearRangeStart,
    required this.yearRangeEnd,
  });
  
  @override
  State<_YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<_YearPickerDialog> {
  late int _selectedYear;
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? DateTime.now().year;
    _scrollController = ScrollController();
    
    // Scroll to selected year after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedYear();
    });
  }
  
  void _scrollToSelectedYear() {
    final yearIndex = _selectedYear - widget.yearRangeStart;
    final itemHeight = 56.0; // Approximate height of each year item
    final targetOffset = yearIndex * itemHeight - 100; // Center approximately
    
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final years = List.generate(
      widget.yearRangeEnd - widget.yearRangeStart + 1,
      (index) => widget.yearRangeStart + index,
    );
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 360,
          maxHeight: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(design.spacingLg),
              color: colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select year',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedYear.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Year grid
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(design.spacingMd),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == _selectedYear;
                  final isCurrentYear = year == DateTime.now().year;
                  
                  return Material(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedYear = year;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: isCurrentYear && !isSelected
                              ? Border.all(color: colorScheme.primary)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          year.toString(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected || isCurrentYear
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Actions
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
                    onPressed: () {
                      final result = DateTime(_selectedYear);
                      Navigator.of(context).pop(result);
                    },
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

/// Year and month picker dialog
class _YearMonthPickerDialog extends StatefulWidget {
  final DateTime? initialValue;
  final int yearRangeStart;
  final int yearRangeEnd;
  
  const _YearMonthPickerDialog({
    this.initialValue,
    required this.yearRangeStart,
    required this.yearRangeEnd,
  });
  
  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  
  final List<String> _monthNames = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.initialValue?.year ?? now.year;
    _selectedMonth = widget.initialValue?.month ?? now.month;
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(design.spacingLg),
              color: colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select month and year',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_monthNames[_selectedMonth - 1]} $_selectedYear',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Year selector
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacingLg,
                vertical: design.spacingMd,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _selectedYear > widget.yearRangeStart
                        ? () {
                            setState(() {
                              _selectedYear--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _selectedYear.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _selectedYear < widget.yearRangeEnd
                        ? () {
                            setState(() {
                              _selectedYear++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            // Month grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(design.spacingMd),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == _selectedMonth;
                  final now = DateTime.now();
                  final isCurrentMonth = month == now.month && _selectedYear == now.year;
                  
                  return Material(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMonth = month;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: isCurrentMonth && !isSelected
                              ? Border.all(color: colorScheme.primary)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _monthNames[index].substring(0, 3),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected || isCurrentMonth
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Actions
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
                    onPressed: () {
                      final result = DateTime(_selectedYear, _selectedMonth);
                      Navigator.of(context).pop(result);
                    },
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

/// Month and day picker dialog
class _MonthDayPickerDialog extends StatefulWidget {
  final DateTime? initialValue;
  
  const _MonthDayPickerDialog({
    this.initialValue,
  });
  
  @override
  State<_MonthDayPickerDialog> createState() => _MonthDayPickerDialogState();
}

class _MonthDayPickerDialogState extends State<_MonthDayPickerDialog> {
  late int _selectedMonth;
  late int _selectedDay;
  
  final List<String> _monthNames = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = widget.initialValue?.month ?? now.month;
    _selectedDay = widget.initialValue?.day ?? now.day;
  }
  
  int _getDaysInMonth(int month) {
    // Use a leap year to handle February correctly
    return DateTime(2024, month + 1, 0).day;
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final daysInMonth = _getDaysInMonth(_selectedMonth);
    
    // Ensure selected day is valid for the month
    if (_selectedDay > daysInMonth) {
      _selectedDay = daysInMonth;
    }
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(design.spacingLg),
              color: colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select month and day',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_monthNames[_selectedMonth - 1]} $_selectedDay',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Month selector
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == _selectedMonth;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: FilterChip(
                      label: Text(_monthNames[index].substring(0, 3)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedMonth = month;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // Day grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(design.spacingMd),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == _selectedDay;
                  
                  return Material(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          day.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Actions
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
                    onPressed: () {
                      // Use current year as placeholder
                      final result = DateTime(2024, _selectedMonth, _selectedDay);
                      Navigator.of(context).pop(result);
                    },
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

/// Day and time picker dialog
class _DayTimePickerDialog extends StatefulWidget {
  final DateTime? initialValue;
  final bool use24HourFormat;
  final int minuteInterval;
  
  const _DayTimePickerDialog({
    this.initialValue,
    required this.use24HourFormat,
    required this.minuteInterval,
  });
  
  @override
  State<_DayTimePickerDialog> createState() => _DayTimePickerDialogState();
}

class _DayTimePickerDialogState extends State<_DayTimePickerDialog> {
  late int _selectedDay;
  late TimeOfDay _selectedTime;
  
  final List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = widget.initialValue?.weekday ?? now.weekday;
    _selectedTime = widget.initialValue != null
        ? TimeOfDay.fromDateTime(widget.initialValue!)
        : TimeOfDay.now();
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(design.spacingLg),
              color: colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select day and time',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_dayNames[_selectedDay - 1]} at ${_selectedTime.format(context)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Day selector
            Padding(
              padding: EdgeInsets.all(design.spacingMd),
              child: Column(
                children: List.generate(7, (index) {
                  final day = index + 1;
                  final isSelected = day == _selectedDay;
                  
                  return ListTile(
                    title: Text(_dayNames[index]),
                    selected: isSelected,
                    selectedTileColor: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedDay = day;
                      });
                    },
                  );
                }),
              ),
            ),
            // Time selector button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
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
                  
                  if (time != null) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text('Change time: ${_selectedTime.format(context)}'),
              ),
            ),
            const SizedBox(height: 16),
            // Actions
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
                    onPressed: () {
                      // Calculate the next occurrence of this day
                      final now = DateTime.now();
                      var targetDate = now;
                      while (targetDate.weekday != _selectedDay) {
                        targetDate = targetDate.add(const Duration(days: 1));
                      }
                      
                      final result = DateTime(
                        targetDate.year,
                        targetDate.month,
                        targetDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      Navigator.of(context).pop(result);
                    },
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

/// Full date picker dialog
class _FullDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;
  
  const _FullDatePickerDialog({
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
  });
  
  @override
  State<_FullDatePickerDialog> createState() => _FullDatePickerDialogState();
}

class _FullDatePickerDialogState extends State<_FullDatePickerDialog> {
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
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
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

/// Date and time picker dialog
class _DateTimePickerDialog extends StatefulWidget {
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;
  final bool use24HourFormat;
  final int minuteInterval;
  
  const _DateTimePickerDialog({
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
    required this.use24HourFormat,
    required this.minuteInterval,
  });
  
  @override
  State<_DateTimePickerDialog> createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<_DateTimePickerDialog> {
  late VooCalendarController _controller;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
    _selectedTime = widget.initialValue != null
        ? TimeOfDay.fromDateTime(widget.initialValue!)
        : null;
    _controller = VooCalendarController(
      initialDate: widget.initialValue,
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
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(design.spacingLg),
              child: Text(
                'Select Date and Time',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: VooCalendar(
                controller: _controller,
                initialDate: widget.initialValue,
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
            if (_selectedDate != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    
                    if (time != null) {
                      setState(() {
                        _selectedTime = time;
                      });
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _selectedTime != null
                        ? 'Time: ${_selectedTime!.format(context)}'
                        : 'Select time',
                  ),
                ),
              ),
            const SizedBox(height: 16),
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
                    onPressed: _selectedDate != null && _selectedTime != null
                        ? () {
                            final result = DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              _selectedTime!.hour,
                              _selectedTime!.minute,
                            );
                            Navigator.of(context).pop(result);
                          }
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

/// Time only picker dialog
class _TimeOnlyPickerDialog extends StatelessWidget {
  final TimeOfDay? initialTime;
  final bool use24HourFormat;
  final int minuteInterval;
  
  const _TimeOnlyPickerDialog({
    this.initialTime,
    required this.use24HourFormat,
    required this.minuteInterval,
  });
  
  @override
  Widget build(BuildContext context) {
    // Delegate to the built-in time picker
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final time = await showTimePicker(
        context: context,
        initialTime: initialTime ?? TimeOfDay.now(),
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
      
      if (context.mounted) {
        if (time != null) {
          // Convert to DateTime for consistency
          final now = DateTime.now();
          final result = DateTime(now.year, now.month, now.day, time.hour, time.minute);
          Navigator.of(context).pop(result);
        } else {
          Navigator.of(context).pop();
        }
      }
    });
    
    // Return empty container while waiting
    return const SizedBox.shrink();
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
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
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
                  if (_controller.rangeStart != null || _controller.rangeEnd != null) ...[
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

/// Date and time range picker dialog
class _DateTimeRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final VooCalendarTheme? calendarTheme;
  final bool use24HourFormat;
  
  const _DateTimeRangePickerDialog({
    this.initialRange,
    this.firstDate,
    this.lastDate,
    this.calendarTheme,
    required this.use24HourFormat,
  });
  
  @override
  State<_DateTimeRangePickerDialog> createState() => _DateTimeRangePickerDialogState();
}

class _DateTimeRangePickerDialogState extends State<_DateTimeRangePickerDialog> {
  late VooCalendarController _controller;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange?.start;
    _endDate = widget.initialRange?.end;
    _startTime = _startDate != null ? TimeOfDay.fromDateTime(_startDate!) : null;
    _endTime = _endDate != null ? TimeOfDay.fromDateTime(_endDate!) : null;
    
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
        constraints: const BoxConstraints(
          maxWidth: 450,
          maxHeight: 650,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(design.spacingLg),
              child: Column(
                children: [
                  Text(
                    'Select Date and Time Range',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (_controller.rangeStart != null || _controller.rangeEnd != null) ...[
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
            // Time selectors
            if (_startDate != null && _endDate != null)
              Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _startTime ?? TimeOfDay.now(),
                              );
                              
                              if (time != null) {
                                setState(() {
                                  _startTime = time;
                                });
                              }
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              _startTime != null
                                  ? 'Start: ${_startTime!.format(context)}'
                                  : 'Start time',
                            ),
                          ),
                        ),
                        SizedBox(width: design.spacingMd),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _endTime ?? TimeOfDay.now(),
                              );
                              
                              if (time != null) {
                                setState(() {
                                  _endTime = time;
                                });
                              }
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              _endTime != null
                                  ? 'End: ${_endTime!.format(context)}'
                                  : 'End time',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    onPressed: _canSubmit()
                        ? () {
                            final start = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day,
                              _startTime?.hour ?? 0,
                              _startTime?.minute ?? 0,
                            );
                            final end = DateTime(
                              _endDate!.year,
                              _endDate!.month,
                              _endDate!.day,
                              _endTime?.hour ?? 23,
                              _endTime?.minute ?? 59,
                            );
                            Navigator.of(context).pop(
                              DateTimeRange(start: start, end: end),
                            );
                          }
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
  
  bool _canSubmit() {
    return _startDate != null && 
           _endDate != null && 
           _startTime != null && 
           _endTime != null;
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