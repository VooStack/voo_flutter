import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  group('Example Pages Navigation Test', () {
    testWidgets('Main page loads without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('VooForms Examples'), findsOneWidget);
      expect(find.text('Registration Form'), findsOneWidget);
      expect(find.text('Survey Form'), findsOneWidget);
    });

    testWidgets('Registration Form page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Registration Form'));
      await tester.pumpAndSettle();
      
      expect(find.text('Registration Form'), findsOneWidget);
      expect(find.text('Create Account'), findsAny);
    });

    testWidgets('Survey Form page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Survey Form'));
      await tester.pumpAndSettle();
      
      expect(find.text('Survey Form'), findsOneWidget);
      expect(find.text('Customer Satisfaction Survey'), findsAny);
    });

    testWidgets('All Field Types page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('All Field Types'));
      await tester.pumpAndSettle();
      
      expect(find.text('All Field Types'), findsOneWidget);
    });

    testWidgets('Stepped Form page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Stepped Form'));
      await tester.pumpAndSettle();
      
      expect(find.text('Stepped Form'), findsOneWidget);
    });

    testWidgets('Dynamic Form page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Dynamic Form'));
      await tester.pumpAndSettle();
      
      expect(find.text('Dynamic Form'), findsOneWidget);
    });

    testWidgets('Validation Examples page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Custom Validators'));
      await tester.pumpAndSettle();
      
      expect(find.text('Validation Examples'), findsOneWidget);
    });

    testWidgets('Headers Example page loads', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Form Headers'));
      await tester.pumpAndSettle();
      
      expect(find.text('Headers Example'), findsOneWidget);
    });
  });
}