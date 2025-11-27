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

  const OverlayHandle({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.style = VooOverlayStyle.material,
    this.padding,
  });

  double _getWidth() {
    if (width != null) return width!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return 36.0;
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.custom:
        return 32.0;
    }
  }

  double _getHeight() {
    if (height != null) return height!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return 5.0;
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
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
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
      case VooOverlayStyle.cupertino:
        return isDark
            ? Colors.grey.shade600
            : Colors.grey.shade400;
      case VooOverlayStyle.glass:
        return Colors.white.withValues(alpha: 0.5);
      case VooOverlayStyle.minimal:
        return theme.colorScheme.outline.withValues(alpha: 0.3);
      case VooOverlayStyle.custom:
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
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
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.custom:
        return const EdgeInsets.symmetric(vertical: 12.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Drag handle',
      hint: 'Drag to resize or dismiss',
      child: Padding(
        padding: _getPadding(),
        child: Center(
          child: Container(
            width: _getWidth(),
            height: _getHeight(),
            decoration: BoxDecoration(
              color: _getColor(context),
              borderRadius: _getBorderRadius(),
            ),
          ),
        ),
      ),
    );
  }
}
