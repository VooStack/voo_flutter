import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/src/domain/enums/button_type.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/buttons/voo_form_button.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_date_field_button.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';

void main() {
  group('VooDateFieldButton', () {
    testWidgets('should display button with placeholder text when no date selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select a date'),
          ),
        ),
      );

      expect(find.text('Select a date'), findsOneWidget);
      expect(find.byType(VooFormButton), findsOneWidget);
    });

    testWidgets('should display custom button text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', buttonText: 'Pick Date'),
          ),
        ),
      );

      expect(find.text('Pick Date'), findsOneWidget);
    });

    testWidgets('should display formatted date when value is provided', (WidgetTester tester) async {
      final testDate = DateTime(2024, 3, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', initialValue: testDate),
          ),
        ),
      );

      expect(find.text('2024-03-15'), findsOneWidget);
    });

    testWidgets('should use custom date format when provided', (WidgetTester tester) async {
      final testDate = DateTime(2024, 3, 15);
      final dateFormat = DateFormat('MMM dd, yyyy');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', initialValue: testDate, dateFormat: dateFormat),
          ),
        ),
      );

      expect(find.text('Mar 15, 2024'), findsOneWidget);
    });

    testWidgets('should display label when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', label: 'Birth Date'),
          ),
        ),
      );

      expect(find.text('Birth Date'), findsOneWidget);
    });

    testWidgets('should display helper text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', helper: 'Select your date of birth'),
          ),
        ),
      );

      expect(find.text('Select your date of birth'), findsOneWidget);
    });

    testWidgets('should display error text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', error: 'Date is required'),
          ),
        ),
      );

      expect(find.text('Date is required'), findsOneWidget);
    });

    testWidgets('should open date picker when button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select Date'),
          ),
        ),
      );

      await tester.tap(find.byType(VooFormButton));
      await tester.pumpAndSettle();

      // Date picker should be shown
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should not open date picker when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', enabled: false, placeholder: 'Select Date'),
          ),
        ),
      );

      await tester.tap(find.byType(VooFormButton));
      await tester.pumpAndSettle();

      // Date picker should not be shown
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('should not open date picker when readOnly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', readOnly: true, placeholder: 'Select Date'),
          ),
        ),
      );

      await tester.tap(find.byType(VooFormButton));
      await tester.pumpAndSettle();

      // Date picker should not be shown
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('should call onChanged when date is selected', (WidgetTester tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', onChanged: (value) => selectedDate = value, placeholder: 'Select Date'),
          ),
        ),
      );

      // Open date picker
      await tester.tap(find.byType(VooFormButton));
      await tester.pumpAndSettle();

      // Select a date (15th of current month)
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      // Confirm selection
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(selectedDate, isNotNull);
      expect(selectedDate?.day, 15);
    });

    testWidgets('should hide field when isHidden is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', isHidden: true, placeholder: 'Select Date'),
          ),
        ),
      );

      expect(find.byType(VooDateFieldButton), findsOneWidget);
      expect(find.text('Select Date'), findsNothing);
      expect(find.byType(VooFormButton), findsNothing);
    });

    testWidgets('should display prefix icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select Date', prefixIcon: Icon(Icons.calendar_today)),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should display suffix icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select Date', suffixIcon: Icon(Icons.event)),
          ),
        ),
      );

      expect(find.byIcon(Icons.event), findsOneWidget);
    });

    testWidgets('should respect button type setting', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select Date', buttonType: ButtonType.filled),
          ),
        ),
      );

      final button = tester.widget<VooFormButton>(find.byType(VooFormButton));
      expect(button.type, ButtonType.filled);
    });

    testWidgets('should respect firstDate and lastDate constraints', (WidgetTester tester) async {
      final firstDate = DateTime(2020);
      final lastDate = DateTime(2025, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', placeholder: 'Select Date', firstDate: firstDate, lastDate: lastDate),
          ),
        ),
      );

      // Open date picker
      await tester.tap(find.byType(VooFormButton));
      await tester.pumpAndSettle();

      // Date picker should be shown with constraints
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should display value when provided', (WidgetTester tester) async {
      final dateValue = DateTime(2024, 6, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'test_date', initialValue: dateValue),
          ),
        ),
      );

      expect(find.text('2024-06-15'), findsOneWidget);
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(
              name: 'date',
              readOnly: true,
              onChanged: (date) {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Try to tap the date button
      await tester.tap(find.text('Select Date'));
      await tester.pumpAndSettle();

      // Should not open date picker
      expect(tapped, isFalse);
      expect(find.byType(CalendarDatePicker), findsNothing);
    });

    testWidgets('respects form-level readOnly', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormScope(
              isReadOnly: true,
              isLoading: false,
              child: VooDateFieldButton(
                name: 'date',
                onChanged: (date) {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // Try to tap the date button
      await tester.tap(find.text('Select Date'));
      await tester.pumpAndSettle();

      // Should not open date picker
      expect(tapped, isFalse);
      expect(find.byType(CalendarDatePicker), findsNothing);
    });

    testWidgets('displays initial value on button', (WidgetTester tester) async {
      final date = DateTime(2024, 12, 25);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'dateButton', initialValue: date),
          ),
        ),
      );

      // Date should be displayed on button
      expect(find.text('2024-12-25'), findsOneWidget);
    });

    testWidgets('displays placeholder when no initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'dateButton', placeholder: 'Pick a date'),
          ),
        ),
      );

      expect(find.text('Pick a date'), findsOneWidget);
    });

    testWidgets('button is disabled when readOnly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDateFieldButton(name: 'date', readOnly: true, initialValue: DateTime(2024)),
          ),
        ),
      );

      // Find the VooFormButton widget and check its enabled state
      final button = tester.widget<VooFormButton>(find.byType(VooFormButton));
      expect(button.enabled, isFalse);
    });
  });
}
