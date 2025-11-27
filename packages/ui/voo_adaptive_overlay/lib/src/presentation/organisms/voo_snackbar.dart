import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// A floating snackbar at the bottom of the screen.
///
/// Snackbars are used for brief messages with optional actions.
/// They automatically dismiss after a duration.
class VooSnackbar extends StatelessWidget {
  /// The message to display.
  final String message;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional action button.
  final VooOverlayAction? action;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Whether to show close button.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Whether to use floating style.
  final bool floating;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom text color.
  final Color? textColor;

  const VooSnackbar({
    super.key,
    required this.message,
    this.icon,
    this.action,
    this.style = VooOverlayStyle.material,
    this.showCloseButton = false,
    this.onClose,
    this.floating = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark
            ? theme.colorScheme.inverseSurface
            : theme.colorScheme.surfaceContainerHighest);
    final fgColor = textColor ??
        (isDark
            ? theme.colorScheme.onInverseSurface
            : theme.colorScheme.onSurface);

    final borderRadius =
        overlayStyle.getBorderRadius(context, VooOverlayType.snackbar);
    final blurSigma = overlayStyle.getBlurSigma();

    Widget snackbar = Container(
      margin: floating
          ? const EdgeInsets.only(left: 16, right: 16, bottom: 16)
          : EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: floating ? borderRadius : BorderRadius.zero,
        boxShadow: floating ? overlayStyle.getBoxShadow(context) : null,
        border: overlayStyle.getBorder(context),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: fgColor, size: 24),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: fgColor),
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
                foregroundColor: theme.colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );

    if (blurSigma > 0 && floating) {
      snackbar = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: snackbar,
        ),
      );
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: snackbar,
      ),
    );
  }
}
