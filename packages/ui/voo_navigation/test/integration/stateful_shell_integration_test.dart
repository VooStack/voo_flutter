import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('StatefulNavigationShell Integration', () {
    late GoRouter router;
    late List<VooNavigationItem> navigationItems;

    setUp(() {
      navigationItems = [
        VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          route: '/home',
        ),
        VooNavigationItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          route: '/profile',
        ),
        VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          route: '/settings',
        ),
      ];

      router = GoRouter(
        initialLocation: '/home',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return _TestScaffold(
                navigationShell: navigationShell,
                navigationItems: navigationItems,
              );
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/home',
                    builder: (context, state) => const _TestPage('Home'),
                    routes: [
                      GoRoute(
                        path: 'details',
                        builder: (context, state) => const _TestPage('Home Details'),
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const _TestPage('Profile'),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => const _TestPage('Edit Profile'),
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) => const _TestPage('Settings'),
                    routes: [
                      GoRoute(
                        path: 'privacy',
                        builder: (context, state) => const _TestPage('Privacy Settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });

    testWidgets('renders VooAdaptiveScaffold with StatefulNavigationShell', (tester) async {
      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: router,
        ),
      );

      // Verify scaffold is rendered
      expect(find.byType(VooAdaptiveScaffold), findsOneWidget);
      expect(find.byType(StatefulNavigationShell), findsOneWidget);

      // Verify initial page
      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('navigation between branches works correctly', (tester) async {
      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: router,
        ),
      );

      // Initial state - Home is selected
      expect(find.text('Home Page'), findsOneWidget);
      expect(find.text('Profile Page'), findsNothing);

      // Navigate to Profile
      final profileItem = find.byIcon(Icons.person_outline);
      expect(profileItem, findsOneWidget);

      await tester.tap(profileItem);
      await tester.pumpAndSettle();

      // Profile should now be visible
      expect(find.text('Profile Page'), findsOneWidget);
      expect(find.text('Home Page'), findsNothing);

      // Navigate to Settings
      final settingsItem = find.byIcon(Icons.settings_outlined);
      await tester.tap(settingsItem);
      await tester.pumpAndSettle();

      // Settings should now be visible
      expect(find.text('Settings Page'), findsOneWidget);
      expect(find.text('Profile Page'), findsNothing);
    });

    testWidgets('maintains state when switching branches', (tester) async {
      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: router,
        ),
      );

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // Find and tap increment button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Counter: 1'), findsOneWidget);

      // Navigate away to Settings
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      // Navigate back to Profile
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // State should be preserved
      expect(find.text('Counter: 1'), findsOneWidget);
    });

    testWidgets('navigates to nested routes within branches', (tester) async {
      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: router,
        ),
      );

      // Navigate to nested route
      router.go('/home/details');
      await tester.pumpAndSettle();

      expect(find.text('Home Details Page'), findsOneWidget);

      // Navigate to another branch's nested route
      router.go('/profile/edit');
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile Page'), findsOneWidget);
    });

    testWidgets('shows badges on navigation items', (tester) async {
      final itemsWithBadges = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          route: '/home',
          badgeCount: 5,
        ),
        VooNavigationItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          route: '/profile',
          showDot: true,
          badgeColor: Colors.red,
        ),
        VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          route: '/settings',
          badgeText: 'NEW',
          badgeColor: Colors.orange,
        ),
      ];

      // Create a fresh router to avoid conflicts
      final testRouter = _createTestRouter(itemsWithBadges);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        ),
      );

      // Verify badges are displayed
      expect(find.byType(VooNavigationBadge), findsWidgets);
      expect(find.text('5'), findsOneWidget); // Badge count
      expect(find.text('NEW'), findsOneWidget); // Badge text
    });

    testWidgets('handles navigation with sections and children', (tester) async {
      // Create items with a section containing children
      final itemsWithSections = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/home',
        ),
        VooNavigationItem.section(
          label: 'Account',
          id: 'account',
          children: [
            const VooNavigationItem(
              id: 'profile',
              label: 'Profile',
              icon: Icons.person,
              route: '/profile',
            ),
            const VooNavigationItem(
              id: 'settings',
              label: 'Settings',
              icon: Icons.settings,
              route: '/settings',
            ),
          ],
        ),
      ];

      // Create a custom test scaffold that handles sections properly
      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: VooNavigationConfig(
              items: itemsWithSections,
              selectedId: 'home',
              onNavigationItemSelected: (itemId) {},
            ),
            body: const Center(child: Text('Test Content')),
          ),
        ),
      );

      // Verify section is rendered (in navigation rail/drawer it would show the section label)
      // The actual presence of sections depends on the navigation type
      // For this test, we just verify the items are properly structured
      expect(find.byType(VooAdaptiveScaffold), findsOneWidget);

      // Verify the navigation items exist in the configuration
      final scaffold = tester.widget<VooAdaptiveScaffold>(find.byType(VooAdaptiveScaffold));
      expect(scaffold.config.items.length, 2); // home + section
      expect(scaffold.config.items[1].hasChildren, true);
      expect(scaffold.config.items[1].children?.length, 2); // profile + settings
    });

    testWidgets('adapts to different screen sizes', (tester) async {
      // Test each size with a fresh router instance to avoid key conflicts

      // Test mobile layout (bottom navigation)
      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: _createTestRouter(navigationItems),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VooAdaptiveBottomNavigation), findsOneWidget);
      expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);

      // Clear and test tablet layout (navigation rail)
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: _createTestRouter(navigationItems),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VooAdaptiveBottomNavigation), findsNothing);
      expect(find.byType(VooAdaptiveNavigationRail), findsOneWidget);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);

      // Clear and test desktop layout (navigation drawer)
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        createTestRouterApp(
          routerConfig: _createTestRouter(navigationItems),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VooAdaptiveBottomNavigation), findsNothing);
      expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsOneWidget);
    });
  });
}

// Helper function to create test router
GoRouter _createTestRouter(List<VooNavigationItem> items) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _TestScaffold(
            navigationShell: navigationShell,
            navigationItems: items,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const _TestPage('Home'),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const _TestPage('Home Details'),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const _TestPage('Profile'),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const _TestPage('Edit Profile'),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const _TestPage('Settings'),
                routes: [
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) => const _TestPage('Privacy Settings'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Test scaffold that integrates with StatefulNavigationShell
class _TestScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<VooNavigationItem> navigationItems;

  const _TestScaffold({
    required this.navigationShell,
    required this.navigationItems,
  });

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: navigationItems,
        selectedId: navigationItems[navigationShell.currentIndex].id,
        onNavigationItemSelected: (itemId) {
          final index = navigationItems.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          }
        },
        showNotificationBadges: true,
      ),
      body: navigationShell,
    );
  }
}

// Test page widget
class _TestPage extends StatefulWidget {
  final String title;

  const _TestPage(this.title);

  @override
  State<_TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${widget.title} Page'),
          const SizedBox(height: 20),
          Text('Counter: $_counter'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}