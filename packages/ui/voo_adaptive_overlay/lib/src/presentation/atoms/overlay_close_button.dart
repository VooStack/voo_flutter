import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';

/// A close button for dismissing overlays.
///
/// Adapts its appearance based on the overlay style preset.
class OverlayCloseButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The icon to display.
  final IconData? icon;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Tooltip text.
  final String? tooltip;

  const OverlayCloseButton({
    super.key,
    this.onPressed,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.style = VooOverlayStyle.material,
    this.tooltip,
  });

  IconData _getIcon() {
    if (icon != null) return icon!;
    switch (style) {
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.frosted:
        return Icons.close_rounded;
      case VooOverlayStyle.material:
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.brutalist:
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.custom:
        return Icons.close;
    }
  }

  double _getIconSize() {
    if (iconSize != null) return iconSize!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return 18.0;
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.custom:
        return 24.0;
      case VooOverlayStyle.glass:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.frosted:
        return 20.0;
      case VooOverlayStyle.brutalist:
        return 22.0;
    }
  }

  Color? _getIconColor(BuildContext context) {
    if (iconColor != null) return iconColor!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.paper:
        return theme.colorScheme.onSurfaceVariant;
      case VooOverlayStyle.cupertino:
        return Colors.grey.shade600;
      case VooOverlayStyle.glass:
      case VooOverlayStyle.frosted:
        return isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87;
      case VooOverlayStyle.minimal:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
        return Colors.white.withValues(alpha: 0.9);
      case VooOverlayStyle.brutalist:
        return isDark ? Colors.white : Colors.black;
      case VooOverlayStyle.retro:
        return const Color(0xFF8B4513);
      case VooOverlayStyle.neon:
        return theme.colorScheme.primary;
      case VooOverlayStyle.custom:
        return null;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case VooOverlayStyle.material:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.custom:
        return null;
      case VooOverlayStyle.cupertino:
        return isDark
            ? Colors.grey.shade800
            : Colors.grey.shade200;
      case VooOverlayStyle.glass:
      case VooOverlayStyle.frosted:
        return Colors.white.withValues(alpha: 0.15);
      case VooOverlayStyle.soft:
        return theme.colorScheme.primaryContainer.withValues(alpha: 0.3);
      case VooOverlayStyle.dark:
        return Colors.white.withValues(alpha: 0.1);
      case VooOverlayStyle.gradient:
        return Colors.white.withValues(alpha: 0.2);
      case VooOverlayStyle.neumorphic:
        return isDark ? const Color(0xFF3D3D3D) : const Color(0xFFD8D8D8);
      case VooOverlayStyle.fluent:
        return isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05);
      case VooOverlayStyle.brutalist:
        return isDark ? Colors.white : Colors.black;
      case VooOverlayStyle.retro:
        return const Color(0xFF8B4513).withValues(alpha: 0.1);
      case VooOverlayStyle.neon:
        return theme.colorScheme.primary.withValues(alpha: 0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(context);

    Widget button;

    if (style == VooOverlayStyle.cupertino && bgColor != null) {
      button = Material(
        color: bgColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              _getIcon(),
              size: _getIconSize(),
              color: _getIconColor(context),
            ),
          ),
        ),
      );
    } else if (style == VooOverlayStyle.glass && bgColor != null) {
      button = Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(_getIcon()),
          iconSize: _getIconSize(),
          color: _getIconColor(context),
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
        ),
      );
    } else {
      button = IconButton(
        onPressed: onPressed,
        icon: Icon(_getIcon()),
        iconSize: _getIconSize(),
        color: _getIconColor(context),
        tooltip: tooltip ?? 'Close',
      );
    }

    return Semantics(
      label: tooltip ?? 'Close',
      button: true,
      child: button,
    );
  }
}
