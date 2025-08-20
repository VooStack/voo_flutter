import 'package:flutter/material.dart';

/// Consistent theme configuration for DevTools extension
class AppTheme {
  // Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  // Border radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;

  // Component heights
  static const double filterBarHeight = 56.0;
  static const double listTileHeight = 72.0;
  static const double headerHeight = 60.0;

  // Colors for different log levels/states
  static const Map<String, Color> levelColors = {
    'verbose': Colors.grey,
    'debug': Colors.blue,
    'info': Colors.green,
    'warning': Colors.orange,
    'error': Colors.red,
    'fatal': Color(0xFF9C27B0), // Purple
  };

  // Get color for log level
  static Color getLevelColor(String level) {
    return levelColors[level.toLowerCase()] ?? Colors.grey;
  }

  // Get color for HTTP status
  static Color getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return Colors.green;
    if (statusCode >= 300 && statusCode < 400) return Colors.blue;
    if (statusCode >= 400 && statusCode < 500) return Colors.orange;
    if (statusCode >= 500) return Colors.red;
    return Colors.grey;
  }

  // Get color for duration
  static Color getDurationColor(int milliseconds) {
    if (milliseconds < 100) return Colors.green;
    if (milliseconds < 300) return Colors.lightGreen;
    if (milliseconds < 500) return Colors.lime;
    if (milliseconds < 1000) return Colors.yellow;
    if (milliseconds < 3000) return Colors.orange;
    return Colors.red;
  }

  // Text styles
  static TextStyle getMonospaceStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontFamily: 'monospace', fontSize: 12);
  }

  static TextStyle getTitleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle getSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  // Card decoration
  static BoxDecoration getCardDecoration(
    BuildContext context, {
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.5)
            : theme.colorScheme.outline.withValues(alpha: 0.2),
        width: isSelected ? 1.5 : 1,
      ),
    );
  }

  // Hover decoration
  static BoxDecoration getHoverDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
