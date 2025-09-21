import 'package:flutter/material.dart';

extension ResponsiveExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024 && screenWidth < 1440;
  bool get isWidescreen => screenWidth >= 1440;
}
