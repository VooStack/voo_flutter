import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/breakpoint.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';

/// Helper utilities for navigation
class VooNavigationHelper {
  const VooNavigationHelper._();

  /// Determine navigation type based on screen width
  static VooNavigationType getNavigationType(
    double width, {
    List<VooBreakpoint>? customBreakpoints,
  }) {
    final breakpoints = customBreakpoints ?? VooBreakpoint.material3Breakpoints;

    // Find matching breakpoint
    for (final breakpoint in breakpoints) {
      if (width >= breakpoint.minWidth &&
          (breakpoint.maxWidth == null || width < breakpoint.maxWidth!)) {
        return breakpoint.navigationType;
      }
    }

    // Default fallback based on width
    if (width < 600) return VooNavigationType.bottomNavigation;
    if (width < 840) return VooNavigationType.navigationRail;
    if (width < 1240) return VooNavigationType.extendedNavigationRail;
    return VooNavigationType.navigationDrawer;
  }

  /// Get the current breakpoint for a given width
  static VooBreakpoint getCurrentBreakpoint(
    double width, {
    List<VooBreakpoint>? customBreakpoints,
  }) {
    final breakpoints = customBreakpoints ?? VooBreakpoint.material3Breakpoints;

    for (final breakpoint in breakpoints) {
      if (width >= breakpoint.minWidth &&
          (breakpoint.maxWidth == null || width < breakpoint.maxWidth!)) {
        return breakpoint;
      }
    }

    // Return default compact breakpoint
    return VooBreakpoint.compact;
  }

  /// Check if navigation should be shown based on config
  static bool shouldShowNavigation(
    VooNavigationConfig config,
    VooNavigationType type,
  ) {
    // If not adaptive and forced type doesn't match, don't show
    if (!config.isAdaptive && config.forcedNavigationType != null) {
      return config.forcedNavigationType == type;
    }

    // Otherwise show based on adaptive logic
    return true;
  }

  /// Get effective navigation items (filtered by visibility)
  static List<dynamic> getEffectiveItems(VooNavigationConfig config) =>
      config.items.where((item) => item.isVisible).toList();

  /// Calculate bottom navigation bar height
  static double getBottomNavigationHeight({
    bool hasLabels = true,
    bool isExtended = false,
  }) {
    if (isExtended) {
      return 80.0;
    }
    return hasLabels ? 64.0 : 56.0;
  }

  /// Calculate navigation rail width
  static double getNavigationRailWidth({
    bool isExtended = false,
    NavigationRailLabelType? labelType,
  }) {
    if (isExtended) {
      return 256.0;
    }

    switch (labelType) {
      case NavigationRailLabelType.none:
        return 72.0;
      case NavigationRailLabelType.selected:
      case NavigationRailLabelType.all:
      default:
        return 80.0;
    }
  }

  /// Calculate navigation drawer width
  static double getNavigationDrawerWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Standard Material 3 drawer width
    const standardWidth = 360.0;

    // Don't exceed 90% of screen width
    final maxWidth = screenWidth * 0.9;

    return standardWidth > maxWidth ? maxWidth : standardWidth;
  }

  /// Check if platform is mobile
  static bool isMobilePlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  /// Check if platform is desktop
  static bool isDesktopPlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux;
  }

  /// Get platform-specific padding
  static EdgeInsets getPlatformPadding(BuildContext context) {
    if (isMobilePlatform(context)) {
      return const EdgeInsets.all(8.0);
    }
    return const EdgeInsets.all(16.0);
  }

  /// Get safe area padding for navigation
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  /// Check if should use extended rail based on width
  static bool shouldUseExtendedRail(double width, VooNavigationConfig config) {
    // Respect config setting first
    if (!config.useExtendedRail) {
      return false;
    }

    // Use extended rail between 840-1240px
    return width >= 840 && width < 1240;
  }

  /// Get the appropriate FAB location based on navigation type
  static FloatingActionButtonLocation? getFabLocation(
    VooNavigationType type,
    VooNavigationConfig config,
  ) {
    if (config.floatingActionButton == null) {
      return null;
    }

    switch (type) {
      case VooNavigationType.bottomNavigation:
        return FloatingActionButtonLocation.endFloat;
      case VooNavigationType.navigationRail:
      case VooNavigationType.extendedNavigationRail:
        return FloatingActionButtonLocation.endFloat;
      case VooNavigationType.navigationDrawer:
        return FloatingActionButtonLocation.endFloat;
    }
  }

  /// Calculate responsive columns based on breakpoint
  static int getResponsiveColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = getCurrentBreakpoint(width);
    return breakpoint.columns;
  }

  /// Calculate responsive margin based on breakpoint
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = getCurrentBreakpoint(width);
    return breakpoint.margin;
  }

  /// Calculate responsive gutter based on breakpoint
  static double getResponsiveGutter(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = getCurrentBreakpoint(width);
    return breakpoint.gutter;
  }

  /// Check if navigation item has notification
  static bool hasNotification(dynamic item) =>
      item.badgeCount != null || item.badgeText != null || item.showDot == true;

  /// Count total notifications across all items
  static int getTotalNotifications(VooNavigationConfig config) {
    int total = 0;
    for (final item in config.items) {
      if (item.badgeCount != null) {
        total += item.badgeCount!;
      } else if (item.showDot == true || item.badgeText != null) {
        total += 1;
      }
    }
    return total;
  }
}
