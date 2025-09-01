import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Dropdown InitialValue Tests', () {
    testWidgets('Regular dropdown should display initialValue correctly', (WidgetTester tester) async {
      const initialValue = 'flutter';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdown<String>(
                name: 'framework',
                label: 'Select Framework',
                initialValue: initialValue,
                options: const ['flutter', 'react', 'vue'],
                converter: (value) => VooDropdownChild<String>(
                  value: value,
                  label: value[0].toUpperCase() + value.substring(1),
                ),
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that the initial value 'Flutter' is displayed
      expect(find.text('Flutter'), findsOneWidget);
    });

    testWidgets('Regular dropdown should prioritize value over initialValue', (WidgetTester tester) async {
      const initialValue = 'flutter';
      const currentValue = 'react';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdown<String>(
                name: 'framework',
                label: 'Select Framework',
                initialValue: initialValue,
                options: const ['flutter', 'react', 'vue'],
                converter: (value) => VooDropdownChild<String>(
                  value: value,
                  label: value[0].toUpperCase() + value.substring(1),
                ),
              ).copyWith(value: currentValue),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that the current value 'React' is displayed, not the initial value
      expect(find.text('React'), findsOneWidget);
      expect(find.text('Flutter'), findsNothing);
    });

    testWidgets('Async dropdown should display initialValue correctly', (WidgetTester tester) async {
      final initialUser = TestUser(id: '2', name: 'Jane Smith');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdownAsync<TestUser>(
                name: 'user',
                label: 'Select User',
                initialValue: initialUser,
                asyncOptionsLoader: (query) async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  return [
                    TestUser(id: '1', name: 'John Doe'),
                    TestUser(id: '2', name: 'Jane Smith'),
                    TestUser(id: '3', name: 'Bob Johnson'),
                  ];
                },
                converter: (user) => VooDropdownChild<TestUser>(
                  value: user,
                  label: user.name,
                ),
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify that the initial value is displayed
      expect(find.text('Jane Smith'), findsOneWidget);
    });

    testWidgets('Dropdown onChanged should be called with correct type', (WidgetTester tester) async {
      String? selectedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdown<String>(
                name: 'framework',
                label: 'Select Framework',
                initialValue: 'flutter',
                options: const ['flutter', 'react', 'vue'],
                converter: (value) => VooDropdownChild<String>(
                  value: value,
                  label: value[0].toUpperCase() + value.substring(1),
                ),
                onChanged: (String? value) {
                  selectedValue = value;
                },
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      
      // Select 'react'
      await tester.tap(find.text('React').last);
      await tester.pumpAndSettle();
      
      // Verify onChanged was called with correct value
      expect(selectedValue, 'react');
    });

    testWidgets('Dropdown should maintain initialValue after rebuild', (WidgetTester tester) async {
      const initialValue = 'vue';
      
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    VooFieldWidget(
                      field: VooField.dropdown<String>(
                        name: 'framework',
                        label: 'Select Framework',
                        initialValue: initialValue,
                        options: const ['flutter', 'react', 'vue'],
                        converter: (value) => VooDropdownChild<String>(
                          value: value,
                          label: value[0].toUpperCase() + value.substring(1),
                        ),
                      ),
                      options: VooFieldOptions.material,
                    ),
                    TextButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Rebuild'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify initial value is displayed
      expect(find.text('Vue'), findsOneWidget);
      
      // Trigger rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();
      
      // Verify initial value is still displayed after rebuild
      expect(find.text('Vue'), findsOneWidget);
    });

    testWidgets('Async dropdown should show initial value even before options load', (WidgetTester tester) async {
      final initialUser = TestUser(id: '2', name: 'Jane Smith');
      bool optionsLoaded = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.dropdownAsync<TestUser>(
                name: 'user',
                label: 'Select User',
                initialValue: initialUser,
                asyncOptionsLoader: (query) async {
                  await Future.delayed(const Duration(seconds: 1));
                  optionsLoaded = true;
                  return [
                    TestUser(id: '1', name: 'John Doe'),
                    TestUser(id: '2', name: 'Jane Smith'),
                    TestUser(id: '3', name: 'Bob Johnson'),
                  ];
                },
                converter: (user) => VooDropdownChild<TestUser>(
                  value: user,
                  label: user.name,
                ),
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      // Initial pump without waiting for async
      await tester.pump();
      
      // Verify initial value is displayed even before options load
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(optionsLoaded, false);
      
      // Wait for options to load
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verify initial value is still displayed after options load
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(optionsLoaded, true);
    });
  });
}

class TestUser {
  final String id;
  final String name;
  
  TestUser({required this.id, required this.name});
  
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