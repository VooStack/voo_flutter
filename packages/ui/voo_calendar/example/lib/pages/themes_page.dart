import 'package:flutter/material.dart';
import 'package:voo_calendar/voo_calendar.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  late VooCalendarController _controller;
  VooCalendarTheme? _selectedTheme;
  String _selectedThemeName = 'Default (Material 3)';

  @override
  void initState() {
    super.initState();
    _controller = VooCalendarController(
      initialDate: DateTime.now(),
    );
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
              'Calendar Themes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Customize the calendar appearance with different themes and color schemes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildThemeSelector(),
            const SizedBox(height: 24),
            _buildCalendarCard(),
            const SizedBox(height: 24),
            _buildThemeCustomization(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildThemeChip(
                  'Default (Material 3)',
                  null,
                  Colors.blue,
                ),
                _buildThemeChip(
                  'Light',
                  VooCalendarTheme.light(),
                  Colors.blue,
                ),
                _buildThemeChip(
                  'Dark',
                  VooCalendarTheme.dark(),
                  Colors.grey.shade800,
                ),
                _buildThemeChip(
                  'Ocean Blue',
                  _createOceanTheme(),
                  Colors.cyan,
                ),
                _buildThemeChip(
                  'Sunset Orange',
                  _createSunsetTheme(),
                  Colors.deepOrange,
                ),
                _buildThemeChip(
                  'Forest Green',
                  _createForestTheme(),
                  Colors.green,
                ),
                _buildThemeChip(
                  'Royal Purple',
                  _createPurpleTheme(),
                  Colors.deepPurple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(String name, VooCalendarTheme? theme, Color color) {
    final isSelected = _selectedThemeName == name;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTheme = theme;
            _selectedThemeName = name;
          });
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
          theme: _selectedTheme,
        ),
      ),
    );
  }

  Widget _buildThemeCustomization() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Theme Customization',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'VooCalendar supports extensive theme customization:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildCustomizationSection(
              'Colors',
              [
                'Background colors',
                'Header colors',
                'Selected date colors',
                'Today highlight color',
                'Event indicator colors',
                'Border and grid line colors',
              ],
            ),
            const SizedBox(height: 16),
            _buildCustomizationSection(
              'Typography',
              [
                'Header text styles',
                'Weekday text styles',
                'Day number text styles',
                'Event text styles',
                'Custom font families',
              ],
            ),
            const SizedBox(height: 16),
            _buildCustomizationSection(
              'Layout',
              [
                'Spacing and padding',
                'Border radius',
                'Grid line thickness',
                'Compact mode',
              ],
            ),
            const SizedBox(height: 16),
            _buildCodeExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeExample() {
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
                Icons.code,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Example Usage',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '''VooCalendar(
  theme: VooCalendarTheme.fromContext(context),
  // or use predefined themes:
  // theme: VooCalendarTheme.light(),
  // theme: VooCalendarTheme.dark(),
  // or create custom theme:
  // theme: VooCalendarTheme(
  //   backgroundColor: Colors.white,
  //   selectedDayBackgroundColor: Colors.blue,
  //   todayBackgroundColor: Colors.orange,
  //   ...
  // ),
)''',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  VooCalendarTheme _createOceanTheme() {
    return VooCalendarTheme.light().copyWith(
      backgroundColor: Colors.cyan.shade50,
      headerBackgroundColor: Colors.cyan.shade100,
      selectedDayBackgroundColor: Colors.cyan.shade600,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.cyan.shade200,
      todayTextColor: Colors.cyan.shade900,
      eventIndicatorColor: Colors.cyan,
      eventBackgroundColor: Colors.cyan.shade100,
    );
  }

  VooCalendarTheme _createSunsetTheme() {
    return VooCalendarTheme.light().copyWith(
      backgroundColor: Colors.orange.shade50,
      headerBackgroundColor: Colors.deepOrange.shade100,
      selectedDayBackgroundColor: Colors.deepOrange.shade600,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.orange.shade200,
      todayTextColor: Colors.deepOrange.shade900,
      eventIndicatorColor: Colors.deepOrange,
      eventBackgroundColor: Colors.orange.shade100,
    );
  }

  VooCalendarTheme _createForestTheme() {
    return VooCalendarTheme.light().copyWith(
      backgroundColor: Colors.green.shade50,
      headerBackgroundColor: Colors.green.shade100,
      selectedDayBackgroundColor: Colors.green.shade700,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.green.shade200,
      todayTextColor: Colors.green.shade900,
      eventIndicatorColor: Colors.green,
      eventBackgroundColor: Colors.green.shade100,
    );
  }

  VooCalendarTheme _createPurpleTheme() {
    return VooCalendarTheme.light().copyWith(
      backgroundColor: Colors.deepPurple.shade50,
      headerBackgroundColor: Colors.deepPurple.shade100,
      selectedDayBackgroundColor: Colors.deepPurple.shade600,
      selectedDayTextColor: Colors.white,
      todayBackgroundColor: Colors.deepPurple.shade200,
      todayTextColor: Colors.deepPurple.shade900,
      eventIndicatorColor: Colors.deepPurple,
      eventBackgroundColor: Colors.deepPurple.shade100,
    );
  }
}
