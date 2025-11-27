import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';

/// A backdrop/scrim widget that appears behind the overlay.
///
/// Supports different styles including solid color, blur effect,
/// and gradients for glassmorphism effects.
class OverlayBarrier extends StatelessWidget {
  /// The color of the barrier.
  final Color? color;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Callback when the barrier is tapped.
  final VoidCallback? onTap;

  /// Whether the barrier is dismissible.
  final bool isDismissible;

  /// The opacity of the barrier animation.
  final Animation<double>? animation;

  /// Blur sigma for glass effect.
  final double? blurSigma;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  const OverlayBarrier({
    super.key,
    this.color,
    this.style = VooOverlayStyle.material,
    this.onTap,
    this.isDismissible = true,
    this.animation,
    this.blurSigma,
    this.semanticLabel,
  });

  Color _getBarrierColor(BuildContext context) {
    if (color != null) return color!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case VooOverlayStyle.material:
        return Colors.black.withValues(alpha: isDark ? 0.6 : 0.54);
      case VooOverlayStyle.cupertino:
        return Colors.black.withValues(alpha: 0.4);
      case VooOverlayStyle.glass:
        return Colors.black.withValues(alpha: 0.3);
      case VooOverlayStyle.minimal:
        return Colors.black.withValues(alpha: 0.3);
      case VooOverlayStyle.custom:
        return Colors.black.withValues(alpha: 0.54);
    }
  }

  double _getBlurSigma() {
    if (blurSigma != null) return blurSigma!;

    switch (style) {
      case VooOverlayStyle.glass:
        return 10.0;
      case VooOverlayStyle.cupertino:
        return 5.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final barrierColor = _getBarrierColor(context);
    final sigma = _getBlurSigma();

    Widget barrier = Container(color: barrierColor);

    if (sigma > 0) {
      barrier = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: barrier,
      );
    }

    if (animation != null) {
      barrier = FadeTransition(
        opacity: animation!,
        child: barrier,
      );
    }

    if (isDismissible && onTap != null) {
      barrier = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: barrier,
      );
    }

    return Semantics(
      label: semanticLabel ?? 'Close overlay',
      button: isDismissible,
      excludeSemantics: !isDismissible,
      child: barrier,
    );
  }
}
