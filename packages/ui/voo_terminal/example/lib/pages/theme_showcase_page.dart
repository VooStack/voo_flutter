import 'package:flutter/material.dart';
import 'package:voo_terminal/voo_terminal.dart';

/// Demo page showcasing different terminal themes.
class ThemeShowcasePage extends StatefulWidget {
  const ThemeShowcasePage({super.key});

  @override
  State<ThemeShowcasePage> createState() => _ThemeShowcasePageState();
}

class _ThemeShowcasePageState extends State<ThemeShowcasePage> {
  int _selectedThemeIndex = 0;
  bool _showHeader = true;
  bool _showWindowControls = true;
  bool _showTimestamps = false;
  bool _enableSelection = true;

  final List<_ThemeOption> _themes = [
    _ThemeOption('Classic', 'Green phosphor', VooTerminalTheme.classic()),
    _ThemeOption('Modern', 'Clean and minimal', VooTerminalTheme.modern()),
    _ThemeOption(
      'Modern (Light)',
      'Light mode variant',
      VooTerminalTheme.modern(brightness: Brightness.light),
    ),
    _ThemeOption('Retro', 'CRT scanlines', VooTerminalTheme.retro()),
    _ThemeOption('Matrix', 'Green rain', VooTerminalTheme.matrix()),
    _ThemeOption('Amber', 'Warm phosphor', VooTerminalTheme.amber()),
    _ThemeOption('Ubuntu', 'Ubuntu style', VooTerminalTheme.ubuntu()),
  ];

  List<TerminalLine> get _demoLines => [
        TerminalLine.system('VooTerminal Theme Preview'),
        TerminalLine.output(''),
        TerminalLine.output('This is standard output text.'),
        TerminalLine.input('echo "Hello World"'),
        TerminalLine.output('Hello World'),
        TerminalLine.output(''),
        TerminalLine.success('✓ Build succeeded'),
        TerminalLine.warning('⚠ 3 warnings generated'),
        TerminalLine.error('✗ 1 error found'),
        TerminalLine.info('ℹ Starting analysis...'),
        TerminalLine.debug('🔍 Debug: Loading module'),
        TerminalLine.output(''),
        TerminalLine.system('Ready.'),
      ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = _themes[_selectedThemeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
        actions: [
          IconButton(
            icon: Icon(_showHeader ? Icons.visibility : Icons.visibility_off),
            tooltip: 'Toggle Header',
            onPressed: () => setState(() => _showHeader = !_showHeader),
          ),
          IconButton(
            icon: Icon(_showWindowControls ? Icons.circle : Icons.circle_outlined),
            tooltip: 'Toggle Window Controls',
            onPressed: () => setState(() => _showWindowControls = !_showWindowControls),
          ),
          IconButton(
            icon: Icon(_showTimestamps ? Icons.schedule : Icons.schedule_outlined),
            tooltip: 'Toggle Timestamps',
            onPressed: () => setState(() => _showTimestamps = !_showTimestamps),
          ),
          IconButton(
            icon: Icon(_enableSelection ? Icons.select_all : Icons.deselect),
            tooltip: 'Toggle Selection',
            onPressed: () => setState(() => _enableSelection = !_enableSelection),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: VooTerminalPreview(
                lines: _demoLines,
                theme: selectedTheme.theme,
                showHeader: _showHeader,
                showWindowControls: _showWindowControls,
                showTimestamps: _showTimestamps,
                enableSelection: _enableSelection,
                title: selectedTheme.name,
                onClose: () => _showSnackBar('Close pressed'),
                onMinimize: () => _showSnackBar('Minimize pressed'),
                onMaximize: () => _showSnackBar('Maximize pressed'),
              ),
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _themes.length,
              itemBuilder: (context, index) {
                final theme = _themes[index];
                final isSelected = index == _selectedThemeIndex;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _ThemePreviewCard(
                    name: theme.name,
                    description: theme.description,
                    theme: theme.theme,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedThemeIndex = index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption {
  final String name;
  final String description;
  final VooTerminalTheme theme;

  _ThemeOption(this.name, this.description, this.theme);
}

class _ThemePreviewCard extends StatelessWidget {
  final String name;
  final String description;
  final VooTerminalTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.name,
    required this.description,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : theme.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: 10,
                color: theme.systemColor,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _ColorDot(theme.textColor),
                _ColorDot(theme.successColor),
                _ColorDot(theme.warningColor),
                _ColorDot(theme.errorColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
