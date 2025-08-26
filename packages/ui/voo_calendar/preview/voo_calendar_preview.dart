import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart' as cal;
import 'package:voo_ui_core/voo_ui_core.dart';

// Widget previews for voo_calendar components

@pragma('preview')
class VooCalendarMonthPreview extends StatefulWidget {
  const VooCalendarMonthPreview({super.key});

  @override
  State<VooCalendarMonthPreview> createState() => _VooCalendarMonthPreviewState();
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
          appBar: AppBar(
            title: const Text('Calendar Month View'),
          ),
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

@pragma('preview')
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
          appBar: AppBar(
            title: const Text('Calendar Week View'),
          ),
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

@pragma('preview')
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
    _controller.addEvent(cal.VooCalendarEvent(
      id: '1',
      title: 'Morning Meeting',
      startTime: DateTime.now().copyWith(hour: 9, minute: 0),
      endTime: DateTime.now().copyWith(hour: 10, minute: 0),
      color: Colors.blue,
    ));
    _controller.addEvent(cal.VooCalendarEvent(
      id: '2',
      title: 'Lunch',
      startTime: DateTime.now().copyWith(hour: 12, minute: 0),
      endTime: DateTime.now().copyWith(hour: 13, minute: 0),
      color: Colors.green,
    ));
    _controller.addEvent(cal.VooCalendarEvent(
      id: '3',
      title: 'Team Sync',
      startTime: DateTime.now().copyWith(hour: 15, minute: 0),
      endTime: DateTime.now().copyWith(hour: 16, minute: 0),
      color: Colors.orange,
    ));
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
            title: const Text('Calendar Day View'),
          ),
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

@pragma('preview')
class VooDateTimePickerPreview extends StatefulWidget {
  const VooDateTimePickerPreview({super.key});

  @override
  State<VooDateTimePickerPreview> createState() => _VooDateTimePickerPreviewState();
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
          appBar: AppBar(
            title: const Text('Date & Time Pickers'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (value) => setState(() => _selectedDate = value),
                ),
                const SizedBox(height: 24),
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.dateTime,
                  initialDateTime: _selectedDateTime,
                  onDateTimeChanged: (value) => setState(() => _selectedDateTime = value),
                ),
                const SizedBox(height: 24),
                cal.VooDateTimePicker(
                  mode: cal.VooDateTimePickerMode.dateRange,
                  initialDateRange: _selectedRange,
                  onDateRangeChanged: (value) => setState(() => _selectedRange = value),
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