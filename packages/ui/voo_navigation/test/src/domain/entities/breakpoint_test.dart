import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  group('VooBreakpoint', () {
    test('should create breakpoint with required parameters', () {
      var breakpoint = VooBreakpoint.medium;

      expect(breakpoint.minWidth, 600);
      expect(breakpoint.maxWidth, 840);
      expect(breakpoint.navigationType, VooNavigationType.navigationRail);
      expect(breakpoint.columns, 8);
      expect(breakpoint.margin, const EdgeInsets.symmetric(horizontal: 32));
      expect(breakpoint.gutter, 12);
    });

    test('contains should correctly identify width ranges', () {
      var breakpoint = VooBreakpoint.medium;

      expect(breakpoint.contains(599), isFalse);
      expect(breakpoint.contains(600), isTrue);
      expect(breakpoint.contains(720), isTrue);
      expect(breakpoint.contains(839), isTrue);
      expect(breakpoint.contains(840), isFalse);
      expect(breakpoint.contains(1000), isFalse);
    });

    test('contains should handle null maxWidth', () {
      var breakpoint = VooBreakpoint(
        minWidth: 1240,
        navigationType: VooNavigationType.navigationDrawer,
        columns: 12,
        margin: EdgeInsets.symmetric(horizontal: 200),
        gutter: 12,
      );

      expect(breakpoint.contains(1239), isFalse);
      expect(breakpoint.contains(1240), isTrue);
      expect(breakpoint.contains(1500), isTrue);
      expect(breakpoint.contains(9999), isTrue);
    });

    test('compact breakpoint should have correct values', () {
      expect(VooBreakpoint.compact.minWidth, 0);
      expect(VooBreakpoint.compact.maxWidth, 600);
      expect(
        VooBreakpoint.compact.navigationType,
        VooNavigationType.bottomNavigation,
      );
      expect(VooBreakpoint.compact.columns, 4);
      expect(
        VooBreakpoint.compact.margin,
        const EdgeInsets.symmetric(horizontal: 16),
      );
      expect(VooBreakpoint.compact.gutter, 8);
    });

    test('medium breakpoint should have correct values', () {
      expect(VooBreakpoint.medium.minWidth, 600);
      expect(VooBreakpoint.medium.maxWidth, 840);
      expect(
        VooBreakpoint.medium.navigationType,
        VooNavigationType.navigationRail,
      );
      expect(VooBreakpoint.medium.columns, 8);
      expect(
        VooBreakpoint.medium.margin,
        const EdgeInsets.symmetric(horizontal: 32),
      );
      expect(VooBreakpoint.medium.gutter, 12);
    });

    test('expanded breakpoint should have correct values', () {
      expect(VooBreakpoint.expanded.minWidth, 840);
      expect(VooBreakpoint.expanded.maxWidth, 1240);
      expect(
        VooBreakpoint.expanded.navigationType,
        VooNavigationType.extendedNavigationRail,
      );
      expect(VooBreakpoint.expanded.columns, 12);
      expect(
        VooBreakpoint.expanded.margin,
        const EdgeInsets.symmetric(horizontal: 32),
      );
      expect(VooBreakpoint.expanded.gutter, 12);
    });

    test('large breakpoint should have correct values', () {
      expect(VooBreakpoint.large.minWidth, 1240);
      expect(VooBreakpoint.large.maxWidth, 1440);
      expect(
        VooBreakpoint.large.navigationType,
        VooNavigationType.navigationDrawer,
      );
      expect(VooBreakpoint.large.columns, 12);
      expect(
        VooBreakpoint.large.margin,
        const EdgeInsets.symmetric(horizontal: 200),
      );
      expect(VooBreakpoint.large.gutter, 12);
    });

    test('extraLarge breakpoint should have correct values', () {
      expect(VooBreakpoint.extraLarge.minWidth, 1440);
      expect(VooBreakpoint.extraLarge.maxWidth, isNull);
      expect(
        VooBreakpoint.extraLarge.navigationType,
        VooNavigationType.navigationDrawer,
      );
      expect(VooBreakpoint.extraLarge.columns, 12);
      expect(
        VooBreakpoint.extraLarge.margin,
        const EdgeInsets.symmetric(horizontal: 200),
      );
      expect(VooBreakpoint.extraLarge.gutter, 12);
    });

    test('material3Breakpoints should contain all default breakpoints', () {
      expect(VooBreakpoint.material3Breakpoints.length, 5);
      expect(VooBreakpoint.material3Breakpoints[0], VooBreakpoint.compact);
      expect(VooBreakpoint.material3Breakpoints[1], VooBreakpoint.medium);
      expect(VooBreakpoint.material3Breakpoints[2], VooBreakpoint.expanded);
      expect(VooBreakpoint.material3Breakpoints[3], VooBreakpoint.large);
      expect(VooBreakpoint.material3Breakpoints[4], VooBreakpoint.extraLarge);
    });

    test('fromWidth should return correct breakpoint', () {
      // Test with default breakpoints
      expect(VooBreakpoint.fromWidth(300), VooBreakpoint.compact);
      expect(VooBreakpoint.fromWidth(599), VooBreakpoint.compact);
      expect(VooBreakpoint.fromWidth(600), VooBreakpoint.medium);
      expect(VooBreakpoint.fromWidth(839), VooBreakpoint.medium);
      expect(VooBreakpoint.fromWidth(840), VooBreakpoint.expanded);
      expect(VooBreakpoint.fromWidth(1239), VooBreakpoint.expanded);
      expect(VooBreakpoint.fromWidth(1240), VooBreakpoint.large);
      expect(VooBreakpoint.fromWidth(1439), VooBreakpoint.large);
      expect(VooBreakpoint.fromWidth(1440), VooBreakpoint.extraLarge);
      expect(VooBreakpoint.fromWidth(2000), VooBreakpoint.extraLarge);
    });

    test('fromWidth should work with custom breakpoints', () {
      var customBreakpoints = [
        VooBreakpoint(
          minWidth: 0,
          maxWidth: 500,
          navigationType: VooNavigationType.bottomNavigation,
          columns: 4,
          margin: EdgeInsets.all(8),
          gutter: 4,
        ),
        VooBreakpoint(
          minWidth: 500,
          maxWidth: 1000,
          navigationType: VooNavigationType.navigationRail,
          columns: 6,
          margin: EdgeInsets.all(16),
          gutter: 8,
        ),
        VooBreakpoint(
          minWidth: 1000,
          navigationType: VooNavigationType.navigationDrawer,
          columns: 12,
          margin: EdgeInsets.all(32),
          gutter: 16,
        ),
      ];

      expect(
        VooBreakpoint.fromWidth(250, customBreakpoints),
        customBreakpoints[0],
      );
      expect(
        VooBreakpoint.fromWidth(500, customBreakpoints),
        customBreakpoints[1],
      );
      expect(
        VooBreakpoint.fromWidth(750, customBreakpoints),
        customBreakpoints[1],
      );
      expect(
        VooBreakpoint.fromWidth(1000, customBreakpoints),
        customBreakpoints[2],
      );
      expect(
        VooBreakpoint.fromWidth(1500, customBreakpoints),
        customBreakpoints[2],
      );
    });
  });
}
