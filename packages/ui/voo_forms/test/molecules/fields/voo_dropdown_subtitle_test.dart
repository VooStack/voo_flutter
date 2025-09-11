import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooDropdownField Subtitle Support', () {
    testWidgets('displays subtitles when subtitleBuilder is provided', (tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              label: 'Select Option',
              options: options,
              displayTextBuilder: (value) => value,
              subtitleBuilder: (value) => 'Description for $value',
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify subtitles are displayed
      expect(find.text('Description for Option 1'), findsOneWidget);
      expect(find.text('Description for Option 2'), findsOneWidget);
      expect(find.text('Description for Option 3'), findsOneWidget);
    });

    testWidgets('works with complex objects and subtitles', (tester) async {
      final products = [
        Product('Laptop', 'High-performance computing device'),
        Product('Phone', 'Mobile communication device'),
        Product('Tablet', 'Portable touch screen device'),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<Product>(
              name: 'product',
              label: 'Select Product',
              options: products,
              displayTextBuilder: (product) => product.name,
              subtitleBuilder: (product) => product.description,
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooDropdownField<Product>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify product names are displayed
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Tablet'), findsOneWidget);
      
      // Verify product descriptions are displayed as subtitles
      expect(find.text('High-performance computing device'), findsOneWidget);
      expect(find.text('Mobile communication device'), findsOneWidget);
      expect(find.text('Portable touch screen device'), findsOneWidget);
    });
  });

  group('VooAsyncDropdownField Subtitle Support', () {
    testWidgets('displays subtitles with async loaded options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'async_test',
              label: 'Select Option',
              asyncOptionsLoader: (query) async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['Result 1', 'Result 2', 'Result 3'];
              },
              displayTextBuilder: (value) => value,
              subtitleBuilder: (value) => 'Async description for $value',
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooAsyncDropdownField<String>));
      await tester.pump();
      
      // Wait for async loading
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 300));

      // Verify subtitles are displayed for async loaded options
      expect(find.text('Async description for Result 1'), findsOneWidget);
      expect(find.text('Async description for Result 2'), findsOneWidget);
      expect(find.text('Async description for Result 3'), findsOneWidget);
    });
  });

  group('VooMultiSelectField Subtitle Support', () {
    testWidgets('displays subtitles in multi-select', (tester) async {
      final categories = ['Electronics', 'Clothing', 'Food'];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooMultiSelectField<String>(
              name: 'categories',
              label: 'Select Categories',
              options: categories,
              displayTextBuilder: (value) => value,
              subtitleBuilder: (value) => getCategoryDescription(value),
            ),
          ),
        ),
      );

      // Tap on the multi-select to open it
      await tester.tap(find.byType(VooMultiSelectField<String>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify subtitles are displayed
      expect(find.text('Gadgets and devices'), findsOneWidget);
      expect(find.text('Apparel and accessories'), findsOneWidget);
      expect(find.text('Groceries and consumables'), findsOneWidget);
    });
  });
}

// Helper function for category descriptions
String getCategoryDescription(String category) {
  switch (category) {
    case 'Electronics':
      return 'Gadgets and devices';
    case 'Clothing':
      return 'Apparel and accessories';
    case 'Food':
      return 'Groceries and consumables';
    default:
      return '';
  }
}

// Simple Product class for testing
class Product {
  final String name;
  final String description;
  
  Product(this.name, this.description);
}