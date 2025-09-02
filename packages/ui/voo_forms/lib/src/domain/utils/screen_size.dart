import 'package:flutter/material.dart';

/// Screen size breakpoints and utilities
class VooScreenSize {
  /// Mobile breakpoint (phones)
  static const double mobile = 600;
  
  /// Large breakpoint (tablets)
  static const double large = 1024;
  
  /// Extra large breakpoint (desktops)
  static const double extraLarge = 1440;
  
  /// Get current screen type based on width
  static ScreenType getType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobile) {
      return ScreenType.mobile;
    } else if (width < large) {
      return ScreenType.tablet;
    } else if (width < extraLarge) {
      return ScreenType.desktop;
    } else {
      return ScreenType.extraLarge;
    }
  }
  
  /// Check if screen is mobile
  static bool isMobile(BuildContext context) => 
      getType(context) == ScreenType.mobile;
  
  /// Check if screen is tablet
  static bool isTablet(BuildContext context) => 
      getType(context) == ScreenType.tablet;
  
  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) => 
      getType(context) == ScreenType.desktop;
  
  /// Check if screen is extra large
  static bool isExtraLarge(BuildContext context) => 
      getType(context) == ScreenType.extraLarge;
}

/// Screen type enum
enum ScreenType {
  mobile,
  tablet,
  desktop,
  extraLarge,
}