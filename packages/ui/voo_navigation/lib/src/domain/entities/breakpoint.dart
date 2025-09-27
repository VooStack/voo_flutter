import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Defines responsive breakpoints for adaptive layouts
class VooBreakpoint {
  /// Default tokens for spacing
  static const _spacingTokens = VooSpacingTokens();

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

  VooBreakpoint({
    required this.minWidth,
    this.maxWidth,
    required this.navigationType,
    required this.columns,
    required this.margin,
    required this.gutter,
  });

  /// Checks if a given width falls within this breakpoint
  bool contains(double width) {
    if (maxWidth == null) {
      return width >= minWidth;
    }
    return width >= minWidth && width < maxWidth!;
  }

  /// Material 3 compact breakpoint (phones)
  static final compact = VooBreakpoint(
    minWidth: 0,
    maxWidth: 600,
    navigationType: VooNavigationType.bottomNavigation,
    columns: 4,
    margin: EdgeInsets.symmetric(horizontal: _spacingTokens.md),
    gutter: _spacingTokens.sm,
  );

  /// Material 3 medium breakpoint (tablets)
  static final medium = VooBreakpoint(
    minWidth: 600,
    maxWidth: 840,
    navigationType: VooNavigationType.navigationRail,
    columns: 8,
    margin: EdgeInsets.symmetric(horizontal: _spacingTokens.xl),
    gutter: _spacingTokens.sm + _spacingTokens.xs,
  );

  /// Material 3 expanded breakpoint (small laptops)
  static final expanded = VooBreakpoint(
    minWidth: 840,
    maxWidth: 1240,
    navigationType: VooNavigationType.extendedNavigationRail,
    columns: 12,
    margin: EdgeInsets.symmetric(horizontal: _spacingTokens.xl),
    gutter: _spacingTokens.sm + _spacingTokens.xs,
  );

  /// Material 3 large breakpoint (desktops)
  static final large = VooBreakpoint(
    minWidth: 1240,
    maxWidth: 1440,
    navigationType: VooNavigationType.navigationDrawer,
    columns: 12,
    margin: EdgeInsets.symmetric(
      horizontal: _spacingTokens.xxxl * 3 + _spacingTokens.sm,
    ),
    gutter: _spacingTokens.sm + _spacingTokens.xs,
  );

  /// Material 3 extra large breakpoint (large desktops)
  static final extraLarge = VooBreakpoint(
    minWidth: 1440,
    navigationType: VooNavigationType.navigationDrawer,
    columns: 12,
    margin: EdgeInsets.symmetric(
      horizontal: _spacingTokens.xxxl * 3 + _spacingTokens.sm,
    ),
    gutter: _spacingTokens.sm + _spacingTokens.xs,
  );

  /// Default Material 3 breakpoints
  static final List<VooBreakpoint> material3Breakpoints = [
    compact,
    medium,
    expanded,
    large,
    extraLarge,
  ];

  /// Gets the current breakpoint based on screen width
  static VooBreakpoint fromWidth(
    double width, [
    List<VooBreakpoint>? breakpoints,
  ]) {
    final points = breakpoints ?? material3Breakpoints;
    for (final breakpoint in points) {
      if (breakpoint.contains(width)) {
        return breakpoint;
      }
    }
    return points.last;
  }
}
