import 'package:flutter/material.dart';

/// Consistent spacing values used throughout the application
class AppSpacing {
  AppSpacing._();

  // Padding values
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  static const double paddingXLarge = 24.0;

  // Commonly used EdgeInsets
  static const edgeInsetsAll4 = EdgeInsets.all(paddingXSmall);
  static const edgeInsetsAll8 = EdgeInsets.all(paddingSmall);
  static const edgeInsetsAll12 = EdgeInsets.all(paddingMedium);
  static const edgeInsetsAll16 = EdgeInsets.all(paddingLarge);

  // Container padding (used in filter bars, toolbars, cards)
  static const containerPadding = EdgeInsets.all(paddingLarge);

  // Tile padding (used in list items)
  static const tilePadding = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingMedium,
  );

  // Input field content padding
  static const inputContentPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );

  // Card content padding
  static const cardPadding = EdgeInsets.all(paddingLarge);

  // Card margin
  static const cardMargin = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingSmall,
  );

  // Standard gaps between elements
  static const gapSmall = SizedBox(height: paddingSmall, width: paddingSmall);
  static const gapMedium = SizedBox(
    height: paddingMedium,
    width: paddingMedium,
  );
  static const gapLarge = SizedBox(height: paddingLarge, width: paddingLarge);

  // Vertical gaps
  static const vGap4 = SizedBox(height: paddingXSmall);
  static const vGap8 = SizedBox(height: paddingSmall);
  static const vGap12 = SizedBox(height: paddingMedium);
  static const vGap16 = SizedBox(height: paddingLarge);

  // Horizontal gaps
  static const hGap4 = SizedBox(width: paddingXSmall);
  static const hGap8 = SizedBox(width: paddingSmall);
  static const hGap12 = SizedBox(width: paddingMedium);
  static const hGap16 = SizedBox(width: paddingLarge);
}
