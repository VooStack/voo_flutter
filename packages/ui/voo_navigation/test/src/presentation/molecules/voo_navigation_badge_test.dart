import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooNavigationBadge', () {
    testWidgets('should show count badge', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 5,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should show text badge', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeText: 'NEW',
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('should show dot indicator', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        showDot: true,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config, size: 8),
            ),
          ),
        ),
      );

      // Should find a container with specific size
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(VooNavigationBadge),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.minWidth, 8);
      expect(container.constraints?.minHeight, 8);
    });

    testWidgets('should format large count', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 150,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('should hide when no badge data', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should use custom badge color', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 3,
        badgeColor: Colors.green,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      // Find all containers within the badge and get the one with decoration
      final badgeFinder = find.byType(VooNavigationBadge);
      final containerFinder = find.descendant(
        of: badgeFinder,
        matching: find.byType(Container),
      );

      Container? decoratedContainer;
      for (
        int i = 0;
        i < tester.widgetList<Container>(containerFinder).length;
        i++
      ) {
        final container = tester
            .widgetList<Container>(containerFinder)
            .elementAt(i);
        if (container.decoration != null) {
          decoratedContainer = container;
          break;
        }
      }

      expect(decoratedContainer, isNotNull);
      final container = decoratedContainer!;

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.green);
    });

    testWidgets('should animate badge appearance', (WidgetTester tester) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 5,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
        badgeAnimationDuration: const Duration(milliseconds: 300),
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      // Should find TweenAnimationBuilder for animation
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets('should not animate when animations disabled', (
      WidgetTester tester,
    ) async {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 5,
      );

      final config = VooNavigationConfig(
        items: [item],
        onNavigationItemSelected: (id) {},
        enableAnimations: false,
      );

      await tester.pumpWidget(
        createTestApp(
          child: Scaffold(
            body: Center(
              child: VooNavigationBadge(item: item, config: config),
            ),
          ),
        ),
      );

      // Should not find TweenAnimationBuilder when animations are disabled
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });
  });
}
