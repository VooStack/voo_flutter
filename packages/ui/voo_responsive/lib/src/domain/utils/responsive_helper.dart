import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/breakpoint.dart';
import 'package:voo_responsive/src/domain/enums/device_type.dart';
import 'package:voo_responsive/src/domain/enums/screen_size.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1024 && width < 1440;
  }

  static bool isWidescreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1440;
  }

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return DeviceType.mobile;
    if (width < 1024) return DeviceType.tablet;
    if (width < 1440) return DeviceType.desktop;
    return DeviceType.widescreen;
  }

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return ScreenSize.extraSmall;
    if (width < 600) return ScreenSize.small;
    if (width < 1024) return ScreenSize.medium;
    if (width < 1440) return ScreenSize.large;
    return ScreenSize.extraLarge;
  }

  static Breakpoint? getCurrentBreakpoint(BuildContext context, List<Breakpoint> breakpoints) {
    final width = MediaQuery.of(context).size.width;
    for (final breakpoint in breakpoints) {
      if (breakpoint.matches(width)) {
        return breakpoint;
      }
    }
    return null;
  }

  static double getResponsiveValue<T extends num>(BuildContext context, {required T mobile, T? tablet, T? desktop, T? widescreen}) {
    if (isWidescreen(context) && widescreen != null) {
      return widescreen.toDouble();
    }
    if (isDesktop(context) && desktop != null) {
      return desktop.toDouble();
    }
    if (isTablet(context) && tablet != null) {
      return tablet.toDouble();
    }
    return mobile.toDouble();
  }

  static int getResponsiveColumns(BuildContext context, {int mobileColumns = 1, int tabletColumns = 2, int desktopColumns = 3, int widescreenColumns = 4}) {
    if (isMobile(context)) return mobileColumns;
    if (isTablet(context)) return tabletColumns;
    if (isDesktop(context)) return desktopColumns;
    return widescreenColumns;
  }
}
