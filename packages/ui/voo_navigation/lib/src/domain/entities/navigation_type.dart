import 'package:flutter/material.dart';

/// Enum defining the type of navigation layout
enum VooNavigationType {
  /// Bottom navigation bar for mobile devices
  bottomNavigation,

  /// Navigation rail for tablets and medium screens
  navigationRail,

  /// Navigation drawer for larger screens or as a menu
  navigationDrawer,

  /// Extended navigation rail with labels
  extendedNavigationRail,
}

/// Extension methods for VooNavigationType
extension VooNavigationTypeExtension on VooNavigationType {
  /// Returns true if this is a rail type navigation
  bool get isRail =>
      this == VooNavigationType.navigationRail ||
      this == VooNavigationType.extendedNavigationRail;

  /// Returns true if this is a drawer type navigation
  bool get isDrawer => this == VooNavigationType.navigationDrawer;

  /// Returns true if this is a bottom navigation
  bool get isBottom => this == VooNavigationType.bottomNavigation;

  /// Returns the minimum width required for this navigation type
  double get minWidth {
    switch (this) {
      case VooNavigationType.bottomNavigation:
        return 0;
      case VooNavigationType.navigationRail:
        return 600;
      case VooNavigationType.extendedNavigationRail:
        return 840;
      case VooNavigationType.navigationDrawer:
        return 1240;
    }
  }

  /// Returns a descriptive name for the navigation type
  String get displayName {
    switch (this) {
      case VooNavigationType.bottomNavigation:
        return 'Bottom Navigation';
      case VooNavigationType.navigationRail:
        return 'Navigation Rail';
      case VooNavigationType.extendedNavigationRail:
        return 'Extended Navigation Rail';
      case VooNavigationType.navigationDrawer:
        return 'Navigation Drawer';
    }
  }
}

/// Helper class for determining navigation type based on screen size
class VooNavigationTypeHelper {
  /// Determines the navigation type based on screen width
  static VooNavigationType fromWidth(double width) {
    if (width < 600) {
      return VooNavigationType.bottomNavigation;
    } else if (width < 840) {
      return VooNavigationType.navigationRail;
    } else if (width < 1240) {
      return VooNavigationType.extendedNavigationRail;
    } else {
      return VooNavigationType.navigationDrawer;
    }
  }

  /// Determines if a floating action button should be shown
  static bool shouldShowFab(VooNavigationType type) =>
      type == VooNavigationType.bottomNavigation ||
      type == VooNavigationType.navigationRail ||
      type == VooNavigationType.extendedNavigationRail;

  /// Determines the position of the floating action button
  static FloatingActionButtonLocation getFabLocation(VooNavigationType type) {
    if (type == VooNavigationType.bottomNavigation) {
      return FloatingActionButtonLocation.centerDocked;
    }
    return FloatingActionButtonLocation.endFloat;
  }
}
