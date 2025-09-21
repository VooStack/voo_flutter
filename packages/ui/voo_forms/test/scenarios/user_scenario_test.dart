import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  testWidgets('User scenario: VooDropdownField with readOnly works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VooForm(
            fields: [
              VooDropdownField(
                readOnly: true, // Field-level readOnly should work
                name: 'name',
                options: ['Option 1', 'Option 2'],
                initialValue: 'Option 1',
              ),
            ],
          ),
        ),
      ),
    );

    // The field should be read-only and show "Option 1"
    expect(find.text('Option 1'), findsOneWidget);

    // Should not show dropdown since it's read-only
    expect(find.byType(DropdownButtonFormField), findsNothing);
  });

  testWidgets('Form-level readOnly works with dropdown', (WidgetTester tester) async {
    const bool readOnly = true; // Form is read-only

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VooForm(
            isReadOnly: readOnly,
            fields: [
              VooDropdownField(
                name: 'name',
                options: ['Option 1', 'Option 2'],
                initialValue: 'Option 1',
              ),
            ],
          ),
        ),
      ),
    );

    // The field should be read-only and show "Option 1"
    expect(find.text('Option 1'), findsOneWidget);

    // Should not show dropdown since form is read-only
    expect(find.byType(DropdownButtonFormField), findsNothing);
  });
}
