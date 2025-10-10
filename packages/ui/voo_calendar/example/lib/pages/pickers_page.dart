import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';
import 'package:intl/intl.dart';

class PickersPage extends StatefulWidget {
  const PickersPage({super.key});

  @override
  State<PickersPage> createState() => _PickersPageState();
}

class _PickersPageState extends State<PickersPage> {
  DateTime? _selectedDate;
  DateTime? _selectedTime;
  DateTime? _selectedDateTime;
  DateTimeRange? _selectedDateRange;

  // Advanced picker selections
  DateTime? _yearSelection;
  DateTime? _yearMonthSelection;
  DateTime? _monthDaySelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time Pickers',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore various date and time picker components with different modes and configurations.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildBasicPickersSection(),
            const SizedBox(height: 24),
            _buildAdvancedPickersSection(),
            const SizedBox(height: 24),
            _buildInlinePickerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicPickersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Pickers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Standard date and time pickers for common use cases.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            VooDateTimePicker(
              mode: VooDateTimePickerMode.date,
              labelText: 'Date Picker',
              hintText: 'Select a date',
              initialDateTime: _selectedDate,
              onDateTimeChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
                if (date != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('MMM d, yyyy').format(date)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            VooDateTimePicker(
              mode: VooDateTimePickerMode.time,
              labelText: 'Time Picker',
              hintText: 'Select a time',
              initialDateTime: _selectedTime,
              onDateTimeChanged: (time) {
                setState(() {
                  _selectedTime = time;
                });
                if (time != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('h:mm a').format(time)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            VooDateTimePicker(
              mode: VooDateTimePickerMode.dateTime,
              labelText: 'Date & Time Picker',
              hintText: 'Select date and time',
              initialDateTime: _selectedDateTime,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _selectedDateTime = dateTime;
                });
                if (dateTime != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('MMM d, yyyy h:mm a').format(dateTime)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            VooDateTimePicker(
              mode: VooDateTimePickerMode.dateRange,
              labelText: 'Date Range Picker',
              hintText: 'Select date range',
              initialDateRange: _selectedDateRange,
              onDateRangeChanged: (range) {
                setState(() {
                  _selectedDateRange = range;
                });
                if (range != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('MMM d').format(range.start)} - ${DateFormat('MMM d, yyyy').format(range.end)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedPickersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Pickers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Specialized pickers for granular date and time component selection.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            VooAdvancedDateTimePicker(
              mode: VooDateTimeSelectionMode.year,
              labelText: 'Year Picker',
              hintText: 'Select a year',
              initialValue: _yearSelection,
              onChanged: (date) {
                setState(() {
                  _yearSelection = date;
                });
                if (date != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected year: ${date.year}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            VooAdvancedDateTimePicker(
              mode: VooDateTimeSelectionMode.yearMonth,
              labelText: 'Year & Month Picker',
              hintText: 'Select year and month',
              initialValue: _yearMonthSelection,
              onChanged: (date) {
                setState(() {
                  _yearMonthSelection = date;
                });
                if (date != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('MMMM yyyy').format(date)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            VooAdvancedDateTimePicker(
              mode: VooDateTimeSelectionMode.monthDay,
              labelText: 'Month & Day Picker',
              hintText: 'Select month and day',
              initialValue: _monthDaySelection,
              onChanged: (date) {
                setState(() {
                  _monthDaySelection = date;
                });
                if (date != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected: ${DateFormat('MMMM d').format(date)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildPickerFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerFeatures() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Picker Features',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('Material 3 Design with modern UI'),
          _buildFeatureItem('Customizable date formats'),
          _buildFeatureItem('24-hour or 12-hour time formats'),
          _buildFeatureItem('Clear button for easy reset'),
          _buildFeatureItem('Inline or dialog presentation'),
          _buildFeatureItem('Min/max date constraints'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlinePickerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inline Calendar Picker',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Display calendar directly without a dialog.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: VooDateTimePicker(
                mode: VooDateTimePickerMode.date,
                isInline: true,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            if (_selectedDate != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Selected: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
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
}
