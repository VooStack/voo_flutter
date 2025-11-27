import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';

/// A drag handle indicator for bottom sheets and draggable overlays.
///
/// Provides visual feedback that the overlay can be dragged.
class OverlayHandle extends StatelessWidget {
  /// The width of the handle.
  final double? width;

  /// The height of the handle.
  final double? height;

  /// The color of the handle.
  final Color? color;

  /// The border radius of the handle.
  final BorderRadius? borderRadius;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Padding around the handle.
  final EdgeInsets? padding;

  const OverlayHandle({super.key, this.width, this.height, this.color, this.borderRadius, this.style = VooOverlayStyle.material, this.padding});

  double _getWidth() {
    if (width != null) return width!;
    switch (style) {
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.soft:
        return 36.0;
      case VooOverlayStyle.brutalist:
        return 48.0;
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.frosted:
      case VooOverlayStyle.custom:
        return 32.0;
    }
  }

  double _getHeight() {
    if (height != null) return height!;
    switch (style) {
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.soft:
        return 5.0;
      case VooOverlayStyle.brutalist:
        return 6.0;
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.frosted:
      case VooOverlayStyle.custom:
        return 4.0;
    }
  }

  Color _getColor(BuildContext context) {
    if (color != null) return color!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.custom:
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
      case VooOverlayStyle.cupertino:
        return isDark ? Colors.grey.shade600 : Colors.grey.shade400;
      case VooOverlayStyle.glass:
      case VooOverlayStyle.frosted:
        return isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.3);
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
        return theme.colorScheme.outline.withValues(alpha: 0.3);
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
        return Colors.white.withValues(alpha: 0.4);
      case VooOverlayStyle.brutalist:
        return isDark ? Colors.white : Colors.black;
      case VooOverlayStyle.retro:
        return const Color(0xFF8B4513).withValues(alpha: 0.5);
      case VooOverlayStyle.neon:
        return theme.colorScheme.primary.withValues(alpha: 0.7);
    }
  }

  BorderRadius _getBorderRadius() {
    if (borderRadius != null) return borderRadius!;
    return BorderRadius.circular(_getHeight() / 2);
  }

  EdgeInsets _getPadding() {
    if (padding != null) return padding!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return const EdgeInsets.symmetric(vertical: 8.0);
      case VooOverlayStyle.brutalist:
        return const EdgeInsets.symmetric(vertical: 16.0);
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.frosted:
      case VooOverlayStyle.custom:
        return const EdgeInsets.symmetric(vertical: 12.0);
    }
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Drag handle',
    hint: 'Drag to resize or dismiss',
    child: Padding(
      padding: _getPadding(),
      child: Center(
        child: Container(
          width: _getWidth(),
          height: _getHeight(),
          decoration: BoxDecoration(color: _getColor(context), borderRadius: _getBorderRadius()),
        ),
      ),
    ),
  );
}
