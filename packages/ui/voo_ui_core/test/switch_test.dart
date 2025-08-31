import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('VooSwitch', () {
    testWidgets('renders with default properties', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitch(
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('handles value changes', (tester) async {
      bool value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooSwitch(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, true);
      expect(value, true);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, false);
      expect(value, false);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitch(
            value: true,
            isError: true,
            onChanged: (_) {},
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      final theme = Theme.of(tester.element(find.byType(Switch)));
      expect(switchWidget.activeThumbColor, theme.colorScheme.error);
    });

    testWidgets('disabled state prevents interaction', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooSwitch(
            value: false,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, false);
    });

    testWidgets('shows thumb icon when provided', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitch(
            value: true,
            onChanged: (_) {},
            thumbIcon: const Icon(Icons.check, size: 16),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('VooSwitchListTile', () {
    testWidgets('renders with title and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
          ),
        ),
      );

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Use dark theme'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('shows secondary widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Notifications'),
            secondary: const Icon(Icons.notifications),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('handles toggle', (tester) async {
      bool value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooSwitchListTile(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
                title: const Text('Enable Feature'),
              ),
          ),
        ),
      );

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, true);
      expect(value, true);
    });
  });

  group('VooLabeledSwitch', () {
    testWidgets('renders with label and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSwitch(
            value: true,
            onChanged: (_) {},
            label: 'Auto-save',
            subtitle: 'Save changes automatically',
          ),
        ),
      );

      expect(find.text('Auto-save'), findsOneWidget);
      expect(find.text('Save changes automatically'), findsOneWidget);
    });

    testWidgets('shows leading widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSwitch(
            value: false,
            onChanged: (_) {},
            label: 'Setting',
            leading: const Icon(Icons.settings),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('handles tap on entire area', (tester) async {
      bool value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooLabeledSwitch(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
                label: 'Tap anywhere',
              ),
          ),
        ),
      );

      // Tap on label
      await tester.tap(find.text('Tap anywhere'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, true);
      expect(value, true);
    });

    testWidgets('disabled state shows disabled styling', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledSwitch(
            value: false,
            onChanged: (_) {},
            label: 'Disabled',
            enabled: false,
          ),
        ),
      );

      final labelText = tester.widget<Text>(find.text('Disabled'));
      final theme = Theme.of(tester.element(find.text('Disabled')));
      expect(labelText.style?.color, theme.disabledColor);
    });
  });

  group('VooSwitchGroup', () {
    testWidgets('renders multiple switches', (tester) async {
      final switches = {
        'wifi': true,
        'bluetooth': false,
        'location': true,
      };
      final labels = {
        'wifi': 'Wi-Fi',
        'bluetooth': 'Bluetooth',
        'location': 'Location',
      };

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchGroup(
            switches: switches,
            labels: labels,
          ),
        ),
      );

      expect(find.text('Wi-Fi'), findsOneWidget);
      expect(find.text('Bluetooth'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.byType(VooSwitchListTile), findsNWidgets(3));
    });

    testWidgets('handles individual switch changes', (tester) async {
      Map<String, bool> switches = {
        'option1': true,
        'option2': false,
      };
      final labels = {
        'option1': 'Option 1',
        'option2': 'Option 2',
      };
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooSwitchGroup(
                switches: switches,
                labels: labels,
                onChanged: (newSwitches) {
                  setState(() => switches = newSwitches);
                  callbacks.onChanged(newSwitches);
                },
              ),
          ),
        ),
      );

      // Toggle option2
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      final lastCall = callbacks.lastCall as Map<String, bool>;
      expect(lastCall['option2'], true);
      expect(switches['option2'], true);
    });

    testWidgets('shows group label and helper text', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooSwitchGroup(
            switches: {'test': false},
            labels: {'test': 'Test'},
            groupLabel: 'Settings',
            helperText: 'Configure your preferences',
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Configure your preferences'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooSwitchGroup(
            switches: {'test': false},
            labels: {'test': 'Test'},
            errorText: 'Please enable at least one option',
          ),
        ),
      );

      expect(find.text('Please enable at least one option'), findsOneWidget);
    });

    testWidgets('shows dividers when enabled', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooSwitchGroup(
            switches: {
              'option1': true,
              'option2': false,
            },
            labels: {
              'option1': 'Option 1',
              'option2': 'Option 2',
            },
            showDividers: true,
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('disables specific switches', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchGroup(
            switches: const {
              'enabled': false,
              'disabled': false,
            },
            labels: const {
              'enabled': 'Enabled',
              'disabled': 'Disabled',
            },
            disabledSwitches: const {'disabled'},
            onChanged: callbacks.onChanged,
          ),
        ),
      );

      // Try to tap disabled switch
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, false);

      // Tap enabled switch
      await tester.tap(find.text('Enabled'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, true);
    });

    testWidgets('shows icons when provided', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooSwitchGroup(
            switches: {'wifi': true},
            labels: {'wifi': 'Wi-Fi'},
            icons: {
              'wifi': Icon(Icons.wifi),
            },
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });
  });

  group('VooSwitchCard', () {
    testWidgets('renders as card with switch', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchCard(
            value: true,
            onChanged: (_) {},
            title: const Text('Premium Features'),
            subtitle: const Text('Access all features'),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Premium Features'), findsOneWidget);
      expect(find.text('Access all features'), findsOneWidget);
    });

    testWidgets('shows different elevation based on state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: Column(
            children: [
              VooSwitchCard(
                value: true,
                onChanged: (_) {},
                title: const Text('On'),
              ),
              VooSwitchCard(
                value: false,
                onChanged: (_) {},
                title: const Text('Off'),
              ),
            ],
          ),
        ),
      );

      final onCard = tester.widget<Card>(find.byType(Card).first);
      final offCard = tester.widget<Card>(find.byType(Card).last);
      
      expect(onCard.elevation, 4);
      expect(offCard.elevation, 1);
    });

    testWidgets('shows leading widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchCard(
            value: false,
            onChanged: (_) {},
            title: const Text('Feature'),
            leading: const Icon(Icons.star),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles toggle', (tester) async {
      bool value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooSwitchCard(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
                title: const Text('Toggle Feature'),
              ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, true);
      expect(value, true);
    });

    testWidgets('shows custom trailing widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooSwitchCard(
            value: true,
            onChanged: (_) {},
            title: const Text('Custom'),
            trailing: const Text('Active'),
          ),
        ),
      );

      expect(find.text('Active'), findsOneWidget);
      // Switch should not be shown when custom trailing is provided
      expect(find.byType(VooSwitch), findsNothing);
    });
  });

  group('VooAdaptiveSwitch', () {
    testWidgets('renders adaptive switch', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooAdaptiveSwitch(
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('handles value changes', (tester) async {
      bool value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooAdaptiveSwitch(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, true);
      expect(value, true);
    });

    testWidgets('applies custom colors', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooAdaptiveSwitch(
            value: true,
            onChanged: (_) {},
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.activeTrackColor, Colors.green);
      expect(switchWidget.inactiveTrackColor, Colors.grey);
    });
  });
}