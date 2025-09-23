import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooEmailField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooEmailField(name: 'email', label: 'Email Address'),
          ),
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('uses email keyboard type', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooEmailField(name: 'email')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      const field = VooEmailField(name: 'email', label: 'Email');

      // Invalid email formats
      expect(field.validate('notanemail'), contains('valid'));
      expect(field.validate('missing@'), contains('valid'));
      expect(field.validate('@domain.com'), contains('valid'));
      expect(field.validate('test@'), contains('valid'));

      // Valid email formats
      expect(field.validate('user@example.com'), null);
      expect(field.validate('test.user@example.co.uk'), null);
      expect(field.validate('user+tag@example.com'), null);
    });

    testWidgets('validates required email', (WidgetTester tester) async {
      final field = VooEmailField(name: 'email', label: 'Email', validators: [VooValidator.required()]);

      expect(field.validate(null), 'This field is required');
      expect(field.validate(''), 'This field is required');
      expect(field.validate('user@example.com'), null);
    });

    testWidgets('shows email icon by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooEmailField(name: 'email')),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('calls onChanged when email changes', (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooEmailField(
              name: 'email',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@example.com');
      expect(changedValue, 'test@example.com');
    });

    testWidgets('displays initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooEmailField(name: 'email', initialValue: 'user@example.com'),
          ),
        ),
      );

      // Find the TextField and check its value
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'user@example.com');
    });

    testWidgets('shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooEmailField(name: 'email', error: 'Invalid email address'),
          ),
        ),
      );

      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('shows helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooEmailField(name: 'email', helper: 'We will never share your email'),
          ),
        ),
      );

      expect(find.text('We will never share your email'), findsOneWidget);
    });

    testWidgets('autocorrect is disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VooEmailField(name: 'email')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autocorrect, false);
    });
  });
}
