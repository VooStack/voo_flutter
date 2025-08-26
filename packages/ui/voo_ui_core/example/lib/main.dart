import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        title: 'VooUI Core Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _checkboxValue = false;
  bool _switchValue = false;
  double _sliderValue = 50;
  String? _radioValue = 'option1';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('VooUI Core Components'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Buttons'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VooButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                VooButton(
                  variant: VooButtonVariant.outlined,
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                VooButton(
                  variant: VooButtonVariant.text,
                  onPressed: () {},
                  child: const Text('Text'),
                ),
                VooButton(
                  variant: VooButtonVariant.tonal,
                  onPressed: () {},
                  child: const Text('Tonal'),
                ),
                VooButton(
                  icon: Icons.add,
                  onPressed: () {},
                  child: const Text('With Icon'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Text Field'),
            const VooTextField(
              label: 'Email',
              hint: 'Enter your email address',
            ),
            const SizedBox(height: 16),
            const VooTextField(
              label: 'Password',
              hint: 'Enter password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Checkbox'),
            VooCheckbox(
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
            ),
            const SizedBox(height: 8),
            VooCheckboxListTile(
              title: const Text('Accept terms and conditions'),
              value: _checkboxValue,
              onChanged: (value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Switch'),
            VooSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
            VooSwitchListTile(
              title: const Text('Enable notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Slider'),
            Text('Value: ${_sliderValue.toStringAsFixed(0)}'),
            VooSlider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 20,
              label: _sliderValue.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Radio Group'),
            VooRadioGroup<String>(
              items: const ['option1', 'option2', 'option3'],
              value: _radioValue,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                });
              },
              labelBuilder: (value) => 'Option ${value.substring(6)}',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Date Picker'),
            VooDateTimePicker(
              value: _selectedDate,
              label: 'Select Date',
              onChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Selected: ${_selectedDate!.toLocal()}'),
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('Cards'),
            const VooCard(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('This is a VooCard with some content'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Chips'),
            Wrap(
              spacing: 8,
              children: [
                VooChip(
                  label: const Text('Chip 1'),
                  onDeleted: () {},
                ),
                const VooChip(
                  label: Text('Chip 2'),
                  avatar: Icon(Icons.star, size: 18),
                ),
                VooChip(
                  label: const Text('Selectable'),
                  selected: true,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Empty State'),
            const VooEmptyState(
              icon: Icons.inbox,
              title: 'No Data',
              message: 'There is no data to display',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Progress Indicators'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VooCircularProgressIndicator(),
                VooLinearProgressIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
