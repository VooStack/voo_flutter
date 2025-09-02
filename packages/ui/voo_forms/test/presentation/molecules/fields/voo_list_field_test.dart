import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_list_field.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_text_field.dart';

void main() {
  group('VooListField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              label: 'Items',
              items: const [],
              itemBuilder: (context, item, index) => VooTextField(
                name: 'item_$index',
                initialValue: item,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Items'), findsOneWidget);
      expect(find.text('No items added yet'), findsOneWidget);
    });

    testWidgets('displays items correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const ['Item 1', 'Item 2'],
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('shows add button when enabled', (WidgetTester tester) async {
      int addCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
              onAddPressed: () {
                addCallCount++;
              },
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      
      // Tap add button
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      expect(addCallCount, 1);
    });

    // Test removed - onRemovePressed callback no longer exists
    // Remove functionality should be handled within itemBuilder

    testWidgets('handles reordering when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              canReorderItems: true,
              onReorder: (oldIndex, newIndex) {},
            ),
          ),
        ),
      );

      // Check that drag handles are shown
      expect(find.byIcon(Icons.drag_indicator), findsNWidgets(3));
    });

    testWidgets('shows custom add button text and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
              addButtonText: 'Add New',
              addButtonIcon: const Icon(Icons.add_box),
              onAddPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add New'), findsOneWidget);
      expect(find.byIcon(Icons.add_box), findsOneWidget);
    });

    testWidgets('shows item numbers when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              showItemNumbers: true,
              items: const ['Item 1', 'Item 2'],
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('is disabled when enabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              enabled: false,
              items: [],
              itemBuilder: _simpleItemBuilder,
              onAddPressed: _dummyCallback,
            ),
          ),
        ),
      );

      // The add button should exist but be disabled
      // Note: OutlinedButton.icon is used, so we look for OutlinedButton as the base type
      final addButtonFinder = find.byWidgetPredicate(
        (widget) => widget is OutlinedButton,
      );
      expect(addButtonFinder, findsOneWidget);
      
      final addButton = tester.widget<OutlinedButton>(addButtonFinder);
      expect(addButton.onPressed, null);
    });

    testWidgets('hides add/remove buttons in readOnly mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              readOnly: true,
              items: const ['Item 1'],
              itemBuilder: (context, item, index) => Text(item),
              onAddPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsNothing);
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });

    testWidgets('shows helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              helper: 'Add up to 5 items',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );

      expect(find.text('Add up to 5 items'), findsOneWidget);
    });

    testWidgets('shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              error: 'At least one item is required',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
            ),
          ),
        ),
      );

      expect(find.text('At least one item is required'), findsOneWidget);
    });

    testWidgets('shows custom empty state widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
              emptyStateWidget: const Text('Custom empty state'),
            ),
          ),
        ),
      );

      expect(find.text('Custom empty state'), findsOneWidget);
    });

    testWidgets('uses custom item decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const ['Item 1'],
              itemBuilder: (context, item, index) => Text(item),
              itemDecoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );

      // Check that the item is rendered
      expect(find.text('Item 1'), findsOneWidget);
      
      // Check that a Container with decoration exists
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('does not show add button when showAddButton is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const [],
              itemBuilder: (context, item, index) => Text(item),
              showAddButton: false,
              onAddPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsNothing);
    });

    testWidgets('does not show remove buttons when showRemoveButtons is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooListField<String>(
              name: 'items',
              items: const ['Item 1'],
              itemBuilder: (context, item, index) => Text(item),
              showRemoveButtons: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });
  });
}

// Helper functions for const constructors
Widget _simpleItemBuilder(BuildContext context, String item, int index) => Text(item);
void _dummyCallback() {}