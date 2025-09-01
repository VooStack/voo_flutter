import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Test helpers and utilities for VooForms testing
/// Provides consistent test setup and detailed error reporting

/// Creates a properly wrapped test app with all required providers
Widget createTestApp({
  required Widget child,
  VooDesignSystemData? designSystem,
}) => MaterialApp(
    home: VooDesignSystem(
      data: designSystem ?? VooDesignSystemData.defaultSystem,
      child: VooResponsiveBuilder(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );

/// Helper to tap dropdown fields that works with both DropdownButtonFormField and TextFormField
Future<void> tapDropdown(WidgetTester tester, {String? reason}) async {
  reason ??= 'Tapping dropdown field';
  
  // Try to find DropdownButtonFormField of any generic type
  final dropdownButton = find.byWidgetPredicate((widget) {
    return widget.runtimeType.toString().startsWith('DropdownButtonFormField');
  });
  if (dropdownButton.evaluate().isNotEmpty) {
    await tester.tap(dropdownButton.first);
    return;
  }
  
  // Otherwise look for TextFormField (searchable dropdowns)
  final textField = find.byType(TextFormField);
  if (textField.evaluate().isNotEmpty) {
    await tester.tap(textField.first);
    return;
  }
  
  throw TestFailure('$reason: No dropdown field found');
}

/// Helper to enter text with detailed error reporting
Future<void> enterTextWithVerification(
  WidgetTester tester,
  String text, {
  String? fieldName,
}) async {
  final textField = find.byType(TextField);
  
  if (textField.evaluate().isEmpty) {
    throw TestFailure(
      'Failed to find TextField${fieldName != null ? ' for $fieldName' : ''}',
    );
  }
  
  await tester.enterText(textField, text);
  await tester.pump();
  
  // Verify the text was entered
  final controller = tester.widget<TextField>(textField).controller;
  if (controller?.text != text) {
    throw TestFailure(
      'Text verification failed${fieldName != null ? ' for $fieldName' : ''}: '
      'Expected "$text", got "${controller?.text}"',
    );
  }
}

/// Helper to verify field value with detailed error reporting
void expectFieldValue<T>({
  required T? actual,
  required T expected,
  required String fieldName,
  String? context,
}) {
  final contextMsg = context != null ? ' ($context)' : '';
  
  expect(
    actual,
    equals(expected),
    reason: 'Field "$fieldName" value mismatch$contextMsg: '
        'Expected $expected, got $actual',
  );
}

/// Helper to verify callback invocation with detailed reporting
void expectCallbackInvoked({
  required bool wasInvoked,
  required String callbackName,
  String? context,
}) {
  final contextMsg = context != null ? ' ($context)' : '';
  
  expect(
    wasInvoked,
    isTrue,
    reason: 'Callback "$callbackName" was not invoked$contextMsg',
  );
}

/// Helper to verify widget state with detailed reporting
void expectWidgetState({
  required WidgetTester tester,
  required Type widgetType,
  required bool Function(dynamic widget) predicate,
  required String description,
}) {
  final widget = tester.widget(find.byType(widgetType));
  
  expect(
    predicate(widget),
    isTrue,
    reason: 'Widget state verification failed: $description',
  );
}

/// Helper to create a test field with comprehensive configuration
VooFormField createTestField<T>({
  required String name,
  required VooFieldType type,
  String? label,
  T? initialValue,
  ValueChanged<T?>? onChanged,
  bool enabled = true,
  bool readOnly = false,
  List<VooFieldOption<T>>? options,
  List<VooValidationRule<T>>? validators,
}) => VooFormField<T>(
    id: name,
    name: name,
    type: type,
    label: label ?? 'Test $name',
    initialValue: initialValue,
    value: initialValue,
    onChanged: onChanged,
    enabled: enabled,
    readOnly: readOnly,
    options: options,
    validators: validators ?? [],
  );

/// Helper for async testing with timeout and error handling
Future<void> testWithTimeout(
  String description,
  Future<void> Function() test, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  try {
    await test().timeout(
      timeout,
      onTimeout: () {
        throw TestFailure('Test "$description" timed out after ${timeout.inSeconds} seconds');
      },
    );
  } catch (e) {
    throw TestFailure('Test "$description" failed: $e');
  }
}

/// Helper to verify form validation with detailed reporting
void expectValidationError({
  required Map<String, String?> errors,
  required String fieldId,
  String? expectedError,
}) {
  final actualError = errors[fieldId];
  
  if (expectedError != null) {
    expect(
      actualError,
      equals(expectedError),
      reason: 'Validation error mismatch for field "$fieldId": '
          'Expected "$expectedError", got "$actualError"',
    );
  } else {
    expect(
      actualError,
      isNull,
      reason: 'Unexpected validation error for field "$fieldId": $actualError',
    );
  }
}

/// Helper to verify form submission state
void expectFormSubmissionState({
  required bool isSubmitting,
  required bool isValid,
  required Map<String, dynamic> values,
  String? context,
}) {
  final contextMsg = context != null ? ' ($context)' : '';
  
  expect(
    isSubmitting,
    isFalse,
    reason: 'Form should not be submitting$contextMsg',
  );
  
  expect(
    isValid,
    isTrue,
    reason: 'Form should be valid$contextMsg',
  );
  
  expect(
    values,
    isNotEmpty,
    reason: 'Form values should not be empty$contextMsg',
  );
}