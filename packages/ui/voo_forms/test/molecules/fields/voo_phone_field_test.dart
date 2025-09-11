import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/country_code.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooPhoneField', () {
    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('formats US phone numbers correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // Type phone number
      await tester.enterText(textField, '5551234567');
      await tester.pump();
      
      // Should be formatted as (555) 123-4567
      // Check that the TextFormField contains this value
      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(555) 123-4567');
    });

    testWidgets('shows country flag and dial code', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
            showDialCode: true,
          ),
        ),
      );

      // Should show US flag
      expect(find.text('🇺🇸'), findsOneWidget);
      
      // Should show US dial code
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('allows country selection when no default provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
          ),
        ),
      );

      // Should show dropdown arrow icon
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      
      // Default should be US
      expect(find.text('🇺🇸'), findsOneWidget);
      // Dial code is not shown by default (showDialCode: false)
    });

    testWidgets('opens country picker on tap', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
          ),
        ),
      );

      // Tap on the country selector
      await tester.tap(find.text('🇺🇸'));
      await tester.pumpAndSettle();
      
      // Should show country picker
      expect(find.text('Select Country'), findsOneWidget);
      
      // Should show various countries
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('changes country and updates formatting', (tester) async {
      CountryCode? selectedCountry;
      
      await tester.pumpWidget(
        buildTestWidget(
          VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            onCountryChanged: (country) => selectedCountry = country,
          ),
        ),
      );

      // Open country picker
      await tester.tap(find.text('🇺🇸'));
      await tester.pumpAndSettle();
      
      // Select UK
      await tester.tap(find.text('United Kingdom'));
      await tester.pumpAndSettle();
      
      // Should show UK flag (dial code not shown by default)
      expect(find.text('🇬🇧'), findsOneWidget);
      
      // Callback should have been called
      expect(selectedCountry?.isoCode, 'GB');
      
      // Type UK phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '7911123456');
      await tester.pump();
      
      // Should be formatted as UK number
      expect(find.text('7911 123456'), findsOneWidget);
    });

    testWidgets('handles onChanged callback with full number', (tester) async {
      String? lastValue;
      
      await tester.pumpWidget(
        buildTestWidget(
          VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
            showDialCode: true,
            onChanged: (value) => lastValue = value,
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Type phone number
      await tester.enterText(textField, '5551234567');
      await tester.pump();
      
      // Should include dial code in the value
      expect(lastValue, '+1 (555) 123-4567');
    });

    testWidgets('displays initial value correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
            initialValue: '(555) 123-4567',
          ),
        ),
      );

      // Should display the initial value
      final textField = find.byType(TextFormField);
      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.controller?.text, '(555) 123-4567');
    });

    testWidgets('handles read-only mode', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
            initialValue: '+1 (555) 123-4567',
            readOnly: true,
          ),
        ),
      );

      // Should show read-only field
      expect(find.text('+1 (555) 123-4567'), findsOneWidget);
      
      // Should show phone icon
      expect(find.byIcon(Icons.phone), findsOneWidget);
      
      // Should not show country selector in read-only mode
      expect(find.text('🇺🇸'), findsNothing);
    });

    testWidgets('validates phone number', (tester) async {
      final controller = VooFormController();
      
      await tester.pumpWidget(
        buildTestWidget(
          VooForm(
            controller: controller,
            fields: const [
              VooPhoneField(
                name: 'phone',
                label: 'Phone Number',
                defaultCountryCode: 'US',
                validators: [RequiredValidation<String>()],
              ),
            ],
          ),
        ),
      );

      // Validate empty field
      controller.validateField('phone', force: true);
      await tester.pump();
      
      // Should show error
      expect(find.text('This field is required'), findsOneWidget);
      
      // Type phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '5551234567');
      await tester.pump();
      
      // Error should be cleared
      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('formats different country numbers correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
          ),
        ),
      );

      // Select France
      await tester.tap(find.text('🇺🇸'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('France'));
      await tester.pumpAndSettle();
      
      // Type French phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '612345678');
      await tester.pump();
      
      // Should be formatted as French number
      expect(find.text('6 12 34 56 78'), findsOneWidget);
      
      // Select Japan
      await tester.tap(find.text('🇫🇷'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Japan'));
      await tester.pumpAndSettle();
      
      // Text should be cleared when country changes
      expect(find.text('6 12 34 56 78'), findsNothing);
      
      // Type Japanese phone number
      await tester.enterText(textField, '9012345678');
      await tester.pump();
      
      // Should be formatted as Japanese number
      expect(find.text('90-1234-5678'), findsOneWidget);
    }, skip: true);

    testWidgets('limits input to correct phone length', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'SG', // Singapore has 8 digit numbers
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      
      // Try to type more than 8 digits
      await tester.enterText(textField, '123456789');
      await tester.pump();
      
      // Should only show 8 digits formatted
      expect(find.text('9123 4567'), findsOneWidget);
    });

    testWidgets('does not allow country selection when default is set and allowCountrySelection is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VooPhoneField(
            name: 'phone',
            label: 'Phone Number',
            defaultCountryCode: 'US',
            allowCountrySelection: false,
          ),
        ),
      );

      // Should not show dropdown arrow
      expect(find.byIcon(Icons.arrow_drop_down), findsNothing);
      
      // Tap on country flag should not open picker
      await tester.tap(find.text('🇺🇸'));
      await tester.pumpAndSettle();
      
      // Should not show country picker
      expect(find.text('Select Country'), findsNothing);
    });

    testWidgets('integrates with VooFormController', (tester) async {
      final controller = VooFormController();
      
      await tester.pumpWidget(
        buildTestWidget(
          VooForm(
            controller: controller,
            fields: const [
              VooPhoneField(
                name: 'phone',
                label: 'Phone Number',
                defaultCountryCode: 'US',
                showDialCode: true,
              ),
            ],
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '5551234567');
      await tester.pump();
      
      // Controller should have the full phone number with dial code
      expect(controller.getValue('phone'), '+1 (555) 123-4567');
    });
  });
}