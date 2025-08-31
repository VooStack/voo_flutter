import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('VooRadio', () {
    testWidgets('renders with default properties', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadio<String>(
            value: 'option1',
            groupValue: 'option1',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Radio<String>), findsOneWidget);
    });

    testWidgets('handles value selection', (tester) async {
      String? groupValue = 'A';
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
                children: [
                  VooRadio<String>(
                    value: 'A',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                  ),
                  VooRadio<String>(
                    value: 'B',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                  ),
                ],
              ),
          ),
        ),
      );

      // Select B
      await tester.tap(find.byType(Radio<String>).last);
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, 'B');
      expect(groupValue, 'B');
    });

    testWidgets('supports toggleable', (tester) async {
      String? groupValue = 'A';
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooRadio<String>(
                value: 'A',
                groupValue: groupValue,
                toggleable: true,
                onChanged: (value) {
                  setState(() => groupValue = value);
                  callbacks.onChanged(value);
                },
              ),
          ),
        ),
      );

      // Deselect
      await tester.tap(find.byType(Radio<String>));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, null);
      expect(groupValue, null);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadio<String>(
            value: 'option',
            groupValue: null,
            isError: true,
            onChanged: (_) {},
          ),
        ),
      );

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      final theme = Theme.of(tester.element(find.byType(Radio<String>)));
      expect(radio.activeColor, theme.colorScheme.error);
    });
  });

  group('VooRadioListTile', () {
    testWidgets('renders with title and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioListTile<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            title: const Text('Option 1'),
            subtitle: const Text('Description'),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.byType(RadioListTile<int>), findsOneWidget);
    });

    testWidgets('handles selection', (tester) async {
      int? groupValue = 1;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
                children: [
                  VooRadioListTile<int>(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                    title: const Text('Option 1'),
                  ),
                  VooRadioListTile<int>(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                    title: const Text('Option 2'),
                  ),
                ],
              ),
          ),
        ),
      );

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, 2);
      expect(groupValue, 2);
    });
  });

  group('VooRadioGroup', () {
    testWidgets('renders multiple radio options', (tester) async {
      final items = ['Red', 'Green', 'Blue'];

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioGroup<String>(
            items: items,
            value: 'Red',
            labelBuilder: (item) => item,
            onChanged: (_) {}, // Add onChanged to avoid assertion error
          ),
        ),
      );

      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Green'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
      // VooRadioListTile uses RadioListTile internally
      expect(find.byType(RadioListTile<String>), findsNWidgets(3));
    });

    testWidgets('handles single selection', (tester) async {
      final items = ['Small', 'Medium', 'Large'];
      String? selectedValue = 'Small';
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooRadioGroup<String>(
                items: items,
                value: selectedValue,
                labelBuilder: (item) => item,
                onChanged: (value) {
                  setState(() => selectedValue = value);
                  callbacks.onChanged(value);
                },
              ),
          ),
        ),
      );

      await tester.tap(find.text('Large'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, 'Large');
      expect(selectedValue, 'Large');
    });

    testWidgets('shows label and helper text', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioGroup<String>(
            items: const ['Option'],
            labelBuilder: (item) => item,
            onChanged: (_) {}, // Add onChanged
            label: 'Select size',
            helperText: 'Choose one option',
          ),
        ),
      );

      expect(find.text('Select size'), findsOneWidget);
      expect(find.text('Choose one option'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioGroup<String>(
            items: const ['Option'],
            labelBuilder: (item) => item,
            onChanged: (_) {}, // Add onChanged
            errorText: 'Please select an option',
          ),
        ),
      );

      expect(find.text('Please select an option'), findsOneWidget);
    });

    testWidgets('horizontal layout with chips', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioGroup<String>(
            items: const ['A', 'B', 'C'],
            value: 'A',
            labelBuilder: (item) => item,
            onChanged: (_) {}, // Add onChanged
            direction: Axis.horizontal,
          ),
        ),
      );

      expect(find.byType(ChoiceChip), findsNWidgets(3));
    });

    testWidgets('supports toggleable selection', (tester) async {
      String? selectedValue = 'A';
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooRadioGroup<String>(
                items: const ['A', 'B'],
                value: selectedValue,
                labelBuilder: (item) => item,
                toggleable: true,
                onChanged: (value) {
                  setState(() => selectedValue = value);
                  callbacks.onChanged(value);
                },
              ),
          ),
        ),
      );

      // Deselect current selection
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, null);
      expect(selectedValue, null);
    });

    testWidgets('disables specific items', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioGroup<String>(
            items: const ['Available', 'Unavailable'],
            labelBuilder: (item) => item,
            isDisabled: (item) => item == 'Unavailable',
            onChanged: callbacks.onChanged,
          ),
        ),
      );

      // Try to select disabled item
      await tester.tap(find.text('Unavailable'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, false);

      // Select enabled item
      await tester.tap(find.text('Available'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, true);
      expect(callbacks.lastCall, 'Available');
    });
  });

  group('VooLabeledRadio', () {
    testWidgets('renders with label and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledRadio<String>(
            value: 'option',
            groupValue: 'option',
            onChanged: (_) {},
            label: 'Main Label',
            subtitle: 'Extra info',
          ),
        ),
      );

      expect(find.text('Main Label'), findsOneWidget);
      expect(find.text('Extra info'), findsOneWidget);
    });

    testWidgets('handles tap on entire area', (tester) async {
      String? groupValue = 'A';
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
                children: [
                  VooLabeledRadio<String>(
                    value: 'A',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                    label: 'Option A',
                  ),
                  VooLabeledRadio<String>(
                    value: 'B',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() => groupValue = value);
                      callbacks.onChanged(value);
                    },
                    label: 'Option B',
                  ),
                ],
              ),
          ),
        ),
      );

      // Tap on label
      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, 'B');
      expect(groupValue, 'B');
    });
  });

  group('VooRadioCard', () {
    testWidgets('renders as card with radio', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioCard<String>(
            value: 'premium',
            groupValue: 'premium',
            onChanged: (_) {},
            title: const Text('Premium Plan'),
            subtitle: const Text('\$9.99/month'),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Premium Plan'), findsOneWidget);
      expect(find.text('\$9.99/month'), findsOneWidget);
    });

    testWidgets('shows selected state with elevation', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: Column(
            children: [
              VooRadioCard<String>(
                value: 'selected',
                groupValue: 'selected',
                onChanged: (_) {},
                title: const Text('Selected'),
              ),
              VooRadioCard<String>(
                value: 'unselected',
                groupValue: 'selected',
                onChanged: (_) {},
                title: const Text('Unselected'),
              ),
            ],
          ),
        ),
      );

      final selectedCard = tester.widget<Card>(find.byType(Card).first);
      final unselectedCard = tester.widget<Card>(find.byType(Card).last);
      
      expect(selectedCard.elevation, 4);
      expect(unselectedCard.elevation, 1);
    });

    testWidgets('shows leading and trailing widgets', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooRadioCard<String>(
            value: 'option',
            groupValue: null,
            onChanged: (_) {},
            title: const Text('Title'),
            leading: const Icon(Icons.star),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('handles selection', (tester) async {
      String? groupValue;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooRadioCard<String>(
                value: 'plan',
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() => groupValue = value);
                  callbacks.onChanged(value);
                },
                title: const Text('Select Plan'),
              ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, 'plan');
      expect(groupValue, 'plan');
    });
  });
}