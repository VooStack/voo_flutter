import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

/// Example demonstrating VooCalendar and VooDateTimePicker widgets
class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  late VooCalendarController _calendarController;
  DateTime? _selectedDate;
  DateTimeRange? _selectedDateRange;
  TimeOfDay? _selectedTime;
  
  @override
  void initState() {
    super.initState();
    _calendarController = VooCalendarController(
      initialDate: DateTime.now(),
      initialView: VooCalendarView.month,
      selectionMode: VooCalendarSelectionMode.single,
    );
    
    // Add sample events
    _addSampleEvents();
  }
  
  void _addSampleEvents() {
    final now = DateTime.now();
    
    _calendarController.addEvent(
      VooCalendarEvent(
        id: '1',
        title: 'Team Standup',
        description: 'Daily team sync meeting',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 9, 30),
        color: Colors.blue,
        icon: Icons.group,
      ),
    );
    
    _calendarController.addEvent(
      VooCalendarEvent(
        id: '2',
        title: 'Design Review',
        description: 'Review new UI designs',
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 30),
        color: Colors.purple,
        icon: Icons.palette,
      ),
    );
    
    _calendarController.addEvent(
      VooCalendarEvent(
        id: '3',
        title: 'Sprint Planning',
        description: 'Plan next sprint tasks',
        startTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 12, 0),
        color: Colors.green,
        icon: Icons.task_alt,
      ),
    );
    
    _calendarController.addEvent(
      VooCalendarEvent(
        id: '4',
        title: 'Release Day',
        description: 'Version 2.0 release',
        startTime: DateTime(now.year, now.month, now.day + 5),
        endTime: DateTime(now.year, now.month, now.day + 5),
        isAllDay: true,
        color: Colors.orange,
        icon: Icons.rocket_launch,
      ),
    );
    
    _calendarController.addEvent(
      VooCalendarEvent(
        id: '5',
        title: 'Conference',
        description: 'Flutter Forward 2024',
        startTime: DateTime(now.year, now.month, now.day + 10),
        endTime: DateTime(now.year, now.month, now.day + 12),
        isAllDay: true,
        color: Colors.red,
        icon: Icons.event,
      ),
    );
  }
  
  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Example'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(design.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Calendar
            Text(
              'Full Calendar with Events',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: design.spacingMd),
            VooCard(
              child: SizedBox(
                height: 600,
                child: VooCalendar(
                  controller: _calendarController,
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
                    _showEventDetails(context, event);
                  },
                ),
              ),
            ),
            
            SizedBox(height: design.spacingXl),
            Divider(),
            SizedBox(height: design.spacingXl),
            
            // Date/Time Pickers
            Text(
              'Date & Time Pickers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: design.spacingMd),
            
            // Date Picker
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Picker',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: design.spacingMd),
                    VooDateTimePicker(
                      mode: VooDateTimePickerMode.date,
                      labelText: 'Select Date',
                      hintText: 'Choose a date',
                      helperText: 'Pick your preferred date',
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
            
            // Time Picker
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Picker',
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
                          setState(() {
                            _selectedTime = TimeOfDay.fromDateTime(dateTime);
                          });
                        }
                      },
                    ),
                    if (_selectedTime != null) ...[
                      SizedBox(height: design.spacingSm),
                      Text(
                        'Selected: ${_selectedTime!.format(context)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: design.spacingMd),
            
            // Date & Time Picker
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time Picker',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: design.spacingMd),
                    VooDateTimePicker(
                      mode: VooDateTimePickerMode.dateTime,
                      labelText: 'Select Date & Time',
                      hintText: 'Choose date and time',
                      onDateTimeChanged: (dateTime) {
                        if (dateTime != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected: $dateTime'),
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
            
            // Date Range Picker
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Range Picker',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: design.spacingMd),
                    VooDateTimePicker(
                      mode: VooDateTimePickerMode.dateRange,
                      labelText: 'Select Date Range',
                      hintText: 'Choose start and end dates',
                      onDateRangeChanged: (range) {
                        setState(() {
                          _selectedDateRange = range;
                        });
                      },
                    ),
                    if (_selectedDateRange != null) ...[
                      SizedBox(height: design.spacingSm),
                      Text(
                        'Range: ${_selectedDateRange!.start.toString().split(' ')[0]} to ${_selectedDateRange!.end.toString().split(' ')[0]}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            SizedBox(height: design.spacingXl),
            Divider(),
            SizedBox(height: design.spacingXl),
            
            // Inline Calendar
            Text(
              'Inline Date Picker',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: design.spacingMd),
            
            VooCard(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Embedded Calendar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: design.spacingMd),
                    SizedBox(
                      height: 350,
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
            
            SizedBox(height: design.spacingXl),
            
            // Custom Theme Example
            Text(
              'Custom Themed Calendar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: design.spacingMd),
            
            VooCard(
              child: SizedBox(
                height: 400,
                child: VooCalendar(
                  initialView: VooCalendarView.month,
                  showViewSwitcher: false,
                  theme: VooCalendarTheme(
                    backgroundColor: Colors.indigo.shade50,
                    headerBackgroundColor: Colors.indigo.shade700,
                    headerTextColor: Colors.white,
                    headerTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    selectedDayBackgroundColor: Colors.indigo,
                    selectedDayTextColor: Colors.white,
                    todayBackgroundColor: Colors.orange,
                    todayTextColor: Colors.white,
                    eventIndicatorColor: Colors.pink,
                    borderColor: Colors.indigo.shade200,
                    gridLineColor: Colors.indigo.shade100,
                    weekdayTextStyle: TextStyle(
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    dayTextStyle: TextStyle(
                      color: Colors.indigo.shade900,
                    ),
                    dayTextColor: Colors.indigo.shade900,
                    outsideMonthTextColor: Colors.indigo.shade300,
                    rangeBackgroundColor: Colors.indigo.shade100,
                    weekendTextColor: Colors.red,
                    eventBackgroundColor: Colors.indigo.shade200,
                    eventTitleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    eventDescriptionTextStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                    ),
                    eventTimeTextStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                    weekNumberBackgroundColor: Colors.indigo.shade100,
                    weekNumberTextStyle: TextStyle(
                      color: Colors.indigo.shade700,
                      fontSize: 10,
                    ),
                    monthTextStyle: TextStyle(
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                    timeTextStyle: TextStyle(
                      color: Colors.indigo.shade600,
                      fontSize: 11,
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
            ),
          ],
        ),
      ),
    );
  }
  
  void _showEventDetails(BuildContext context, VooCalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (event.icon != null) ...[
              Icon(event.icon, color: event.color),
              const SizedBox(width: 8),
            ],
            Text(event.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[
              Text(event.description!),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 8),
                Text(
                  event.isAllDay
                      ? 'All Day Event'
                      : '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                        '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${event.startTime.day}/${event.startTime.month}/${event.startTime.year}',
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}