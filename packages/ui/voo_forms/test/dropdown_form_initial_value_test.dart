import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Dropdown InitialValue in Forms Tests', () {
    testWidgets('Dropdown initialValue should work in VooForm', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: VooFormWidget(
                form: VooForm(
                  id: 'test_form',
                  fields: [
                    VooField.dropdown<String>(
                      name: 'country',
                      label: 'Country',
                      initialValue: 'US',
                      options: const ['US', 'CA', 'UK'],
                      converter: (value) => VooDropdownChild<String>(
                        value: value,
                        label: _getCountryName(value),
                      ),
                      onChanged: (value) {
                        selectedValue = value;
                      },
                    ),
                    VooField.text(
                      name: 'name',
                      label: 'Name',
                      initialValue: 'John Doe',
                    ),
                  ],
                ),
                config: const VooFormConfig(
                  defaultFieldOptions: VooFieldOptions.material,
                ),
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that the initial value 'United States' is displayed
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      
      // Verify form can get values
      final formState = formKey.currentState;
      expect(formState, isNotNull);
    });

    testWidgets('Multiple dropdowns with different initialValues should work', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormWidget(
              form: VooForm(
                id: 'multi_dropdown_form',
                fields: [
                  VooField.dropdown<String>(
                    name: 'country',
                    label: 'Country',
                    initialValue: 'CA',
                    options: const ['US', 'CA', 'UK'],
                    converter: (value) => VooDropdownChild<String>(
                      value: value,
                      label: _getCountryName(value),
                    ),
                  ),
                  VooField.dropdown<String>(
                    name: 'language',
                    label: 'Language',
                    initialValue: 'fr',
                    options: const ['en', 'fr', 'es'],
                    converter: (value) => VooDropdownChild<String>(
                      value: value,
                      label: _getLanguageName(value),
                    ),
                  ),
                ],
              ),
              config: const VooFormConfig(
                defaultFieldOptions: VooFieldOptions.material,
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify both initial values are displayed
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
    });

    testWidgets('Async dropdown initialValue should work in VooForm', (WidgetTester tester) async {
      final initialUser = TestUser(id: '2', name: 'Jane Smith', email: 'jane@example.com');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormWidget(
              form: VooForm(
                id: 'async_form',
                fields: [
                  VooField.dropdownAsync<TestUser>(
                    name: 'user',
                    label: 'Select User',
                    initialValue: initialUser,
                    asyncOptionsLoader: (query) async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      return [
                        TestUser(id: '1', name: 'John Doe', email: 'john@example.com'),
                        TestUser(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
                        TestUser(id: '3', name: 'Bob Johnson', email: 'bob@example.com'),
                      ];
                    },
                    converter: (user) => VooDropdownChild<TestUser>(
                      value: user,
                      label: user.name,
                      subtitle: user.email,
                    ),
                  ),
                  VooField.text(
                    name: 'notes',
                    label: 'Notes',
                  ),
                ],
              ),
              config: const VooFormConfig(
                defaultFieldOptions: VooFieldOptions.material,
              ),
            ),
          ),
        ),
      );
      
      await tester.pump();
      
      // Verify that initial value is shown immediately
      expect(find.text('Jane Smith'), findsOneWidget);
      
      // Wait for async load
      await tester.pumpAndSettle();
      
      // Verify that initial value is still shown after load
      expect(find.text('Jane Smith'), findsOneWidget);
    });

    testWidgets('Dropdown with enableSearch should maintain initialValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdown<String>(
                name: 'framework',
                label: 'Framework',
                initialValue: 'react',
                options: const ['flutter', 'react', 'vue', 'angular'],
                converter: (value) => VooDropdownChild<String>(
                  value: value,
                  label: value[0].toUpperCase() + value.substring(1),
                ),
                enableSearch: true,
                searchHint: 'Search frameworks...',
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that searchable dropdown shows initial value
      expect(find.text('React'), findsOneWidget);
    });

    testWidgets('Dropdown initialValue with complex object type', (WidgetTester tester) async {
      final initialProduct = Product(
        id: 'p2',
        name: 'Laptop',
        price: 999.99,
        category: 'Electronics',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdown<Product>(
                name: 'product',
                label: 'Select Product',
                initialValue: initialProduct,
                options: [
                  Product(id: 'p1', name: 'Phone', price: 599.99, category: 'Electronics'),
                  Product(id: 'p2', name: 'Laptop', price: 999.99, category: 'Electronics'),
                  Product(id: 'p3', name: 'Tablet', price: 399.99, category: 'Electronics'),
                ],
                converter: (product) => VooDropdownChild<Product>(
                  value: product,
                  label: product.name,
                  subtitle: '\$${product.price.toStringAsFixed(2)}',
                ),
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that complex object initial value is displayed
      expect(find.text('Laptop'), findsOneWidget);
    });

    testWidgets('Dropdown should preserve initialValue through parent rebuilds', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _RebuildTestWidget(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify initial value is displayed
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Counter: 0'), findsOneWidget);
      
      // Trigger parent rebuild
      await tester.tap(find.text('Increment'));
      await tester.pumpAndSettle();
      
      // Verify initial value is still displayed after parent rebuild
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Counter: 1'), findsOneWidget);
      
      // Trigger another rebuild
      await tester.tap(find.text('Increment'));
      await tester.pumpAndSettle();
      
      // Verify initial value persists
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Counter: 2'), findsOneWidget);
    });
  });
}

String _getCountryName(String code) {
  switch (code) {
    case 'US':
      return 'United States';
    case 'CA':
      return 'Canada';
    case 'UK':
      return 'United Kingdom';
    default:
      return code;
  }
}

String _getLanguageName(String code) {
  switch (code) {
    case 'en':
      return 'English';
    case 'fr':
      return 'French';
    case 'es':
      return 'Spanish';
    default:
      return code;
  }
}

class TestUser {
  final String id;
  final String name;
  final String email;
  
  TestUser({required this.id, required this.name, required this.email});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestUser &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => name;
}

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class _RebuildTestWidget extends StatefulWidget {
  @override
  State<_RebuildTestWidget> createState() => _RebuildTestWidgetState();
}

class _RebuildTestWidgetState extends State<_RebuildTestWidget> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Counter: $counter'),
          VooFieldWidget(
            field: VooField.dropdown<String>(
              name: 'option',
              label: 'Select Option',
              initialValue: 'b',
              options: const ['a', 'b', 'c'],
              converter: (value) => VooDropdownChild<String>(
                value: value,
                label: 'Option ${value.toUpperCase()}',
              ),
            ),
            options: VooFieldOptions.material,
          ),
          TextButton(
            onPressed: () => setState(() => counter++),
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}