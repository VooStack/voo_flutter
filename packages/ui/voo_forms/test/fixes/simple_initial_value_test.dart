import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Simple Initial Value Tests', () {
    testWidgets('Form displays initial values immediately without readonly', (tester) async {
      final formController = VooFormController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: formController,
              isReadOnly: false, // Explicitly NOT readonly
              fields: [
                VooTextField(
                  name: 'text',
                  label: 'Text Field',
                  initialValue: 'Initial Text Value',
                ),
                VooDropdownField<String>(
                  name: 'dropdown',
                  label: 'Dropdown',
                  options: const ['Option 1', 'Option 2', 'Option 3'],
                  initialValue: 'Option 2',
                ),
                VooCheckboxField(
                  name: 'checkbox',
                  label: 'Checkbox',
                  initialValue: true,
                ),
                VooMultiSelectField<String>(
                  name: 'multiselect',
                  label: 'Multi Select',
                  options: const ['A', 'B', 'C', 'D'],
                  initialValue: const ['B', 'D'],
                ),
              ],
            ),
          ),
        ),
      );

      // All initial values should be displayed immediately
      expect(find.text('Initial Text Value'), findsOneWidget,
        reason: 'Text field should display initial value');
      
      expect(find.text('Option 2'), findsOneWidget,
        reason: 'Dropdown should display initial value');
      
      // Checkbox should be checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true,
        reason: 'Checkbox should be checked');
      
      // Multi-select should show selected values as chips
      expect(find.text('B'), findsOneWidget,
        reason: 'Multi-select should show selected value B');
      expect(find.text('D'), findsOneWidget,
        reason: 'Multi-select should show selected value D');
    });

    testWidgets('Form in readonly mode displays initial values', (tester) async {
      final formController = VooFormController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: formController,
              isReadOnly: true, // Readonly mode
              fields: [
                VooTextField(
                  name: 'text',
                  label: 'Text Field',
                  initialValue: 'Readonly Text',
                ),
                VooDropdownField<String>(
                  name: 'dropdown',
                  label: 'Dropdown',
                  options: const ['Option 1', 'Option 2', 'Option 3'],
                  initialValue: 'Option 3',
                ),
                VooMultiSelectField<String>(
                  name: 'multiselect',
                  label: 'Multi Select',
                  options: const ['A', 'B', 'C'],
                  initialValue: const ['A', 'C'],
                ),
              ],
            ),
          ),
        ),
      );

      // In readonly mode, values should still be displayed
      expect(find.text('Readonly Text'), findsOneWidget,
        reason: 'Text field should display value in readonly');
      
      expect(find.text('Option 3'), findsOneWidget,
        reason: 'Dropdown should display value in readonly');
      
      // Multi-select in readonly shows comma-separated
      expect(find.text('A, C'), findsOneWidget,
        reason: 'Multi-select should show comma-separated values in readonly');
    });

    testWidgets('Form with async initial values displays them when available', (tester) async {
      final formController = VooFormController();
      String textValue = '';
      String? dropdownValue;
      List<String> multiSelectValue = [];
      
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          textValue = 'Async Loaded';
                          dropdownValue = 'Option 2';
                          multiSelectValue = ['B', 'C'];
                        });
                      },
                      child: const Text('Load Data'),
                    ),
                    Expanded(
                      child: VooForm(
                        controller: formController,
                        fields: [
                          VooTextField(
                            name: 'text',
                            label: 'Text',
                            initialValue: textValue,
                          ),
                          VooDropdownField<String>(
                            name: 'dropdown',
                            label: 'Dropdown',
                            options: const ['Option 1', 'Option 2', 'Option 3'],
                            initialValue: dropdownValue,
                          ),
                          VooMultiSelectField<String>(
                            name: 'multiselect',
                            label: 'Multi Select',
                            options: const ['A', 'B', 'C', 'D'],
                            initialValue: multiSelectValue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Initially, fields should be empty or have default values
      expect(find.text('Async Loaded'), findsNothing);
      
      // Click button to load data
      await tester.tap(find.text('Load Data'));
      await tester.pump();
      
      // After loading, values should be displayed
      expect(find.text('Async Loaded'), findsOneWidget,
        reason: 'Text field should display async loaded value');
      
      expect(find.text('Option 2'), findsOneWidget,
        reason: 'Dropdown should display async loaded value');
      
      // Multi-select should show the loaded values
      expect(find.text('B'), findsOneWidget,
        reason: 'Multi-select should show B');
      expect(find.text('C'), findsOneWidget,
        reason: 'Multi-select should show C');
    });
  });
}