import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_style_data.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';

/// Base class that provides style data for overlay components.
///
/// Each style preset (Material, Cupertino, Glass, etc.) has its own
/// implementation that returns appropriate styling for the current theme.
abstract class BaseOverlayStyle {
  /// Creates the appropriate style instance for the given preset.
  factory BaseOverlayStyle.fromPreset(
    VooOverlayStyle style, {
    VooOverlayStyleData? customData,
  }) {
    switch (style) {
      case VooOverlayStyle.material:
        return MaterialOverlayStyle();
      case VooOverlayStyle.cupertino:
        return CupertinoOverlayStyle();
      case VooOverlayStyle.glass:
        return GlassOverlayStyle();
      case VooOverlayStyle.minimal:
        return MinimalOverlayStyle();
      case VooOverlayStyle.custom:
        return CustomOverlayStyle(customData ?? const VooOverlayStyleData());
    }
  }

  /// Gets the background color for the overlay surface.
  Color getBackgroundColor(BuildContext context, VooOverlayType type);

  /// Gets the barrier/scrim color.
  Color getBarrierColor(BuildContext context);

  /// Gets the border radius based on overlay type.
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type);

  /// Gets the box shadow for the overlay.
  List<BoxShadow> getBoxShadow(BuildContext context);

  /// Gets the border decoration.
  Border? getBorder(BuildContext context);

  /// Gets the blur sigma for glass effects.
  double getBlurSigma();

  /// Gets the decoration for the overlay container.
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type);
}

/// Material Design 3 style for overlays.
class MaterialOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    return theme.colorScheme.surfaceContainerHigh;
  }

  @override
  Color getBarrierColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.black.withValues(alpha: isDark ? 0.6 : 0.54);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(28));
      case VooOverlayType.modal:
        return BorderRadius.circular(28);
      case VooOverlayType.sideSheet:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) {
    return BoxDecoration(
      color: getBackgroundColor(context, type),
      borderRadius: getBorderRadius(context, type),
      boxShadow: getBoxShadow(context),
    );
  }
}

/// iOS/Cupertino style for overlays.
class CupertinoOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
  }

  @override
  Color getBarrierColor(BuildContext context) {
    return Colors.black.withValues(alpha: 0.4);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(12));
      case VooOverlayType.modal:
        return BorderRadius.circular(14);
      case VooOverlayType.sideSheet:
        return const BorderRadius.horizontal(left: Radius.circular(10));
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 16,
        offset: const Offset(0, -2),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 5;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) {
    return BoxDecoration(
      color: getBackgroundColor(context, type),
      borderRadius: getBorderRadius(context, type),
      boxShadow: getBoxShadow(context),
    );
  }
}

/// Glassmorphism style for overlays.
class GlassOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.7);
  }

  @override
  Color getBarrierColor(BuildContext context) {
    return Colors.black.withValues(alpha: 0.3);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(24));
      case VooOverlayType.modal:
        return BorderRadius.circular(20);
      case VooOverlayType.sideSheet:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 30,
        offset: const Offset(0, -5),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.2)
          : Colors.white.withValues(alpha: 0.5),
      width: 1.5,
    );
  }

  @override
  double getBlurSigma() => 15;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) {
    return BoxDecoration(
      color: getBackgroundColor(context, type),
      borderRadius: getBorderRadius(context, type),
      border: getBorder(context),
      boxShadow: getBoxShadow(context),
    );
  }
}

/// Minimal/clean style for overlays.
class MinimalOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  @override
  Color getBarrierColor(BuildContext context) {
    return Colors.black.withValues(alpha: 0.3);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case VooOverlayType.modal:
        return BorderRadius.circular(12);
      case VooOverlayType.sideSheet:
        return BorderRadius.zero;
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [];

  @override
  Border? getBorder(BuildContext context) {
    final theme = Theme.of(context);
    return Border.all(
      color: theme.colorScheme.outlineVariant,
      width: 1,
    );
  }

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) {
    return BoxDecoration(
      color: getBackgroundColor(context, type),
      borderRadius: getBorderRadius(context, type),
      border: getBorder(context),
    );
  }
}

/// Custom style using user-provided style data.
class CustomOverlayStyle implements BaseOverlayStyle {
  final VooOverlayStyleData data;

  CustomOverlayStyle(this.data);

  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    return data.backgroundColor ?? Theme.of(context).colorScheme.surface;
  }

  @override
  Color getBarrierColor(BuildContext context) {
    return data.barrierColor ?? Colors.black.withValues(alpha: 0.54);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    if (data.borderRadius != null) return data.borderRadius!;

    switch (type) {
      case VooOverlayType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case VooOverlayType.modal:
        return BorderRadius.circular(16);
      case VooOverlayType.sideSheet:
        return BorderRadius.zero;
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    return data.boxShadow ?? [];
  }

  @override
  Border? getBorder(BuildContext context) => data.border;

  @override
  double getBlurSigma() => data.blurSigma ?? 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) {
    return BoxDecoration(
      color: getBackgroundColor(context, type),
      borderRadius: getBorderRadius(context, type),
      border: getBorder(context),
      boxShadow: getBoxShadow(context),
      gradient: data.backgroundGradient,
    );
  }
}

/// Extension to apply glass effect with blur.
extension GlassEffect on Widget {
  /// Wraps the widget with a backdrop blur filter.
  Widget withGlassEffect(double sigma) {
    if (sigma <= 0) return this;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: this,
      ),
    );
  }
}
