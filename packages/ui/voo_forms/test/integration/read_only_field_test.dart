import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Read-only field tests', () {
    testWidgets('VooDropdownField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooDropdownField(
                  readOnly: true,
                  name: 'name',
                  options: ['Option 1', 'Option 2'],
                  initialValue: 'Option 1',
                ),
              ],
            ),
          ),
        ),
      );

      // Should show dropdown with the value but disabled
      expect(find.text('Option 1'), findsOneWidget);
      // Should show dropdown input decorator
      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets('VooTextField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooTextField(
                  readOnly: true,
                  name: 'text',
                  initialValue: 'Test Value',
                ),
              ],
            ),
          ),
        ),
      );

      // Should show VooReadOnlyField with the value
      expect(find.text('Test Value'), findsOneWidget);
      // Should show VooReadOnlyField instead of TextFormField
      expect(find.byType(VooReadOnlyField), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('VooBooleanField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooBooleanField(
                  readOnly: true,
                  name: 'bool',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ),
      );

      // Should show Switch widget but disabled
      expect(find.byType(Switch), findsOneWidget);

      // Verify the switch is in the correct state
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
      // Should be disabled (onChanged is null when disabled)
      expect(switchWidget.onChanged, null);
    });

    testWidgets('VooCheckboxField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooCheckboxField(
                  readOnly: true,
                  name: 'check',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ),
      );

      // Should show Checkbox widget but disabled
      expect(find.byType(Checkbox), findsOneWidget);

      // Verify the checkbox is in the correct state
      final checkboxWidget = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkboxWidget.value, true);
      // Should be disabled (onChanged is null when disabled)
      expect(checkboxWidget.onChanged, null);
    });

    testWidgets('VooDateField respects readOnly property', (WidgetTester tester) async {
      final testDate = DateTime(2024, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooDateField(
                  readOnly: true,
                  name: 'date',
                  initialValue: testDate,
                ),
              ],
            ),
          ),
        ),
      );

      // Should show formatted date
      expect(find.textContaining('Jan'), findsOneWidget);
      expect(find.textContaining('15'), findsOneWidget);
      expect(find.textContaining('2024'), findsOneWidget);
    });

    testWidgets('VooNumberField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooNumberField(
                  readOnly: true,
                  name: 'number',
                  initialValue: 42,
                ),
              ],
            ),
          ),
        ),
      );

      // Should show VooReadOnlyField with the value
      expect(find.text('42'), findsOneWidget);
      // Should not show number input
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('Form-level isReadOnly overrides field-level readOnly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                VooTextField(
                  name: 'text',
                  initialValue: 'Test',
                ),
                VooDropdownField(
                  name: 'dropdown',
                  options: ['A', 'B'],
                  initialValue: 'A',
                ),
              ],
            ),
          ),
        ),
      );

      // Both fields should be present but in read-only mode
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      // Should show VooReadOnlyField for text field, and dropdown should be disabled
      expect(find.byType(VooReadOnlyField), findsOneWidget); // Text field becomes VooReadOnlyField
      expect(find.byType(InputDecorator), findsOneWidget); // One for dropdown
    });
  });
}
