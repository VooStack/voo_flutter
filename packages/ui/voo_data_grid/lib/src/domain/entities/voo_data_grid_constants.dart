/// Constants used throughout the VooDataGrid package
class VooDataGridConstants {
  // Private constructor to prevent instantiation
  VooDataGridConstants._();

  // Font sizes
  static const double filterFontSize = 12.0;
  static const double cellFontSize = 14.0;
  static const double headerFontSize = 14.0;
  static const double smallFontSize = 10.0;
  static const double labelFontSize = 11.0;

  // Spacing
  static const double defaultPadding = 8.0;
  static const double compactPadding = 4.0;
  static const double largePadding = 16.0;

  // Sizes
  static const double defaultRowHeight = 48.0;
  static const double compactRowHeight = 36.0;
  static const double headerHeight = 56.0;
  static const double filterRowHeight = 48.0;
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);
  static const Duration fastAnimationDuration = Duration(milliseconds: 100);
  
  // Default page sizes
  static const List<int> defaultPageSizeOptions = [10, 25, 50, 100];
  static const int defaultPageSize = 10;
  
  // Icon sizes
  static const double defaultIconSize = 18.0;
  static const double smallIconSize = 14.0;
  static const double largeIconSize = 24.0;
  
  // Border radius
  static const double defaultBorderRadius = 8.0;
  static const double smallBorderRadius = 4.0;
  static const double largeBorderRadius = 12.0;
}