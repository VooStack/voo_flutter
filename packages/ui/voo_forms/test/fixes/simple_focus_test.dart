import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  testWidgets('field maintains focus when typing with validation error present', (tester) async {
    final controller = VooFormController();
    final focusNode = FocusNode();
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VooFormScope(
            controller: controller,
            isReadOnly: false,
            isLoading: false,
            child: VooTextField(
              name: 'test',
              label: 'Test Field',
              focusNode: focusNode,
              validators: const [RequiredValidation<String>()],
            ),
          ),
        ),
      ),
    );
    
    // Register the field with validation
    controller.registerField('test', 
      validators: [const RequiredValidation<String>()],
    );
    
    // Force show error
    controller.validateField('test', force: true);
    await tester.pump();
    
    // Focus the field
    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    
    // Verify field has focus
    expect(focusNode.hasFocus, isTrue, reason: 'Field should have focus after tapping');
    
    // Type first character
    await tester.enterText(find.byType(TextFormField), 'a');
    await tester.pump();
    
    // CRITICAL TEST: Field should still have focus
    expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus after typing first character');
    
    // Type more to verify continuous typing works
    await tester.enterText(find.byType(TextFormField), 'abc');
    await tester.pump();
    
    // Should still have focus
    expect(focusNode.hasFocus, isTrue, reason: 'Field should maintain focus during continuous typing');
  });
}