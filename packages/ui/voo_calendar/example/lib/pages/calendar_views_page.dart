import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';

class CalendarViewsPage extends StatefulWidget {
  const CalendarViewsPage({super.key});

  @override
  State<CalendarViewsPage> createState() => _CalendarViewsPageState();
}

class _CalendarViewsPageState extends State<CalendarViewsPage> {
  late VooCalendarController _controller;
  VooCalendarView _selectedView = VooCalendarView.month;
  bool _showOnlyHoursWithEvents = false;
  bool _showHourLineActions = false;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
      initialView: _selectedView,
    );

    // Add sample events for day view demonstration
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _controller.setEvents([
      VooCalendarEvent(
        id: '1',
        title: 'Morning Meeting',
        description: 'Team sync meeting',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 10)),
        color: Colors.blue,
        icon: Icons.people,
      ),
      VooCalendarEvent(
        id: '2',
        title: 'Lunch Break',
        description: 'Time to eat',
        startTime: today.add(const Duration(hours: 12)),
        endTime: today.add(const Duration(hours: 13)),
        color: Colors.orange,
        icon: Icons.restaurant,
        isAllDay: false,
      ),
      VooCalendarEvent(
        id: '3',
        title: 'Project Review',
        description: 'Q4 project review',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        color: Colors.purple,
        icon: Icons.work,
      ),
      VooCalendarEvent(
        id: '4',
        title: 'Gym Time',
        description: 'Workout session',
        startTime: today.add(const Duration(hours: 18)),
        endTime: today.add(const Duration(hours: 19)),
        color: Colors.green,
        icon: Icons.fitness_center,
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar Views',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore different calendar view modes: Month, Week, Day, Year, and Schedule.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildViewSelector(),
            const SizedBox(height: 24),
            if (_selectedView == VooCalendarView.day) ...[
              _buildDayViewCustomization(),
              const SizedBox(height: 24),
            ],
            _buildCalendarCard(),
            const SizedBox(height: 24),
            _buildViewDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select View Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildViewChip(
                  VooCalendarView.month,
                  'Month',
                  Icons.calendar_view_month,
                ),
                _buildViewChip(
                  VooCalendarView.week,
                  'Week',
                  Icons.calendar_view_week,
                ),
                _buildViewChip(
                  VooCalendarView.day,
                  'Day',
                  Icons.calendar_view_day,
                ),
                _buildViewChip(
                  VooCalendarView.year,
                  'Year',
                  Icons.calendar_today,
                ),
                _buildViewChip(
                  VooCalendarView.schedule,
                  'Schedule',
                  Icons.schedule,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewChip(VooCalendarView view, String label, IconData icon) {
    final isSelected = _selectedView == view;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedView = view;
            _controller.setView(view);
          });
        }
      },
    );
  }

  Widget _buildDayViewCustomization() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Day View Customization',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Toggle these options to customize the day view appearance and behavior.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Show Only Hours with Events'),
              subtitle: const Text('Display only the hours that have scheduled events'),
              value: _showOnlyHoursWithEvents,
              onChanged: (value) {
                setState(() {
                  _showOnlyHoursWithEvents = value;
                });
              },
              secondary: const Icon(Icons.compress),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Show Hour Line Actions'),
              subtitle: const Text('Display action buttons on each hour line'),
              value: _showHourLineActions,
              onChanged: (value) {
                setState(() {
                  _showHourLineActions = value;
                });
              },
              secondary: const Icon(Icons.add_box),
            ),
            if (_showHourLineActions || _showOnlyHoursWithEvents) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _showOnlyHoursWithEvents && _showHourLineActions
                            ? 'Viewing compact schedule with quick actions'
                            : _showOnlyHoursWithEvents
                                ? 'Compact view: Showing only hours 9:00, 12:00, 14:00, and 18:00 (hours with events)'
                                : 'Quick actions: Click + button to add events to specific hours',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 600,
        child: VooCalendar(
          controller: _controller,
          initialDate: DateTime.now(),
          initialView: _selectedView,
          availableViews: VooCalendarView.values,
          showViewSwitcher: true,
          showHeader: true,
          enableSwipeNavigation: true,
          dayViewShowOnlyHoursWithEvents: _showOnlyHoursWithEvents,
          dayViewHourLineTrailingBuilder: _showHourLineActions
              ? (context, hour) {
                  return IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Add event at ${hour.toString().padLeft(2, '0')}:00'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    tooltip: 'Add event',
                  );
                }
              : null,
          onDateSelected: (date) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected: ${date.toString().split(' ')[0]}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onViewChanged: (view) {
            setState(() {
              _selectedView = view;
            });
          },
        ),
      ),
    );
  }

  Widget _buildViewDescription() {
    final descriptions = {
      VooCalendarView.month: ViewDescription(
        title: 'Month View',
        description:
            'The classic monthly calendar grid showing all days of the month. Perfect for getting a high-level overview of the entire month.',
        features: [
          'Shows all days in a month grid',
          'Highlights today and selected dates',
          'Supports drag selection',
          'Swipe left/right to navigate months',
        ],
      ),
      VooCalendarView.week: ViewDescription(
        title: 'Week View',
        description:
            'Displays a single week with hourly time slots. Ideal for detailed weekly planning and scheduling.',
        features: [
          'Shows 7 days horizontally',
          'Hourly time slots for events',
          'Perfect for weekly planning',
          'Swipe to navigate weeks',
        ],
      ),
      VooCalendarView.day: ViewDescription(
        title: 'Day View',
        description:
            'Focuses on a single day with detailed hourly breakdown. Great for precise day planning and time management.',
        features: [
          'Single day with hourly slots',
          'Detailed time management',
          'Clear event visualization',
          'Swipe to navigate days',
        ],
      ),
      VooCalendarView.year: ViewDescription(
        title: 'Year View',
        description:
            'Shows all 12 months in a grid layout. Perfect for long-term planning and getting a bird\'s-eye view of the year.',
        features: [
          'All 12 months visible',
          'Great for long-term planning',
          'Tap month to view details',
          'Navigate years easily',
        ],
      ),
      VooCalendarView.schedule: ViewDescription(
        title: 'Schedule View',
        description:
            'Lists events chronologically in a list format. Ideal for viewing upcoming events and appointments.',
        features: [
          'Chronological event list',
          'Easy to scan upcoming events',
          'Compact and efficient',
          'Perfect for event-heavy calendars',
        ],
      ),
    };

    final desc = descriptions[_selectedView]!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  desc.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              desc.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...desc.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewDescription {
  final String title;
  final String description;
  final List<String> features;

  ViewDescription({
    required this.title,
    required this.description,
    required this.features,
  });
}
