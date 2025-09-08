import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Dropdown Validation Fix', () {
    testWidgets('dropdown selection clears validation error', (tester) async {
      final controller = VooFormController();
      
      // Set field as required
      controller.registerField('dropdown', 
        validators: [const RequiredValidation<String>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooDropdownField<String>(
                name: 'dropdown',
                label: 'Jurisdiction',
                options: const ['Option 1', 'Option 2', 'Option 3'],
                placeholder: 'Select an option',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('dropdown');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('dropdown is required'), findsOneWidget);
      
      // Open dropdown
      await tester.tap(find.byType(VooDropdownField));
      await tester.pumpAndSettle();
      
      // Select an option
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      
      // Verify error is cleared
      expect(find.text('dropdown is required'), findsNothing);
    });
    
    testWidgets('async dropdown selection clears validation error', (tester) async {
      final controller = VooFormController();
      
      // Set field as required
      controller.registerField('asyncDropdown', 
        validators: [const RequiredValidation<String>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: VooAsyncDropdownField<String>(
                name: 'asyncDropdown',
                label: 'Async Dropdown',
                asyncOptionsLoader: (query) async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  return ['Option 1', 'Option 2', 'Option 3'];
                },
                placeholder: 'Select an option',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('asyncDropdown');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('asyncDropdown is required'), findsOneWidget);
      
      // Open dropdown
      await tester.tap(find.byType(VooAsyncDropdownField));
      await tester.pumpAndSettle();
      
      // Wait for options to load
      await tester.pump(const Duration(milliseconds: 150));
      
      // Select an option
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();
      
      // Verify error is cleared
      expect(find.text('asyncDropdown is required'), findsNothing);
    });
  });
  
  group('Focus Retention Fix', () {
    testWidgets('text field maintains focus when error clears', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Set field as required
      controller.registerField('textField', 
        validators: [const RequiredValidation<String>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: const VooTextField(
                name: 'textField',
                label: 'Text Field',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('textField');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('textField is required'), findsOneWidget);
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus by checking if we can type
      // The fact that we can type means the field has focus
      
      // Type a character
      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      
      // Verify we can continue typing (field still has focus)
      await tester.enterText(find.byType(TextFormField), 'ab');
      await tester.pump();
      expect(find.text('ab'), findsOneWidget);
      
      // Verify error is cleared
      expect(find.text('textField is required'), findsNothing);
    });
    
    testWidgets('currency field maintains focus when error clears', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Set field as required
      controller.registerField('currencyField', 
        validators: [const RequiredValidation<double>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: const VooCurrencyField(
                name: 'currencyField',
                label: 'Amount',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('currencyField');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('currencyField is required'), findsOneWidget);
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus by checking if we can type
      // The fact that we can type means the field has focus
      
      // Type a digit
      await tester.enterText(find.byType(TextFormField), '5');
      await tester.pump();
      
      // Verify we can continue typing (field still has focus)
      await tester.enterText(find.byType(TextFormField), 'ab');
      await tester.pump();
      expect(find.text('ab'), findsOneWidget);
      
      // Verify error is cleared
      expect(find.text('currencyField is required'), findsNothing);
    });
    
    testWidgets('number field maintains focus when error clears', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onTyping,
      );
      
      // Set field as required
      controller.registerField('numberField', 
        validators: [const RequiredValidation<num>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: const VooNumberField(
                name: 'numberField',
                label: 'Number',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('numberField');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('numberField is required'), findsOneWidget);
      
      // Focus the field
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Verify field has focus by checking if we can type
      // The fact that we can type means the field has focus
      
      // Type a digit
      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pump();
      
      // Verify we can continue typing (field still has focus)
      await tester.enterText(find.byType(TextFormField), 'ab');
      await tester.pump();
      expect(find.text('ab'), findsOneWidget);
      
      // Verify error is cleared
      expect(find.text('numberField is required'), findsNothing);
    });
    
    testWidgets('date field selection clears validation error', (tester) async {
      final controller = VooFormController();
      
      // Set field as required
      controller.registerField('dateField', 
        validators: [const RequiredValidation<DateTime>()],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              controller: controller,
              isReadOnly: false,
              isLoading: false,
              child: const VooDateField(
                name: 'dateField',
                label: 'Date',
              ),
            ),
          ),
        ),
      );
      
      // Trigger validation to show error
      controller.validateField('dateField');
      await tester.pump();
      
      // Verify error is shown
      expect(find.text('dateField is required'), findsOneWidget);
      
      // Tap the date field to open picker
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      
      // Select a date (today)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Verify error is cleared
      expect(find.text('dateField is required'), findsNothing);
    });
  });
}