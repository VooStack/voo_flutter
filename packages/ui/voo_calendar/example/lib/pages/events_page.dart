import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late VooCalendarController _controller;
  List<VooCalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(initialDate: DateTime.now());
    _generateSampleEvents();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateSampleEvents() {
    final now = DateTime.now();
    _events = [
      VooCalendarEvent(
        id: '1',
        title: 'Team Meeting',
        description: 'Quarterly planning and review',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 30),
        color: Colors.blue,
        icon: Icons.people,
      ),
      VooCalendarEvent(
        id: '2',
        title: 'Lunch Break',
        description: 'Team lunch at restaurant',
        startTime: DateTime(now.year, now.month, now.day, 12, 0),
        endTime: DateTime(now.year, now.month, now.day, 13, 0),
        color: Colors.green,
        icon: Icons.restaurant,
      ),
      VooCalendarEvent(
        id: '3',
        title: 'Client Presentation',
        description: 'Q3 results presentation',
        startTime: DateTime(now.year, now.month, now.day, 14, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 30),
        color: Colors.orange,
        icon: Icons.present_to_all,
      ),
      VooCalendarEvent(
        id: '4',
        title: 'All-Day Workshop',
        description: 'Professional development workshop',
        startTime: DateTime(now.year, now.month, now.day + 2, 0, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 23, 59),
        color: Colors.purple,
        icon: Icons.school,
        isAllDay: true,
      ),
      VooCalendarEvent(
        id: '5',
        title: 'Project Deadline',
        description: 'Submit final deliverables',
        startTime: DateTime(now.year, now.month, now.day + 5, 17, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 18, 0),
        color: Colors.red,
        icon: Icons.flag,
      ),
      VooCalendarEvent(
        id: '6',
        title: 'Team Building',
        description: 'Outdoor activities',
        startTime: DateTime(now.year, now.month, now.day + 7, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 7, 16, 0),
        color: Colors.teal,
        icon: Icons.celebration,
      ),
    ];

    for (final event in _events) {
      _controller.addEvent(event);
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => _AddEventDialog(
        onEventAdded: (event) {
          setState(() {
            _events.add(event);
            _controller.addEvent(event);
          });
        },
      ),
    );
  }

  void _removeEvent(String eventId) {
    setState(() {
      _events.removeWhere((e) => e.id == eventId);
      _controller.removeEvent(eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Events Management', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Create, view, and manage calendar events with rich details.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(onPressed: _addEvent, icon: const Icon(Icons.add), label: const Text('Add Event')),
              ],
            ),
            const SizedBox(height: 24),
            _buildCalendarCard(),
            const SizedBox(height: 24),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 500,
        child: VooCalendar(
          controller: _controller,
          initialDate: DateTime.now(),
          onEventTap: (event) {
            _showEventDetails(event);
          },
          onDateSelected: (date) {
            final eventsOnDate = _controller.getEventsForDate(date);
            if (eventsOnDate.isNotEmpty) {
              _showEventsForDate(date, eventsOnDate);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (_events.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.event_busy, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text('No Events', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Add your first event to get started', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }

    final sortedEvents = List<VooCalendarEvent>.from(_events)..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Events (${_events.length})', style: Theme.of(context).textTheme.titleLarge),
                if (_events.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        for (final event in _events) {
                          _controller.removeEvent(event.id);
                        }
                        _events.clear();
                      });
                    },
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear All'),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedEvents.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final event = sortedEvents[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: event.color?.withValues(alpha: 0.2),
                  child: Icon(event.icon ?? Icons.event, color: event.color),
                ),
                title: Text(event.title),
                subtitle: Text(
                  event.isAllDay
                      ? 'All day - ${DateFormat('MMM d, yyyy').format(event.startTime)}'
                      : '${DateFormat('MMM d, yyyy h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _removeEvent(event.id)),
                onTap: () => _showEventDetails(event),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEventDetails(VooCalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (event.icon != null) Icon(event.icon, color: event.color, size: 24),
            if (event.icon != null) const SizedBox(width: 8),
            Expanded(child: Text(event.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[Text(event.description!, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 16)],
            _buildEventDetailRow(
              Icons.access_time,
              'Time',
              event.isAllDay ? 'All day' : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
            ),
            const SizedBox(height: 8),
            _buildEventDetailRow(Icons.calendar_today, 'Date', DateFormat('EEEE, MMMM d, yyyy').format(event.startTime)),
            const SizedBox(height: 8),
            _buildEventDetailRow(Icons.timelapse, 'Duration', _formatDuration(event.duration)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _removeEvent(event.id);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  void _showEventsForDate(DateTime date, List<VooCalendarEvent> events) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Events on ${DateFormat('MMM d, yyyy').format(date)}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: events.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(event.icon ?? Icons.event, color: event.color),
                title: Text(event.title),
                subtitle: Text(event.isAllDay ? 'All day' : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEventDetails(event);
                },
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) {
      return '$minutes minute${minutes == 1 ? '' : 's'}';
    }
    if (minutes == 0) {
      return '$hours hour${hours == 1 ? '' : 's'}';
    }
    return '$hours hour${hours == 1 ? '' : 's'} $minutes minute${minutes == 1 ? '' : 's'}';
  }
}

class _AddEventDialog extends StatefulWidget {
  final void Function(VooCalendarEvent event) onEventAdded;

  const _AddEventDialog({required this.onEventAdded});

  @override
  State<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<_AddEventDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DateTime _startTime = DateTime.now();
  final DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.event;
  bool _isAllDay = false;

  final List<Color> _availableColors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple, Colors.teal, Colors.pink, Colors.indigo];

  final List<IconData> _availableIcons = [Icons.event, Icons.people, Icons.work, Icons.restaurant, Icons.celebration, Icons.school, Icons.flight, Icons.sports];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('All Day Event'),
              value: _isAllDay,
              onChanged: (value) {
                setState(() {
                  _isAllDay = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3) : null,
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Icon', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableIcons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                      border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final event = VooCalendarEvent(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                startTime: _startTime,
                endTime: _endTime,
                color: _selectedColor,
                icon: _selectedIcon,
                isAllDay: _isAllDay,
              );
              widget.onEventAdded(event);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
