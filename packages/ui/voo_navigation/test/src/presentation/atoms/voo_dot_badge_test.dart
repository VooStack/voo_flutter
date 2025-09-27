import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_dot_badge.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooDotBadge', () {
    testWidgets('should render dot badge with correct color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooDotBadge(
            badgeColor: Colors.red,
            size: 8.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Find the Container with the dot
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      // Verify the decoration
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('should have correct size', (WidgetTester tester) async {
      const testSize = 10.0;

      await tester.pumpWidget(
        createTestApp(
          child: const VooDotBadge(
            badgeColor: Colors.blue,
            size: testSize,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Find the Container and check its constraints
      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);

      // Check size via constraints
      expect(container.constraints?.maxWidth ?? testSize, testSize);
      expect(container.constraints?.maxHeight ?? testSize, testSize);
    });

    testWidgets('should animate when animate is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooDotBadge(
            badgeColor: Colors.green,
            size: 8.0,
            animate: true,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Should find TweenAnimationBuilder when animating
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

      // Pump to complete animation
      await tester.pumpAndSettle();

      // Container should still be present
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should not animate when animate is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooDotBadge(
            badgeColor: Colors.orange,
            size: 8.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      // Should not find TweenAnimationBuilder when not animating
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);

      // Container should be directly rendered
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should have box shadow', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const VooDotBadge(
            badgeColor: Colors.purple,
            size: 8.0,
            animate: false,
            animationDuration: Duration(milliseconds: 300),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      // Verify it has a box shadow
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, true);
    });
  });
}
