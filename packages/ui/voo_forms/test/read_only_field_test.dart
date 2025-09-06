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

      // Should show VooReadOnlyField with the value
      expect(find.text('Option 1'), findsOneWidget);
      // Should not show dropdown (check for DropdownButtonFormField which is the underlying widget)
      expect(find.byType(DropdownButtonFormField), findsNothing);
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

      // Should show VooReadOnlyField with the value
      expect(find.text('Test Value'), findsOneWidget);
      // Should not show TextFormField
      expect(find.byType(TextFormField), findsNothing);
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

      // Should show VooReadOnlyField with "Yes"
      expect(find.text('Yes'), findsOneWidget);
      // Should not show Switch
      expect(find.byType(Switch), findsNothing);
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

      // Should show VooReadOnlyField with "Checked"
      expect(find.text('Checked'), findsOneWidget);
      // Should not show Checkbox
      expect(find.byType(Checkbox), findsNothing);
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

      // Both fields should show as read-only
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      // Should not show input fields
      expect(find.byType(TextFormField), findsNothing);
      expect(find.byType(DropdownButtonFormField), findsNothing);
    });
  });
}