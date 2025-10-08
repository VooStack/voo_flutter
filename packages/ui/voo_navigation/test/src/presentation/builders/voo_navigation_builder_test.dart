import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooNavigationBuilder', () {
    test('creates empty builder', () {
      final builder = VooNavigationBuilder();
      final config = builder.buildConfig();

      expect(config.items, isEmpty);
      expect(config.isAdaptive, true);
      expect(config.enableAnimations, true);
    });

    test('adds navigation items', () {
      final builder = VooNavigationBuilder()
        ..addItem(id: 'home', label: 'Home', icon: Icons.home, route: '/home')
        ..addItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/settings',
        );

      final config = builder.buildConfig();

      expect(config.items.length, 2);
      expect(config.items.first.id, 'home');
      expect(config.items.last.id, 'settings');
    });

    test('adds items with badges', () {
      final builder = VooNavigationBuilder()
        ..addItem(
          id: 'notifications',
          label: 'Notifications',
          icon: Icons.notifications,
          badgeCount: 5,
        )
        ..addItem(
          id: 'messages',
          label: 'Messages',
          icon: Icons.message,
          showDot: true,
          badgeColor: Colors.red,
        )
        ..addItem(
          id: 'updates',
          label: 'Updates',
          icon: Icons.update,
          badgeText: 'NEW',
          badgeColor: Colors.orange,
        );

      final config = builder.buildConfig();

      expect(config.items[0].badgeCount, 5);
      expect(config.items[1].showDot, true);
      expect(config.items[1].badgeColor, Colors.red);
      expect(config.items[2].badgeText, 'NEW');
    });

    test('adds divider', () {
      final builder = VooNavigationBuilder()
        ..addItem(id: 'home', label: 'Home', icon: Icons.home)
        ..addDivider()
        ..addItem(id: 'settings', label: 'Settings', icon: Icons.settings);

      final config = builder.buildConfig();

      expect(config.items.length, 3);
      expect(config.items[1].isDivider, true);
    });

    test('adds section with children', () {
      final children = [
        VooNavigationItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person,
          route: '/profile',
        ),
        VooNavigationItem(
          id: 'security',
          label: 'Security',
          icon: Icons.security,
          route: '/security',
        ),
      ];

      final builder = VooNavigationBuilder()
        ..addSection(
          label: 'Account',
          id: 'account',
          children: children,
          isExpanded: true,
        );

      final config = builder.buildConfig();

      expect(config.items.length, 1);
      expect(config.items.first.hasChildren, true);
      expect(config.items.first.children!.length, 2);
      expect(config.items.first.isExpanded, true);
    });

    test('configures theme settings', () {
      final builder = VooNavigationBuilder()
        ..selectedId('home')
        ..railLabelType(NavigationRailLabelType.all)
        ..useExtendedRail(false)
        ..centerAppBarTitle(true)
        ..showFloatingActionButton(false)
        ..backgroundColor(Colors.grey)
        ..navigationBackgroundColor(Colors.blue)
        ..selectedItemColor(Colors.red)
        ..unselectedItemColor(Colors.grey)
        ..indicatorColor(Colors.green)
        ..elevation(8)
        ..showNavigationRailDivider(false);

      final config = builder.buildConfig();

      expect(config.selectedId, 'home');
      expect(config.railLabelType, NavigationRailLabelType.all);
      expect(config.useExtendedRail, false);
      expect(config.centerAppBarTitle, true);
      expect(config.showFloatingActionButton, false);
      expect(config.backgroundColor, Colors.grey);
      expect(config.navigationBackgroundColor, Colors.blue);
      expect(config.selectedItemColor, Colors.red);
      expect(config.unselectedItemColor, Colors.grey);
      expect(config.indicatorColor, Colors.green);
      expect(config.elevation, 8);
      expect(config.showNavigationRailDivider, false);
    });

    test('configures animation settings', () {
      final builder = VooNavigationBuilder()
        ..animationDuration(const Duration(milliseconds: 500))
        ..animationCurve(Curves.bounceIn)
        ..enableAnimations(false)
        ..enableHapticFeedback(false)
        ..persistNavigationState(false)
        ..showNotificationBadges(false)
        ..badgeAnimationDuration(const Duration(milliseconds: 100));

      final config = builder.buildConfig();

      expect(config.animationDuration, const Duration(milliseconds: 500));
      expect(config.animationCurve, Curves.bounceIn);
      expect(config.enableAnimations, false);
      expect(config.enableHapticFeedback, false);
      expect(config.persistNavigationState, false);
      expect(config.showNotificationBadges, false);
      expect(config.badgeAnimationDuration, const Duration(milliseconds: 100));
    });

    test('sets custom widgets', () {
      final drawerHeader = Container(height: 200);
      final drawerFooter = Container(height: 100);
      Widget appBarTitleBuilder(String? _) => const Text('App');
      final fab = FloatingActionButton(onPressed: () {});

      final builder = VooNavigationBuilder()
        ..drawerHeader(drawerHeader)
        ..drawerFooter(drawerFooter)
        ..appBarTitleBuilder(appBarTitleBuilder)
        ..floatingActionButton(fab)
        ..floatingActionButtonLocation(
          FloatingActionButtonLocation.centerFloat,
        );

      final config = builder.buildConfig();

      expect(config.drawerHeader, drawerHeader);
      expect(config.drawerFooter, drawerFooter);
      expect(config.appBarTitleBuilder, appBarTitleBuilder);
      expect(config.floatingActionButton, fab);
      expect(
        config.floatingActionButtonLocation,
        FloatingActionButtonLocation.centerFloat,
      );
    });

    test('sets navigation callback', () {
      String? selectedId;

      final builder = VooNavigationBuilder()
        ..onNavigationItemSelected((itemId) {
          selectedId = itemId;
        });

      final config = builder.buildConfig();

      config.onNavigationItemSelected?.call('test');
      expect(selectedId, 'test');
    });

    test('sets indicator shape', () {
      final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

      final builder = VooNavigationBuilder()..indicatorShape(shape);

      final config = builder.buildConfig();

      expect(config.indicatorShape, shape);
    });

    testWidgets('creates MaterialYou themed builder', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Builder(
            builder: (context) {
              final builder = VooNavigationBuilder.materialYou(
                context: context,
                seedColor: Colors.purple,
                brightness: Brightness.light,
              );

              final config = builder.buildConfig();

              expect(config.theme, isNotNull);
              expect(config.theme!.useMaterial3, true);
              expect(config.indicatorShape, isNotNull);
              expect(config.selectedItemColor, isNotNull);
              expect(config.unselectedItemColor, isNotNull);

              return Container();
            },
          ),
        ),
      );
    });

    test('adds multiple items at once', () {
      final items = [
        VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/home',
        ),
        VooNavigationItem(
          id: 'profile',
          label: 'Profile',
          icon: Icons.person,
          route: '/profile',
        ),
      ];

      final builder = VooNavigationBuilder()..addItems(items);

      final config = builder.buildConfig();

      expect(config.items.length, 2);
      expect(config.items.first.id, 'home');
      expect(config.items.last.id, 'profile');
    });

    test('adds pages', () {
      final builder = VooNavigationBuilder()
        ..addPage(id: 'home', page: const Text('Home'), path: '/home')
        ..addPage(id: 'profile', page: const Text('Profile'), path: '/profile');

      // Pages are stored internally
      final config = builder.buildConfig();
      expect(config.items, isEmpty); // Pages don't automatically create items
    });

    test('adds routes', () {
      final route = VooNavigationRoute.material(
        id: 'test',
        path: '/test',
        builder: (context, state) => const Text('Test'),
      );

      final builder = VooNavigationBuilder()..addRoute(route);

      final config = builder.buildConfig();
      expect(config.items, isEmpty); // Routes don't automatically create items
    });
  });
}
