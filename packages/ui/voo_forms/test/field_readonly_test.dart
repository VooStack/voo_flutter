import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

void main() {
  group('Field-level readOnly Support', () {
    testWidgets('Field respects its own readOnly property when form is editable', 
        (WidgetTester tester) async {
      // Create a field that is marked as readOnly
      final readOnlyField = VooField.text(
        name: 'username',
        label: 'Username',
        initialValue: 'john_doe',
        readOnly: true, // Field is read-only
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: readOnlyField,
                  options: const VooFieldOptions(),
                  isEditable: true, // Form is editable
                );
              },
            ),
          ),
        ),
      );

      // The field should display as read-only even though form is editable
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('john_doe'), findsOneWidget);
      // Should not find TextFormField since it's read-only
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('Editable field remains editable when form is editable', 
        (WidgetTester tester) async {
      // Create a field that is NOT marked as readOnly
      final editableField = VooField.text(
        name: 'email',
        label: 'Email',
        initialValue: 'test@example.com',
        readOnly: false, // Field is editable
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: editableField,
                  options: const VooFieldOptions(),
                  isEditable: true, // Form is editable
                );
              },
            ),
          ),
        ),
      );

      // The field should be editable
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('All fields become read-only when form is not editable', 
        (WidgetTester tester) async {
      // Create a field that is NOT marked as readOnly
      final editableField = VooField.text(
        name: 'password',
        label: 'Password',
        initialValue: 'secret123',
        readOnly: false, // Field is editable
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: editableField,
                  options: const VooFieldOptions(),
                  isEditable: false, // Form is NOT editable
                );
              },
            ),
          ),
        ),
      );

      // The field should display as read-only because form is not editable
      expect(find.text('Password'), findsOneWidget);
      // Should not find TextFormField since form is not editable
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('Mixed form with some read-only and some editable fields', 
        (WidgetTester tester) async {
      // Create fields with different readOnly states
      final idField = VooField.text(
        name: 'id',
        label: 'ID',
        initialValue: '12345',
        readOnly: true, // Read-only field (auto-generated)
      );

      final nameField = VooField.text(
        name: 'name',
        label: 'Name',
        initialValue: 'John Doe',
        readOnly: false, // Editable field
      );

      final createdAtField = VooField.text(
        name: 'createdAt',
        label: 'Created At',
        initialValue: '2025-01-01',
        readOnly: true, // Read-only field (system-generated)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Builder(
                  builder: (context) {
                    const factory = FieldWidgetFactory();
                    return factory.create(
                      context: context,
                      field: idField,
                      options: const VooFieldOptions(),
                      isEditable: true, // Form is editable
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    const factory = FieldWidgetFactory();
                    return factory.create(
                      context: context,
                      field: nameField,
                      options: const VooFieldOptions(),
                      isEditable: true, // Form is editable
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    const factory = FieldWidgetFactory();
                    return factory.create(
                      context: context,
                      field: createdAtField,
                      options: const VooFieldOptions(),
                      isEditable: true, // Form is editable
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // ID field should be read-only
      expect(find.text('12345'), findsOneWidget);
      
      // Name field should be editable (has TextFormField)
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Created At field should be read-only
      expect(find.text('2025-01-01'), findsOneWidget);
    });

    test('Field readOnly property is preserved through copyWith', () {
      final field = VooField.text(
        name: 'test',
        readOnly: true,
      );

      // readOnly should be preserved
      expect(field.readOnly, isTrue);

      // copyWith should preserve readOnly
      final copiedField = field.copyWith(label: 'Test Label');
      expect(copiedField.readOnly, isTrue);

      // Should be able to change readOnly with copyWith
      final editableField = field.copyWith(readOnly: false);
      expect(editableField.readOnly, isFalse);
    });
  });
}