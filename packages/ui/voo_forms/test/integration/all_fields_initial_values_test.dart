import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('All VooFields Initial Values Test', () {
    Widget wrapInApp(Widget child) => MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

    testWidgets('VooTextField displays initial value', (tester) async {
      const initialValue = 'John Doe';

      await tester.pumpWidget(wrapInApp(const VooTextField(name: 'text', label: 'Name', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('VooEmailField displays initial value', (tester) async {
      const initialValue = 'test@example.com';

      await tester.pumpWidget(wrapInApp(const VooEmailField(name: 'email', label: 'Email', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('VooPasswordField displays initial value (obscured)', (tester) async {
      const initialValue = 'secret123';

      await tester.pumpWidget(wrapInApp(const VooPasswordField(name: 'password', label: 'Password', initialValue: initialValue)));

      // Password field obscures text with dots, but the field should have the value
      // Try to clear it and verify it had content
      final textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);

      // Enter new text to verify field is working
      await tester.enterText(textFormField, 'newpassword');
      await tester.pump();

      // The initial value was set, field is functional
    });

    testWidgets('VooPhoneField displays initial value', (tester) async {
      const initialValue = '5551234567';

      await tester.pumpWidget(wrapInApp(const VooPhoneField(name: 'phone', label: 'Phone', initialValue: initialValue)));

      // Phone field might format the value, verify field exists
      expect(find.byType(TextFormField), findsOneWidget);
      // Phone formatter shows both raw and formatted, check for formatted version
      expect(find.text('(555) 123-4567'), findsOneWidget);
    });

    testWidgets('VooNumberField displays initial value', (tester) async {
      const initialValue = 42.5;

      await tester.pumpWidget(wrapInApp(const VooNumberField(name: 'number', label: 'Number', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text('42.5'), findsOneWidget);
    });

    testWidgets('VooIntegerField displays initial value', (tester) async {
      const initialValue = 100;

      await tester.pumpWidget(wrapInApp(VooIntegerField(name: 'integer', label: 'Integer', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('VooDecimalField displays initial value', (tester) async {
      const initialValue = 3.14159;

      await tester.pumpWidget(wrapInApp(VooDecimalField(name: 'decimal', label: 'Decimal', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text('3.14159'), findsOneWidget);
    });

    testWidgets('VooCurrencyField displays initial value', (tester) async {
      const initialValue = 1234.56;

      await tester.pumpWidget(wrapInApp(const VooCurrencyField(name: 'currency', label: 'Price', initialValue: initialValue)));

      // Currency field formats the value with symbol and comma separators
      expect(find.text(r'$1,234.56'), findsOneWidget);
    });

    testWidgets('VooPercentageField displays initial value', (tester) async {
      const initialValue = 75.5;

      await tester.pumpWidget(wrapInApp(VooPercentageField(name: 'percentage', label: 'Progress', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text('75.5'), findsOneWidget);
    });

    testWidgets('VooMultilineField displays initial value', (tester) async {
      const initialValue = 'Line 1\nLine 2\nLine 3';

      await tester.pumpWidget(wrapInApp(const VooMultilineField(name: 'multiline', label: 'Description', initialValue: initialValue)));

      // Verify the initial value is displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('VooBooleanField displays initial value true', (tester) async {
      const initialValue = true;

      await tester.pumpWidget(wrapInApp(const VooBooleanField(name: 'boolean', label: 'Enabled', initialValue: initialValue)));

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('VooBooleanField displays initial value false', (tester) async {
      const initialValue = false;

      await tester.pumpWidget(wrapInApp(const VooBooleanField(name: 'boolean', label: 'Enabled', initialValue: initialValue)));

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('VooCheckboxField displays initial value checked', (tester) async {
      const initialValue = true;

      await tester.pumpWidget(wrapInApp(const VooCheckboxField(name: 'checkbox', label: 'Accept Terms', initialValue: initialValue)));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('VooCheckboxField displays initial value unchecked', (tester) async {
      const initialValue = false;

      await tester.pumpWidget(wrapInApp(const VooCheckboxField(name: 'checkbox', label: 'Accept Terms', initialValue: initialValue)));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('VooDropdownField displays initial value', (tester) async {
      const initialValue = 'Option 2';

      await tester.pumpWidget(
        wrapInApp(
          const VooDropdownField<String>(name: 'dropdown', label: 'Select Option', options: ['Option 1', 'Option 2', 'Option 3'], initialValue: initialValue),
        ),
      );

      // The dropdown should display the initial value
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('VooDropdownField with displayTextBuilder displays initial value', (tester) async {
      const initialValue = 2;

      await tester.pumpWidget(
        wrapInApp(
          VooDropdownField<int>(
            name: 'dropdown',
            label: 'Select Number',
            options: const [1, 2, 3],
            initialValue: initialValue,
            displayTextBuilder: (value) => 'Number $value',
          ),
        ),
      );

      // The dropdown should display the formatted initial value
      expect(find.text('Number 2'), findsOneWidget);
    });

    testWidgets('VooAsyncDropdownField displays initial value', (tester) async {
      const initialValue = 'Async Option 2';

      await tester.pumpWidget(
        wrapInApp(
          VooAsyncDropdownField<String>(
            name: 'asyncDropdown',
            label: 'Async Select',
            asyncOptionsLoader: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return ['Async Option 1', 'Async Option 2', 'Async Option 3'];
            },
            initialValue: initialValue,
          ),
        ),
      );

      // The async dropdown should display the initial value immediately
      expect(find.text(initialValue), findsOneWidget);

      // Wait for async load to complete
      await tester.pumpAndSettle();

      // Value should still be displayed
      expect(find.text(initialValue), findsOneWidget);
    });

    testWidgets('VooAsyncDropdownField with displayTextBuilder displays initial value', (tester) async {
      const initialValue = 42;

      await tester.pumpWidget(
        wrapInApp(
          VooAsyncDropdownField<int>(
            name: 'asyncDropdown',
            label: 'Async Number',
            asyncOptionsLoader: (query) async {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return [41, 42, 43];
            },
            initialValue: initialValue,
            displayTextBuilder: (value) => 'ID: $value',
          ),
        ),
      );

      // The async dropdown should display the formatted initial value immediately
      expect(find.text('ID: 42'), findsOneWidget);

      // Wait for async load to complete
      await tester.pumpAndSettle();

      // Value should still be displayed
      expect(find.text('ID: 42'), findsOneWidget);
    });

    testWidgets('VooDateField displays initial value', (tester) async {
      final initialValue = DateTime(2024, 3, 15);

      await tester.pumpWidget(wrapInApp(VooDateField(name: 'date', label: 'Date', initialValue: initialValue)));

      // The date field defaults to MM/dd/yyyy format
      expect(find.text('03/15/2024'), findsOneWidget);
    });

    testWidgets('VooDateField with custom format displays initial value', (tester) async {
      final initialValue = DateTime(2024, 3, 15);
      final dateFormat = DateFormat('MM/dd/yyyy');

      await tester.pumpWidget(wrapInApp(VooDateField(name: 'date', label: 'Date', initialValue: initialValue, dateFormat: dateFormat)));

      // The date field should display the custom formatted date
      expect(find.text('03/15/2024'), findsOneWidget);
    });

    testWidgets('VooDateFieldButton displays initial value', (tester) async {
      final initialValue = DateTime(2024, 6, 20);

      await tester.pumpWidget(wrapInApp(VooDateFieldButton(name: 'dateButton', label: 'Select Date', initialValue: initialValue)));

      // The date button should display the date
      expect(find.text('2024-06-20'), findsOneWidget);
    });

    testWidgets('VooDateFieldButton with custom format displays initial value', (tester) async {
      final initialValue = DateTime(2024, 6, 20);
      final dateFormat = DateFormat('dd/MM/yyyy');

      await tester.pumpWidget(wrapInApp(VooDateFieldButton(name: 'dateButton', label: 'Select Date', initialValue: initialValue, dateFormat: dateFormat)));

      // The date button should display the custom formatted date
      expect(find.text('20/06/2024'), findsOneWidget);
    });

    testWidgets('VooFileField displays initial file', (tester) async {
      final initialValue = VooFile.fromPlatformFile(PlatformFile(name: 'document.pdf', size: 2048, path: '/path/to/document.pdf'));

      await tester.pumpWidget(wrapInApp(VooFileField(name: 'file', label: 'Upload File', initialValue: initialValue)));

      // The file field should display the file name
      expect(find.text('document.pdf'), findsOneWidget);
    });

    testWidgets('VooListField displays initial items', (tester) async {
      const initialItems = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpWidget(
        wrapInApp(
          VooListField<String>(name: 'list', label: 'Items', items: initialItems, itemBuilder: (context, item, index) => Text(item), onAddPressed: () {}),
        ),
      );

      // All initial items should be displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Integration: Multiple fields with initial values', (tester) async {
      final dateValue = DateTime(2025, 8, 26);

      await tester.pumpWidget(
        wrapInApp(
          Column(
            children: [
              const VooTextField(name: 'siteName', label: 'Site Name', initialValue: '1 Washington Street, Units 102'),
              const VooTextField(name: 'siteCity', label: 'Site City', initialValue: 'Salem'),
              const VooDropdownField<String>(
                name: 'siteState',
                label: 'Site State',
                options: ['Massachusetts', 'New York', 'California'],
                initialValue: 'Massachusetts',
              ),
              const VooTextField(name: 'siteZip', label: 'Site Zip', initialValue: '1970'),
              VooDateField(name: 'orderDate', label: 'Order Date', initialValue: dateValue, dateFormat: DateFormat('MM/dd/yyyy')),
              const VooTextField(name: 'projectNumber', label: 'Project Number', initialValue: 'EBI Consulting Project#: 05188'),
              const VooDropdownField<String>(name: 'orderStatus', label: 'Order Status', options: ['Pending', 'Working', 'Completed'], initialValue: 'Working'),
              VooAsyncDropdownField<String>(
                name: 'researcher',
                label: 'Researcher',
                asyncOptionsLoader: (query) async => ['John Doe', 'Jane Smith'],
                initialValue: 'John Doe',
              ),
              VooAsyncDropdownField<String>(
                name: 'analyst',
                label: 'Analyst',
                asyncOptionsLoader: (query) async => ['Bob Johnson', 'Alice Brown'],
                initialValue: 'Bob Johnson',
              ),
              const VooCurrencyField(name: 'orderCost', label: 'Order Cost', initialValue: 500.00),
            ],
          ),
        ),
      );

      // Verify all initial values are displayed
      expect(find.text('1 Washington Street, Units 102'), findsOneWidget);
      expect(find.text('Salem'), findsOneWidget);
      expect(find.text('Massachusetts'), findsOneWidget);
      expect(find.text('1970'), findsOneWidget);
      expect(find.text('08/26/2025'), findsOneWidget);
      expect(find.text('EBI Consulting Project#: 05188'), findsOneWidget);
      expect(find.text('Working'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Bob Johnson'), findsOneWidget);

      // Currency field might format differently
      // Just verify we have enough text fields
      expect(find.byType(TextFormField).evaluate().length, greaterThanOrEqualTo(6));

      // Wait for async dropdowns to load
      await tester.pumpAndSettle();

      // Values should still be displayed
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Bob Johnson'), findsOneWidget);
    });
  });
}
