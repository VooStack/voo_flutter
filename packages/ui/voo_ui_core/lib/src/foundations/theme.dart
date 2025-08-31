import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/spacing.dart';

class VooTheme {
  static BoxDecoration getCardDecoration(
    BuildContext context, {
    bool isSelected = false,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(VooSpacing.radiusMd),
      border: Border.all(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.5)
            : theme.colorScheme.outline.withValues(alpha: 0.2),
        width: isSelected ? 1.5 : 1,
      ),
    );
  }

  static BoxDecoration getHoverDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(VooSpacing.radiusMd),
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

  static BoxDecoration getSurfaceDecoration(
    BuildContext context, {
    double? radius,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(radius ?? VooSpacing.radiusMd),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.1),
      ),
    );
  }
}