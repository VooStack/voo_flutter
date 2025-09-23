import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooNavigationItem', () {
    test('should create basic navigation item', () {
      const item = VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home,
        route: '/test',
      );

      expect(item.id, 'home');
      expect(item.label, 'Home');
      expect(item.icon, Icons.home);
      expect(item.selectedIcon, isNull);
      expect(item.route, '/test');
      expect(item.isEnabled, isTrue);
      expect(item.isVisible, isTrue);
    });

    test('should create navigation item with all properties', () {
      const item = VooNavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        route: '/dashboard',
        tooltip: 'Go to dashboard',
        badgeCount: 5,
        badgeText: 'NEW',
        showDot: true,
        badgeColor: Colors.red,
        iconColor: Colors.blue,
        selectedIconColor: Colors.green,
        labelStyle: TextStyle(fontSize: 14),
        selectedLabelStyle: TextStyle(fontSize: 16),
        isEnabled: false,
        isVisible: false,
        sortOrder: 10,
        children: [],
        isExpanded: true,
        trailingWidget: Icon(Icons.arrow_forward),
      );

      expect(item.id, 'dashboard');
      expect(item.label, 'Dashboard');
      expect(item.icon, Icons.dashboard_outlined);
      expect(item.selectedIcon, Icons.dashboard);
      expect(item.route, '/dashboard');
      expect(item.tooltip, 'Go to dashboard');
      expect(item.badgeCount, 5);
      expect(item.badgeText, 'NEW');
      expect(item.showDot, isTrue);
      expect(item.badgeColor, Colors.red);
      expect(item.iconColor, Colors.blue);
      expect(item.selectedIconColor, Colors.green);
      expect(item.labelStyle, isNotNull);
      expect(item.selectedLabelStyle, isNotNull);
      expect(item.isEnabled, isFalse);
      expect(item.isVisible, isFalse);
      expect(item.sortOrder, 10);
      expect(item.children, isEmpty);
      expect(item.isExpanded, isTrue);
      expect(item.trailingWidget, isNotNull);
    });

    test('should create divider', () {
      final divider = VooNavigationItem.divider();

      expect(divider.id, startsWith('divider_'));
      expect(divider.label, '');
      expect(divider.icon, Icons.remove);
      expect(
        divider.isEnabled,
        isTrue,
      ); // divider has onTap callback, so it's enabled
      expect(divider.isVisible, isTrue);
    });

    test('should create section', () {
      final section = VooNavigationItem.section(
        label: 'Settings',
        children: const [
          VooNavigationItem(
            id: 'general',
            label: 'General',
            icon: Icons.settings,
            route: '/general',
          ),
          VooNavigationItem(
            id: 'privacy',
            label: 'Privacy',
            icon: Icons.lock,
            route: '/privacy',
          ),
        ],
      );

      expect(section.label, 'Settings');
      expect(
        section.id,
        'section_settings',
      ); // factory method generates 'section_' prefix
      expect(section.icon, Icons.folder_outlined);
      expect(section.selectedIcon, Icons.folder);
      expect(section.children?.length, 2);
      expect(section.hasChildren, isTrue);
      expect(section.isExpanded, isTrue);
    });

    test('effectiveSelectedIcon should return correct icon', () {
      const itemWithSelected = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: '/test',
      );

      const itemWithoutSelected = VooNavigationItem(
        id: 'test2',
        label: 'Test2',
        icon: Icons.settings,
        route: '/test2',
      );

      expect(itemWithSelected.effectiveSelectedIcon, Icons.home);
      expect(itemWithoutSelected.effectiveSelectedIcon, Icons.settings);
    });

    test('effectiveTooltip should return correct tooltip', () {
      const itemWithTooltip = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        tooltip: 'Custom tooltip',
        route: '/test',
      );

      const itemWithoutTooltip = VooNavigationItem(
        id: 'test2',
        label: 'Test Label',
        icon: Icons.settings,
        route: '/test2',
      );

      expect(itemWithTooltip.effectiveTooltip, 'Custom tooltip');
      expect(itemWithoutTooltip.effectiveTooltip, 'Test Label');
    });

    test('hasBadge should return correct value', () {
      const itemWithCount = VooNavigationItem(
        id: 'test1',
        label: 'Test1',
        icon: Icons.home,
        route: '/test1',
        badgeCount: 5,
      );

      const itemWithText = VooNavigationItem(
        id: 'test2',
        label: 'Test2',
        icon: Icons.home,
        route: '/test2',
        badgeText: 'NEW',
      );

      const itemWithDot = VooNavigationItem(
        id: 'test3',
        label: 'Test3',
        icon: Icons.home,
        route: '/test3',
        showDot: true,
      );

      const itemWithoutBadge = VooNavigationItem(
        id: 'test4',
        label: 'Test4',
        icon: Icons.home,
        route: '/test4',
      );

      expect(itemWithCount.hasBadge, isTrue);
      expect(itemWithText.hasBadge, isTrue);
      expect(itemWithDot.hasBadge, isTrue);
      expect(itemWithoutBadge.hasBadge, isFalse);
    });

    test('hasChildren should return correct value', () {
      const itemWithChildren = VooNavigationItem(
        id: 'parent',
        label: 'Parent',
        icon: Icons.folder,
        children: [
          VooNavigationItem(
            id: 'child',
            label: 'Child',
            icon: Icons.file_copy,
            route: '/child',
          ),
        ],
      );

      const itemWithEmptyChildren = VooNavigationItem(
        id: 'parent2',
        label: 'Parent2',
        icon: Icons.folder,
        children: [],
      );

      const itemWithoutChildren = VooNavigationItem(
        id: 'single',
        label: 'Single',
        icon: Icons.home,
        route: '/single',
      );

      expect(itemWithChildren.hasChildren, isTrue);
      expect(itemWithEmptyChildren.hasChildren, isFalse);
      expect(itemWithoutChildren.hasChildren, isFalse);
    });

    test('props should include all properties for Equatable', () {
      const item = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
        badgeCount: 5,
      );

      expect(item.props.length, greaterThan(0));
      expect(item.props, contains('test'));
      expect(item.props, contains('Test'));
      expect(item.props, contains(Icons.home));
      expect(item.props, contains(5));
    });

    test('should be equal when properties are same', () {
      const item1 = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
      );

      const item2 = VooNavigationItem(
        id: 'test',
        label: 'Test',
        icon: Icons.home,
        route: '/test',
      );

      const item3 = VooNavigationItem(
        id: 'different',
        label: 'Test',
        icon: Icons.home,
        route: '/different',
      );

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });
  });
}
