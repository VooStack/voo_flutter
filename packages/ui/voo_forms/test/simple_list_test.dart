import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  testWidgets('Simple list field test', (WidgetTester tester) async {
    List<String>? lastValue;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VooFieldWidget(
            field: VooField.list<String>(
              name: 'test',
              label: 'Test List',
              itemTemplate: VooField.text(
                name: 'item',
                label: 'Item',
              ),
              initialItems: ['first'],
            ),
            onChanged: (value) {
              print('onChanged called with: $value');
              if (value is List) {
                lastValue = value.cast<String>();
              } else {
                lastValue = null;
              }
            },
            options: VooFieldOptions.material,
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Verify initial state
    expect(find.text('first'), findsOneWidget);
    expect(lastValue, isNull); // Not called yet
    
    // Add an item
    await tester.tap(find.text('Add Item'));
    await tester.pumpAndSettle();
    
    // Should have 2 text fields now
    expect(find.byType(TextFormField), findsNWidgets(2));
    
    // Enter text in the new field
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.last, 'second');
    await tester.pumpAndSettle();
    
    // Check if onChanged was called
    print('Last value after entering text: $lastValue');
    expect(lastValue, isNotNull);
    expect(lastValue!.length, 2);
    expect(lastValue, contains('first'));
    expect(lastValue, contains('second'));
  });
}