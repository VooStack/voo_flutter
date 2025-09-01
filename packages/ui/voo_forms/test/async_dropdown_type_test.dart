import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

// Custom type similar to JurisdictionListOption
class JurisdictionListOption {
  final String id;
  final String name;
  final String code;

  const JurisdictionListOption({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JurisdictionListOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('Async Dropdown Type Safety', () {
    test('VooField.dropdownAsync with custom type should not throw type errors', () {
      JurisdictionListOption? selectedValue;
      
      // Create an async dropdown with strongly typed callback
      final field = VooField.dropdownAsync<JurisdictionListOption>(
        name: 'jurisdiction',
        label: 'Jurisdiction',
        asyncOptionsLoader: (query) async {
          // Simulate API call
          await Future.delayed(const Duration(milliseconds: 100));
          return [
            const JurisdictionListOption(id: '1', name: 'New York', code: 'NY'),
            const JurisdictionListOption(id: '2', name: 'California', code: 'CA'),
            const JurisdictionListOption(id: '3', name: 'Texas', code: 'TX'),
          ];
        },
        converter: (jurisdiction) => VooFieldOption(
          value: jurisdiction,
          label: jurisdiction.name,
          subtitle: jurisdiction.code,
        ),
        onChanged: (JurisdictionListOption? value) {
          // This strongly typed callback should not cause type errors
          selectedValue = value;
        },
      );

      // Verify the field was created successfully
      expect(field, isNotNull);
      expect(field.onChanged, isNotNull);
      
      // Simulate calling onChanged with a value
      final testValue = const JurisdictionListOption(id: '1', name: 'New York', code: 'NY');
      
      // This should not throw a type error
      expect(() {
        field.onChanged?.call(testValue);
      }, returnsNormally);
      
      expect(selectedValue, equals(testValue));
    });

    testWidgets('Async dropdown with custom type renders without type errors', 
        (WidgetTester tester) async {
      JurisdictionListOption? selectedValue;
      
      final field = VooField.dropdownAsync<JurisdictionListOption>(
        name: 'jurisdiction',
        label: 'Jurisdiction',
        asyncOptionsLoader: (query) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return [
            const JurisdictionListOption(id: '1', name: 'New York', code: 'NY'),
            const JurisdictionListOption(id: '2', name: 'California', code: 'CA'),
          ];
        },
        converter: (jurisdiction) => VooFieldOption(
          value: jurisdiction,
          label: jurisdiction.name,
          subtitle: jurisdiction.code,
        ),
        onChanged: (JurisdictionListOption? value) {
          selectedValue = value;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                const factory = FieldWidgetFactory();
                return factory.create(
                  context: context,
                  field: field,
                  options: const VooFieldOptions(),
                  onChanged: (dynamic value) {
                    // This should properly invoke the typed callback
                    if (value is JurisdictionListOption?) {
                      field.onChanged?.call(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      );

      // Should render without errors
      expect(find.text('Jurisdiction'), findsOneWidget);
      
      // Tap to open dropdown
      await tester.tap(find.text('Jurisdiction'));
      await tester.pump();
      
      // Wait for async loading
      await tester.pump(const Duration(milliseconds: 150));
      
      // Should show options without type errors
      expect(find.text('New York'), findsOneWidget);
      expect(find.text('California'), findsOneWidget);
    });

    test('Function.apply correctly handles strongly typed callbacks', () {
      // Test that Function.apply solution works
      JurisdictionListOption? result;
      
      void typedCallback(JurisdictionListOption? value) {
        result = value;
      }
      
      const testValue = JurisdictionListOption(id: '1', name: 'Test', code: 'TST');
      
      // This should work without type errors
      expect(() {
        Function.apply(typedCallback, [testValue]);
      }, returnsNormally);
      
      expect(result, equals(testValue));
      
      // Also test with null
      expect(() {
        Function.apply(typedCallback, [null]);
      }, returnsNormally);
      
      expect(result, isNull);
    });
  });
}