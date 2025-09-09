import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('VooDropdownField optionBuilder', () {
    testWidgets('uses custom option builder when provided', (WidgetTester tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              label: 'Test Dropdown',
              options: options,
              onChanged: (value) => selectedValue = value,
              optionBuilder: (context, item, isSelected, displayText) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withValues(alpha: 0.2) : null,
                    border: Border(
                      left: BorderSide(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: isSelected ? Colors.blue : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          displayText,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : null,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 20,
                        ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Verify custom option builder is used - look for star icons
      expect(find.byIcon(Icons.star), findsWidgets);
      
      // Tap on the second option
      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      // Verify the value was selected
      expect(selectedValue, 'Option 2');
    });

    testWidgets('optionBuilder receives correct isSelected state', (WidgetTester tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];
      bool? option2WasSelected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              label: 'Test Dropdown',
              options: options,
              initialValue: 'Option 2',
              optionBuilder: (context, item, isSelected, displayText) {
                if (item == 'Option 2') {
                  option2WasSelected = isSelected;
                }
                return Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: isSelected ? Colors.green : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Verify Option 2 is marked as selected
      expect(option2WasSelected, true);
    });

    testWidgets('falls back to default rendering when optionBuilder is null', (WidgetTester tester) async {
      final options = ['Option 1', 'Option 2', 'Option 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooDropdownField<String>(
              name: 'test',
              label: 'Test Dropdown',
              options: options,
              initialValue: 'Option 2',
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooDropdownField<String>));
      await tester.pumpAndSettle();

      // Verify default rendering with check icon for selected item
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Option 2'), findsWidgets);
    });
  });

  group('VooAsyncDropdownField optionBuilder', () {
    testWidgets('uses custom option builder with async dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooAsyncDropdownField<String>(
              name: 'test',
              label: 'Test Async Dropdown',
              asyncOptionsLoader: (query) async {
                // Simulate async loading
                await Future<void>.delayed(const Duration(milliseconds: 100));
                return ['Async 1', 'Async 2', 'Async 3']
                    .where((item) => item.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              },
              optionBuilder: (context, item, isSelected, displayText) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud, size: 20),
                      const SizedBox(width: 8),
                      Text(displayText),
                      if (isSelected) ...[
                        const Spacer(),
                        const Icon(Icons.check, color: Colors.green),
                      ],
                    ],
                  ),
                ),
            ),
          ),
        ),
      );

      // Tap on the dropdown to open it
      await tester.tap(find.byType(VooAsyncDropdownField<String>));
      await tester.pumpAndSettle();

      // Wait for async loading
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Verify custom option builder is used - look for cloud icons
      expect(find.byIcon(Icons.cloud), findsWidgets);
    });
  });
}