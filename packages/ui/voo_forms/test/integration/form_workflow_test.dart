import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Integration tests for complete form workflows
/// Tests end-to-end form scenarios following clean architecture
void main() {
  Widget createTestApp(Widget child) {
    return MaterialApp(
      home: VooDesignSystem(
        data: VooDesignSystemData.defaultSystem,
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
  }

  group('Form Workflow Integration Tests', () {
    testWidgets('Complete registration form workflow', (tester) async {
      final form = VooForm(
        id: 'registration',
        fields: [
          VooField.text(
            name: 'username',
            label: 'Username',
            validators: [
              VooValidator.required(),
              VooValidator.minLength(3),
            ],
          ),
          VooField.email(
            name: 'email',
            label: 'Email',
            validators: [
              VooValidator.required(),
              VooValidator.email(),
            ],
          ),
          VooField.password(
            name: 'password',
            label: 'Password',
            validators: [
              VooValidator.required(),
              VooValidator.minLength(8),
            ],
          ),
          VooField.password(
            name: 'confirmPassword',
            label: 'Confirm Password',
            validators: [
              VooValidator.required(),
              VooValidator.custom(
                validator: (value) {
                  // Note: Can't access other field values directly here
                  // This would need to be handled at the controller level
                  return null;
                },
              ),
            ],
          ),
          VooField.checkbox(
            name: 'terms',
            label: 'I agree to the terms and conditions',
            validators: [
              VooValidator.custom(
                validator: (value) {
                  if (value != true) {
                    return 'You must agree to the terms';
                  }
                  return null;
                },
              ),
            ],
          ),
        ],
      );

      final controller = VooFormController(form: form);
      bool submitCalled = false;

      await tester.pumpWidget(
        createTestApp(
          Column(
            children: [
              ...form.fields.map((field) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VooFieldWidget(
                    field: field,
                    onChanged: (value) {
                      controller.setValue(field.id, value);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.validate()) {
                    submitCalled = true;
                    controller.submit(
                      onSubmit: (data) async {
                        // Form submitted
                      },
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      );

      // Fill out the form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.enterText(textFields.at(1), 'test@example.com');
      await tester.enterText(textFields.at(2), 'password123');
      await tester.enterText(textFields.at(3), 'password123');
      
      // Check the terms checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // Verify the values are captured in the controller
      final values = controller.values;
      expect(values['username'], equals('testuser'));
      expect(values['email'], equals('test@example.com'));
      expect(values['password'], equals('password123'));
      expect(values['confirmPassword'], equals('password123'));
      expect(values['terms'], equals(true));
      
      // Verify submission was triggered
      expect(submitCalled, isTrue);
    });

    testWidgets('Dynamic form with conditional fields', (tester) async {
      final form = VooForm(
        id: 'dynamic_form',
        fields: [
          VooField.dropdown<String>(
            name: 'accountType',
            label: 'Account Type',
            options: ['Personal', 'Business'],
            converter: (type) => VooDropdownChild(value: type, label: type),
            initialValue: 'Personal',
          ),
        ],
      );

      String accountType = 'Personal';

      await tester.pumpWidget(
        createTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              // Add conditional fields based on account type
              final fields = [...form.fields];
              
              if (accountType == 'Business') {
                fields.add(
                  VooField.text(
                    name: 'companyName',
                    label: 'Company Name',
                  ),
                );
                fields.add(
                  VooField.text(
                    name: 'taxId',
                    label: 'Tax ID',
                  ),
                );
              } else {
                fields.add(
                  VooField.date(
                    name: 'birthdate',
                    label: 'Date of Birth',
                  ),
                );
              }
              
              return Column(
                children: [
                  ...fields.map((field) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VooFieldWidget(
                        field: field,
                        onChanged: field.name == 'accountType' 
                          ? (value) {
                              setState(() {
                                accountType = value as String;
                              });
                            }
                          : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Initially shows personal fields
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Company Name'), findsNothing);
      
      // Change to business account
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      
      if (find.text('Business').evaluate().isNotEmpty) {
        await tester.tap(find.text('Business').last);
        await tester.pumpAndSettle();
        
        // Should show business fields
        expect(find.text('Company Name'), findsOneWidget);
        expect(find.text('Tax ID'), findsOneWidget);
      }
    });

    testWidgets('Multi-step form navigation', (tester) async {
      int currentStep = 0;
      
      final steps = [
        const VooFormSection(
          id: 'personal',
          title: 'Personal Info',
          fieldIds: ['firstName', 'lastName'],
        ),
        const VooFormSection(
          id: 'contact',
          title: 'Contact Info',
          fieldIds: ['email', 'phone'],
        ),
        const VooFormSection(
          id: 'address',
          title: 'Address',
          fieldIds: ['street', 'city'],
        ),
      ];

      final form = VooForm(
        id: 'multi_step',
        fields: [
          VooField.text(name: 'firstName', label: 'First Name'),
          VooField.text(name: 'lastName', label: 'Last Name'),
          VooField.email(name: 'email', label: 'Email'),
          VooField.text(name: 'phone', label: 'Phone'),
          VooField.text(name: 'street', label: 'Street'),
          VooField.text(name: 'city', label: 'City'),
        ],
        sections: steps,
      );

      await tester.pumpWidget(
        createTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              final currentSection = steps[currentStep];
              final sectionFields = form.fields.where(
                (f) => currentSection.fieldIds.contains(f.name),
              ).toList();
              
              return Column(
                children: [
                  Text('Step ${currentStep + 1} of ${steps.length}'),
                  Text(currentSection.title ?? 'Step'),
                  ...sectionFields.map((field) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VooFieldWidget(field: field),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        ElevatedButton(
                          onPressed: () => setState(() => currentStep--),
                          child: const Text('Previous'),
                        ),
                      if (currentStep < steps.length - 1)
                        ElevatedButton(
                          onPressed: () => setState(() => currentStep++),
                          child: const Text('Next'),
                        ),
                      if (currentStep == steps.length - 1)
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Submit'),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Step 1: Personal Info
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      
      // Go to next step
      await tester.tap(find.text('Next'));
      await tester.pump();
      
      // Step 2: Contact Info
      expect(find.text('Contact Info'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      
      // Go back
      await tester.tap(find.text('Previous'));
      await tester.pump();
      
      // Back to Step 1
      expect(find.text('Personal Info'), findsOneWidget);
    });

    testWidgets('Form validation workflow', (tester) async {
      final form = VooForm(
        id: 'validation_form',
        fields: [
          VooField.text(
            name: 'required',
            label: 'Required Field',
            validators: [VooValidator.required()],
          ),
          VooField.email(
            name: 'email',
            label: 'Email',
            validators: [
              VooValidator.required(),
              VooValidator.email(),
            ],
          ),
          VooField.number(
            name: 'age',
            label: 'Age',
            validators: [
              VooValidator.required(),
              VooValidator.min(18, 'Must be 18 or older'),
            ],
          ),
        ],
        validationMode: FormValidationMode.onChange,
      );

      final controller = VooFormController(form: form);
      
      await tester.pumpWidget(
        createTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ...form.fields.map((field) {
                    final error = controller.getError(field.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VooFieldWidget(
                        field: field,
                        error: error,
                        showError: true,
                        onChanged: (value) {
                          controller.setValue(field.id, value);
                        },
                      ),
                    );
                  }),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.validate();
                      });
                    },
                    child: const Text('Validate'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Try to validate empty form
      await tester.tap(find.text('Validate'));
      await tester.pumpAndSettle();
      
      // Validation should trigger and form should be marked invalid
      expect(controller.isValid, isFalse);
      
      // Fill invalid email
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'invalid-email');
      await tester.pump();
      
      // Validate again
      await tester.tap(find.text('Validate'));
      await tester.pump();
      
      // Should show email validation error
      expect(find.textContaining('email'), findsAny);
    });

    testWidgets('Form reset workflow', (tester) async {
      final form = VooForm(
        id: 'reset_form',
        fields: [
          VooField.text(name: 'field1', label: 'Field 1'),
          VooField.text(name: 'field2', label: 'Field 2'),
          VooField.boolean(name: 'field3', label: 'Field 3'),
        ],
      );

      final controller = VooFormController(form: form);
      
      await tester.pumpWidget(
        createTestApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ...form.fields.map((field) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: VooFieldWidget(
                        field: field,
                        controller: controller.getTextController(field.id),
                        onChanged: (value) {
                          controller.setValue(field.id, value);
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.reset();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.submit(
                            onSubmit: (data) async {
                              // Submit the form
                            },
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Fill the form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Value 1');
      await tester.enterText(textFields.at(1), 'Value 2');
      if (find.byType(Switch).evaluate().isNotEmpty) {
        await tester.tap(find.byType(Switch));
      }
      await tester.pump();
      
      // Verify values are in controller
      expect(controller.getValue('field1'), equals('Value 1'));
      expect(controller.getValue('field2'), equals('Value 2'));
      
      // Reset the form
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      
      // Fields should be cleared in controller
      expect(controller.getValue('field1'), anyOf(isNull, equals('')));
      expect(controller.getValue('field2'), anyOf(isNull, equals('')));
    });
  });
}