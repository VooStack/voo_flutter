import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_boolean_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_checkbox_field.dart';

void main() {
  group('VooBooleanField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
              label: 'Active',
            ),
          ),
        ),
      );

      expect(find.text('Active'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('displays initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
              initialValue: true,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('calls onChanged when toggled', (WidgetTester tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
              value: false,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(changedValue, true);
    });

    testWidgets('is disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
              enabled: false,
              value: true,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.onChanged, null);
    });

    testWidgets('shows helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
              label: 'Active',
              helper: 'Enable to activate this feature',
            ),
          ),
        ),
      );

      expect(find.text('Enable to activate this feature'), findsOneWidget);
    });

    testWidgets('defaults to false when no initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooBooleanField(
              name: 'active',
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);
    });
  });

  group('VooCheckboxField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'terms',
              label: 'I agree to the terms',
            ),
          ),
        ),
      );

      expect(find.text('I agree to the terms'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('shows required indicator when required', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'terms',
              label: 'Terms and Conditions',
              required: true,
            ),
          ),
        ),
      );

      expect(find.text('Terms and Conditions'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('displays initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'subscribe',
              initialValue: true,
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('calls onChanged when toggled', (WidgetTester tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'subscribe',
              value: false,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(changedValue, true);
    });

    testWidgets('validates required checkbox', (WidgetTester tester) async {
      const field = VooCheckboxField(
        name: 'terms',
        label: 'Terms',
        required: true,
      );

      expect(field.validate(false), 'Terms must be accepted');
      expect(field.validate(null), 'Terms must be accepted');
      expect(field.validate(true), null);
    });

    testWidgets('is disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'subscribe',
              enabled: false,
              value: true,
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.onChanged, null);
    });

    testWidgets('shows helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'terms',
              helper: 'Please read the terms carefully',
            ),
          ),
        ),
      );

      expect(find.text('Please read the terms carefully'), findsOneWidget);
    });

    testWidgets('defaults to false when no initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooCheckboxField(
              name: 'subscribe',
            ),
          ),
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });
  });
}