import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooAdaptiveNavigationRail', () {
    late List<VooNavigationItem> navigationItems;
    late VooNavigationConfig config;

    setUp(() {
      navigationItems = [
        const VooNavigationItem(
          id: 'dashboard',
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          route: '/dashboard',
        ),
        const VooNavigationItem(
          id: 'analytics',
          label: 'Analytics',
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          route: '/analytics',
          badgeCount: 5,
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          route: '/settings',
          showDot: true,
        ),
      ];

      config = VooNavigationConfig(
        items: navigationItems,
        selectedId: 'dashboard',
        onNavigationItemSelected: (id) {},
      );
    });

    testWidgets('should render navigation rail with items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      // Verify icons are displayed
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('should show extended rail with labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                  extended: true,
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify labels are displayed in extended mode
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should handle item selection', (WidgetTester tester) async {
      String? selectedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (id) {
                    selectedId = id;
                  },
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      // Tap on analytics item
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();

      expect(selectedId, 'analytics');
    });

    testWidgets('should display badges correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      // Check for badge count on analytics
      expect(find.text('5'), findsOneWidget);

      // Check for dot indicator on settings
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              ((widget.decoration as BoxDecoration?)?.shape == BoxShape.circle) &&
              widget.constraints?.maxWidth == 6,
        ),
        findsOneWidget,
      );
    });

    testWidgets('should animate on selection change', (WidgetTester tester) async {
      String selectedId = 'dashboard';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: Row(
                children: [
                  VooAdaptiveNavigationRail(
                    config: config,
                    selectedId: selectedId,
                    onNavigationItemSelected: (id) {
                      setState(() {
                        selectedId = id;
                      });
                    },
                  ),
                  const Expanded(child: Center(child: Text('Content'))),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially dashboard is selected
      expect(find.byIcon(Icons.dashboard), findsOneWidget);

      // Tap on analytics
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pump();

      // Animation should start
      await tester.pump(const Duration(milliseconds: 150));

      // Animation should complete
      await tester.pumpAndSettle();

      // Analytics should now show selected icon
      expect(find.byIcon(Icons.analytics), findsOneWidget);
    });

    testWidgets('should apply custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                  backgroundColor: Colors.blue.shade50,
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(VooAdaptiveNavigationRail),
              matching: find.byType(Material),
            )
            .first,
      );

      expect(material.color, Colors.blue.shade50);
    });

    testWidgets('should apply border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(VooAdaptiveNavigationRail),
              matching: find.byType(Material),
            )
            .first,
      );

      expect(material.borderRadius, const BorderRadius.horizontal(right: Radius.circular(16)));
    });

    testWidgets('should handle hover states on desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: config,
                  selectedId: 'dashboard',
                  onNavigationItemSelected: (_) {},
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      // Find the analytics item's MouseRegion
      final mouseRegion = find.byWidgetPredicate(
        (widget) => widget is MouseRegion,
      );

      expect(mouseRegion, findsWidgets);

      // Simulate hover
      final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byIcon(Icons.analytics_outlined)));
      await tester.pumpAndSettle();

      // Hover state should be applied (visual changes tested through integration tests)
    });

    testWidgets('should handle section headers', (WidgetTester tester) async {
      final sectionItems = [
        VooNavigationItem.section(
          label: 'Main',
          children: const [
            VooNavigationItem(
              id: 'home',
              label: 'Home',
              icon: Icons.home,
              route: '/home',
            ),
            VooNavigationItem(
              id: 'search',
              label: 'Search',
              icon: Icons.search,
              route: '/search',
            ),
          ],
        ),
      ];

      final sectionConfig = VooNavigationConfig(
        items: sectionItems,
        selectedId: 'home',
        groupItemsBySections: true,
        onNavigationItemSelected: (_) {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                VooAdaptiveNavigationRail(
                  config: sectionConfig,
                  selectedId: 'home',
                  onNavigationItemSelected: (_) {},
                  extended: true,
                ),
                const Expanded(child: Center(child: Text('Content'))),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find section header
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.text('Main'), findsOneWidget);
    });

    testWidgets('should animate width change when toggling extended', (WidgetTester tester) async {
      bool extended = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: Row(
                children: [
                  VooAdaptiveNavigationRail(
                    config: config,
                    selectedId: 'dashboard',
                    onNavigationItemSelected: (_) {},
                    extended: extended,
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            extended = !extended;
                          });
                        },
                        child: const Text('Toggle'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the rail container
      final railFinder = find.byType(VooAdaptiveNavigationRail);
      expect(railFinder, findsOneWidget);

      // Get the render box to check width
      RenderBox railBox = tester.renderObject(railFinder);
      expect(railBox.size.width, 88.0);

      // Toggle to extended
      await tester.tap(find.text('Toggle'));
      await tester.pump();

      // Animation starts
      await tester.pump(const Duration(milliseconds: 150));

      // Animation completes
      await tester.pumpAndSettle();

      // Check new width
      railBox = tester.renderObject(railFinder);
      expect(railBox.size.width, 256.0);
    });
  });
}
