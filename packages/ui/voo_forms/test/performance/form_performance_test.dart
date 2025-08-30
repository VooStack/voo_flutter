import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

/// Performance tests for form operations
/// Tests form rendering and validation performance
void main() {
  group('Form Performance Tests', () {
    test('Should handle large forms efficiently', () {
      final stopwatch = Stopwatch()..start();
      
      // Create a large form with many fields
      final fields = List.generate(100, (index) => 
        VooField.text(
          name: 'field_$index',
          label: 'Field $index',
          validators: [
            VooValidator.required(),
            VooValidator.minLength(3),
          ],
        ),
      );
      
      final form = VooForm(
        id: 'large_form',
        fields: fields,
      );
      
      stopwatch.stop();
      
      // Form creation should be fast
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(form.fields.length, equals(100));
    });
    
    test('Should validate large forms quickly', () {
      final fields = List.generate(50, (index) => 
        VooField.text(
          name: 'field_$index',
          label: 'Field $index',
          validators: [
            VooValidator.required(),
            VooValidator.minLength(5),
            VooValidator.maxLength(100),
          ],
        ),
      );
      
      final form = VooForm(
        id: 'validation_perf',
        fields: fields,
      );
      
      final controller = VooFormController(form: form);
      
      // Set valid values for all fields
      for (final field in fields) {
        controller.setValue(field.id, 'valid_value');
      }
      
      final stopwatch = Stopwatch()..start();
      
      // Validate all fields
      final isValid = controller.validate();
      
      stopwatch.stop();
      
      // Validation should be fast even with many fields
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
      expect(isValid, isTrue);
    });
    
    test('Should handle rapid field updates efficiently', () {
      final controller = VooFormController(
        form: VooForm(
          id: 'update_perf',
          fields: [
            VooField.text(name: 'field1', label: 'Field 1'),
            VooField.text(name: 'field2', label: 'Field 2'),
          ],
        ),
      );
      
      final stopwatch = Stopwatch()..start();
      
      // Perform many rapid updates
      for (int i = 0; i < 1000; i++) {
        controller.setValue('field1', 'value_$i');
      }
      
      stopwatch.stop();
      
      // Should handle rapid updates efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(controller.getValue('field1'), equals('value_999'));
    });
    
    test('Should efficiently convert form to JSON', () {
      final values = Map.fromEntries(
        List.generate(100, (i) => MapEntry('field_$i', 'value_$i')),
      );
      
      final form = VooForm(
        id: 'json_perf',
        fields: List.generate(100, (i) => 
          VooField.text(name: 'field_$i', label: 'Field $i'),
        ),
        values: values,
      );
      
      final stopwatch = Stopwatch()..start();
      
      final json = form.toJson();
      
      stopwatch.stop();
      
      // JSON conversion should be fast
      expect(stopwatch.elapsedMilliseconds, lessThan(10));
      expect(json.length, equals(100));
    });
    
    test('Should handle deep form sections efficiently', () {
      final sections = List.generate(20, (i) => 
        VooFormSection(
          id: 'section_$i',
          title: 'Section $i',
          fieldIds: List.generate(5, (j) => 'field_${i * 5 + j}'),
        ),
      );
      
      final fields = List.generate(100, (i) => 
        VooField.text(name: 'field_$i', label: 'Field $i'),
      );
      
      final stopwatch = Stopwatch()..start();
      
      final form = VooForm(
        id: 'section_perf',
        fields: fields,
        sections: sections,
      );
      
      // Access fields through sections
      for (final section in sections) {
        for (final fieldId in section.fieldIds) {
          form.getField(fieldId);
        }
      }
      
      stopwatch.stop();
      
      // Field access should be efficient
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
    
    test('Should efficiently handle validator chains', () {
      final validator = VooValidator.all([
        VooValidator.required(),
        VooValidator.minLength(5),
        VooValidator.maxLength(100),
        VooValidator.pattern(r'^[a-zA-Z0-9]+$', 'Alphanumeric only'),
        VooValidator.custom<String>(
          validator: (value) {
            if (value?.contains('test') == true) {
              return 'Cannot contain "test"';
            }
            return null;
          },
        ),
      ]);
      
      final stopwatch = Stopwatch()..start();
      
      // Run validator many times
      for (int i = 0; i < 1000; i++) {
        validator.validate('valid_value_$i');
      }
      
      stopwatch.stop();
      
      // Validator chain should be efficient
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
  
  group('Memory Efficiency Tests', () {
    test('Should not leak memory with controller disposal', () {
      final controllers = <VooFormController>[];
      
      // Create many controllers
      for (int i = 0; i < 100; i++) {
        controllers.add(
          VooFormController(
            form: VooForm(
              id: 'form_$i',
              fields: [
                VooField.text(name: 'field', label: 'Field'),
              ],
            ),
          ),
        );
      }
      
      // Dispose all controllers
      for (final controller in controllers) {
        controller.dispose();
      }
      
      // Test passes if no memory leaks occur
      expect(controllers.length, equals(100));
    });
    
    test('Should efficiently copy forms', () {
      final original = VooForm(
        id: 'original',
        fields: List.generate(50, (i) => 
          VooField.text(name: 'field_$i', label: 'Field $i'),
        ),
        values: Map.fromEntries(
          List.generate(50, (i) => MapEntry('field_$i', 'value_$i')),
        ),
      );
      
      final stopwatch = Stopwatch()..start();
      
      // Make many copies
      final copies = <VooForm>[];
      for (int i = 0; i < 100; i++) {
        copies.add(
          original.copyWith(
            id: 'copy_$i',
            isDirty: true,
          ),
        );
      }
      
      stopwatch.stop();
      
      // Copying should be efficient
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
      expect(copies.length, equals(100));
      expect(copies.first.fields.length, equals(50));
    });
  });
}