import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_calendar/voo_calendar.dart' as cal;
import 'package:voo_ui_core/voo_ui_core.dart';

@Preview(name: 'Calendar Month View')
Widget calendarMonthPreview() => const VooCalendarMonthPreview();

class VooCalendarMonthPreview extends StatefulWidget {
  const VooCalendarMonthPreview({super.key});

  @override
  State<VooCalendarMonthPreview> createState() =>
      _VooCalendarMonthPreviewState();
}

class _VooCalendarMonthPreviewState extends State<VooCalendarMonthPreview> {
  late cal.VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = cal.VooCalendarController(
      initialDate: DateTime.now(),
      initialView: cal.VooCalendarView.month,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Calendar Month View')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: cal.VooCalendar(
              controller: _controller,
              initialView: cal.VooCalendarView.month,
              onDateSelected: (date) {
                _controller.selectDate(date);
              },
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Calendar Week View')
Widget calendarWeekPreview() => const VooCalendarWeekPreview();

class VooCalendarWeekPreview extends StatefulWidget {
  const VooCalendarWeekPreview({super.key});

  @override
  State<VooCalendarWeekPreview> createState() => _VooCalendarWeekPreviewState();
}

class _VooCalendarWeekPreviewState extends State<VooCalendarWeekPreview> {
  late cal.VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = cal.VooCalendarController(
      initialDate: DateTime.now(),
      initialView: cal.VooCalendarView.week,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Calendar Week View')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: cal.VooCalendar(
              controller: _controller,
              initialView: cal.VooCalendarView.week,
              onDateSelected: (date) {
                _controller.selectDate(date);
              },
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Calendar Day View')
Widget calendarDayPreview() => const VooCalendarDayPreview();

class VooCalendarDayPreview extends StatefulWidget {
  const VooCalendarDayPreview({super.key});

  @override
  State<VooCalendarDayPreview> createState() => _VooCalendarDayPreviewState();
}

class _VooCalendarDayPreviewState extends State<VooCalendarDayPreview> {
  late cal.VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = cal.VooCalendarController(
      initialDate: DateTime.now(),
      initialView: cal.VooCalendarView.day,
    );

    // Add sample events one by one
    _controller.addEvent(
      cal.VooCalendarEvent(
        id: '1',
        title: 'Morning Meeting',
        startTime: DateTime.now().copyWith(hour: 9, minute: 0),
        endTime: DateTime.now().copyWith(hour: 10, minute: 0),
        color: Colors.blue,
      ),
    );
    _controller.addEvent(
      cal.VooCalendarEvent(
        id: '2',
        title: 'Lunch',
        startTime: DateTime.now().copyWith(hour: 12, minute: 0),
        endTime: DateTime.now().copyWith(hour: 13, minute: 0),
        color: Colors.green,
      ),
    );
    _controller.addEvent(
      cal.VooCalendarEvent(
        id: '3',
        title: 'Team Sync',
        startTime: DateTime.now().copyWith(hour: 15, minute: 0),
        endTime: DateTime.now().copyWith(hour: 16, minute: 0),
        color: Colors.orange,
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Calendar Day View')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: cal.VooCalendar(
              controller: _controller,
              initialView: cal.VooCalendarView.day,
              onDateSelected: (date) {
                _controller.selectDate(date);
              },
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Date & Time Pickers')
Widget dateTimePickerPreview() => const VooDateTimePickerPreview();

class VooDateTimePickerPreview extends StatefulWidget {
  const VooDateTimePickerPreview({super.key});

  @override
  State<VooDateTimePickerPreview> createState() =>
      _VooDateTimePickerPreviewState();
}

class _VooDateTimePickerPreviewState extends State<VooDateTimePickerPreview> {
  DateTime? _selectedDate;
  DateTime? _selectedDateTime;
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Date & Time Pickers')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (value) =>
                      setState(() => _selectedDate = value),
                ),
                const SizedBox(height: 24),
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.dateTime,
                  initialDateTime: _selectedDateTime,
                  onDateTimeChanged: (value) =>
                      setState(() => _selectedDateTime = value),
                ),
                const SizedBox(height: 24),
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.dateRange,
                  initialDateRange: _selectedRange,
                  onDateRangeChanged: (value) =>
                      setState(() => _selectedRange = value),
                ),
                const SizedBox(height: 24),
                Text(
                  _selectedDate != null
                      ? 'Selected Date: ${_selectedDate!.toLocal()}'
                      : 'No date selected',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (_selectedRange != null)
                  Text(
                    'Range: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Calendar With Events')
Widget calendarWithEventsPreview() => const VooCalendarWithEventsPreview();

class VooCalendarWithEventsPreview extends StatefulWidget {
  const VooCalendarWithEventsPreview({super.key});

  @override
  State<VooCalendarWithEventsPreview> createState() =>
      _VooCalendarWithEventsPreviewState();
}

class _VooCalendarWithEventsPreviewState
    extends State<VooCalendarWithEventsPreview> {
  late cal.VooCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = cal.VooCalendarController(
      initialDate: DateTime.now(),
      initialView: cal.VooCalendarView.month,
    );

    final today = DateTime.now();
    final events = [
      cal.VooCalendarEvent(
        id: '1',
        title: 'Team Meeting',
        startTime: today.copyWith(hour: 9, minute: 0),
        endTime: today.copyWith(hour: 10, minute: 0),
        color: Colors.blue,
      ),
      cal.VooCalendarEvent(
        id: '2',
        title: 'Product Review',
        startTime: today.copyWith(hour: 14, minute: 0),
        endTime: today.copyWith(hour: 15, minute: 30),
        color: Colors.green,
      ),
      cal.VooCalendarEvent(
        id: '3',
        title: 'Client Call',
        startTime: today
            .add(const Duration(days: 1))
            .copyWith(hour: 11, minute: 0),
        endTime: today
            .add(const Duration(days: 1))
            .copyWith(hour: 12, minute: 0),
        color: Colors.orange,
      ),
      cal.VooCalendarEvent(
        id: '4',
        title: 'Workshop',
        startTime: today
            .add(const Duration(days: 2))
            .copyWith(hour: 10, minute: 0),
        endTime: today
            .add(const Duration(days: 2))
            .copyWith(hour: 16, minute: 0),
        color: Colors.purple,
        isAllDay: false,
      ),
      cal.VooCalendarEvent(
        id: '5',
        title: 'Conference',
        startTime: today
            .add(const Duration(days: 5))
            .copyWith(hour: 0, minute: 0),
        endTime: today
            .add(const Duration(days: 7))
            .copyWith(hour: 23, minute: 59),
        color: Colors.red,
        isAllDay: true,
      ),
    ];

    for (final event in events) {
      _controller.addEvent(event);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Calendar With Events'),
            actions: [
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () => _controller.goToToday(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: cal.VooCalendar(
              controller: _controller,
              initialView: cal.VooCalendarView.month,
              onDateSelected: (date) {
                _controller.selectDate(date);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected: ${date.toString().split(' ')[0]}'),
                  ),
                );
              },
              onEventTap: (event) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Event: ${event.title}')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Advanced Date Time Picker')
Widget advancedDateTimePickerPreview() =>
    const VooAdvancedDateTimePickerPreview();

class VooAdvancedDateTimePickerPreview extends StatefulWidget {
  const VooAdvancedDateTimePickerPreview({super.key});

  @override
  State<VooAdvancedDateTimePickerPreview> createState() =>
      _VooAdvancedDateTimePickerPreviewState();
}

class _VooAdvancedDateTimePickerPreviewState
    extends State<VooAdvancedDateTimePickerPreview> {
  DateTime? _selectedDateTime;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Advanced Date Time Picker')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && mounted && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            _selectedTime = time;
                          });
                        }
                      }
                    },
                    child: const Text('Pick Date & Time'),
                  ),
                  const SizedBox(height: 32),
                  if (_selectedDateTime != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Selected Date & Time',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_selectedDateTime!.toLocal()}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Calendar Customization')
Widget calendarCustomizationPreview() =>
    const VooCalendarCustomizationPreview();

class VooCalendarCustomizationPreview extends StatefulWidget {
  const VooCalendarCustomizationPreview({super.key});

  @override
  State<VooCalendarCustomizationPreview> createState() =>
      _VooCalendarCustomizationPreviewState();
}

class _VooCalendarCustomizationPreviewState
    extends State<VooCalendarCustomizationPreview> {
  late cal.VooCalendarController _controller;
  cal.VooCalendarView _currentView = cal.VooCalendarView.month;
  bool _showWeekNumbers = false;
  bool _showWeekends = true;

  @override
  void initState() {
    super.initState();
    _controller = cal.VooCalendarController(
      initialDate: DateTime.now(),
      initialView: _currentView,
    );

    // Add sample events with custom colors
    final today = DateTime.now();
    _controller.addEvent(
      cal.VooCalendarEvent(
        id: '1',
        title: 'Design Review',
        startTime: today.copyWith(hour: 10, minute: 0),
        endTime: today.copyWith(hour: 11, minute: 30),
        color: const Color(0xFF4CAF50),
      ),
    );
    _controller.addEvent(
      cal.VooCalendarEvent(
        id: '2',
        title: 'Sprint Planning',
        startTime: today
            .add(const Duration(days: 1))
            .copyWith(hour: 9, minute: 0),
        endTime: today
            .add(const Duration(days: 1))
            .copyWith(hour: 12, minute: 0),
        color: const Color(0xFF2196F3),
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
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Calendar Customization'),
            actions: [
              PopupMenuButton<cal.VooCalendarView>(
                initialValue: _currentView,
                onSelected: (view) {
                  setState(() {
                    _currentView = view;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: cal.VooCalendarView.month,
                    child: Text('Month'),
                  ),
                  const PopupMenuItem(
                    value: cal.VooCalendarView.week,
                    child: Text('Week'),
                  ),
                  const PopupMenuItem(
                    value: cal.VooCalendarView.day,
                    child: Text('Day'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Switch(
                      value: _showWeekNumbers,
                      onChanged: (value) =>
                          setState(() => _showWeekNumbers = value),
                    ),
                    const Text('Show Week Numbers'),
                    const SizedBox(width: 24),
                    Switch(
                      value: _showWeekends,
                      onChanged: (value) =>
                          setState(() => _showWeekends = value),
                    ),
                    const Text('Show Weekends'),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: cal.VooCalendar(
                    controller: _controller,
                    initialView: _currentView,
                    theme: cal.VooCalendarTheme.fromContext(context).copyWith(
                      todayBackgroundColor: Colors.amber.shade100,
                      todayTextColor: Colors.amber.shade900,
                      weekendTextColor: _showWeekends
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onDateSelected: (date) {
                      _controller.selectDate(date);
                    },
                    onEventTap: (event) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(event.title),
                          content: Text(
                            'Start: ${event.startTime}\n'
                            'End: ${event.endTime}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
