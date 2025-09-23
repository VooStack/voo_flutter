import 'package:flutter/material.dart';

/// Theme configuration for VooDataGrid
class VooDataGridTheme {
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color rowBackgroundColor;
  final Color alternateRowBackgroundColor;
  final Color selectedRowBackgroundColor;
  final Color hoveredRowBackgroundColor;
  final Color borderColor;
  final Color gridLineColor;
  final TextStyle headerTextStyle;
  final TextStyle cellTextStyle;
  final double borderWidth;

  const VooDataGridTheme({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.rowBackgroundColor,
    required this.alternateRowBackgroundColor,
    required this.selectedRowBackgroundColor,
    required this.hoveredRowBackgroundColor,
    required this.borderColor,
    required this.gridLineColor,
    required this.headerTextStyle,
    required this.cellTextStyle,
    this.borderWidth = 1.0,
  });

  factory VooDataGridTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return VooDataGridTheme(
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerTextColor: colorScheme.onSurface,
      rowBackgroundColor: colorScheme.surface,
      alternateRowBackgroundColor: colorScheme.surfaceContainerLowest,
      selectedRowBackgroundColor: colorScheme.primaryContainer,
      hoveredRowBackgroundColor: colorScheme.surfaceContainerHigh,
      borderColor: colorScheme.outline,
      gridLineColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
      headerTextStyle: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
      cellTextStyle: theme.textTheme.bodyMedium!,
    );
  }
}
