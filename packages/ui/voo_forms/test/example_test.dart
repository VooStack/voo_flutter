import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooForms Example Components', () {
    test('VooFormController initializes correctly', () {
      final form = VooFormUtils.createForm(
        id: 'test',
        title: 'Test Form',
        fields: [
          VooFieldUtils.textField(
            id: 'name',
            name: 'name',
            label: 'Name',
          ),
          VooFieldUtils.switchField(
            id: 'enabled',
            name: 'enabled',
            label: 'Enabled',
          ),
        ],
      );

      final controller = VooFormController(form: form);
      
      expect(controller.form.id, 'test');
      expect(controller.form.fields.length, 2);
      expect(controller.getValue('name'), null);
      expect(controller.getValue('enabled'), false);
    });

    test('VooValidator methods work correctly', () {
      // Required validator
      final required = VooValidator.required<String>();
      expect(required.validate(null), isNotNull);
      expect(required.validate(''), isNotNull);
      expect(required.validate('value'), isNull);

      // Email validator
      final email = VooValidator.email();
      expect(email.validate('invalid'), isNotNull);
      expect(email.validate('test@example.com'), isNull);

      // Min length validator
      final minLength = VooValidator.minLength(5);
      expect(minLength.validate('abc'), isNotNull);
      expect(minLength.validate('abcde'), isNull);

      // Alpha validator
      final alpha = VooValidator.alpha();
      expect(alpha.validate('123'), isNotNull);
      expect(alpha.validate('abc'), isNull);

      // Alphanumeric validator
      final alphanumeric = VooValidator.alphanumeric();
      expect(alphanumeric.validate('abc123'), isNull);
      expect(alphanumeric.validate('abc-123'), isNotNull);
    });

    test('VooFormatters work correctly', () {
      // Phone formatter
      final phoneFormatter = VooFormatters.phoneUS();
      final phoneResult = phoneFormatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '1234567890'),
      );
      expect(phoneResult.text, '(123) 456-7890');

      // Credit card formatter
      final cardFormatter = VooFormatters.creditCard();
      final cardResult = cardFormatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '1234567812345678'),
      );
      expect(cardResult.text, '1234 5678 1234 5678');

      // Postal code formatter
      final postalFormatter = VooFormatters.postalCodeUS();
      final postalResult = postalFormatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '123456789'),
      );
      expect(postalResult.text, '12345-6789');
    });

    testWidgets('Switch field renders correctly', (WidgetTester tester) async {
      final field = VooFieldUtils.switchField(
        id: 'switch',
        name: 'switch',
        label: 'Enable Feature',
        helper: 'Toggle to enable',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooSwitchFormField(
              field: field,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Enable Feature'), findsOneWidget);
      expect(find.text('Toggle to enable'), findsOneWidget);
    });

    test('FormStep creates correctly', () {
      final step = FormStep(
        title: 'Step 1',
        icon: Icons.person,
        fields: [
          VooFieldUtils.textField(
            id: 'field1',
            name: 'field1',
            label: 'Field 1',
          ),
        ],
      );

      expect(step.title, 'Step 1');
      expect(step.icon, Icons.person);
      expect(step.fields.length, 1);
    });

    test('VooFormUtils.createSteppedForm works', () {
      final form = VooFormUtils.createSteppedForm(
        id: 'wizard',
        title: 'Setup Wizard',
        steps: [
          FormStep(
            title: 'Step 1',
            icon: Icons.person,
            fields: [
              VooFieldUtils.textField(
                id: 'name',
                name: 'name',
                label: 'Name',
              ),
            ],
          ),
          FormStep(
            title: 'Step 2',
            icon: Icons.settings,
            fields: [
              VooFieldUtils.switchField(
                id: 'notifications',
                name: 'notifications',
                label: 'Enable Notifications',
              ),
            ],
          ),
        ],
      );

      expect(form.id, 'wizard');
      expect(form.title, 'Setup Wizard');
      expect(form.fields.length, 2);
      expect(form.sections?.length, 2);
      expect(form.layout, FormLayout.stepped);
    });
  });
}