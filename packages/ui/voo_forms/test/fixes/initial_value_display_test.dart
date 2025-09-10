import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Initial Value Display Tests', () {
    testWidgets('Text field displays initial value immediately', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  initialValue: 'john_doe',
                ),
              ],
            ),
          ),
        ),
      );

      // Initial value should be displayed immediately
      expect(find.text('john_doe'), findsOneWidget);
    });

    testWidgets('Dropdown field displays initial value immediately', (tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooDropdownField<String>(
                  name: 'option',
                  label: 'Select Option',
                  options: options,
                  initialValue: 'Option 2',
                ),
              ],
            ),
          ),
        ),
      );

      // Initial value should be displayed immediately
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('Checkbox field displays initial value immediately', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooCheckboxField(
                  name: 'agree',
                  label: 'I agree',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ),
      );

      // Checkbox should be checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('Multi-select field displays initial values immediately', (tester) async {
      final options = ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4'];
      final initialValues = ['Tag 1', 'Tag 3'];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooMultiSelectField<String>(
                  name: 'tags',
                  label: 'Select Tags',
                  options: options,
                  initialValue: initialValues,
                ),
              ],
            ),
          ),
        ),
      );

      // Initial values should be displayed as chips
      expect(find.text('Tag 1'), findsOneWidget);
      expect(find.text('Tag 3'), findsOneWidget);
    });

    testWidgets('Fields display correctly in readonly mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              isReadOnly: true,
              fields: [
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  initialValue: 'john_doe',
                ),
                VooDropdownField<String>(
                  name: 'option',
                  label: 'Option',
                  options: ['Option 1', 'Option 2'],
                  initialValue: 'Option 1',
                ),
              ],
            ),
          ),
        ),
      );

      // Values should be displayed in readonly fields
      expect(find.text('john_doe'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      
      // VooTextField uses VooReadOnlyField when readonly
      // VooDropdownField shows disabled dropdown when readonly
      expect(find.byType(VooReadOnlyField), findsOneWidget);
    });

    testWidgets('Form controller preserves values during rebuilds', (tester) async {
      final controller = VooFormController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return VooForm(
                  controller: controller,
                  fields: [
                    VooTextField(
                      name: 'username',
                      label: 'Username',
                      initialValue: 'initial_value',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Initial value should be displayed
      expect(find.text('initial_value'), findsOneWidget);
      
      // Change the value
      await tester.enterText(find.byType(TextFormField), 'new_value');
      await tester.pump();
      
      // New value should be displayed
      expect(find.text('new_value'), findsOneWidget);
      
      // Trigger a rebuild
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return VooForm(
                  controller: controller,
                  fields: [
                    VooTextField(
                      name: 'username',
                      label: 'Username',
                      initialValue: 'different_initial', // Different initial value
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      
      // Value should be preserved (not reset to new initial value)
      expect(find.text('new_value'), findsOneWidget);
      expect(find.text('different_initial'), findsNothing);
    });
  });
}