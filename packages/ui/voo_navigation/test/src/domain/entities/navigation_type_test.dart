import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooNavigationType', () {
    test('should have correct values', () {
      expect(VooNavigationType.values.length, 4);
      expect(
        VooNavigationType.values,
        contains(VooNavigationType.bottomNavigation),
      );
      expect(
        VooNavigationType.values,
        contains(VooNavigationType.navigationRail),
      );
      expect(
        VooNavigationType.values,
        contains(VooNavigationType.extendedNavigationRail),
      );
      expect(
        VooNavigationType.values,
        contains(VooNavigationType.navigationDrawer),
      );
    });

    test('isBottom should return correct value', () {
      expect(VooNavigationType.bottomNavigation.isBottom, isTrue);
      expect(VooNavigationType.navigationRail.isBottom, isFalse);
      expect(VooNavigationType.extendedNavigationRail.isBottom, isFalse);
      expect(VooNavigationType.navigationDrawer.isBottom, isFalse);
    });

    test('isRail should return correct value', () {
      expect(VooNavigationType.bottomNavigation.isRail, isFalse);
      expect(VooNavigationType.navigationRail.isRail, isTrue);
      expect(VooNavigationType.extendedNavigationRail.isRail, isTrue);
      expect(VooNavigationType.navigationDrawer.isRail, isFalse);
    });

    test('isDrawer should return correct value', () {
      expect(VooNavigationType.bottomNavigation.isDrawer, isFalse);
      expect(VooNavigationType.navigationRail.isDrawer, isFalse);
      expect(VooNavigationType.extendedNavigationRail.isDrawer, isFalse);
      expect(VooNavigationType.navigationDrawer.isDrawer, isTrue);
    });

    test('minWidth should return correct values', () {
      expect(VooNavigationType.bottomNavigation.minWidth, 0);
      expect(VooNavigationType.navigationRail.minWidth, 600);
      expect(VooNavigationType.extendedNavigationRail.minWidth, 840);
      expect(VooNavigationType.navigationDrawer.minWidth, 1240);
    });

    test('displayName should return correct names', () {
      expect(
        VooNavigationType.bottomNavigation.displayName,
        'Bottom Navigation',
      );
      expect(VooNavigationType.navigationRail.displayName, 'Navigation Rail');
      expect(
        VooNavigationType.extendedNavigationRail.displayName,
        'Extended Navigation Rail',
      );
      expect(
        VooNavigationType.navigationDrawer.displayName,
        'Navigation Drawer',
      );
    });
  });

  group('VooNavigationTypeHelper', () {
    test('fromWidth should return correct navigation type', () {
      expect(
        VooNavigationTypeHelper.fromWidth(300),
        VooNavigationType.bottomNavigation,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(599),
        VooNavigationType.bottomNavigation,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(600),
        VooNavigationType.navigationRail,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(839),
        VooNavigationType.navigationRail,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(840),
        VooNavigationType.extendedNavigationRail,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(1239),
        VooNavigationType.extendedNavigationRail,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(1240),
        VooNavigationType.navigationDrawer,
      );
      expect(
        VooNavigationTypeHelper.fromWidth(1920),
        VooNavigationType.navigationDrawer,
      );
    });

    test('shouldShowFab should return correct value', () {
      expect(
        VooNavigationTypeHelper.shouldShowFab(
          VooNavigationType.bottomNavigation,
        ),
        isTrue,
      );
      expect(
        VooNavigationTypeHelper.shouldShowFab(VooNavigationType.navigationRail),
        isTrue,
      );
      expect(
        VooNavigationTypeHelper.shouldShowFab(
          VooNavigationType.extendedNavigationRail,
        ),
        isTrue,
      );
      expect(
        VooNavigationTypeHelper.shouldShowFab(
          VooNavigationType.navigationDrawer,
        ),
        isFalse,
      );
    });

    test('getFabLocation should return correct location', () {
      expect(
        VooNavigationTypeHelper.getFabLocation(
          VooNavigationType.bottomNavigation,
        ),
        FloatingActionButtonLocation.centerDocked,
      );
      expect(
        VooNavigationTypeHelper.getFabLocation(
          VooNavigationType.navigationRail,
        ),
        FloatingActionButtonLocation.endFloat,
      );
      expect(
        VooNavigationTypeHelper.getFabLocation(
          VooNavigationType.extendedNavigationRail,
        ),
        FloatingActionButtonLocation.endFloat,
      );
      expect(
        VooNavigationTypeHelper.getFabLocation(
          VooNavigationType.navigationDrawer,
        ),
        FloatingActionButtonLocation.endFloat,
      );
    });
  });
}
