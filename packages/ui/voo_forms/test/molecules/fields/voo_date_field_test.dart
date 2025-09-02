import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooDateField', () {
    testWidgets('should display label when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              label: 'Date of Birth',
            ),
          ),
        ),
      );

      expect(find.text('Date of Birth'), findsOneWidget);
    });

    testWidgets('should display placeholder when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              placeholder: 'Select a date',
            ),
          ),
        ),
      );

      expect(find.text('Select a date'), findsOneWidget);
    });

    testWidgets('should display initial value when provided', (tester) async {
      final initialDate = DateTime(2024, 1, 15);
      final expectedFormat = DateFormat('MM/dd/yyyy').format(initialDate);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              initialValue: initialDate,
            ),
          ),
        ),
      );

      expect(find.text(expectedFormat), findsOneWidget);
    });

    testWidgets('should display value when provided', (tester) async {
      final date = DateTime(2024, 3, 25);
      final expectedFormat = DateFormat('MM/dd/yyyy').format(date);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              value: date,
            ),
          ),
        ),
      );

      expect(find.text(expectedFormat), findsOneWidget);
    });

    testWidgets('should use custom date format when provided', (tester) async {
      final date = DateTime(2024, 3, 25);
      final customFormat = DateFormat('dd-MM-yyyy');
      final expectedFormat = customFormat.format(date);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              initialValue: date,
              dateFormat: customFormat,
            ),
          ),
        ),
      );

      expect(find.text(expectedFormat), findsOneWidget);
    });

    testWidgets('should show calendar icon by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should display helper text when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              helper: 'Please select your date of birth',
            ),
          ),
        ),
      );

      expect(find.text('Please select your date of birth'), findsOneWidget);
    });

    testWidgets('should display error when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              error: 'Date is required',
            ),
          ),
        ),
      );

      expect(find.text('Date is required'), findsOneWidget);
    });

    testWidgets('should not display error when showError is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              error: 'Date is required',
              showError: false,
            ),
          ),
        ),
      );

      expect(find.text('Date is required'), findsNothing);
    });

    testWidgets('should display required asterisk when required is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              label: 'Date of Birth',
              required: true,
            ),
          ),
        ),
      );

      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('should open date picker when tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              label: 'Date of Birth',
            ),
          ),
        ),
      );

      // Tap on the text field
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Check if date picker dialog is shown
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('should not open date picker when disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              label: 'Date of Birth',
              enabled: false,
            ),
          ),
        ),
      );

      // Tap on the text field
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Check that date picker dialog is NOT shown
      expect(find.byType(DatePickerDialog), findsNothing);
    });

    testWidgets('should not open date picker when readOnly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              label: 'Date of Birth',
              readOnly: true,
            ),
          ),
        ),
      );

      // Tap on the text field
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Check that date picker dialog is NOT shown
      expect(find.byType(DatePickerDialog), findsNothing);
    });

    testWidgets('should call onChanged when date is selected', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              onChanged: (value) {
                selectedDate = value;
              },
            ),
          ),
        ),
      );

      // Tap on the text field to open date picker
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Select a date (find and tap OK button)
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Check that onChanged was called with a date
      expect(selectedDate, isNotNull);
    });

    testWidgets('should display custom prefix icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              prefixIcon: Icon(Icons.cake),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('should display custom suffix icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateField(
              name: 'birthdate',
              suffixIcon: Icon(Icons.event),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.event), findsOneWidget);
      // Calendar icon should not be shown since custom suffix is provided
      expect(find.byIcon(Icons.calendar_today), findsNothing);
    });
  });
}
