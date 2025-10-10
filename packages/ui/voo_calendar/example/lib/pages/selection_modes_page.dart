import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';
import 'package:intl/intl.dart';

class SelectionModesPage extends StatefulWidget {
  const SelectionModesPage({super.key});

  @override
  State<SelectionModesPage> createState() => _SelectionModesPageState();
}

class _SelectionModesPageState extends State<SelectionModesPage> {
  late VooCalendarController _controller;
  VooCalendarSelectionMode _selectedMode = VooCalendarSelectionMode.single;
  DateTime? _selectedDate;
  Set<DateTime> _selectedDates = {};
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
      selectionMode: _selectedMode,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeSelectionMode(VooCalendarSelectionMode mode) {
    setState(() {
      _selectedMode = mode;
      _selectedDate = null;
      _selectedDates = {};
      _rangeStart = null;
      _rangeEnd = null;
    });

    _controller.dispose();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
      selectionMode: mode,
    );
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
              'Selection Modes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore different selection modes: None, Single, Multiple, and Range with gesture support.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildModeSelector(),
            const SizedBox(height: 24),
            _buildCalendarCard(),
            const SizedBox(height: 24),
            _buildSelectionInfo(),
            const SizedBox(height: 24),
            _buildModeDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildModeChip(
                  VooCalendarSelectionMode.none,
                  'None',
                  Icons.block,
                ),
                _buildModeChip(
                  VooCalendarSelectionMode.single,
                  'Single',
                  Icons.radio_button_checked,
                ),
                _buildModeChip(
                  VooCalendarSelectionMode.multiple,
                  'Multiple',
                  Icons.check_box,
                ),
                _buildModeChip(
                  VooCalendarSelectionMode.range,
                  'Range',
                  Icons.date_range,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChip(
    VooCalendarSelectionMode mode,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedMode == mode;
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
          _changeSelectionMode(mode);
        }
      },
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
          selectionMode: _selectedMode,
          showViewSwitcher: false,
          gestureConfig: const VooCalendarGestureConfig(
            enableDragSelection: true,
            enableLongPressRange: true,
            enableSwipeNavigation: true,
          ),
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
              _selectedDates = _controller.selectedDates;
            });
          },
          onRangeSelected: (start, end) {
            setState(() {
              _rangeStart = start;
              _rangeEnd = end;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSelectionInfo() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Selection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSelectionDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionDetails() {
    final dateFormat = DateFormat('MMM d, yyyy');

    switch (_selectedMode) {
      case VooCalendarSelectionMode.none:
        return Text(
          'Selection is disabled in this mode.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        );

      case VooCalendarSelectionMode.single:
        return Text(
          _selectedDate != null
              ? 'Selected: ${dateFormat.format(_selectedDate!)}'
              : 'No date selected. Tap a date to select.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        );

      case VooCalendarSelectionMode.multiple:
        if (_selectedDates.isEmpty) {
          return Text(
            'No dates selected. Tap dates to select multiple.\nTip: Drag across dates for quick selection!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected ${_selectedDates.length} date(s):',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDates
                  .map(
                    (date) => Chip(
                      label: Text(
                        dateFormat.format(date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onDeleted: () {
                        _controller.selectDate(date);
                        setState(() {
                          _selectedDates = _controller.selectedDates;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        );

      case VooCalendarSelectionMode.range:
        if (_rangeStart == null) {
          return Text(
            'No range selected. Tap a start date.\nTip: Drag to select a range quickly!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          );
        }
        if (_rangeEnd == null) {
          return Text(
            'Start: ${dateFormat.format(_rangeStart!)}\nTap an end date to complete the range.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          );
        }
        final days = _rangeEnd!.difference(_rangeStart!).inDays + 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Range: ${dateFormat.format(_rangeStart!)} - ${dateFormat.format(_rangeEnd!)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Duration: $days day${days == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        );
    }
  }

  Widget _buildModeDescription() {
    final descriptions = {
      VooCalendarSelectionMode.none: ModeDescription(
        title: 'No Selection',
        description:
            'Selection is completely disabled. Useful for read-only calendars or when you only want to display information.',
        features: [
          'No dates can be selected',
          'Perfect for display-only calendars',
          'Users can still navigate',
          'Events can still be tapped',
        ],
      ),
      VooCalendarSelectionMode.single: ModeDescription(
        title: 'Single Selection',
        description:
            'Allows selecting one date at a time. Each new selection replaces the previous one.',
        features: [
          'Tap any date to select it',
          'Previous selection is cleared',
          'Simple and intuitive',
          'Perfect for date pickers',
        ],
      ),
      VooCalendarSelectionMode.multiple: ModeDescription(
        title: 'Multiple Selection',
        description:
            'Select multiple individual dates. Tap to toggle selection on each date. Supports drag selection for quick multi-date selection.',
        features: [
          'Tap dates to toggle selection',
          'Drag across dates for quick selection',
          'Select as many dates as needed',
          'Great for availability calendars',
        ],
      ),
      VooCalendarSelectionMode.range: ModeDescription(
        title: 'Range Selection',
        description:
            'Select a continuous date range. First tap sets the start date, second tap sets the end date. Supports drag selection.',
        features: [
          'First tap sets start date',
          'Second tap sets end date',
          'Drag to select range quickly',
          'Perfect for booking systems',
        ],
      ),
    };

    final desc = descriptions[_selectedMode]!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              desc.title,
              style: Theme.of(context).textTheme.titleLarge,
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

class ModeDescription {
  final String title;
  final String description;
  final List<String> features;

  ModeDescription({
    required this.title,
    required this.description,
    required this.features,
  });
}
