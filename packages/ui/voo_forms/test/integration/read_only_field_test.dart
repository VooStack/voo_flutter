import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Read-only field tests', () {
    testWidgets('VooDropdownField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooDropdownField(
                  readOnly: true,
                  name: 'name',
                  options: const ['Option 1', 'Option 2'],
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
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: const [
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

      // Should show TextFormField with the value but in read-only mode
      expect(find.text('Test Value'), findsOneWidget);
      // Should show TextFormField
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Verify it's actually read-only by trying to change it
      await tester.enterText(find.byType(TextFormField), 'New Value');
      await tester.pump();
      // Value should not change
      expect(find.text('Test Value'), findsOneWidget);
      expect(find.text('New Value'), findsNothing);
    });

    testWidgets('VooBooleanField respects readOnly property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: const [
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
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: const [
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
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: const [
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
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                VooTextField(
                  readOnly: false, // This should be overridden by form-level
                  name: 'text',
                  initialValue: 'Test',
                ),
                VooDropdownField(
                  readOnly: false, // This should be overridden by form-level
                  name: 'dropdown',
                  options: const ['A', 'B'],
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
      // Input fields should be shown
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(InputDecorator), findsNWidgets(2)); // One for text field, one for dropdown
    });
  });
}