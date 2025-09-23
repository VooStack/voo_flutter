import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooAdaptiveScaffold', () {
    late List<VooNavigationItem> navigationItems;
    late VooNavigationConfig config;

    setUp(() {
      navigationItems = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/home',
        ),
        const VooNavigationItem(
          id: 'search',
          label: 'Search',
          icon: Icons.search,
          route: '/search',
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/settings',
        ),
      ];

      config = VooNavigationConfig(
        items: navigationItems,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );
    });

    testWidgets('should build scaffold with body', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test Body'), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should show bottom navigation on mobile', (
      WidgetTester tester,
    ) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Mobile')),
          ),
        ),
      );

      // Should find bottom navigation
      expect(find.byType(VooAdaptiveBottomNavigation), findsOneWidget);
      expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);
    });

    testWidgets('should show navigation rail on tablet', (
      WidgetTester tester,
    ) async {
      // Set tablet screen size
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Tablet')),
          ),
        ),
      );

      // Should find navigation rail
      expect(find.byType(VooAdaptiveNavigationRail), findsOneWidget);
      expect(find.byType(VooAdaptiveBottomNavigation), findsNothing);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);
    });

    testWidgets('should show navigation drawer on desktop', (
      WidgetTester tester,
    ) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Desktop')),
          ),
        ),
      );

      // Should find navigation drawer
      expect(find.byType(VooAdaptiveNavigationDrawer), findsOneWidget);
      expect(find.byType(VooAdaptiveBottomNavigation), findsNothing);
      expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
    });

    testWidgets('should show app bar when specified', (
      WidgetTester tester,
    ) async {
      final configWithAppBar = config.copyWith(
        appBarTitle: const Text('Test Title'),
      );

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: configWithAppBar,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      expect(find.byType(VooAdaptiveAppBar), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should show floating action button when provided', (
      WidgetTester tester,
    ) async {
      final configWithFab = config.copyWith(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: configWithFab,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should force navigation type when specified', (
      WidgetTester tester,
    ) async {
      // Set mobile size but force navigation rail
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      final forcedConfig = config.copyWith(
        isAdaptive: false,
        forcedNavigationType: VooNavigationType.navigationRail,
      );

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: forcedConfig,
            body: const Center(child: Text('Forced Rail')),
          ),
        ),
      );

      // Should show rail even on mobile size
      expect(find.byType(VooAdaptiveNavigationRail), findsOneWidget);
      expect(find.byType(VooAdaptiveBottomNavigation), findsNothing);
    });

    testWidgets('should handle navigation item selection', (
      WidgetTester tester,
    ) async {
      String? selectedId;

      // Create navigation items with onTap callbacks for testing
      final testItems = [
        VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'search',
          label: 'Search',
          icon: Icons.search,
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          onTap: () {},
        ),
      ];

      final interactiveConfig = VooNavigationConfig(
        items: testItems,
        selectedId: 'home',
        onNavigationItemSelected: (id) {
          selectedId = id;
        },
      );

      // Set mobile size for easier interaction
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: interactiveConfig,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      // Tap on search navigation item
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(selectedId, 'search');
    });

    testWidgets('should apply custom background color', (
      WidgetTester tester,
    ) async {
      final coloredConfig = config.copyWith(backgroundColor: Colors.red);

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: coloredConfig,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);

      expect(scaffold.backgroundColor, Colors.red);
    });

    testWidgets('should show extended rail at appropriate size', (
      WidgetTester tester,
    ) async {
      // Set size for extended rail
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;

      final extendedConfig = config.copyWith(useExtendedRail: true);

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: extendedConfig,
            body: const Center(child: Text('Extended')),
          ),
        ),
      );

      // Should find extended navigation rail
      final rail = tester.widget<VooAdaptiveNavigationRail>(
        find.byType(VooAdaptiveNavigationRail),
      );

      expect(rail.extended, isTrue);
    });

    // Reset view after tests
    tearDown(() {
      TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    });
  });
}
