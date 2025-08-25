import 'package:flutter/material.dart';
import 'package:voo_ui/voo_ui.dart';

/// Preview page for date and time picker components
class VooDateTimePickerPreviews extends StatefulWidget {
  const VooDateTimePickerPreviews({super.key});

  @override
  State<VooDateTimePickerPreviews> createState() => _VooDateTimePickerPreviewsState();
}

class _VooDateTimePickerPreviewsState extends State<VooDateTimePickerPreviews> {
  // Advanced picker values
  DateTime? _yearOnlyValue;
  DateTime? _yearMonthValue;
  DateTime? _yearMonthDayValue;
  DateTime? _monthDayValue;
  DateTime? _dayTimeValue;
  DateTime? _fullDateTimeValue;
  DateTime? _timeOnlyValue;
  DateTimeRange? _dateRangeValue;
  DateTimeRange? _dateTimeRangeValue;
  
  // Standard picker values
  DateTime? _standardDateValue;
  DateTime? _standardTimeValue;
  DateTime? _standardDateTimeValue;
  DateTimeRange? _standardRangeValue;
  
  // Time picker values
  TimeOfDay? _selectedTime;
  
  @override
  Widget build(BuildContext context) {
    return VooResponsiveBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Date & Time Pickers'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveInfo(),
              const SizedBox(height: 32),
              _buildAdvancedPickers(),
              const SizedBox(height: 32),
              _buildStandardPickers(),
              const SizedBox(height: 32),
              _buildTimePickers(),
              const SizedBox(height: 32),
              _buildInlinePickers(),
              const SizedBox(height: 32),
              _buildQuickSelectors(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildResponsiveInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final responsive = context.responsive;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device Type: ${responsive.deviceType.name}'),
                    Text('Screen Size: ${responsive.screenSize.name}'),
                    Text('Orientation: ${responsive.orientation.name}'),
                    Text('Screen Dimensions: ${responsive.screenDimensions.width.toInt()} x ${responsive.screenDimensions.height.toInt()}'),
                    Text('Pixel Ratio: ${responsive.pixelRatio.toStringAsFixed(2)}'),
                    Text('Is High Density: ${responsive.isHighDensity}'),
                    Text('Has Notch: ${responsive.hasNotch}'),
                    Text('Is Foldable: ${responsive.isFoldable}'),
                    const SizedBox(height: 16),
                    Text('Grid Config: ${responsive.gridConfig.columns} columns'),
                    Text('Gutter: ${responsive.gridConfig.gutter}px'),
                    Text('Margin: ${responsive.gridConfig.margin}px'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAdvancedPickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Date/Time Pickers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Year only
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.year,
          labelText: 'Year Only',
          initialValue: _yearOnlyValue,
          onChanged: (value) {
            setState(() {
              _yearOnlyValue = value;
            });
          },
          helperText: 'Select year only',
        ),
        const SizedBox(height: 16),
        
        // Year and Month
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.yearMonth,
          labelText: 'Year and Month',
          initialValue: _yearMonthValue,
          onChanged: (value) {
            setState(() {
              _yearMonthValue = value;
            });
          },
          helperText: 'Select year and month',
        ),
        const SizedBox(height: 16),
        
        // Full Date
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.yearMonthDay,
          labelText: 'Full Date',
          initialValue: _yearMonthDayValue,
          onChanged: (value) {
            setState(() {
              _yearMonthDayValue = value;
            });
          },
          helperText: 'Select full date',
        ),
        const SizedBox(height: 16),
        
        // Month and Day
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.monthDay,
          labelText: 'Month and Day',
          initialValue: _monthDayValue,
          onChanged: (value) {
            setState(() {
              _monthDayValue = value;
            });
          },
          helperText: 'Select month and day (no year)',
        ),
        const SizedBox(height: 16),
        
        // Day and Time
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.dayTime,
          labelText: 'Day and Time',
          initialValue: _dayTimeValue,
          onChanged: (value) {
            setState(() {
              _dayTimeValue = value;
            });
          },
          helperText: 'Select day of week and time',
        ),
        const SizedBox(height: 16),
        
        // Full Date and Time
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.yearMonthDayTime,
          labelText: 'Full Date and Time',
          initialValue: _fullDateTimeValue,
          onChanged: (value) {
            setState(() {
              _fullDateTimeValue = value;
            });
          },
          helperText: 'Select date and time',
        ),
        const SizedBox(height: 16),
        
        // Time Only
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.time,
          labelText: 'Time Only',
          initialValue: _timeOnlyValue,
          onChanged: (value) {
            setState(() {
              _timeOnlyValue = value;
            });
          },
          helperText: 'Select time only',
        ),
        const SizedBox(height: 16),
        
        // Date Range
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.dateRange,
          labelText: 'Date Range',
          initialRange: _dateRangeValue,
          onRangeChanged: (range) {
            setState(() {
              _dateRangeValue = range;
            });
          },
          helperText: 'Select date range',
        ),
        const SizedBox(height: 16),
        
        // Date and Time Range
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.dateTimeRange,
          labelText: 'Date and Time Range',
          initialRange: _dateTimeRangeValue,
          onRangeChanged: (range) {
            setState(() {
              _dateTimeRangeValue = range;
            });
          },
          helperText: 'Select date and time range',
        ),
      ],
    );
  }
  
  Widget _buildStandardPickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Standard Date/Time Pickers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Standard Date Picker
        VooDateTimePicker(
          mode: VooDateTimePickerMode.date,
          labelText: 'Standard Date',
          initialDateTime: _standardDateValue,
          onDateTimeChanged: (value) {
            setState(() {
              _standardDateValue = value;
            });
          },
          helperText: 'Select a date',
        ),
        const SizedBox(height: 16),
        
        // Standard Time Picker
        VooDateTimePicker(
          mode: VooDateTimePickerMode.time,
          labelText: 'Standard Time',
          initialDateTime: _standardTimeValue,
          onDateTimeChanged: (value) {
            setState(() {
              _standardTimeValue = value;
            });
          },
          helperText: 'Select a time',
        ),
        const SizedBox(height: 16),
        
        // Standard Date/Time Picker
        VooDateTimePicker(
          mode: VooDateTimePickerMode.dateTime,
          labelText: 'Standard Date & Time',
          initialDateTime: _standardDateTimeValue,
          onDateTimeChanged: (value) {
            setState(() {
              _standardDateTimeValue = value;
            });
          },
          helperText: 'Select date and time',
        ),
        const SizedBox(height: 16),
        
        // Standard Range Picker
        VooDateTimePicker(
          mode: VooDateTimePickerMode.dateRange,
          labelText: 'Standard Date Range',
          initialDateRange: _standardRangeValue,
          onDateRangeChanged: (range) {
            setState(() {
              _standardRangeValue = range;
            });
          },
          helperText: 'Select a date range',
        ),
      ],
    );
  }
  
  Widget _buildTimePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material 3 Time Pickers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // 12-hour format
        VooTimePicker(
          labelText: '12-hour Time',
          initialTime: _selectedTime,
          onTimeChanged: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          helperText: 'Select time in 12-hour format',
        ),
        const SizedBox(height: 16),
        
        // 24-hour format
        VooTimePicker(
          labelText: '24-hour Time',
          initialTime: _selectedTime,
          use24HourFormat: true,
          onTimeChanged: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          helperText: 'Select time in 24-hour format',
        ),
        const SizedBox(height: 16),
        
        // With seconds
        VooTimePicker(
          labelText: 'Time with Seconds',
          initialTime: _selectedTime,
          showSeconds: true,
          onTimeChanged: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          helperText: 'Select time with seconds',
        ),
        const SizedBox(height: 16),
        
        // With minute interval
        VooTimePicker(
          labelText: 'Time with 15-min Interval',
          initialTime: _selectedTime,
          minuteInterval: 15,
          onTimeChanged: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          helperText: 'Select time with 15-minute intervals',
        ),
        const SizedBox(height: 16),
        
        // Disabled
        VooTimePicker(
          labelText: 'Disabled Time Picker',
          initialTime: TimeOfDay.now(),
          enabled: false,
          helperText: 'This picker is disabled',
        ),
        const SizedBox(height: 16),
        
        // With error
        VooTimePicker(
          labelText: 'Time Picker with Error',
          initialTime: _selectedTime,
          onTimeChanged: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
          errorText: 'Please select a valid time',
        ),
      ],
    );
  }
  
  Widget _buildInlinePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inline Pickers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Inline date picker
        VooAdvancedDateTimePicker(
          mode: VooDateTimeSelectionMode.yearMonthDay,
          labelText: 'Inline Date Picker',
          isInline: true,
          initialValue: _yearMonthDayValue,
          onChanged: (value) {
            setState(() {
              _yearMonthDayValue = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Inline calendar
        VooDateTimePicker(
          mode: VooDateTimePickerMode.date,
          isInline: true,
          initialDateTime: _standardDateValue,
          onDateTimeChanged: (value) {
            setState(() {
              _standardDateValue = value;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildQuickSelectors() {
    TimeOfDay? quickSelectedTime;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Time Selector',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick time selection chips:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                VooQuickTimeSelector(
                  selectedTime: quickSelectedTime,
                  onTimeSelected: (time) {
                    setState(() {
                      quickSelectedTime = time;
                    });
                  },
                ),
                if (quickSelectedTime != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Selected: ${quickSelectedTime!.format(context)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Responsive demo showing different layouts
class VooResponsivePickerDemo extends StatelessWidget {
  const VooResponsivePickerDemo({super.key});
  
  @override
  Widget build(BuildContext context) {
    return VooResponsiveBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Responsive Picker Demo'),
        ),
        body: VooResponsiveLayout(
          phone: _buildPhoneLayout(),
          tablet: _buildTabletLayout(),
          desktop: _buildDesktopLayout(),
        ),
      ),
    );
  }
  
  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Phone Layout'),
          const SizedBox(height: 16),
          VooAdvancedDateTimePicker(
            mode: VooDateTimeSelectionMode.yearMonthDay,
            labelText: 'Select Date',
          ),
          const SizedBox(height: 16),
          VooTimePicker(
            labelText: 'Select Time',
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Tablet Layout'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: VooAdvancedDateTimePicker(
                  mode: VooDateTimeSelectionMode.yearMonthDay,
                  labelText: 'Select Date',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: VooTimePicker(
                  labelText: 'Select Time',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text('Desktop Layout'),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: VooAdvancedDateTimePicker(
                  mode: VooDateTimeSelectionMode.yearMonthDay,
                  labelText: 'Select Date',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: VooTimePicker(
                  labelText: 'Select Time',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: VooAdvancedDateTimePicker(
                  mode: VooDateTimeSelectionMode.dateRange,
                  labelText: 'Select Range',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}