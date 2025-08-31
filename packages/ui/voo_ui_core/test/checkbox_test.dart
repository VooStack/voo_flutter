import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('VooCheckbox', () {
    testWidgets('renders with default properties', (tester) async {
      bool? value = false;
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckbox(
            value: value,
            onChanged: (newValue) => value = newValue,
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('handles value changes', (tester) async {
      bool? value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooCheckbox(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      expect(callbacks.lastCall, true);
      expect(value, true);
    });

    testWidgets('supports tristate', (tester) async {
      bool? value;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooCheckbox(
                value: value,
                tristate: true,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
              ),
          ),
        ),
      );

      // null -> false
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, false);

      // false -> true
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, true);

      // true -> null
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, null);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckbox(
            value: false,
            isError: true,
            onChanged: (_) {},
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      final theme = Theme.of(tester.element(find.byType(Checkbox)));
      expect(checkbox.activeColor, theme.colorScheme.error);
    });

    testWidgets('disabled state prevents interaction', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: const VooCheckbox(
            value: false,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, false);
    });
  });

  group('VooCheckboxListTile', () {
    testWidgets('renders with title and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsOneWidget);
    });

    testWidgets('shows secondary widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Title'),
            secondary: const Icon(Icons.info),
          ),
        ),
      );

      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('handles selection', (tester) async {
      bool? value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooCheckboxListTile(
                value: value,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
                title: const Text('Option'),
              ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      expect(callbacks.lastCall, true);
    });
  });

  group('VooCheckboxGroup', () {
    testWidgets('renders multiple checkboxes', (tester) async {
      final items = ['Option 1', 'Option 2', 'Option 3'];
      final selectedItems = ['Option 1'];

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxGroup<String>(
            items: items,
            values: selectedItems,
            labelBuilder: (item) => item,
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
      expect(find.byType(VooCheckboxListTile), findsNWidgets(3));
    });

    testWidgets('handles multiple selections', (tester) async {
      final items = ['A', 'B', 'C'];
      List<String> selectedItems = ['A'];
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooCheckboxGroup<String>(
                items: items,
                values: selectedItems,
                labelBuilder: (item) => item,
                onChanged: (newSelection) {
                  setState(() => selectedItems = newSelection);
                  callbacks.onChanged(newSelection);
                },
              ),
          ),
        ),
      );

      // Select B
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, ['A', 'B']);
      expect(selectedItems.length, 2);

      // Deselect A
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      expect(callbacks.lastCall, ['B']);
      expect(selectedItems.length, 1);
    });

    testWidgets('shows label and helper text', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxGroup<String>(
            items: const ['Option'],
            values: const [],
            labelBuilder: (item) => item,
            label: 'Select options',
            helperText: 'Choose multiple',
          ),
        ),
      );

      expect(find.text('Select options'), findsOneWidget);
      expect(find.text('Choose multiple'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxGroup<String>(
            items: const ['Option'],
            values: const [],
            labelBuilder: (item) => item,
            errorText: 'Selection required',
          ),
        ),
      );

      expect(find.text('Selection required'), findsOneWidget);
      
      final errorText = tester.widget<Text>(find.text('Selection required'));
      final theme = Theme.of(tester.element(find.text('Selection required')));
      expect(errorText.style?.color, theme.colorScheme.error);
    });

    testWidgets('horizontal layout with chips', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxGroup<String>(
            items: const ['A', 'B', 'C'],
            values: const ['A'],
            labelBuilder: (item) => item,
            direction: Axis.horizontal,
          ),
        ),
      );

      expect(find.byType(FilterChip), findsNWidgets(3));
    });

    testWidgets('disables specific items', (tester) async {
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooCheckboxGroup<String>(
            items: const ['Enabled', 'Disabled'],
            values: const [],
            labelBuilder: (item) => item,
            isDisabled: (item) => item == 'Disabled',
            onChanged: callbacks.onChanged,
          ),
        ),
      );

      // Try to tap disabled item
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, false);

      // Tap enabled item
      await tester.tap(find.text('Enabled'));
      await tester.pumpAndSettle();
      
      expect(callbacks.wasCalled, true);
    });
  });

  group('VooLabeledCheckbox', () {
    testWidgets('renders with label and subtitle', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledCheckbox(
            value: true,
            onChanged: (_) {},
            label: 'Main Label',
            subtitle: 'Description',
          ),
        ),
      );

      expect(find.text('Main Label'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('shows leading widget', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'Label',
            leading: const Icon(Icons.star),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles tap on entire area', (tester) async {
      bool? value = false;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooLabeledCheckbox(
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

      // Tap on label text
      await tester.tap(find.text('Tap anywhere'));
      await tester.pumpAndSettle();

      expect(callbacks.wasCalled, true);
      expect(callbacks.lastCall, true);
    });

    testWidgets('supports tristate', (tester) async {
      bool? value;
      final callbacks = MockCallbacks();

      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => VooLabeledCheckbox(
                value: value,
                tristate: true,
                onChanged: (newValue) {
                  setState(() => value = newValue);
                  callbacks.onChanged(newValue);
                },
                label: 'Tristate',
              ),
          ),
        ),
      );

      // null -> false
      await tester.tap(find.text('Tristate'));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, false);

      // false -> true
      await tester.tap(find.text('Tristate'));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, true);

      // true -> null
      await tester.tap(find.text('Tristate'));
      await tester.pumpAndSettle();
      expect(callbacks.lastCall, null);
    });

    testWidgets('disabled state shows disabled styling', (tester) async {
      await pumpWidgetAndSettle(
        tester,
        createTestApp(
          child: VooLabeledCheckbox(
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
}