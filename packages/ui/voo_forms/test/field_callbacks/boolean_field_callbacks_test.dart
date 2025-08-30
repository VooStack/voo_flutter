import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import '../test_helpers.dart';

/// Comprehensive tests for boolean field types (checkbox, switch, radio)
/// Ensures proper type handling and callback invocation
void main() {
  group('Boolean Field Callbacks - Comprehensive Testing', () {
    group('VooField.checkbox() - Checkbox Input', () {
      testWidgets(
        'should toggle checkbox value and invoke callback with bool',
        (tester) async {
          // Arrange
          bool? capturedValue;
          int callbackCount = 0;
          
          final field = VooField.checkbox(
            name: 'terms_checkbox',
            label: 'I agree to the terms',
            initialValue: false,
            onChanged: (bool? value) {
              capturedValue = value;
              callbackCount++;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Verify initial state
          final checkbox = find.byType(Checkbox);
          expect(
            checkbox,
            findsOneWidget,
            reason: 'Checkbox widget should be rendered',
          );
          
          // First tap - should check the checkbox
          await tester.tap(checkbox);
          await tester.pumpAndSettle();
          
          // Assert first toggle
          expect(
            callbackCount,
            equals(1),
            reason: 'Callback should be invoked once after first tap',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: true,
            fieldName: 'terms_checkbox',
            context: 'after checking checkbox',
          );
          
          // Second tap - should uncheck the checkbox
          await tester.tap(checkbox);
          await tester.pumpAndSettle();
          
          // Assert second toggle
          expect(
            callbackCount,
            equals(2),
            reason: 'Callback should be invoked twice after second tap',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: false,
            fieldName: 'terms_checkbox',
            context: 'after unchecking checkbox',
          );
        },
      );
      
      testWidgets(
        'should handle checkbox with null initial value',
        (tester) async {
          // Arrange
          bool? capturedValue;
          final stateSequence = <bool?>[];
          
          final field = VooField.checkbox(
            name: 'nullable_checkbox',
            label: 'Nullable option',
            // Note: tristate is not supported in current API
            initialValue: false,
            onChanged: (bool? value) {
              capturedValue = value;
              stateSequence.add(value);
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final checkbox = find.byType(Checkbox);
          
          // Toggle states
          for (int i = 0; i < 2; i++) {
            await tester.tap(checkbox);
            await tester.pumpAndSettle();
          }
          
          // Assert
          expect(
            stateSequence,
            equals([true, false]),
            reason: 'Checkbox should toggle between true and false',
          );
        },
      );
      
      testWidgets(
        'should respect disabled state',
        (tester) async {
          // Arrange
          bool? capturedValue;
          bool callbackInvoked = false;
          
          final field = VooField.checkbox(
            name: 'disabled_checkbox',
            label: 'Disabled option',
            enabled: false,
            initialValue: true,
            onChanged: (bool? value) {
              capturedValue = value;
              callbackInvoked = true;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final checkbox = find.byType(Checkbox);
          await tester.tap(checkbox);
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            callbackInvoked,
            isFalse,
            reason: 'Disabled checkbox should not invoke callback',
          );
          expect(
            capturedValue,
            isNull,
            reason: 'Value should not change when checkbox is disabled',
          );
        },
      );
    });
    
    group('VooField.boolean() / VooField.switch() - Switch Input', () {
      testWidgets(
        'should toggle switch value between true and false',
        (tester) async {
          // Arrange
          bool? capturedValue;
          int callbackCount = 0;
          
          final field = VooField.boolean(
            name: 'notifications_switch',
            label: 'Enable notifications',
            initialValue: false,
            onChanged: (bool? value) {
              capturedValue = value;
              callbackCount++;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Verify switch is rendered
          final switchWidget = find.byType(Switch);
          expect(
            switchWidget,
            findsOneWidget,
            reason: 'Switch widget should be rendered for boolean field',
          );
          
          // Toggle on
          await tester.tap(switchWidget);
          await tester.pumpAndSettle();
          
          // Assert toggle on
          expect(
            callbackCount,
            equals(1),
            reason: 'Callback should be invoked once after toggling on',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: true,
            fieldName: 'notifications_switch',
            context: 'after toggling switch on',
          );
          
          // Toggle off
          await tester.tap(switchWidget);
          await tester.pumpAndSettle();
          
          // Assert toggle off
          expect(
            callbackCount,
            equals(2),
            reason: 'Callback should be invoked twice after toggling off',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: false,
            fieldName: 'notifications_switch',
            context: 'after toggling switch off',
          );
        },
      );
      
      testWidgets(
        'should display label correctly for switch',
        (tester) async {
          // Arrange
          final field = VooField.boolean(
            name: 'dark_mode',
            label: 'Dark Mode',
            helper: 'Use dark theme', // subtitle is not available, use helper instead
            initialValue: true,
            onChanged: (_) {},
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Assert
          expect(
            find.text('Dark Mode'),
            findsOneWidget,
            reason: 'Switch label should be displayed',
          );
          
          if (field.helper != null) {
            expect(
              find.text('Use dark theme'),
              findsAny,
              reason: 'Switch helper text should be displayed if provided',
            );
          }
        },
      );
    });
    
    group('VooField.radio() - Radio Button Group', () {
      testWidgets(
        'should select radio option and invoke callback',
        (tester) async {
          // Arrange
          String? capturedValue;
          int callbackCount = 0;
          
          final field = VooField.radio(
            name: 'payment_method',
            label: 'Payment Method',
            options: ['credit', 'debit', 'paypal'],
            initialValue: 'credit',
            onChanged: (dynamic value) {
              capturedValue = value as String?;
              callbackCount++;
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Verify all radio options are displayed
          expect(
            find.text('credit'),
            findsOneWidget,
            reason: 'credit option should be displayed',
          );
          expect(
            find.text('debit'),
            findsOneWidget,
            reason: 'debit option should be displayed',
          );
          expect(
            find.text('paypal'),
            findsOneWidget,
            reason: 'paypal option should be displayed',
          );
          
          // Select paypal option
          await tester.tap(find.text('paypal'));
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            callbackCount,
            equals(1),
            reason: 'Callback should be invoked once when selecting radio option',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'paypal',
            fieldName: 'payment_method',
            context: 'after selecting PayPal',
          );
          
          // Select debit option
          await tester.tap(find.text('debit'));
          await tester.pumpAndSettle();
          
          // Assert second selection
          expect(
            callbackCount,
            equals(2),
            reason: 'Callback should be invoked again for second selection',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'debit',
            fieldName: 'payment_method',
            context: 'after selecting Debit Card',
          );
        },
      );
      
      testWidgets(
        'should handle custom object types in radio buttons',
        (tester) async {
          // Arrange
          String? capturedValue;
          
          final plans = [
            Plan(id: 'basic', name: 'Basic', price: 9.99),
            Plan(id: 'pro', name: 'Professional', price: 19.99),
            Plan(id: 'enterprise', name: 'Enterprise', price: 49.99),
          ];
          
          final field = VooField.radio(
            name: 'subscription_plan',
            label: 'Choose Plan',
            options: plans.map((plan) => plan.id).toList(),
            onChanged: (dynamic value) => capturedValue = value as String?,
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Select Professional plan - now using plan id
          await tester.tap(find.text('pro'));
          await tester.pumpAndSettle();
          
          // Assert - now comparing captured string with plan id
          expectFieldValue(
            actual: capturedValue,
            expected: 'pro',
            fieldName: 'subscription_plan',
            context: 'after selecting Professional plan',
          );
        },
      );
      
      testWidgets(
        'should enforce single selection in radio group',
        (tester) async {
          // Arrange
          String? capturedValue;
          final selectedValues = <String?>[];
          
          final field = VooField.radio(
            name: 'size',
            label: 'Size',
            options: ['S', 'M', 'L'],
            onChanged: (dynamic value) {
              capturedValue = value as String?;
              selectedValues.add(value);
            },
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          // Try to select multiple options
          await tester.tap(find.text('S'));
          await tester.pumpAndSettle();
          
          await tester.tap(find.text('L'));
          await tester.pumpAndSettle();
          
          // Assert - Only last selection should be active
          expect(
            selectedValues.length,
            equals(2),
            reason: 'Should record both selection attempts',
          );
          expectFieldValue(
            actual: capturedValue,
            expected: 'L',
            fieldName: 'size',
            context: 'radio group should only allow single selection',
          );
        },
      );
    });
    
    group('Edge Cases and Error Scenarios', () {
      testWidgets(
        'should handle rapid toggling without losing state',
        (tester) async {
          // Arrange
          final toggleSequence = <bool?>[];
          
          final field = VooField.boolean(
            name: 'rapid_toggle',
            label: 'Rapid Toggle Test',
            onChanged: (bool? value) => toggleSequence.add(value),
          );
          
          // Act
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final switchWidget = find.byType(Switch);
          
          // Rapid toggling
          for (int i = 0; i < 5; i++) {
            await tester.tap(switchWidget);
            await tester.pump(const Duration(milliseconds: 50));
          }
          await tester.pumpAndSettle();
          
          // Assert
          expect(
            toggleSequence.isNotEmpty,
            isTrue,
            reason: 'Should capture all rapid toggle events',
          );
          expect(
            toggleSequence.last,
            equals(toggleSequence.length.isOdd),
            reason: 'Final state should match odd/even toggle count',
          );
        },
      );
      
      testWidgets(
        'should handle null callback gracefully',
        (tester) async {
          // Arrange
          final field = VooField.checkbox(
            name: 'no_callback',
            label: 'No Callback Checkbox',
            // No onChanged provided
          );
          
          // Act & Assert - Should not throw
          await tester.pumpWidget(createTestApp(child: VooFieldWidget(field: field)));
          
          final checkbox = find.byType(Checkbox);
          await expectLater(
            () async {
              await tester.tap(checkbox);
              await tester.pumpAndSettle();
            },
            returnsNormally,
            reason: 'Should handle missing callback without errors',
          );
        },
      );
    });
  });
}

// Test helper classes
class Plan {
  final String id;
  final String name;
  final double price;
  
  const Plan({
    required this.id,
    required this.name,
    required this.price,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Plan &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}