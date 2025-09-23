import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooFormScope Integration', () {
    testWidgets('fields respect form-level isReadOnly setting', (WidgetTester tester) async {
      // Test with form not read-only (field should be editable)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [VooTextField(name: 'testField', label: 'Test Field', initialValue: 'Initial Value')],
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
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [VooTextField(name: 'testField', label: 'Test Field', initialValue: 'Initial Value')],
            ),
          ),
        ),
      );

      await tester.pump();

      // Field should now be read-only and show VooReadOnlyField
      final readOnlyField = find.byType(VooReadOnlyField);
      expect(readOnlyField, findsOneWidget);

      // Should not find a TextFormField since it's read-only
      expect(find.byType(TextFormField), findsNothing);

      // The field should display the initial value
      expect(find.text('Initial Value'), findsOneWidget);
    });

    testWidgets('field-level readOnly overrides are respected when form is not read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooTextField(name: 'editableField', label: 'Editable Field'),
                VooTextField(name: 'readOnlyField', label: 'Read Only Field', readOnly: true),
              ],
            ),
          ),
        ),
      );

      // First field should be editable (TextFormField)
      final editableField = find.byType(TextFormField);
      expect(editableField, findsOneWidget);

      await tester.enterText(editableField, 'Can Edit');
      await tester.pump();
      expect(find.text('Can Edit'), findsOneWidget);

      // Second field should be read-only (VooReadOnlyField)
      expect(find.byType(VooReadOnlyField), findsOneWidget);
    });

    testWidgets('form-level readOnly always takes precedence', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true, // Form is read-only
              fields: [
                VooTextField(name: 'field1', label: 'Field 1'),
                VooTextField(name: 'field2', label: 'Field 2', readOnly: true),
              ],
            ),
          ),
        ),
      );

      // Both fields should be VooReadOnlyField because form is read-only
      expect(find.byType(VooReadOnlyField), findsNWidgets(2));
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('VooBooleanField respects VooFormScope', (WidgetTester tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [VooBooleanField(name: 'boolField', label: 'Boolean Field', initialValue: false, onChanged: (value) => changedValue = value)],
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
              fields: [VooBooleanField(name: 'boolField', label: 'Boolean Field', initialValue: false, onChanged: (value) => changedValue = value)],
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
              fields: [VooCheckboxField(name: 'checkField', label: 'Checkbox Field', initialValue: false, onChanged: (value) => changedValue = value)],
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
              fields: [VooCheckboxField(name: 'checkField', label: 'Checkbox Field', initialValue: false, onChanged: (value) => changedValue = value)],
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
          home: Scaffold(body: VooForm(isLoading: true, fields: [])),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test with custom loading widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(isLoading: true, loadingWidget: Text('Custom Loading'), fields: []),
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
      );

      final copiedField = originalField.copyWith(label: 'New Label', readOnly: true);

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
