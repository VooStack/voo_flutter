import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_text_badge.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooTextBadge', () {
    testWidgets('should render text badge with correct text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '5',
            badgeColor: Colors.red,
            textColor: Colors.white,
            size: 16.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Find the text
      expect(find.text('5'), findsOneWidget);

      // Verify the container
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('should apply correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '99+',
            badgeColor: Colors.blue,
            textColor: Colors.white,
            size: 16.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Find the container and verify background color
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);

      // Find the text and verify text color
      final text = tester.widget<Text>(find.text('99+'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('should animate when animate is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '10',
            badgeColor: Colors.green,
            textColor: Colors.white,
            size: 16.0,
            animate: true,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Should find TweenAnimationBuilder when animating
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

      // Pump to complete animation
      await tester.pumpAndSettle();

      // Text should still be present
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should not animate when animate is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '7',
            badgeColor: Colors.orange,
            textColor: Colors.white,
            size: 16.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Should not find TweenAnimationBuilder when not animating
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

      // Container should be directly rendered
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '3',
            badgeColor: Colors.purple,
            textColor: Colors.white,
            size: 20.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      // Verify it has rounded corners (half of size)
      expect(decoration.borderRadius, BorderRadius.circular(10.0));
    });

    testWidgets('should apply custom text style', (WidgetTester tester) async {
      const customStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      );

      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: 'NEW',
            badgeColor: Colors.teal,
            textColor: Colors.white,
            size: 16.0,
            textStyle: customStyle,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('NEW'));
      expect(text.style?.fontSize, 14);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.fontStyle, FontStyle.italic);
    });

    testWidgets('should handle long text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '999+',
            badgeColor: Colors.red,
            textColor: Colors.white,
            size: 16.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Text should be present and container should adjust
      expect(find.text('999+'), findsOneWidget);

      // Container should have appropriate padding for multi-character text
      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    });

    testWidgets('should use different padding for single character', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooTextBadge(
            text: '1',
            badgeColor: Colors.blue,
            textColor: Colors.white,
            size: 16.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Container should have different padding for single character
      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      );
    });
  });
}
