import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

void main() {
  group('Text Field maxLines and expanded Tests', () {
    testWidgets('Text field with maxLines should be created successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.text(
                name: 'test',
                label: 'Test Field',
                maxLines: 3,
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify the TextFormField is created
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Enter multiline text to verify it accepts multiple lines
      await tester.enterText(find.byType(TextFormField), 'Line 1\nLine 2\nLine 3');
      await tester.pumpAndSettle();
      
      // Text should be present
      expect(find.text('Line 1\nLine 2\nLine 3'), findsOneWidget);
    });
    
    testWidgets('Multiline field should accept multiple lines', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.multiline(
                name: 'notes',
                label: 'Notes',
                maxLines: 10,
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Enter multiline text
      final longText = 'Line 1\nLine 2\nLine 3\nLine 4\nLine 5';
      await tester.enterText(find.byType(TextFormField), longText);
      await tester.pumpAndSettle();
      
      expect(find.text(longText), findsOneWidget);
    });
    
    testWidgets('Text field with expanded should wrap in Expanded widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooFieldWidget(
                  field: VooField.text(
                    name: 'expandedTest',
                    label: 'Expanded Field',
                    expanded: true,
                  ),
                  options: VooFieldOptions.material,
                ),
              ],
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Check that Expanded widget is present
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
    
    testWidgets('Multiline field with expanded should wrap in Expanded widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                VooFieldWidget(
                  field: VooField.multiline(
                    name: 'expandedMultiline',
                    label: 'Expanded Multiline',
                    expanded: true,
                  ),
                  options: VooFieldOptions.material,
                ),
              ],
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Check that Expanded widget is present
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Enter multiline text to verify it works
      await tester.enterText(find.byType(TextFormField), 'This is\na multiline\ntext field\nthat expands');
      await tester.pumpAndSettle();
      
      expect(find.text('This is\na multiline\ntext field\nthat expands'), findsOneWidget);
    });
    
    testWidgets('Email field with maxLines should be created successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFieldWidget(
              field: VooField.email(
                name: 'email',
                label: 'Email',
                maxLines: 2,
              ),
              options: VooFieldOptions.material,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Verify the field is created
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Enter an email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pumpAndSettle();
      
      expect(find.text('test@example.com'), findsOneWidget);
    });
    
    testWidgets('Phone field with expanded should wrap in Expanded widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooFieldWidget(
                  field: VooField.phone(
                    name: 'phone',
                    label: 'Phone',
                    expanded: true,
                  ),
                  options: VooFieldOptions.material,
                ),
              ],
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Check that Expanded widget is present
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
    
    testWidgets('Text field without expanded should not wrap in Expanded widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooFieldWidget(
                  field: VooField.text(
                    name: 'notExpanded',
                    label: 'Not Expanded',
                    expanded: false,
                  ),
                  options: VooFieldOptions.material,
                ),
              ],
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Check that Expanded widget is NOT present
      expect(find.byType(Expanded), findsNothing);
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}