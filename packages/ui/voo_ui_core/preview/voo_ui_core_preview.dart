import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

// Widget previews for voo_ui_core components

@pragma('preview')
class VooButtonPreview extends StatelessWidget {
  const VooButtonPreview({super.key});

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VooButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                const SizedBox(height: 16),
                VooButton(
                  variant: VooButtonVariant.outlined,
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                const SizedBox(height: 16),
                VooButton(
                  variant: VooButtonVariant.text,
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
                const SizedBox(height: 16),
                const VooButton(
                  child: Text('Disabled Button'),
                ),
                const SizedBox(height: 16),
                VooButton(
                  icon: Icons.add,
                  onPressed: () {},
                  child: const Text('Button with Icon'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooCheckboxPreview extends StatefulWidget {
  const VooCheckboxPreview({super.key});

  @override
  State<VooCheckboxPreview> createState() => _VooCheckboxPreviewState();
}

class _VooCheckboxPreviewState extends State<VooCheckboxPreview> {
  bool _checked = false;
  bool? _tristate;

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VooCheckbox(
                  value: _checked,
                  onChanged: (value) => setState(() => _checked = value ?? false),
                ),
                const SizedBox(height: 16),
                VooCheckboxListTile(
                  title: const Text('Checkbox with Label'),
                  value: _checked,
                  onChanged: (value) => setState(() => _checked = value ?? false),
                ),
                const SizedBox(height: 16),
                VooCheckbox(
                  value: _tristate,
                  tristate: true,
                  onChanged: (value) => setState(() => _tristate = value),
                ),
                const SizedBox(height: 16),
                const VooCheckboxListTile(
                  title: Text('Disabled Checkbox'),
                  value: true,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooTextFieldPreview extends StatefulWidget {
  const VooTextFieldPreview({super.key});

  @override
  State<VooTextFieldPreview> createState() => _VooTextFieldPreviewState();
}

class _VooTextFieldPreviewState extends State<VooTextFieldPreview> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VooTextField(
                    controller: _controller,
                    label: 'Text Field',
                    hint: 'Enter some text',
                  ),
                  const SizedBox(height: 16),
                  const VooTextField(
                    label: 'Password Field',
                    hint: 'Enter password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  const VooTextField(
                    label: 'Disabled Field',
                    hint: 'Cannot edit',
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  const VooTextField(
                    label: 'Multiline Field',
                    hint: 'Enter multiple lines',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  const VooTextField(
                    label: 'Field with Error',
                    hint: 'This field has an error',
                    error: 'This field is required',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooRadioGroupPreview extends StatefulWidget {
  const VooRadioGroupPreview({super.key});

  @override
  State<VooRadioGroupPreview> createState() => _VooRadioGroupPreviewState();
}

class _VooRadioGroupPreviewState extends State<VooRadioGroupPreview> {
  String? _selectedValue = 'option1';

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: VooRadioGroup<String>(
              items: const ['option1', 'option2', 'option3'],
              value: _selectedValue,
              onChanged: (value) => setState(() => _selectedValue = value),
              labelBuilder: (value) => 'Option ${value.substring(6)}',
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooSwitchPreview extends StatefulWidget {
  const VooSwitchPreview({super.key});

  @override
  State<VooSwitchPreview> createState() => _VooSwitchPreviewState();
}

class _VooSwitchPreviewState extends State<VooSwitchPreview> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VooSwitch(
                  value: _enabled,
                  onChanged: (value) => setState(() => _enabled = value),
                ),
                const SizedBox(height: 16),
                VooSwitchListTile(
                  title: const Text('Enable Feature'),
                  value: _enabled,
                  onChanged: (value) => setState(() => _enabled = value),
                ),
                const SizedBox(height: 16),
                const VooSwitchListTile(
                  title: Text('Disabled Switch'),
                  value: true,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooSliderPreview extends StatefulWidget {
  const VooSliderPreview({super.key});

  @override
  State<VooSliderPreview> createState() => _VooSliderPreviewState();
}

class _VooSliderPreviewState extends State<VooSliderPreview> {
  double _value = 50;

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Value: ${_value.toStringAsFixed(0)}'),
                  const SizedBox(height: 16),
                  VooSlider(
                    value: _value,
                    onChanged: (value) => setState(() => _value = value),
                    label: _value.toStringAsFixed(0),
                  ),
                  const SizedBox(height: 32),
                  const Text('Disabled Slider'),
                  const SizedBox(height: 16),
                  const VooSlider(
                    value: 30,
                    onChanged: null,
                  ),
                  const SizedBox(height: 32),
                  Text('Stepped Slider: ${_value.toStringAsFixed(0)}'),
                  const SizedBox(height: 16),
                  VooSlider(
                    value: _value,
                    onChanged: (value) => setState(() => _value = value),
                    max: 100,
                    divisions: 10,
                    label: _value.toStringAsFixed(0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VooDateTimePicker(
                    value: _selectedDate,
                    onChanged: (value) => setState(() => _selectedDate = value),
                    label: 'Date Picker',
                  ),
                  const SizedBox(height: 24),
                  VooDateTimePicker(
                    value: _selectedDateTime,
                    onChanged: (value) => setState(() => _selectedDateTime = value),
                    label: 'Date & Time Picker',
                    showTime: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooDateRangePickerPreview extends StatefulWidget {
  const VooDateRangePickerPreview({super.key});

  @override
  State<VooDateRangePickerPreview> createState() => _VooDateRangePickerPreviewState();
}

class _VooDateRangePickerPreviewState extends State<VooDateRangePickerPreview> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: VooDateRangePicker(
                value: _selectedRange,
                onChanged: (value) => setState(() => _selectedRange = value),
                label: 'Date Range',
              ),
            ),
          ),
        ),
      ),
    );
}

@pragma('preview')
class VooSegmentedButtonPreview extends StatefulWidget {
  const VooSegmentedButtonPreview({super.key});

  @override
  State<VooSegmentedButtonPreview> createState() => _VooSegmentedButtonPreviewState();
}

class _VooSegmentedButtonPreviewState extends State<VooSegmentedButtonPreview> {
  String _selected = 'option1';

  @override
  Widget build(BuildContext context) => VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: VooSegmentedButton<String>(
              segments: const [
                VooButtonSegment(
                  value: 'option1',
                  label: Text('Option 1'),
                ),
                VooButtonSegment(
                  value: 'option2',
                  label: Text('Option 2'),
                ),
                VooButtonSegment(
                  value: 'option3',
                  label: Text('Option 3'),
                ),
              ],
              selected: _selected,
              onSelectionChanged: (value) => setState(() => _selected = value),
            ),
          ),
        ),
      ),
    );
}