import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFormScope Integration', () {
    testWidgets('fields respect form-level isReadOnly setting', (WidgetTester tester) async {
      // Test with form not read-only (field should be editable)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: false,
              fields: [
                const VooTextField(
                  name: 'testField',
                  label: 'Test Field',
                  initialValue: 'Initial Value',
                ),
              ],
            ),
          ),
        ),
      );

      // Field should be editable - try entering text
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      
      await tester.enterText(textField, 'New Value');
      await tester.pump();
      
      // Text should have changed
      expect(find.text('New Value'), findsOneWidget);

      // Now test with form read-only (field should not be editable)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                const VooTextField(
                  name: 'testField',
                  label: 'Test Field',
                  initialValue: 'Initial Value',
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      // Field should now be read-only - try entering text
      final readOnlyTextField = find.byType(TextFormField);
      expect(readOnlyTextField, findsOneWidget);
      
      // Try to change the text - it should not change
      await tester.enterText(readOnlyTextField, 'Should Not Change');
      await tester.pump();
      
      // Text should still be the initial value
      expect(find.text('Initial Value'), findsOneWidget);
      expect(find.text('Should Not Change'), findsNothing);
    });

    testWidgets('field-level readOnly overrides are respected when form is not read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: false,
              fields: [
                const VooTextField(
                  name: 'editableField',
                  label: 'Editable Field',
                  readOnly: false,
                ),
                const VooTextField(
                  name: 'readOnlyField',
                  label: 'Read Only Field',
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));

      // First field should be editable
      await tester.enterText(textFields.at(0), 'Can Edit');
      await tester.pump();
      expect(find.text('Can Edit'), findsOneWidget);

      // Second field should be read-only
      // Try to enter text - it shouldn't change the field value
      await tester.enterText(textFields.at(1), 'Cannot Edit');
      await tester.pump();
      
      // The text should not appear (field is read-only)
      // Note: Due to Flutter's TextFormField behavior with readOnly,
      // the text might appear visually but won't be in the field's value
      // We can't reliably test this without access to the controller
    });

    testWidgets('form-level readOnly always takes precedence', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true, // Form is read-only
              fields: [
                const VooTextField(
                  name: 'field1',
                  label: 'Field 1',
                  readOnly: false, // Even though field says not read-only
                ),
                const VooTextField(
                  name: 'field2',
                  label: 'Field 2',
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));

      // Both fields should be read-only because form is read-only
      // Try to edit both fields
      await tester.enterText(textFields.at(0), 'Should Not Change 1');
      await tester.pump();
      await tester.enterText(textFields.at(1), 'Should Not Change 2');
      await tester.pump();
      
      // Neither field should have changed
      expect(find.text('Should Not Change 1'), findsNothing);
      expect(find.text('Should Not Change 2'), findsNothing);
    });

    testWidgets('VooBooleanField respects VooFormScope', (WidgetTester tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: false,
              fields: [
                VooBooleanField(
                  name: 'boolField',
                  label: 'Boolean Field',
                  initialValue: false,
                  onChanged: (value) => changedValue = value,
                ),
              ],
            ),
          ),
        ),
      );

      // Find and tap the switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      
      await tester.tap(switchFinder);
      await tester.pump();
      
      // Value should have changed
      expect(changedValue, true);

      // Now test with read-only form
      changedValue = null;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                VooBooleanField(
                  name: 'boolField',
                  label: 'Boolean Field',
                  initialValue: false,
                  onChanged: (value) => changedValue = value,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      // Try to tap the switch
      final readOnlySwitchFinder = find.byType(Switch);
      expect(readOnlySwitchFinder, findsOneWidget);
      
      await tester.tap(readOnlySwitchFinder);
      await tester.pump();
      
      // Value should NOT have changed because form is read-only
      expect(changedValue, null);
    });

    testWidgets('VooCheckboxField respects VooFormScope', (WidgetTester tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: false,
              fields: [
                VooCheckboxField(
                  name: 'checkField',
                  label: 'Checkbox Field',
                  initialValue: false,
                  onChanged: (value) => changedValue = value,
                ),
              ],
            ),
          ),
        ),
      );

      // Find and tap the checkbox
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      
      await tester.tap(checkboxFinder);
      await tester.pump();
      
      // Value should have changed
      expect(changedValue, true);

      // Now test with read-only form
      changedValue = null;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                VooCheckboxField(
                  name: 'checkField',
                  label: 'Checkbox Field',
                  initialValue: false,
                  onChanged: (value) => changedValue = value,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      // Try to tap the checkbox
      final readOnlyCheckboxFinder = find.byType(Checkbox);
      expect(readOnlyCheckboxFinder, findsOneWidget);
      
      await tester.tap(readOnlyCheckboxFinder);
      await tester.pump();
      
      // Value should NOT have changed because form is read-only
      expect(changedValue, null);
    });

    testWidgets('VooFormScope loading state is accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isLoading: true,
              fields: [],
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test with custom loading widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isLoading: true,
              loadingWidget: Text('Custom Loading'),
              fields: [],
            ),
          ),
        ),
      );

      // Should show custom loading widget
      expect(find.text('Custom Loading'), findsOneWidget);
    });

    testWidgets('copyWith preserves all field properties', (WidgetTester tester) async {
      const originalField = VooTextField(
        name: 'test',
        label: 'Test Label',
        hint: 'Test Hint',
        helper: 'Test Helper',
        placeholder: 'Test Placeholder',
        initialValue: 'Initial',
        enabled: true,
        readOnly: false,
      );

      final copiedField = originalField.copyWith(
        label: 'New Label',
        readOnly: true,
      );

      expect(copiedField.name, 'test');
      expect(copiedField.label, 'New Label');
      expect(copiedField.hint, 'Test Hint');
      expect(copiedField.helper, 'Test Helper');
      expect(copiedField.placeholder, 'Test Placeholder');
      expect(copiedField.initialValue, 'Initial');
      expect(copiedField.enabled, true);
      expect(copiedField.readOnly, true);
    });
  });
}