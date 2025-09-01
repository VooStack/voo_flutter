import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

// Custom type for US States
class USState {
  final String code;
  final String name;
  final String capital;

  const USState({
    required this.code,
    required this.name,
    required this.capital,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USState &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => name;
}

// Another custom type for testing
class Country {
  final String iso;
  final String name;
  final String flag;

  const Country({
    required this.iso,
    required this.name,
    required this.flag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          iso == other.iso;

  @override
  int get hashCode => iso.hashCode;
}

void main() {
  group('Regular Dropdown Custom Type Tests', () {
    // Sample US States data
    const states = [
      USState(code: 'NY', name: 'New York', capital: 'Albany'),
      USState(code: 'CA', name: 'California', capital: 'Sacramento'),
      USState(code: 'TX', name: 'Texas', capital: 'Austin'),
      USState(code: 'FL', name: 'Florida', capital: 'Tallahassee'),
    ];

    // Sample Countries data
    const countries = [
      Country(iso: 'US', name: 'United States', flag: '🇺🇸'),
      Country(iso: 'CA', name: 'Canada', flag: '🇨🇦'),
      Country(iso: 'MX', name: 'Mexico', flag: '🇲🇽'),
    ];

    test('VooField.dropdown with USState type should not throw type errors', () {
      USState? selectedState;
      
      // Create a regular dropdown with strongly typed callback
      final field = VooField.dropdown<USState>(
        name: 'state',
        label: 'Select State',
        options: states,
        converter: (state) => VooFieldOption(
          value: state,
          label: state.name,
          subtitle: '${state.code} - Capital: ${state.capital}',
        ),
        onChanged: (USState? value) {
          // This strongly typed callback should not cause type errors
          selectedState = value;
        },
      );

      // Verify the field was created successfully
      expect(field, isNotNull);
      expect(field.onChanged, isNotNull);
      expect(field.options, isNotNull);
      expect(field.options!.length, equals(states.length));
      
      // Simulate calling onChanged with a value
      const testState = USState(code: 'NY', name: 'New York', capital: 'Albany');
      
      // This should not throw a type error
      expect(() {
        field.onChanged?.call(testState);
      }, returnsNormally);
      
      expect(selectedState, equals(testState));
    });

    testWidgets('Regular dropdown with USState type renders without type errors', 
        (WidgetTester tester) async {
      USState? selectedState;
      
      final field = VooField.dropdown<USState>(
        name: 'state',
        label: 'Select State',
        options: states,
        converter: (state) => VooFieldOption(
          value: state,
          label: state.name,
          subtitle: state.capital,
        ),
        onChanged: (USState? value) {
          selectedState = value;
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
                  isEditable: true,
                  onChanged: (dynamic value) {
                    // This should properly invoke the typed callback
                    if (value is USState?) {
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
      expect(find.text('Select State'), findsOneWidget);
      
      // Tap to open dropdown
      await tester.tap(find.text('Select State'));
      await tester.pumpAndSettle();
      
      // Should show state options without type errors
      expect(find.text('New York'), findsOneWidget);
      expect(find.text('California'), findsOneWidget);
      expect(find.text('Texas'), findsOneWidget);
      expect(find.text('Florida'), findsOneWidget);
      
      // Select a state
      await tester.tap(find.text('Texas').last);
      await tester.pumpAndSettle();
      
      // Verify selection worked
      expect(selectedState?.code, equals('TX'));
      expect(selectedState?.name, equals('Texas'));
    });

    test('VooField.dropdown with Country type should handle callbacks correctly', () {
      Country? selectedCountry;
      
      final field = VooField.dropdown<Country>(
        name: 'country',
        label: 'Select Country',
        options: countries,
        converter: (country) => VooFieldOption(
          value: country,
          label: '${country.flag} ${country.name}',
          subtitle: country.iso,
        ),
        onChanged: (Country? value) {
          selectedCountry = value;
        },
      );

      // Test the callback
      const testCountry = Country(iso: 'CA', name: 'Canada', flag: '🇨🇦');
      
      expect(() {
        field.onChanged?.call(testCountry);
      }, returnsNormally);
      
      expect(selectedCountry, equals(testCountry));
    });

    testWidgets('Multiple custom type dropdowns on same form work correctly', 
        (WidgetTester tester) async {
      USState? selectedState;
      Country? selectedCountry;
      
      final stateField = VooField.dropdown<USState>(
        name: 'state',
        label: 'State',
        options: states,
        converter: (state) => VooFieldOption(
          value: state,
          label: state.name,
        ),
        onChanged: (USState? value) {
          selectedState = value;
        },
      );

      final countryField = VooField.dropdown<Country>(
        name: 'country',
        label: 'Country',
        options: countries,
        converter: (country) => VooFieldOption(
          value: country,
          label: country.name,
        ),
        onChanged: (Country? value) {
          selectedCountry = value;
        },
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
                      field: stateField,
                      options: const VooFieldOptions(),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    const factory = FieldWidgetFactory();
                    return factory.create(
                      context: context,
                      field: countryField,
                      options: const VooFieldOptions(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Both dropdowns should render
      expect(find.text('State'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      
      // Test state dropdown
      await tester.tap(find.text('State'));
      await tester.pumpAndSettle();
      
      expect(find.text('California'), findsOneWidget);
      await tester.tap(find.text('California').last);
      await tester.pumpAndSettle();
      
      expect(selectedState?.code, equals('CA'));
      
      // Test country dropdown
      await tester.tap(find.text('Country'));
      await tester.pumpAndSettle();
      
      expect(find.text('Mexico'), findsOneWidget);
      await tester.tap(find.text('Mexico').last);
      await tester.pumpAndSettle();
      
      expect(selectedCountry?.iso, equals('MX'));
    });

    test('Function.apply correctly handles USState typed callbacks', () {
      // Test that Function.apply solution works with USState
      USState? result;
      
      void typedCallback(USState? value) {
        result = value;
      }
      
      const testState = USState(code: 'FL', name: 'Florida', capital: 'Tallahassee');
      
      // This should work without type errors
      expect(() {
        Function.apply(typedCallback, [testState]);
      }, returnsNormally);
      
      expect(result, equals(testState));
      
      // Also test with null
      expect(() {
        Function.apply(typedCallback, [null]);
      }, returnsNormally);
      
      expect(result, isNull);
    });

    test('Dropdown with initial value of custom type works correctly', () {
      const initialState = USState(code: 'TX', name: 'Texas', capital: 'Austin');
      USState? selectedState = initialState;
      
      final field = VooField.dropdown<USState>(
        name: 'state',
        label: 'State',
        options: states,
        initialValue: initialState,
        converter: (state) => VooFieldOption(
          value: state,
          label: state.name,
        ),
        onChanged: (USState? value) {
          selectedState = value;
        },
      );

      // Field should have the initial value
      expect(field.initialValue, equals(initialState));
      
      // Changing value should work
      const newState = USState(code: 'NY', name: 'New York', capital: 'Albany');
      field.onChanged?.call(newState);
      
      expect(selectedState, equals(newState));
    });

    testWidgets('Dropdown disables correctly with custom types', 
        (WidgetTester tester) async {
      final field = VooField.dropdown<USState>(
        name: 'state',
        label: 'State',
        options: states,
        enabled: false, // Disabled dropdown
        converter: (state) => VooFieldOption(
          value: state,
          label: state.name,
        ),
        onChanged: (USState? value) {
          // Should not be called
          fail('onChanged should not be called for disabled dropdown');
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
                );
              },
            ),
          ),
        ),
      );

      // Dropdown should be rendered but disabled
      expect(find.text('State'), findsOneWidget);
      
      // Try to tap - should not open
      await tester.tap(find.text('State'));
      await tester.pump();
      
      // Options should not be visible
      expect(find.text('New York'), findsNothing);
    });
  });
}