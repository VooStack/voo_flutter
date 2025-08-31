import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

/// Comprehensive test suite to validate type safety and callback compatibility
/// for all form field types. This addresses the user-reported issue:
/// TypeError: Instance of '(String?) => void': type '(String?) => void' 
/// is not a subtype of type '((dynamic) => void)?'
void main() {
  group('Type Compatibility Tests', () {
    group('Callback Type Conversion', () {
      test('Text field should accept String callbacks', () {
        // This test validates that a text field can accept a String-typed callback
        // and that the type system handles it correctly
        String? capturedValue;
        void onStringChanged(String? value) {
          capturedValue = value;
        }

        final field = VooFormField(
          id: 'test',
          name: 'test',
          type: VooFieldType.text,
          onChanged: onStringChanged,
        );

        // Verify the callback is stored correctly
        expect(field.onChanged, isNotNull);
        field.onChanged?.call('test');
        expect(capturedValue, equals('test'));
      });

      test('Dynamic callbacks should work with all field types', () {
        // Test that a generic dynamic callback works with different field types
        final capturedValues = <String, dynamic>{};
        void onDynamicChanged(dynamic value) {
          capturedValues['last'] = value;
        }

        final textField = VooFormField(
          id: 'text',
          name: 'text',
          type: VooFieldType.text,
          onChanged: onDynamicChanged,
        );

        final numberField = VooFormField(
          id: 'number',
          name: 'number',
          type: VooFieldType.number,
          onChanged: onDynamicChanged,
        );

        final boolField = VooFormField(
          id: 'bool',
          name: 'bool',
          type: VooFieldType.boolean,
          onChanged: onDynamicChanged,
        );

        // Test all callbacks work
        textField.onChanged?.call('string');
        expect(capturedValues['last'], equals('string'));
        
        numberField.onChanged?.call(42);
        expect(capturedValues['last'], equals(42));
        
        boolField.onChanged?.call(true);
        expect(capturedValues['last'], equals(true));
      });
    });

    group('Widget Callback Integration', () {
      testWidgets('VooFieldWidget should handle typed callbacks correctly', (tester) async {
        // This test simulates the actual issue users are experiencing
        String? capturedStringValue;
        dynamic capturedDynamicValue;

        // Create a string-typed callback
        void onStringChanged(String? value) {
          capturedStringValue = value;
        }

        // Create a dynamic-typed callback
        void onDynamicChanged(dynamic value) {
          capturedDynamicValue = value;
        }

        // Test with a text field using string callback
        const stringField = VooFormField<String>(
          id: 'string_field',
          name: 'string_field',
          type: VooFieldType.text,
          label: 'String Field',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // This should work without type errors
                  VooFieldWidget(
                    field: stringField,
                    onChanged: (value) {
                      // Cast to String? should be safe for text fields
                      onStringChanged(value as String?);
                    },
                  ),
                  // This should also work
                  VooFieldWidget(
                    field: stringField,
                    onChanged: onDynamicChanged,
                  ),
                ],
              ),
            ),
          ),
        );

        // Verify the widgets render without errors
        expect(find.byType(VooFieldWidget), findsNWidgets(2));
        
        // Test text input and verify callbacks are invoked
        await tester.enterText(find.byType(TextFormField).first, 'test input');
        await tester.pump();
        expect(capturedStringValue, equals('test input'));
        
        await tester.enterText(find.byType(TextFormField).last, 'test input');
        await tester.pump();
        expect(capturedDynamicValue, equals('test input'));
      });

      testWidgets('Mixed type callbacks should not cause runtime errors', (tester) async {
        // Test that mixing different callback types doesn't cause issues
        final results = <String, dynamic>{};

        final fields = [
          const VooFormField<String>(
            id: 'text',
            name: 'text',
            type: VooFieldType.text,
            label: 'Text',
          ),
          const VooFormField<num>(
            id: 'number',
            name: 'number',
            type: VooFieldType.number,
            label: 'Number',
          ),
          const VooFormField<bool>(
            id: 'bool',
            name: 'bool',
            type: VooFieldType.boolean,
            label: 'Boolean',
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: fields.map((field) => VooFieldWidget(
                    field: field,
                    onChanged: (value) {
                      // This should handle any type
                      results[field.id] = value;
                    },
                  ),).toList(),
              ),
            ),
          ),
        );

        // Verify all widgets render
        expect(find.byType(VooFieldWidget), findsNWidgets(3));
      });
    });

    group('Generic Type Preservation', () {
      test('Generic field types should be preserved', () {
        // Test that generic types are maintained throughout the field lifecycle
        String? capturedString;
        int? capturedInt;
        
        final stringField = VooFormField<String>(
          id: 'string',
          name: 'string',
          type: VooFieldType.text,
          value: 'initial',
          onChanged: (String? value) {
            capturedString = value;
            expect(value, isA<String?>());
          },
        );

        final intField = VooFormField<int>(
          id: 'int',
          name: 'int',
          type: VooFieldType.number,
          value: 42,
          onChanged: (int? value) {
            capturedInt = value;
            expect(value, isA<int?>());
          },
        );

        // Invoke callbacks to test type preservation
        stringField.onChanged?.call('test');
        expect(capturedString, equals('test'));
        
        intField.onChanged?.call(100);
        expect(capturedInt, equals(100));
      });

      test('Option types should match field types', () {
        // Test that dropdown options maintain consistent types
        String? capturedValue;
        
        final stringDropdown = VooFormField<String>(
          id: 'dropdown',
          name: 'dropdown',
          type: VooFieldType.dropdown,
          value: 'option1',
          options: const [
            VooFieldOption<String>(value: 'option1', label: 'Option 1'),
            VooFieldOption<String>(value: 'option2', label: 'Option 2'),
          ],
          onChanged: (String? value) {
            capturedValue = value;
            expect(value, anyOf(isNull, isA<String>()));
          },
        );

        // Test the callback
        stringDropdown.onChanged?.call('option2');
        expect(capturedValue, equals('option2'));
        
        stringDropdown.onChanged?.call(null);
        expect(capturedValue, isNull);
      });
    });

    group('Async Dropdown Tests', () {
      test('Async dropdown should accept loader function', () {
        // Test that async dropdowns can be created with loader functions
        Future<List<VooFieldOption<String>>> loadOptions(String query) async {
          await Future<List<VooFieldOption<String>>>.delayed(const Duration(milliseconds: 100));
          return [
            const VooFieldOption<String>(value: 'async1', label: 'Async Option 1'),
            const VooFieldOption<String>(value: 'async2', label: 'Async Option 2'),
          ];
        }

        final asyncDropdown = VooFormField<String>(
          id: 'async_dropdown',
          name: 'async_dropdown',
          type: VooFieldType.dropdown,
          asyncOptionsLoader: loadOptions,
          enableSearch: true,
          searchHint: 'Search options...',
          searchDebounce: const Duration(milliseconds: 300),
          minSearchLength: 2,
        );

        expect(asyncDropdown.asyncOptionsLoader, isNotNull);
        expect(asyncDropdown.enableSearch, isTrue);
        expect(asyncDropdown.searchHint, equals('Search options...'));
        expect(asyncDropdown.searchDebounce, equals(const Duration(milliseconds: 300)));
        expect(asyncDropdown.minSearchLength, equals(2));
      });

      test('Async dropdown loader should return correct types', () async {
        // Test that the async loader returns the expected option types
        
        Future<List<VooFieldOption<String>>> loadOptions(String query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          final options = [
            const VooFieldOption<String>(value: 'user1', label: 'User 1'),
            const VooFieldOption<String>(value: 'user2', label: 'User 2'),
            const VooFieldOption<String>(value: 'user3', label: 'User 3'),
          ];
          
          if (query.isNotEmpty) {
            return options.where((opt) => 
              opt.label.toLowerCase().contains(query.toLowerCase()),
            ).toList();
          }
          
          return options;
        }

        final asyncDropdown = VooFormField<String>(
          id: 'async_dropdown',
          name: 'async_dropdown',
          type: VooFieldType.dropdown,
          asyncOptionsLoader: loadOptions,
        );

        // Test loading all options
        final allOptions = await asyncDropdown.asyncOptionsLoader!('');
        expect(allOptions.length, equals(3));
        expect(allOptions.first.value, equals('user1'));
        
        // Test filtered options
        final filteredOptions = await asyncDropdown.asyncOptionsLoader!('User 2');
        expect(filteredOptions.length, equals(1));
        expect(filteredOptions.first.value, equals('user2'));
      });

      testWidgets('Async dropdown widget should handle loading state', (tester) async {
        // Test that async dropdown widgets properly handle loading states
        await tester.runAsync(() async {
          Future<List<VooFieldOption<String>>> loadOptions(String query) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return [
              const VooFieldOption<String>(value: 'option1', label: 'Option 1'),
              const VooFieldOption<String>(value: 'option2', label: 'Option 2'),
            ];
          }

          final asyncDropdown = VooFormField<String>(
            id: 'async_dropdown',
            name: 'async_dropdown',
            type: VooFieldType.dropdown,
            label: 'Async Dropdown',
            asyncOptionsLoader: loadOptions,
            enableSearch: true,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: VooFieldWidget(
                  field: asyncDropdown,
                  onChanged: (value) {}, // Callback for testing widget renders
                ),
              ),
            ),
          );

          // Verify the widget renders
          expect(find.byType(VooFieldWidget), findsOneWidget);
          
          // The widget should render without errors
          // Note: Async dropdowns might not immediately show DropdownButtonFormField while loading
        });
      });

      test('Async dropdown with initial value should work', () {
        // Test that async dropdowns can have initial values
        String? capturedValue;
        
        Future<List<VooFieldOption<String>>> loadOptions(String query) async => [
            const VooFieldOption<String>(value: 'initial', label: 'Initial Option'),
            const VooFieldOption<String>(value: 'other', label: 'Other Option'),
          ];

        final asyncDropdown = VooFormField<String>(
          id: 'async_dropdown',
          name: 'async_dropdown',
          type: VooFieldType.dropdown,
          value: 'initial',
          asyncOptionsLoader: loadOptions,
          onChanged: (value) {
            capturedValue = value;
          },
        );

        expect(asyncDropdown.value, equals('initial'));
        
        // Test changing the value
        asyncDropdown.onChanged?.call('other');
        expect(capturedValue, equals('other'));
      });

      test('Async dropdown with complex object types', () async {
        // Test async dropdowns with complex object types
        User? selectedUser;
        
        Future<List<VooFieldOption<User>>> loadUsers(String query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          final users = [
            User(id: '1', name: 'John Doe'),
            User(id: '2', name: 'Jane Smith'),
          ];
          
          return users.map((user) => 
            VooFieldOption<User>(
              value: user,
              label: user.name,
            ),
          ).toList();
        }

        final userDropdown = VooFormField<User>(
          id: 'user_dropdown',
          name: 'user_dropdown',
          type: VooFieldType.dropdown,
          asyncOptionsLoader: loadUsers,
          onChanged: (User? user) {
            selectedUser = user;
          },
        );

        // Load and test options
        final users = await userDropdown.asyncOptionsLoader!('');
        expect(users.length, equals(2));
        expect(users.first.value.id, equals('1'));
        
        // Test selection
        userDropdown.onChanged?.call(users.first.value);
        expect(selectedUser?.id, equals('1'));
        expect(selectedUser?.name, equals('John Doe'));
      });
    });

    group('Common Type Error Scenarios', () {
      test('String to dynamic conversion should work', () {
        // This simulates the exact error users are seeing
        String? capturedValue;
        void stringCallback(String? value) {
          capturedValue = value;
        }
        void Function(dynamic)? dynamicCallback;

        // This should not throw a type error
        dynamicCallback = (dynamic value) {
          if (value == null || value is String) {
            stringCallback(value as String?);
          }
        };

        // Test the conversion
        dynamicCallback('test');
        expect(capturedValue, equals('test'));
        
        dynamicCallback(null);
        expect(capturedValue, isNull);
      });

      test('Widget onChanged should accept various callback signatures', () {
        const field = VooFormField<String>(
          id: 'test',
          name: 'test',
          type: VooFieldType.text,
        );

        // All these callback signatures should be valid
        final callbacks = <void Function(dynamic)?>[
          (dynamic value) {},
          (value) {},
          (Object? value) {},
        ];

        for (final callback in callbacks) {
          expect(() {
            VooFieldWidget(
              field: field,
              onChanged: callback,
            );
          }, returnsNormally,);
        }
      });
    });

    group('Real-world Usage Patterns', () {
      testWidgets('Form with mixed field types and single callback', (tester) async {
        // This simulates a common pattern where a form has multiple field types
        // but uses a single callback to handle all changes
        final formData = <String, dynamic>{};

        final formFields = [
          const VooFormField<String>(
            id: 'name',
            name: 'name',
            type: VooFieldType.text,
            label: 'Name',
          ),
          const VooFormField<num>(
            id: 'age',
            name: 'age',
            type: VooFieldType.number,
            label: 'Age',
          ),
          const VooFormField<String>(
            id: 'email',
            name: 'email',
            type: VooFieldType.email,
            label: 'Email',
          ),
          const VooFormField<bool>(
            id: 'subscribe',
            name: 'subscribe',
            type: VooFieldType.boolean,
            label: 'Subscribe',
          ),
        ];

        // Single callback for all fields
        void handleFieldChange(String fieldId, dynamic value) {
          formData[fieldId] = value;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: formFields.map((field) => VooFieldWidget(
                    field: field,
                    onChanged: (value) => handleFieldChange(field.id, value),
                  ),).toList(),
              ),
            ),
          ),
        );

        // Verify all fields render
        expect(find.byType(VooFieldWidget), findsNWidgets(4));
      });

      testWidgets('Controller-based form management', (tester) async {
        // Test using a text editing controller pattern
        final textController = TextEditingController();
        
        const field = VooFormField<String>(
          id: 'controlled',
          name: 'controlled',
          type: VooFieldType.text,
          label: 'Controlled Field',
        );

        String? lastValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VooFieldWidget(
                field: field,
                controller: textController,
                onChanged: (value) {
                  // Store the value
                  lastValue = value as String?;
                },
              ),
            ),
          ),
        );

        expect(find.byType(VooFieldWidget), findsOneWidget);
        
        // Test entering text
        await tester.enterText(find.byType(TextFormField), 'test input');
        expect(lastValue, equals('test input'));
      });

      testWidgets('Async dropdown in real form scenario', (tester) async {
        // Test async dropdown in a real form with other fields
        await tester.runAsync(() async {
          final formData = <String, dynamic>{};
        
          Future<List<VooFieldOption<String>>> loadCountries(String query) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            final countries = ['USA', 'Canada', 'Mexico', 'Brazil'];
            if (query.isEmpty) {
              return countries.map((c) => 
                VooFieldOption<String>(value: c.toLowerCase(), label: c),
              ).toList();
            }
            
            return countries
              .where((c) => c.toLowerCase().contains(query.toLowerCase()))
              .map((c) => VooFieldOption<String>(value: c.toLowerCase(), label: c))
              .toList();
          }

          final fields = [
            const VooFormField<String>(
              id: 'name',
              name: 'name',
              type: VooFieldType.text,
              label: 'Full Name',
            ),
            VooFormField<String>(
              id: 'country',
              name: 'country',
              type: VooFieldType.dropdown,
              label: 'Country',
              asyncOptionsLoader: loadCountries,
              enableSearch: true,
              searchHint: 'Search countries...',
            ),
            const VooFormField<bool>(
              id: 'terms',
              name: 'terms',
              type: VooFieldType.boolean,
              label: 'Accept Terms',
            ),
          ];

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: fields.map((field) => VooFieldWidget(
                      field: field,
                      onChanged: (value) {
                        formData[field.id] = value;
                      },
                    ),).toList(),
                ),
              ),
            ),
          );

          // Verify all fields render
          expect(find.byType(VooFieldWidget), findsNWidgets(3));
        
          // Test text field - find the first TextFormField (which is the name field)
          final textFields = find.byType(TextFormField);
          await tester.enterText(textFields.first, 'John Doe');
          expect(formData['name'], equals('John Doe'));
        });
      });
    });
  });
}

// Test helper class for complex object types
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}