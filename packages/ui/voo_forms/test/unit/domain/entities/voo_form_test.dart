import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

/// Unit tests for VooForm entity
/// Tests business logic and domain layer following clean architecture
void main() {
  group('VooForm Entity Tests', () {
    test('Should create form with required fields', () {
      final form = VooForm(
        id: 'test_form',
        fields: [
          VooField.text(name: 'name', label: 'Name'),
          VooField.email(name: 'email', label: 'Email'),
        ],
      );

      expect(form.id, equals('test_form'));
      expect(form.fields.length, equals(2));
      expect(form.fields.first.name, equals('name'));
      expect(form.fields.last.name, equals('email'));
    });

    test('Should create form with sections', () {
      final form = VooForm(
        id: 'sectioned_form',
        fields: [
          VooField.text(name: 'firstName', label: 'First Name'),
          VooField.text(name: 'lastName', label: 'Last Name'),
          VooField.email(name: 'email', label: 'Email'),
          VooField.text(name: 'phone', label: 'Phone'),
        ],
        sections: const [
          VooFormSection(
            id: 'personal',
            title: 'Personal Info',
            fieldIds: ['firstName', 'lastName'],
          ),
          VooFormSection(
            id: 'contact',
            title: 'Contact Info',
            fieldIds: ['email', 'phone'],
          ),
        ],
      );

      expect(form.sections?.length, equals(2));
      expect(form.sections?.first.title, equals('Personal Info'));
      expect(form.sections?.last.title, equals('Contact Info'));
      expect(form.sections?.first.fieldIds, equals(['firstName', 'lastName']));
    });

    test('Should handle form configuration', () {
      const form = VooForm(
        id: 'configured_form',
        fields: [],
        layout: FormLayout.horizontal,
      );

      expect(form.layout, equals(FormLayout.horizontal));
      expect(form.validationMode, equals(FormValidationMode.onSubmit));
    });

    test('Should copy form with new values', () {
      final original = VooForm(
        id: 'original',
        fields: [
          VooField.text(name: 'field1', label: 'Field 1'),
        ],
      );

      final copied = original.copyWith(
        id: 'copied',
        fields: [
          VooField.text(name: 'field2', label: 'Field 2'),
        ],
      );

      expect(copied.id, equals('copied'));
      expect(copied.fields.length, equals(1));
      expect(copied.fields.first.name, equals('field2'));
      expect(original.id, equals('original')); // Original unchanged
    });

    test('Should track form state', () {
      final form = VooForm(
        id: 'state_form',
        fields: [
          VooField.text(name: 'username', label: 'Username'),
        ],
        values: const {'username': 'testuser'},
        errors: const {'username': 'Username is taken'},
        isValid: false,
        isDirty: true,
        isSubmitted: true,
      );

      expect(form.values['username'], equals('testuser'));
      expect(form.errors['username'], equals('Username is taken'));
      expect(form.isValid, isFalse);
      expect(form.isDirty, isTrue);
      expect(form.isSubmitting, isFalse);
      expect(form.isSubmitted, isTrue);
    });

    test('Should get field by id', () {
      final form = VooForm(
        id: 'field_access',
        fields: [
          VooField.text(name: 'field1', label: 'Field 1'),
          VooField.email(name: 'field2', label: 'Field 2'),
        ],
      );

      final field1 = form.getField('field1');
      final field2 = form.getField('field2');
      final nonExistent = form.getField('field3');

      expect(field1?.name, equals('field1'));
      expect(field2?.name, equals('field2'));
      expect(nonExistent, isNull);
    });

    test('Should get and check field values and errors', () {
      final form = VooForm(
        id: 'value_error_form',
        fields: [
          VooField.text(name: 'username', label: 'Username'),
          VooField.email(name: 'email', label: 'Email'),
        ],
        values: const {
          'username': 'john_doe',
          'email': 'john@example.com',
        },
        errors: const {
          'username': 'Username already taken',
        },
      );

      expect(form.getValue('username'), equals('john_doe'));
      expect(form.getValue('email'), equals('john@example.com'));
      expect(form.getValue('nonexistent'), isNull);

      expect(form.getError('username'), equals('Username already taken'));
      expect(form.getError('email'), isNull);

      expect(form.hasError('username'), isTrue);
      expect(form.hasError('email'), isFalse);
    });

    test('Should validate form structure', () {
      // Form with duplicate field names should be allowed
      // The form itself doesn't enforce uniqueness, that's up to the consumer
      final form = VooForm(
        id: 'duplicate_form',
        fields: [
          VooField.text(name: 'duplicate', label: 'Field 1'),
          VooField.email(name: 'duplicate', label: 'Field 2'),
        ],
      );

      // Check for duplicate field names
      final fieldNames = form.fields.map((f) => f.name).toList();
      final uniqueNames = fieldNames.toSet();
      
      expect(uniqueNames.length < fieldNames.length, isTrue);
    });

    test('Should convert form data to JSON', () {
      final form = VooForm(
        id: 'json_form',
        fields: [
          VooField.text(name: 'firstName', label: 'First Name'),
          VooField.text(name: 'lastName', label: 'Last Name'),
          VooField.number(name: 'age', label: 'Age'),
        ],
        values: const {
          'firstName': 'John',
          'lastName': 'Doe',
          'age': 30,
        },
      );

      final json = form.toJson();

      expect(json['firstName'], equals('John'));
      expect(json['lastName'], equals('Doe'));
      expect(json['age'], equals(30));
    });

    test('Should handle form metadata', () {
      const form = VooForm(
        id: 'metadata_form',
        fields: [],
        metadata: {
          'version': '1.0.0',
          'createdBy': 'admin',
          'tags': ['important', 'urgent'],
        },
      );

      expect(form.metadata?['version'], equals('1.0.0'));
      expect(form.metadata?['createdBy'], equals('admin'));
      expect(form.metadata?['tags'], isA<List>());
    });

    test('Should handle form layouts', () {
      final layouts = [
        FormLayout.vertical,
        FormLayout.horizontal,
        FormLayout.grid,
        FormLayout.stepped,
        FormLayout.tabbed,
      ];

      for (final layout in layouts) {
        final form = VooForm(
          id: 'layout_test',
          fields: const [],
          layout: layout,
        );
        
        expect(form.layout, equals(layout));
        expect(layout.label, isNotEmpty);
      }
    });

    test('Should handle validation modes', () {
      final modes = [
        FormValidationMode.onSubmit,
        FormValidationMode.onChange,
        FormValidationMode.onBlur,
        FormValidationMode.manual,
      ];

      for (final mode in modes) {
        final form = VooForm(
          id: 'validation_mode_test',
          fields: const [],
          validationMode: mode,
        );
        
        expect(form.validationMode, equals(mode));
      }
    });

    test('Should track enabled and readOnly states', () {
      const form = VooForm(
        id: 'state_test',
        fields: [],
        enabled: false,
        readOnly: true,
      );

      expect(form.enabled, isFalse);
      expect(form.readOnly, isTrue);

      final copiedForm = form.copyWith(
        enabled: true,
        readOnly: false,
      );

      expect(copiedForm.enabled, isTrue);
      expect(copiedForm.readOnly, isFalse);
    });
  });
}