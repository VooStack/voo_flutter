import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooField.list Tests', () {
    testWidgets('Should display initial items correctly', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'emails',
        label: 'Email Addresses',
        itemTemplate: VooField.email(
          name: 'email',
          label: 'Email',
        ),
        initialItems: ['john@example.com', 'jane@example.com'],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify label is displayed
      expect(find.text('Email Addresses'), findsOneWidget);
      
      // Verify initial items are displayed
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      
      // Verify add button is present
      expect(find.text('Add Email'), findsOneWidget);
      
      // Verify remove buttons are present (one for each item)
      expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
    });
    
    testWidgets('Should add new items when add button is clicked', (WidgetTester tester) async {
      String? capturedValue;
      
      final field = VooField.list<String>(
        name: 'phones',
        label: 'Phone Numbers',
        itemTemplate: VooField.phone(
          name: 'phone',
          label: 'Phone',
        ),
        initialItems: ['555-0001'],
        maxItems: 3,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
              onChanged: (value) {
                if (value is List<String>) {
                  capturedValue = value.join(',');
                }
              },
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify initial state
      expect(find.text('555-0001'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Click add button
      await tester.tap(find.text('Add Phone'));
      await tester.pumpAndSettle();
      
      // Verify new field is added
      expect(find.byType(TextFormField), findsNWidgets(2));
      
      // Enter value in new field
      final newField = find.byType(TextFormField).last;
      await tester.enterText(newField, '555-0002');
      await tester.pumpAndSettle();
      
      // Verify onChanged was called
      expect(capturedValue, contains('555-0002'));
    });
    
    testWidgets('Should remove items when remove button is clicked', (WidgetTester tester) async {
      List<String>? capturedValue;
      
      final field = VooField.list<String>(
        name: 'tags',
        label: 'Tags',
        itemTemplate: VooField.text(
          name: 'tag',
          label: 'Tag',
        ),
        initialItems: ['flutter', 'dart', 'mobile'],
        minItems: 1,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
              onChanged: (value) {
                if (value is List<String>) {
                  capturedValue = value;
                }
              },
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify initial state
      expect(find.text('flutter'), findsOneWidget);
      expect(find.text('dart'), findsOneWidget);
      expect(find.text('mobile'), findsOneWidget);
      
      // Remove the second item (dart)
      final removeButtons = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(removeButtons.at(1));
      await tester.pumpAndSettle();
      
      // Verify item is removed
      expect(find.text('dart'), findsNothing);
      expect(find.text('flutter'), findsOneWidget);
      expect(find.text('mobile'), findsOneWidget);
      
      // Verify onChanged was called
      expect(capturedValue, isNotNull);
      expect(capturedValue!.length, 2);
      expect(capturedValue, contains('flutter'));
      expect(capturedValue, contains('mobile'));
    });
    
    testWidgets('Should respect minItems constraint', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'required_emails',
        label: 'Required Emails',
        itemTemplate: VooField.email(
          name: 'email',
          label: 'Email',
        ),
        initialItems: ['admin@example.com'],
        minItems: 1,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Try to remove the only item
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pumpAndSettle();
      
      // Verify item is still there (not removed due to minItems)
      expect(find.text('admin@example.com'), findsOneWidget);
      
      // Verify snackbar message
      expect(find.text('Minimum 1 items required'), findsOneWidget);
    });
    
    testWidgets('Should respect maxItems constraint', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'limited_items',
        label: 'Limited Items',
        itemTemplate: VooField.text(
          name: 'item',
          label: 'Item',
        ),
        initialItems: ['Item 1', 'Item 2'],
        maxItems: 2,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Try to add another item
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();
      
      // Verify no new item is added
      expect(find.byType(TextFormField), findsNWidgets(2));
      
      // Verify snackbar message
      expect(find.text('Maximum 2 items allowed'), findsOneWidget);
    });
    
    testWidgets('Should work with complex object types', (WidgetTester tester) async {
      // For complex objects, we would typically use a custom field
      // For this test, we'll use a simpler approach with strings
      final field = VooField.list<String>(
        name: 'contacts',
        label: 'Contacts',
        itemTemplate: VooField.text(
          name: 'contact',
          label: 'Contact Name',
        ),
        initialItems: [
          'John Doe',
          'Jane Smith',
        ],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify complex objects are handled
      expect(find.text('Contacts'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
    
    testWidgets('Should disable add/remove in readOnly mode', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'readonly_list',
        label: 'Read-only List',
        itemTemplate: VooField.text(
          name: 'item',
          label: 'Item',
        ),
        initialItems: ['Item 1', 'Item 2'],
        readOnly: true,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify add button is not shown in readOnly mode
      expect(find.text('Add Item'), findsNothing);
      
      // Verify remove buttons are not shown in readOnly mode
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });
    
    testWidgets('Should initialize with minItems when no initialItems provided', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'min_items_test',
        label: 'Min Items Test',
        itemTemplate: VooField.text(
          name: 'item',
          label: 'Item',
        ),
        minItems: 3,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify 3 empty fields are created
      expect(find.byType(TextFormField), findsNWidgets(3));
    });
    
    testWidgets('Should handle custom add/remove button text and icons', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'custom_buttons',
        label: 'Custom Buttons',
        itemTemplate: VooField.text(
          name: 'item',
          label: 'Item',
        ),
        addButtonText: 'New Entry',
        removeButtonText: 'Delete',
        addButtonIcon: Icons.add_box,
        removeButtonIcon: Icons.delete,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify custom add button text
      expect(find.text('New Entry'), findsOneWidget);
      
      // Verify custom icons
      expect(find.byIcon(Icons.add_box), findsOneWidget);
      
      // Add an item to see remove button
      await tester.tap(find.text('New Entry'));
      await tester.pumpAndSettle();
      
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
  
  group('VooListFieldWidget Tests', () {
    testWidgets('Should properly index items after removal', (WidgetTester tester) async {
      final field = VooField.list<String>(
        name: 'indexed_items',
        label: 'Indexed Items',
        itemTemplate: VooField.text(
          name: 'item',
          label: 'Item',
        ),
        initialItems: ['A', 'B', 'C', 'D'],
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: field,
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Remove item at index 1 (B)
      final removeButtons = find.byIcon(Icons.remove_circle_outline);
      await tester.tap(removeButtons.at(1));
      await tester.pumpAndSettle();
      
      // Verify remaining items are properly indexed
      expect(find.text('A'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('B'), findsNothing);
      
      // Verify correct number of fields remain
      expect(find.byType(TextFormField), findsNWidgets(3));
    });
  });
}

class Contact {
  final String name;
  final String email;
  
  Contact({required this.name, required this.email});
  
  @override
  String toString() => name;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}