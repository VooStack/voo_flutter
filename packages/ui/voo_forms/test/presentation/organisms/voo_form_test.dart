import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_email_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_number_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form_extensions.dart';
import 'package:voo_forms/src/presentation/widgets/organisms/forms/voo_form_page_builder.dart';

void main() {
  group('VooForm', () {
    testWidgets('accepts field widgets directly', (WidgetTester tester) async {
      final fields = <VooFormFieldWidget>[
        const VooTextField(name: 'name', label: 'Name'),
        const VooEmailField(name: 'email', label: 'Email'),
        const VooNumberField(name: 'age', label: 'Age'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: fields,
            ),
          ),
        ),
      );

      // Verify all fields are rendered
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
    });

    testWidgets('applies spacing between fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              fields: [
                VooTextField(name: 'field1'),
                VooTextField(name: 'field2'),
              ],
            ),
          ),
        ),
      );

      // The form should render both text fields
      expect(find.byType(VooTextField), findsNWidgets(2));
      
      // Form widget should exist
      expect(find.byType(VooForm), findsOneWidget);
    });
  });

  group('VooFormPageBuilder', () {
    testWidgets('shows submit and cancel buttons when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: const VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              showCancelButton: true,
              submitText: 'Save',
              cancelText: 'Discard',
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
    });

    testWidgets('calls onSubmit with form values', (WidgetTester tester) async {
      bool submitCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: const VooForm(
                fields: [
                  VooTextField(
                    name: 'username',
                    label: 'Username',
                    initialValue: 'testuser',
                  ),
                ],
              ),
              onSubmit: (values) {
                submitCalled = true;
                expect(values, isNotNull);
              },
            ),
          ),
        ),
      );

      // Find and tap submit button
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(submitCalled, true);
    });

    testWidgets('shows header and footer when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              header: Text('Form Header'),
              footer: Text('Form Footer'),
            ),
          ),
        ),
      );

      expect(find.text('Form Header'), findsOneWidget);
      expect(find.text('Form Footer'), findsOneWidget);
    });

    testWidgets('shows progress indicator when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              showProgress: true,
            ),
          ),
        ),
      );

      // VooFormProgress is used now
      expect(find.byType(LinearProgressIndicator).evaluate().isNotEmpty, true);
    });

    testWidgets('disables editing when isEditable is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: VooForm(
                fields: [
                  VooTextField(name: 'test', label: 'Test Field'),
                ],
              ),
              isEditable: false,
            ),
          ),
        ),
      );

      // Form should be wrapped in AbsorbPointer when not editable
      final absorbers = tester.widgetList<AbsorbPointer>(find.byType(AbsorbPointer));
      expect(absorbers.any((a) => a.absorbing == true), true);
    });

    testWidgets('uses custom actions builder when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: const VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              actionsBuilder: (context, controller) => const Text('Custom Actions'),
            ),
          ),
        ),
      );

      expect(find.text('Custom Actions'), findsOneWidget);
      expect(find.text('Submit'), findsNothing); // Default submit should not show
    });

    testWidgets('applies padding when provided', (WidgetTester tester) async {
      const padding = EdgeInsets.all(20.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              padding: padding,
            ),
          ),
        ),
      );

      final paddingWidget = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(VooFormPageBuilder),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(paddingWidget.padding, padding);
    });

    testWidgets('handles onSuccess callback', (WidgetTester tester) async {
      bool successCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: const VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              onSubmit: (values) {},
              onSuccess: () {
                successCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(successCalled, true);
    });

    testWidgets('handles onError callback', (WidgetTester tester) async {
      dynamic capturedError;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: const VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              onSubmit: (values) {
                throw Exception('Test error');
              },
              onError: (error) {
                capturedError = error;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(capturedError, isNotNull);
      expect(capturedError.toString(), contains('Test error'));
    });

    testWidgets('wraps form in card when configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              form: VooForm(
                fields: [
                  VooTextField(name: 'test'),
                ],
              ),
              wrapInCard: true,
              cardElevation: 4.0,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4.0);
    });
  });

  group('VooFormExtension', () {
    testWidgets('creates simple form from field list', (WidgetTester tester) async {
      final form = [
        const VooTextField(name: 'name', label: 'Name'),
        const VooEmailField(name: 'email', label: 'Email'),
      ].toForm();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: form),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('creates form page from field list', (WidgetTester tester) async {
      final formPage = [
        const VooTextField(name: 'name', label: 'Name'),
        const VooEmailField(name: 'email', label: 'Email'),
      ].toFormPage(
        onSubmit: (values) {},
        submitText: 'Create',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: formPage),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isLoading: true,
              fields: [
                VooTextField(name: 'name', label: 'Name'),
                VooEmailField(name: 'email', label: 'Email'),
              ],
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Should NOT show form fields
      expect(find.text('Name'), findsNothing);
      expect(find.text('Email'), findsNothing);
    });

    testWidgets('shows custom loading widget when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isLoading: true,
              loadingWidget: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading form data...'),
                  ],
                ),
              ),
              fields: [
                VooTextField(name: 'name', label: 'Name'),
              ],
            ),
          ),
        ),
      );

      // Should show custom loading widget
      expect(find.text('Loading form data...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Should NOT show form fields
      expect(find.text('Name'), findsNothing);
    });

    testWidgets('shows form when isLoading is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooForm(
              isLoading: false,
              fields: [
                VooTextField(name: 'name', label: 'Name'),
                VooEmailField(name: 'email', label: 'Email'),
              ],
            ),
          ),
        ),
      );

      // Should NOT show loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // Should show form fields
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('transitions from loading to loaded state', (WidgetTester tester) async {
      bool isLoading = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  VooForm(
                    isLoading: isLoading,
                    fields: const [
                      VooTextField(name: 'name', label: 'Name'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text('Load Complete'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Name'), findsNothing);
      
      // Trigger state change
      await tester.tap(find.text('Load Complete'));
      await tester.pumpAndSettle();
      
      // Should now show form
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Name'), findsOneWidget);
    });
  });
}