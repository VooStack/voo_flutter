import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/voo_field.dart';
import 'package:voo_forms/src/presentation/molecules/field_widget_factory.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';

// Test data type
class TestOption {
  final String id;
  final String name;

  const TestOption({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('Async Dropdown Behavior Tests', () {
    // Mock data
    final testOptions = [
      const TestOption(id: '1', name: 'Option One'),
      const TestOption(id: '2', name: 'Option Two'),
      const TestOption(id: '3', name: 'Option Three'),
      const TestOption(id: '4', name: 'Another Option'),
    ];

    testWidgets('Overlay should close after selecting an option',
        (WidgetTester tester) async {
      TestOption? selectedValue;

      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return testOptions;
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {
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
                );
              },
            ),
          ),
        ),
      );

      // Verify dropdown is rendered
      expect(find.byType(TextFormField), findsOneWidget);

      // Open dropdown by tapping the TextFormField
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Wait for async options to load
      await tester.pump(const Duration(milliseconds: 100));
      
      // Verify options are visible in overlay
      expect(find.text('Option One'), findsOneWidget);
      expect(find.text('Option Two'), findsOneWidget);

      // Select an option
      await tester.tap(find.text('Option Two').last);
      await tester.pumpAndSettle();

      // Verify the overlay is closed (options should not be visible)
      expect(find.text('Option One'), findsNothing);
      expect(find.text('Option Three'), findsNothing);

      // Verify the selected value is set
      expect(selectedValue?.id, equals('2'));
      expect(selectedValue?.name, equals('Option Two'));
    });

    testWidgets('Search should update options in real-time',
        (WidgetTester tester) async {
      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        searchDebounce: const Duration(milliseconds: 100),
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          // Filter options based on query
          if (query.isEmpty) {
            return testOptions;
          }
          return testOptions
              .where((opt) =>
                  opt.name.toLowerCase().contains(query.toLowerCase()),)
              .toList();
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {},
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

      // Open dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Wait for initial options to load
      await tester.pump(const Duration(milliseconds: 100));

      // All options should be visible initially
      expect(find.text('Option One'), findsOneWidget);
      expect(find.text('Option Two'), findsOneWidget);
      expect(find.text('Option Three'), findsOneWidget);
      expect(find.text('Another Option'), findsOneWidget);

      // Find and type in search field (it's the second TextField when overlay is open)
      final searchField = find.byType(TextField).last;
      await tester.enterText(searchField, 'option t');

      // Wait for debounce and async load
      await tester.pump(const Duration(milliseconds: 200));

      // Only matching options should be visible
      expect(find.text('Option Two'), findsOneWidget);
      expect(find.text('Option Three'), findsOneWidget);
      expect(find.text('Option One'), findsNothing);
      expect(find.text('Another Option'), findsNothing);

      // Clear search
      await tester.enterText(searchField, '');
      await tester.pump(const Duration(milliseconds: 200));

      // All options should be visible again
      expect(find.text('Option One'), findsOneWidget);
      expect(find.text('Option Two'), findsOneWidget);
      expect(find.text('Option Three'), findsOneWidget);
      expect(find.text('Another Option'), findsOneWidget);
    });

    testWidgets('Search updates should not require clicking away',
        (WidgetTester tester) async {
      int loadCount = 0;

      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        searchDebounce: const Duration(milliseconds: 50),
        asyncOptionsLoader: (query) async {
          loadCount++;
          await Future<void>.delayed(const Duration(milliseconds: 30));
          if (query.isEmpty) {
            return testOptions;
          }
          return testOptions
              .where((opt) =>
                  opt.name.toLowerCase().contains(query.toLowerCase()),)
              .toList();
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {},
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

      // Open dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      // Initial load
      expect(loadCount, equals(1));

      // Type in search field
      final searchField = find.byType(TextField).last;
      await tester.enterText(searchField, 'another');

      // Wait for debounce and load
      await tester.pump(const Duration(milliseconds: 100));

      // Should have loaded again with search query
      expect(loadCount, equals(2));

      // Should show filtered results without clicking away
      expect(find.text('Another Option'), findsOneWidget);
      expect(find.text('Option One'), findsNothing);
      expect(find.text('Option Two'), findsNothing);
      expect(find.text('Option Three'), findsNothing);
    });

    testWidgets('Overlay should remain open during search',
        (WidgetTester tester) async {
      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          if (query.isEmpty) {
            return testOptions;
          }
          return testOptions
              .where((opt) =>
                  opt.name.toLowerCase().contains(query.toLowerCase()),)
              .toList();
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {},
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

      // Open dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify overlay is open
      expect(find.text('Option One'), findsOneWidget);

      // Type in search
      final searchField = find.byType(TextField).last;
      await tester.enterText(searchField, 'two');
      await tester.pump(const Duration(milliseconds: 100));

      // Overlay should still be open with filtered results
      expect(find.text('Option Two'), findsOneWidget);

      // Continue typing
      await tester.enterText(searchField, 'three');
      await tester.pump(const Duration(milliseconds: 100));

      // Overlay should still be open with new filtered results
      expect(find.text('Option Three'), findsOneWidget);
      expect(find.text('Option Two'), findsNothing);
    });

    testWidgets('Loading state should be shown during async load',
        (WidgetTester tester) async {
      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          return testOptions;
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {},
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

      // Open dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for load to complete
      await tester.pump(const Duration(milliseconds: 250));

      // Loading indicator should be gone, options should be visible
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Option One'), findsOneWidget);
    });

    testWidgets('Dropdown with custom type should handle selection correctly',
        (WidgetTester tester) async {
      TestOption? selectedValue;

      final field = VooField.dropdownAsync<TestOption>(
        name: 'test',
        label: 'Test Dropdown',
        asyncOptionsLoader: (query) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return testOptions;
        },
        converter: (option) => VooFieldOption(
          value: option,
          label: option.name,
        ),
        onChanged: (TestOption? value) {
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
                    // Should properly invoke the typed callback
                    if (value is TestOption?) {
                      field.onChanged?.call(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      // Select an option
      await tester.tap(find.text('Option Three').last);
      await tester.pumpAndSettle();

      // Verify selection worked with correct type
      expect(selectedValue, isNotNull);
      expect(selectedValue?.id, equals('3'));
      expect(selectedValue?.name, equals('Option Three'));
    });
  });
}