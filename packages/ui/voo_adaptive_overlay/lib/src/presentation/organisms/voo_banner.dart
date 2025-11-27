import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// The position of the banner on the screen.
enum VooBannerPosition {
  /// Top of the screen.
  top,

  /// Bottom of the screen.
  bottom,
}

/// The type/severity of a banner message.
enum VooBannerType {
  /// Informational message.
  info,

  /// Success message.
  success,

  /// Warning message.
  warning,

  /// Error message.
  error,

  /// Neutral/default message.
  neutral,
}

/// A full-width banner overlay at the top or bottom of the screen.
///
/// Great for important notices, promotions, or system messages.
class VooBanner extends StatelessWidget {
  /// The message to display.
  final String message;

  /// Optional title text.
  final String? title;

  /// Optional icon to display.
  final IconData? icon;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Position on screen.
  final VooBannerPosition position;

  /// Type/severity of the banner.
  final VooBannerType type;

  /// Optional action button.
  final VooOverlayAction? action;

  /// Whether to show a close button.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Custom background color (overrides type color).
  final Color? backgroundColor;

  /// Custom text color.
  final Color? textColor;

  /// Custom icon color.
  final Color? iconColor;

  /// Whether to include padding for safe area.
  final bool useSafeArea;

  const VooBanner({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.style = VooOverlayStyle.material,
    this.position = VooBannerPosition.top,
    this.type = VooBannerType.neutral,
    this.action,
    this.showCloseButton = true,
    this.onClose,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.useSafeArea = true,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case VooBannerType.success:
        return isDark ? const Color(0xFF1B5E20) : const Color(0xFF4CAF50);
      case VooBannerType.error:
        return isDark ? const Color(0xFFB71C1C) : const Color(0xFFF44336);
      case VooBannerType.warning:
        return isDark ? const Color(0xFFE65100) : const Color(0xFFFF9800);
      case VooBannerType.info:
        return isDark ? const Color(0xFF0D47A1) : const Color(0xFF2196F3);
      case VooBannerType.neutral:
        return theme.colorScheme.surfaceContainerHigh;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (textColor != null) return textColor!;

    final theme = Theme.of(context);
    if (type == VooBannerType.neutral) {
      return theme.colorScheme.onSurface;
    }
    return Colors.white;
  }

  IconData? _getIcon() {
    if (icon != null) return icon;

    switch (type) {
      case VooBannerType.success:
        return Icons.check_circle;
      case VooBannerType.error:
        return Icons.error;
      case VooBannerType.warning:
        return Icons.warning_amber;
      case VooBannerType.info:
        return Icons.info;
      case VooBannerType.neutral:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final blurSigma = overlayStyle.getBlurSigma();
    final theme = Theme.of(context);

    final bgColor = _getBackgroundColor(context);
    final fgColor = _getTextColor(context);
    final bannerIcon = _getIcon();

    Widget banner = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: position == VooBannerPosition.top
                ? const Offset(0, 2)
                : const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: useSafeArea && position == VooBannerPosition.top,
        bottom: useSafeArea && position == VooBannerPosition.bottom,
        left: useSafeArea,
        right: useSafeArea,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (bannerIcon != null) ...[
                Icon(
                  bannerIcon,
                  color: iconColor ?? fgColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: fgColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    action!.onPressed?.call();
                    if (action!.autoPop) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: fgColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: Text(
                    action!.label.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              if (showCloseButton) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: fgColor, size: 20),
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (blurSigma > 0) {
      banner = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: banner,
        ),
      );
    }

    return Align(
      alignment: position == VooBannerPosition.top
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      child: banner,
    );
  }
}
