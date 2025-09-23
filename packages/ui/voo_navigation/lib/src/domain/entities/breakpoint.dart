import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';

/// Defines responsive breakpoints for adaptive layouts
class VooBreakpoint {
  /// The minimum width for this breakpoint
  final double minWidth;

  /// The maximum width for this breakpoint (null for no upper limit)
  final double? maxWidth;

  /// The navigation type to use at this breakpoint
  final VooNavigationType navigationType;

  /// The number of columns in the grid at this breakpoint
  final int columns;

  /// The margin/padding for this breakpoint
  final EdgeInsets margin;

  /// The gutter spacing between items
  final double gutter;

  const VooBreakpoint({required this.minWidth, this.maxWidth, required this.navigationType, required this.columns, required this.margin, required this.gutter});

  /// Checks if a given width falls within this breakpoint
  bool contains(double width) {
    if (maxWidth == null) {
      return width >= minWidth;
    }
    return width >= minWidth && width < maxWidth!;
  }

  /// Material 3 compact breakpoint (phones)
  static const compact = VooBreakpoint(
    minWidth: 0,
    maxWidth: 600,
    navigationType: VooNavigationType.bottomNavigation,
    columns: 4,
    margin: EdgeInsets.symmetric(horizontal: 16),
    gutter: 8,
  );

  /// Material 3 medium breakpoint (tablets)
  static const medium = VooBreakpoint(
    minWidth: 600,
    maxWidth: 840,
    navigationType: VooNavigationType.navigationRail,
    columns: 8,
    margin: EdgeInsets.symmetric(horizontal: 32),
    gutter: 12,
  );

  /// Material 3 expanded breakpoint (small laptops)
  static const expanded = VooBreakpoint(
    minWidth: 840,
    maxWidth: 1240,
    navigationType: VooNavigationType.extendedNavigationRail,
    columns: 12,
    margin: EdgeInsets.symmetric(horizontal: 32),
    gutter: 12,
  );

  /// Material 3 large breakpoint (desktops)
  static const large = VooBreakpoint(
    minWidth: 1240,
    maxWidth: 1440,
    navigationType: VooNavigationType.navigationDrawer,
    columns: 12,
    margin: EdgeInsets.symmetric(horizontal: 200),
    gutter: 12,
  );

  /// Material 3 extra large breakpoint (large desktops)
  static const extraLarge = VooBreakpoint(
    minWidth: 1440,
    navigationType: VooNavigationType.navigationDrawer,
    columns: 12,
    margin: EdgeInsets.symmetric(horizontal: 200),
    gutter: 12,
  );

  /// Default Material 3 breakpoints
  static const List<VooBreakpoint> material3Breakpoints = [compact, medium, expanded, large, extraLarge];

  /// Gets the current breakpoint based on screen width
  static VooBreakpoint fromWidth(double width, [List<VooBreakpoint>? breakpoints]) {
    final points = breakpoints ?? material3Breakpoints;
    for (final breakpoint in points) {
      if (breakpoint.contains(width)) {
        return breakpoint;
      }
    }
    return points.last;
  }
}
