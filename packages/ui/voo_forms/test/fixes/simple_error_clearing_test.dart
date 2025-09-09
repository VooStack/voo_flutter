import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Simple Error Clearing Tests', () {
    testWidgets('error clears when typing after validation failure', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  validators: [VooValidator.required()],
                ),
              ],
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateAll(force: true);
      await tester.pump();
      
      // Error should be shown
      expect(controller.getError('username'), 'This field is required');
      expect(find.text('This field is required'), findsOneWidget);
      
      // Focus field and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();
      
      // Error should be cleared
      expect(controller.getError('username'), isNull);
      expect(find.text('This field is required'), findsNothing);
      
      // Value should be updated
      expect(controller.getValue('username'), 'test');
    });
    
    testWidgets('error clears when typing with external rebuilds', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
      );
      
      // Simulate external state that causes rebuilds
      final ValueNotifier<int> rebuildCounter = ValueNotifier(0);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<int>(
              valueListenable: rebuildCounter,
              builder: (context, value, child) => VooForm(
                controller: controller,
                fields: [
                  VooTextField(
                    name: 'username',
                    label: 'Username ($value)',
                    validators: [VooValidator.required()],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateAll(force: true);
      await tester.pump();
      
      // Error should be shown
      expect(controller.getError('username'), 'This field is required');
      
      // Trigger rebuild
      rebuildCounter.value++;
      await tester.pump();
      
      // Error should still be shown after rebuild
      expect(controller.getError('username'), 'This field is required');
      
      // Focus field and type
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      
      // Trigger another rebuild while typing
      rebuildCounter.value++;
      await tester.pump();
      
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.pump();
      
      // Error should be cleared
      expect(controller.getError('username'), isNull);
      
      // Value should be updated
      expect(controller.getValue('username'), 'test');
    });
    
    testWidgets('multiple validators work correctly with error clearing', (tester) async {
      final controller = VooFormController(
        errorDisplayMode: VooFormErrorDisplayMode.onSubmit,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'password',
                  label: 'Password',
                  validators: [
                    VooValidator.required(),
                    VooValidator.minLength(8),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      
      // Force validation to show error
      controller.validateAll(force: true);
      await tester.pump();
      
      // Should show required error
      expect(controller.getError('password'), 'This field is required');
      
      // Type short password
      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();
      
      // Should show min length error (required error cleared)
      expect(controller.getError('password'), contains('at least 8'));
      
      // Type valid password
      await tester.enterText(find.byType(TextFormField), 'password123');
      await tester.pump();
      
      // All errors should be cleared
      expect(controller.getError('password'), isNull);
    });
  });
}