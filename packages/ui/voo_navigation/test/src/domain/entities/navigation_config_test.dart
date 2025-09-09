import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooNavigationConfig', () {
    test('should create config with required parameters', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
      ];

      final config = VooNavigationConfig(
        items: items,
        onNavigationItemSelected: (id) {},
      );

      expect(config.items, equals(items));
      expect(config.selectedId, isNull);
      expect(config.isAdaptive, isTrue);
      expect(config.enableAnimations, isTrue);
      expect(config.enableHapticFeedback, isTrue);
    });

    test('should create config with all parameters', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/test',
        ),
      ];

      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        isAdaptive: false,
        forcedNavigationType: VooNavigationType.navigationRail,
        enableAnimations: false,
        enableHapticFeedback: false,
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.linear,
        railLabelType: NavigationRailLabelType.all,
        useExtendedRail: false,
        showNavigationRailDivider: false,
        showNotificationBadges: false,
        centerAppBarTitle: true,
        backgroundColor: Colors.white,
        navigationBackgroundColor: Colors.grey,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        indicatorColor: Colors.blue.withAlpha(30),
        indicatorShape: const RoundedRectangleBorder(),
        elevation: 4.0,
        drawerHeader: const Text('Header'),
        drawerFooter: const Text('Footer'),
        appBarLeading: const Icon(Icons.menu),
        appBarActions: [const Icon(Icons.search)],
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        breakpoints: [],
        onNavigationItemSelected: (id) {},
      );

      expect(config.items, equals(items));
      expect(config.selectedId, 'home');
      expect(config.isAdaptive, isFalse);
      expect(config.forcedNavigationType, VooNavigationType.navigationRail);
      expect(config.enableAnimations, isFalse);
      expect(config.enableHapticFeedback, isFalse);
      expect(config.animationDuration, const Duration(milliseconds: 500));
      expect(config.animationCurve, Curves.linear);
      expect(config.badgeAnimationDuration, const Duration(milliseconds: 200));
      expect(config.railLabelType, NavigationRailLabelType.all);
      expect(config.useExtendedRail, isFalse);
      expect(config.showNavigationRailDivider, isFalse);
      expect(config.showNotificationBadges, isFalse);
      expect(config.groupItemsBySections, isFalse);
      expect(config.centerAppBarTitle, isTrue);
      expect(config.backgroundColor, Colors.white);
      expect(config.navigationBackgroundColor, Colors.grey);
      expect(config.selectedItemColor, Colors.blue);
      expect(config.unselectedItemColor, Colors.black);
      expect(config.indicatorColor, Colors.blue.withAlpha(30));
      expect(config.indicatorShape, isA<RoundedRectangleBorder>());
      expect(config.elevation, 4.0);
      expect(config.drawerHeader, isNotNull);
      expect(config.drawerFooter, isNotNull);
      expect(config.appBarLeading, isNotNull);
      expect(config.appBarActions?.length, 1);
      expect(config.floatingActionButton, isNotNull);
      expect(config.floatingActionButtonAnimator, FloatingActionButtonAnimator.scaling);
      expect(config.breakpoints, isEmpty);
    });

    test('visibleItems should filter out invisible items', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
        const VooNavigationItem(
          id: 'hidden',
          label: 'Hidden',
          icon: Icons.visibility_off,
          route: '/test',
          isVisible: false,
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/test',
        ),
      ];

      final config = VooNavigationConfig(
        items: items,
        onNavigationItemSelected: (id) {},
      );

      expect(config.visibleItems.length, 2);
      expect(config.visibleItems[0].id, 'home');
      expect(config.visibleItems[1].id, 'settings');
    });

    test('selectedId should work correctly', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/test',
        ),
      ];

      final configWithSelected = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );

      final configWithoutSelected = VooNavigationConfig(
        items: items,
        onNavigationItemSelected: (id) {},
      );

      final configWithInvalidSelected = VooNavigationConfig(
        items: items,
        selectedId: 'invalid',
        onNavigationItemSelected: (id) {},
      );

      expect(configWithSelected.selectedId, 'home');
      expect(configWithoutSelected.selectedId, isNull);
      expect(configWithInvalidSelected.selectedId, 'invalid');
    });

    test('selectedItem should return correct item or null', () {
      const homeItem = VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home,
          route: '/test',
      );
      const settingsItem = VooNavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings,
          route: '/test',
      );

      final items = [homeItem, settingsItem];

      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );

      expect(config.selectedItem, equals(homeItem));

      final configNoSelection = VooNavigationConfig(
        items: items,
        onNavigationItemSelected: (id) {},
      );

      expect(configNoSelection.selectedItem, isNull);
    });

    test('copyWith should create new instance with updated values', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
      ];

      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );

      final newItems = [
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/test',
        ),
      ];

      final updatedConfig = config.copyWith(
        items: newItems,
        selectedId: 'settings',
        enableAnimations: false,
      );

      expect(updatedConfig.items, equals(newItems));
      expect(updatedConfig.selectedId, 'settings');
      expect(updatedConfig.enableAnimations, isFalse);
      expect(updatedConfig.enableHapticFeedback, isTrue); // unchanged
    });

    test('configuration callback should be called', () {
      final items = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/test',
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/test',
        ),
      ];

      String? selectedItemId;
      
      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        onNavigationItemSelected: (id) {
          selectedItemId = id;
        },
      );

      // Simulate navigation item selection
      config.onNavigationItemSelected?.call('settings');
      
      expect(selectedItemId, 'settings');
    });
  });
}