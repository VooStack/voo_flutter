import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_ui/voo_ui.dart';

// Calendar Previews

@Preview(name: 'VooCalendar - Month View')
Widget vooCalendarMonthView() => _PreviewWrapper(
  child: _buildMonthViewCalendar(),
);

@Preview(name: 'VooCalendar - Week View')
Widget vooCalendarWeekView() => _PreviewWrapper(
  child: _buildWeekViewCalendar(),
);

@Preview(name: 'VooCalendar - Day View')
Widget vooCalendarDayView() => _PreviewWrapper(
  child: _buildDayViewCalendar(),
);

@Preview(name: 'VooCalendar - With Events')
Widget vooCalendarWithEvents() => _PreviewWrapper(
  child: _buildCalendarWithEvents(),
);

@Preview(name: 'VooDateTimePicker - Date')
Widget vooDatePickerField() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: VooDateTimePicker(
      mode: VooDateTimePickerMode.date,
      labelText: 'Select Date',
      hintText: 'Choose a date',
      onDateTimeChanged: (dateTime) {},
    ),
  ),
);

@Preview(name: 'VooDateTimePicker - Time')
Widget vooTimePickerField() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: VooDateTimePicker(
      mode: VooDateTimePickerMode.time,
      labelText: 'Select Time',
      hintText: 'Choose a time',
      onDateTimeChanged: (dateTime) {},
    ),
  ),
);

@Preview(name: 'VooDateTimePicker - Date Range')
Widget vooDateRangePickerField() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: VooDateTimePicker(
      mode: VooDateTimePickerMode.dateRange,
      labelText: 'Select Date Range',
      hintText: 'Choose start and end dates',
      onDateRangeChanged: (range) {},
    ),
  ),
);

@Preview(name: 'VooDateTimePicker - Inline')
Widget vooDatePickerInline() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 320,
      child: VooDateTimePicker(
        mode: VooDateTimePickerMode.date,
        isInline: true,
        onDateTimeChanged: (dateTime) {},
      ),
    ),
  ),
);

@Preview(name: 'VooCalendar - Compact')
Widget vooCalendarCompact() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 300,
      child: VooCalendar(
        compact: true,
        showViewSwitcher: false,
        onDateSelected: (date) {},
      ),
    ),
  ),
);

@Preview(name: 'VooCalendar - Custom Theme')
Widget vooCalendarCustomTheme() => _PreviewWrapper(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 350,
      child: VooCalendar(
        compact: true,
        showViewSwitcher: false,
        theme: VooCalendarTheme.light(),
        onDateSelected: (date) {},
      ),
    ),
  ),
);

// Helper wrapper for previews
class _PreviewWrapper extends StatelessWidget {
  final Widget child;
  const _PreviewWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return VooMaterialApp(
      title: 'Calendar Preview',
      home: Scaffold(
        body: child,
      ),
    );
  }
}

// Helper functions for calendar previews
Widget _buildMonthViewCalendar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 400,
      child: VooCalendar(
        initialView: VooCalendarView.month,
        showViewSwitcher: false,
        onDateSelected: (date) {},
      ),
    ),
  );
}

Widget _buildWeekViewCalendar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 400,
      child: VooCalendar(
        initialView: VooCalendarView.week,
        showViewSwitcher: false,
        onDateSelected: (date) {},
      ),
    ),
  );
}

Widget _buildDayViewCalendar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 400,
      child: VooCalendar(
        initialView: VooCalendarView.day,
        showViewSwitcher: false,
        onDateSelected: (date) {},
      ),
    ),
  );
}

Widget _buildCalendarWithEvents() {
  final controller = VooCalendarController(
    initialDate: DateTime.now(),
    initialView: VooCalendarView.month,
  );
  
  final now = DateTime.now();
  controller.addEvent(
    VooCalendarEvent(
      id: '1',
      title: 'Meeting',
      description: 'Team sync',
      startTime: DateTime(now.year, now.month, now.day, 10, 0),
      endTime: DateTime(now.year, now.month, now.day, 11, 0),
      color: Colors.blue,
      icon: Icons.people,
    ),
  );
  
  controller.addEvent(
    VooCalendarEvent(
      id: '2',
      title: 'Workshop',
      description: 'Flutter training',
      startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
      endTime: DateTime(now.year, now.month, now.day + 1, 17, 0),
      color: Colors.green,
      icon: Icons.school,
    ),
  );
  
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      height: 450,
      child: VooCalendar(
        controller: controller,
        showWeekNumbers: true,
        onDateSelected: (date) {},
        onEventTap: (event) {},
      ),
    ),
  );
}

/// Preview collection for VooCalendar and date/time picker widgets
class VooCalendarPreviews extends StatelessWidget {
  const VooCalendarPreviews({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Calendar Views'),
          _CalendarViewsSection(),
          SizedBox(height: 32),
          _SectionTitle('Date & Time Pickers'),
          _DateTimePickersSection(),
          SizedBox(height: 32),
          _SectionTitle('Selection Modes'),
          _SelectionModesSection(),
          SizedBox(height: 32),
          _SectionTitle('Themes'),
          _ThemesSection(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

/// Calendar views section
class _CalendarViewsSection extends StatefulWidget {
  const _CalendarViewsSection();

  @override
  State<_CalendarViewsSection> createState() => _CalendarViewsSectionState();
}

class _CalendarViewsSectionState extends State<_CalendarViewsSection> {
  late VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
      initialView: VooCalendarView.month,
    );
    _addSampleEvents();
  }

  void _addSampleEvents() {
    final now = DateTime.now();
    
    _controller.addEvent(
      VooCalendarEvent(
        id: '1',
        title: 'Meeting',
        description: 'Team sync',
        startTime: DateTime(now.year, now.month, now.day, 10, 0),
        endTime: DateTime(now.year, now.month, now.day, 11, 0),
        color: Colors.blue,
        icon: Icons.people,
      ),
    );
    
    _controller.addEvent(
      VooCalendarEvent(
        id: '2',
        title: 'Lunch',
        startTime: DateTime(now.year, now.month, now.day, 12, 30),
        endTime: DateTime(now.year, now.month, now.day, 13, 30),
        color: Colors.orange,
        icon: Icons.restaurant,
      ),
    );
    
    _controller.addEvent(
      VooCalendarEvent(
        id: '3',
        title: 'Workshop',
        description: 'Flutter training',
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 17, 0),
        color: Colors.green,
        icon: Icons.school,
      ),
    );
    
    _controller.addEvent(
      VooCalendarEvent(
        id: '4',
        title: 'Birthday',
        startTime: DateTime(now.year, now.month, now.day + 5),
        endTime: DateTime(now.year, now.month, now.day + 5),
        isAllDay: true,
        color: Colors.pink,
        icon: Icons.cake,
      ),
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
    
    return Column(
      children: [
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Calendar with All Views',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 500,
                  child: VooCalendar(
                    controller: _controller,
                    availableViews: const [
                      VooCalendarView.month,
                      VooCalendarView.week,
                      VooCalendarView.day,
                      VooCalendarView.year,
                      VooCalendarView.schedule,
                    ],
                    showWeekNumbers: true,
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onEventTap: (event) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Event: ${event.title}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compact Calendar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 300,
                  child: VooCalendar(
                    compact: true,
                    showViewSwitcher: false,
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Date time pickers section
class _DateTimePickersSection extends StatefulWidget {
  const _DateTimePickersSection();

  @override
  State<_DateTimePickersSection> createState() => _DateTimePickersSectionState();
}

class _DateTimePickersSectionState extends State<_DateTimePickersSection> {
  DateTime? _selectedDate;
  DateTime? _selectedDateTime;
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      children: [
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Picker Field',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                VooDateTimePicker(
                  mode: VooDateTimePickerMode.date,
                  labelText: 'Select Date',
                  hintText: 'Choose a date',
                  helperText: 'Tap to open calendar',
                  onDateTimeChanged: (dateTime) {
                    setState(() {
                      _selectedDate = dateTime;
                    });
                  },
                ),
                if (_selectedDate != null) ...[
                  SizedBox(height: design.spacingSm),
                  Text(
                    'Selected: ${_selectedDate.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Picker Field',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                VooDateTimePicker(
                  mode: VooDateTimePickerMode.time,
                  labelText: 'Select Time',
                  hintText: 'Choose a time',
                  use24HourFormat: false,
                  onDateTimeChanged: (dateTime) {
                    if (dateTime != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Time: ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date & Time Picker Field',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                VooDateTimePicker(
                  mode: VooDateTimePickerMode.dateTime,
                  labelText: 'Select Date & Time',
                  hintText: 'Choose date and time',
                  onDateTimeChanged: (dateTime) {
                    setState(() {
                      _selectedDateTime = dateTime;
                    });
                  },
                ),
                if (_selectedDateTime != null) ...[
                  SizedBox(height: design.spacingSm),
                  Text(
                    'Selected: $_selectedDateTime',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Range Picker Field',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                VooDateTimePicker(
                  mode: VooDateTimePickerMode.dateRange,
                  labelText: 'Select Date Range',
                  hintText: 'Choose start and end dates',
                  onDateRangeChanged: (range) {
                    setState(() {
                      _selectedRange = range;
                    });
                  },
                ),
                if (_selectedRange != null) ...[
                  SizedBox(height: design.spacingSm),
                  Text(
                    'Range: ${_selectedRange!.start.toString().split(' ')[0]} to ${_selectedRange!.end.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inline Date Picker',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooDateTimePicker(
                    mode: VooDateTimePickerMode.date,
                    isInline: true,
                    onDateTimeChanged: (dateTime) {
                      if (dateTime != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected: ${dateTime.toString().split(' ')[0]}'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Selection modes section
class _SelectionModesSection extends StatelessWidget {
  const _SelectionModesSection();

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      children: [
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Single Selection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    selectionMode: VooCalendarSelectionMode.single,
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multiple Selection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    selectionMode: VooCalendarSelectionMode.multiple,
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Toggled: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Range Selection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    selectionMode: VooCalendarSelectionMode.range,
                    onRangeSelected: (start, end) {
                      if (start != null && end != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Range: ${start.toString().split(' ')[0]} to ${end.toString().split(' ')[0]}',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Themes section
class _ThemesSection extends StatelessWidget {
  const _ThemesSection();

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      children: [
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Material 3 Theme (Default)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Theme - Purple',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                SizedBox(
                  height: 320,
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    theme: VooCalendarTheme(
                      backgroundColor: Colors.purple.shade50,
                      headerBackgroundColor: Colors.purple.shade700,
                      headerTextColor: Colors.white,
                      headerTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      weekdayTextStyle: TextStyle(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      dayTextStyle: TextStyle(
                        color: Colors.purple.shade900,
                      ),
                      dayTextColor: Colors.purple.shade900,
                      selectedDayBackgroundColor: Colors.purple,
                      selectedDayTextColor: Colors.white,
                      todayBackgroundColor: Colors.amber,
                      todayTextColor: Colors.white,
                      outsideMonthTextColor: Colors.purple.shade200,
                      rangeBackgroundColor: Colors.purple.shade100,
                      weekendTextColor: Colors.pink,
                      borderColor: Colors.purple.shade200,
                      gridLineColor: Colors.purple.shade100,
                      eventIndicatorColor: Colors.purple,
                      eventBackgroundColor: Colors.purple.shade100,
                      eventTitleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      eventDescriptionTextStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                      eventTimeTextStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                      weekNumberBackgroundColor: Colors.purple.shade100,
                      weekNumberTextStyle: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 10,
                      ),
                      monthTextStyle: TextStyle(
                        color: Colors.purple.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                      timeTextStyle: TextStyle(
                        color: Colors.purple.shade600,
                      ),
                      disabledDateColor: Colors.grey,
                      holidayTextColor: Colors.red,
                    ),
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: design.spacingMd),
        VooCard(
          child: Padding(
            padding: EdgeInsets.all(design.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Theme - Dark',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: design.spacingMd),
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(design.radiusMd),
                  ),
                  child: VooCalendar(
                    compact: true,
                    showHeader: false,
                    showViewSwitcher: false,
                    theme: VooCalendarTheme.dark(),
                    onDateSelected: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: ${date.toString().split(' ')[0]}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}