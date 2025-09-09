import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Error Clearing with Rebuilds Tests', () {
    testWidgets('errors clear when typing even with frequent widget rebuilds', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
      );
      
      // Simulate external state that causes rebuilds
      final ValueNotifier<int> rebuildCounter = ValueNotifier(0);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ValueListenableBuilder<int>(
                valueListenable: rebuildCounter,
                builder: (context, value, child) {
                  // This simulates a Cubit/BLoC rebuilding the widget tree
                  return VooForm(
                    controller: controller,
                    fields: [
                      VooTextField(
                        name: 'username',
                        label: 'Username (Rebuild count: $value)',
                        validators: [VooValidator.required()],
                      ),
                      VooCurrencyField(
                        name: 'amount',
                        label: 'Amount',
                        validators: [
                          VooValidator.required(),
                          VooValidator.min(100),
                        ],
                      ),
                      VooNumberField(
                        name: 'quantity',
                        label: 'Quantity',
                        validators: [
                          VooValidator.required(),
                          VooValidator.min(1),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
      
      // Submit to trigger validation errors
      await controller.submit(onSubmit: (_) async {});
      await tester.pump();
      
      // Errors should be shown
      expect(controller.getError('username'), 'This field is required');
      expect(controller.getError('amount'), 'This field is required');
      expect(controller.getError('quantity'), 'This field is required');
      
      // Focus the username field
      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();
      
      // Simulate external state changes causing rebuilds while typing
      for (int i = 0; i < 5; i++) {
        // Trigger a rebuild
        rebuildCounter.value++;
        await tester.pump();
        
        // Type a character
        await tester.enterText(find.byType(TextFormField).first, 'user$i');
        await tester.pump();
        
        // Error should be cleared despite the rebuild
        expect(controller.getError('username'), isNull,
            reason: 'Username error should clear after typing character $i');
      }
      
      // Test currency field with rebuilds
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.pump();
      
      // Type invalid amount
      await tester.enterText(find.byType(TextFormField).at(1), '\$50.00');
      rebuildCounter.value++;
      await tester.pump();
      
      // Should show min value error
      expect(controller.getError('amount'), contains('at least'));
      
      // Clear and type valid amount
      await tester.enterText(find.byType(TextFormField).at(1), '');
      await tester.pump();
      await tester.enterText(find.byType(TextFormField).at(1), '\$150.00');
      rebuildCounter.value++;
      await tester.pump();
      
      // Error should clear
      expect(controller.getError('amount'), isNull);
      
      // Test number field with rebuilds
      await tester.tap(find.byType(TextFormField).at(2));
      await tester.pump();
      
      // Type valid number
      await tester.enterText(find.byType(TextFormField).at(2), '5');
      rebuildCounter.value++;
      await tester.pump();
      
      // Error should clear
      expect(controller.getError('quantity'), isNull);
    });
    
    testWidgets('validation continues to work after multiple rebuilds', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
      );
      
      int rebuildCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Rebuild count: $rebuildCount'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rebuildCount++;
                        });
                      },
                      child: const Text('Rebuild'),
                    ),
                    Expanded(
                      child: VooForm(
                        controller: controller,
                        fields: [
                          VooTextField(
                            name: 'email',
                            label: 'Email',
                            validators: [
                              VooValidator.required(),
                              VooValidator.email(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      
      // Force validation to show required error
      controller.validateAll(force: true);
      await tester.pump();
      
      // Should show required error
      expect(controller.getError('email'), 'This field is required');
      
      // Type invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid');
      await tester.pump();
      
      // Should show email validation error (required error cleared)
      final emailError = controller.getError('email');
      expect(emailError != null && emailError.contains('valid email'), isTrue,
          reason: 'Expected email validation error, got: $emailError');
      
      // Trigger multiple rebuilds
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Rebuild'));
        await tester.pump();
      }
      
      // Error should still be shown after rebuilds
      expect(controller.getError('email'), contains('valid email'));
      
      // Clear the field
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();
      
      // Should show required error
      expect(controller.getError('email'), 'This field is required');
      
      // Type valid email
      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      await tester.pump();
      
      // Error should clear
      expect(controller.getError('email'), isNull);
      
      // Trigger more rebuilds
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Rebuild'));
        await tester.pump();
      }
      
      // Should still have no error
      expect(controller.getError('email'), isNull);
    });
    
    testWidgets('TextEditingController state is preserved across rebuilds', (tester) async {
      final controller = VooFormController();
      final ValueNotifier<bool> rebuild = ValueNotifier(false);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<bool>(
              valueListenable: rebuild,
              builder: (context, value, child) {
                return VooForm(
                  controller: controller,
                  fields: [
                    VooTextField(
                      name: 'persistent',
                      label: 'Persistent Field',
                      validators: [VooValidator.required()],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      
      // Wait for the form to be fully built
      await tester.pumpAndSettle();
      
      // Type some text
      await tester.enterText(find.byType(TextFormField), 'Hello World');
      await tester.pump();
      
      // Wait for all microtasks to complete
      await tester.pumpAndSettle();
      
      // Verify text is in the controller
      expect(controller.getValue('persistent'), 'Hello World');
      
      // Verify the TextFormField has the text
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text ?? textField.initialValue, 'Hello World');
      
      // Trigger rebuild
      rebuild.value = !rebuild.value;
      await tester.pump();
      
      // Text should still be in controller
      expect(controller.getValue('persistent'), 'Hello World');
      final textField2 = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField2.controller?.text ?? textField2.initialValue, 'Hello World');
      
      // Type more text
      await tester.enterText(find.byType(TextFormField), 'Hello World!');
      await tester.pump();
      
      // Trigger another rebuild
      rebuild.value = !rebuild.value;
      await tester.pump();
      
      // Updated text should be preserved
      expect(controller.getValue('persistent'), 'Hello World!');
      final textField3 = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField3.controller?.text ?? textField3.initialValue, 'Hello World!');
    });
  });
}