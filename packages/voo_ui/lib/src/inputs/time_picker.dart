import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_ui/src/foundations/design_system.dart';

/// Material 3 compliant time picker
class VooTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay time)? onTimeChanged;
  final bool use24HourFormat;
  final int minuteInterval;
  final bool showSeconds;
  final int? initialSeconds;
  final void Function(TimeOfDay time, int seconds)? onTimeWithSecondsChanged;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  
  const VooTimePicker({
    super.key,
    this.initialTime,
    this.onTimeChanged,
    this.use24HourFormat = false,
    this.minuteInterval = 1,
    this.showSeconds = false,
    this.initialSeconds,
    this.onTimeWithSecondsChanged,
    this.labelText,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });
  
  @override
  State<VooTimePicker> createState() => _VooTimePickerState();
}

class _VooTimePickerState extends State<VooTimePicker> {
  late TimeOfDay _selectedTime;
  late int _selectedSeconds;
  
  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
    _selectedSeconds = widget.initialSeconds ?? 0;
  }
  
  Future<void> _selectTime() async {
    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => VooTimePickerDialog(
        initialTime: _selectedTime,
        use24HourFormat: widget.use24HourFormat,
        minuteInterval: widget.minuteInterval,
        showSeconds: widget.showSeconds,
        initialSeconds: _selectedSeconds,
      ),
    );
    
    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
      widget.onTimeChanged?.call(result);
      if (widget.showSeconds) {
        widget.onTimeWithSecondsChanged?.call(result, _selectedSeconds);
      }
    }
  }
  
  String _formatTime() {
    if (widget.use24HourFormat) {
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      if (widget.showSeconds) {
        final second = _selectedSeconds.toString().padLeft(2, '0');
        return '$hour:$minute:$second';
      }
      return '$hour:$minute';
    } else {
      final hour = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
      if (widget.showSeconds) {
        final second = _selectedSeconds.toString().padLeft(2, '0');
        return '$hour:$minute:$second $period';
      }
      return '$hour:$minute $period';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: design.spacingSm),
            child: Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        InkWell(
          onTap: widget.enabled ? _selectTime : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacingMd,
              vertical: design.spacingMd,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.errorText != null
                    ? colorScheme.error
                    : colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: widget.enabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface.withValues(alpha: 0.38),
                ),
                SizedBox(width: design.spacingMd),
                Expanded(
                  child: Text(
                    _formatTime(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: widget.enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: design.spacingXs),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.errorText != null
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

/// Material 3 time picker dialog
class VooTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final bool use24HourFormat;
  final int minuteInterval;
  final bool showSeconds;
  final int initialSeconds;
  
  const VooTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.use24HourFormat,
    required this.minuteInterval,
    this.showSeconds = false,
    this.initialSeconds = 0,
  });
  
  @override
  State<VooTimePickerDialog> createState() => _VooTimePickerDialogState();
}

class _VooTimePickerDialogState extends State<VooTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late int _selectedSecond;
  late DayPeriod _selectedPeriod;
  late TextEditingController _hourController;
  late TextEditingController _minuteController;
  late TextEditingController _secondController;
  
  bool _isInputMode = true;
  
  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _selectedSecond = widget.initialSeconds;
    _selectedPeriod = widget.initialTime.period;
    
    _hourController = TextEditingController(
      text: _formatHourForInput(),
    );
    _minuteController = TextEditingController(
      text: _selectedMinute.toString().padLeft(2, '0'),
    );
    _secondController = TextEditingController(
      text: _selectedSecond.toString().padLeft(2, '0'),
    );
  }
  
  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }
  
  String _formatHourForInput() {
    if (widget.use24HourFormat) {
      return _selectedHour.toString().padLeft(2, '0');
    } else {
      final displayHour = _selectedHour == 0 ? 12 : (_selectedHour > 12 ? _selectedHour - 12 : _selectedHour);
      return displayHour.toString().padLeft(2, '0');
    }
  }
  
  void _updateHour(String value) {
    final hour = int.tryParse(value);
    if (hour != null) {
      if (widget.use24HourFormat) {
        if (hour >= 0 && hour <= 23) {
          setState(() {
            _selectedHour = hour;
          });
        }
      } else {
        if (hour >= 1 && hour <= 12) {
          setState(() {
            _selectedHour = _selectedPeriod == DayPeriod.am
                ? (hour == 12 ? 0 : hour)
                : (hour == 12 ? 12 : hour + 12);
          });
        }
      }
    }
  }
  
  void _updateMinute(String value) {
    final minute = int.tryParse(value);
    if (minute != null && minute >= 0 && minute <= 59) {
      setState(() {
        _selectedMinute = minute;
      });
    }
  }
  
  void _updateSecond(String value) {
    final second = int.tryParse(value);
    if (second != null && second >= 0 && second <= 59) {
      setState(() {
        _selectedSecond = second;
      });
    }
  }
  
  void _togglePeriod() {
    setState(() {
      _selectedPeriod = _selectedPeriod == DayPeriod.am ? DayPeriod.pm : DayPeriod.am;
      if (_selectedPeriod == DayPeriod.am) {
        _selectedHour = _selectedHour >= 12 ? _selectedHour - 12 : _selectedHour;
      } else {
        _selectedHour = _selectedHour < 12 ? _selectedHour + 12 : _selectedHour;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 360,
          maxHeight: 400,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select time',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isInputMode ? Icons.schedule : Icons.keyboard),
                        onPressed: () {
                          setState(() {
                            _isInputMode = !_isInputMode;
                          });
                        },
                        tooltip: _isInputMode ? 'Clock mode' : 'Input mode',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTimeDisplay(colorScheme),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _isInputMode
                  ? _buildInputMode(design, colorScheme)
                  : _buildClockMode(design, colorScheme),
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
                      final time = TimeOfDay(
                        hour: _selectedHour,
                        minute: _selectedMinute,
                      );
                      Navigator.of(context).pop(time);
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
  
  Widget _buildTimeDisplay(ColorScheme colorScheme) {
    final hourText = _formatHourForInput();
    final minuteText = _selectedMinute.toString().padLeft(2, '0');
    final secondText = _selectedSecond.toString().padLeft(2, '0');
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          hourText,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          ':',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          minuteText,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        if (widget.showSeconds) ...[
          Text(
            ':',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            secondText,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
        if (!widget.use24HourFormat) ...[
          const SizedBox(width: 16),
          Column(
            children: [
              InkWell(
                onTap: _selectedPeriod == DayPeriod.am ? null : _togglePeriod,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == DayPeriod.am
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'AM',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _selectedPeriod == DayPeriod.am
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: _selectedPeriod == DayPeriod.am
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: _selectedPeriod == DayPeriod.pm ? null : _togglePeriod,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == DayPeriod.pm
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'PM',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _selectedPeriod == DayPeriod.pm
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: _selectedPeriod == DayPeriod.pm
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
  
  Widget _buildInputMode(VooDesignSystemData design, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(design.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeInput(
            controller: _hourController,
            label: 'Hour',
            maxValue: widget.use24HourFormat ? 23 : 12,
            minValue: widget.use24HourFormat ? 0 : 1,
            onChanged: _updateHour,
            design: design,
            colorScheme: colorScheme,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
            child: Text(
              ':',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          _buildTimeInput(
            controller: _minuteController,
            label: 'Minute',
            maxValue: 59,
            minValue: 0,
            onChanged: _updateMinute,
            design: design,
            colorScheme: colorScheme,
          ),
          if (widget.showSeconds) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacingMd),
              child: Text(
                ':',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            _buildTimeInput(
              controller: _secondController,
              label: 'Second',
              maxValue: 59,
              minValue: 0,
              onChanged: _updateSecond,
              design: design,
              colorScheme: colorScheme,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildTimeInput({
    required TextEditingController controller,
    required String label,
    required int maxValue,
    required int minValue,
    required void Function(String) onChanged,
    required VooDesignSystemData design,
    required ColorScheme colorScheme,
  }) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: design.spacingSm,
            vertical: design.spacingMd,
          ),
        ),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
  
  Widget _buildClockMode(VooDesignSystemData design, ColorScheme colorScheme) {
    // Simplified clock mode - in a real implementation, this would be an
    // interactive clock face
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 100,
            color: colorScheme.primary,
          ),
          SizedBox(height: design.spacingLg),
          Text(
            'Clock mode coming soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.spacingMd),
          TextButton(
            onPressed: () {
              setState(() {
                _isInputMode = true;
              });
            },
            child: const Text('Switch to input mode'),
          ),
        ],
      ),
    );
  }
}

/// Material 3 time selection chip
class VooTimeChip extends StatelessWidget {
  final TimeOfDay time;
  final bool selected;
  final VoidCallback? onTap;
  final bool use24HourFormat;
  
  const VooTimeChip({
    super.key,
    required this.time,
    this.selected = false,
    this.onTap,
    this.use24HourFormat = false,
  });
  
  String _formatTime() {
    if (use24HourFormat) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return FilterChip(
      label: Text(_formatTime()),
      selected: selected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
    );
  }
}

/// Quick time selector with common time options
class VooQuickTimeSelector extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final void Function(TimeOfDay time)? onTimeSelected;
  final List<TimeOfDay>? quickTimes;
  final bool use24HourFormat;
  
  const VooQuickTimeSelector({
    super.key,
    this.selectedTime,
    this.onTimeSelected,
    this.quickTimes,
    this.use24HourFormat = false,
  });
  
  List<TimeOfDay> get _defaultQuickTimes => [
    const TimeOfDay(hour: 9, minute: 0),   // 9:00 AM
    const TimeOfDay(hour: 10, minute: 0),  // 10:00 AM
    const TimeOfDay(hour: 11, minute: 0),  // 11:00 AM
    const TimeOfDay(hour: 12, minute: 0),  // 12:00 PM
    const TimeOfDay(hour: 13, minute: 0),  // 1:00 PM
    const TimeOfDay(hour: 14, minute: 0),  // 2:00 PM
    const TimeOfDay(hour: 15, minute: 0),  // 3:00 PM
    const TimeOfDay(hour: 16, minute: 0),  // 4:00 PM
    const TimeOfDay(hour: 17, minute: 0),  // 5:00 PM
    const TimeOfDay(hour: 18, minute: 0),  // 6:00 PM
  ];
  
  @override
  Widget build(BuildContext context) {
    final times = quickTimes ?? _defaultQuickTimes;
    final design = context.vooDesign;
    
    return Wrap(
      spacing: design.spacingSm,
      runSpacing: design.spacingSm,
      children: times.map((time) {
        final isSelected = selectedTime?.hour == time.hour &&
                          selectedTime?.minute == time.minute;
        
        return VooTimeChip(
          time: time,
          selected: isSelected,
          onTap: () => onTimeSelected?.call(time),
          use24HourFormat: use24HourFormat,
        );
      }).toList(),
    );
  }
}