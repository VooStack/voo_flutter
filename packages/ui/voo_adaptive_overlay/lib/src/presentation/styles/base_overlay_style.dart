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
      case VooOverlayStyle.outlined:
        return OutlinedOverlayStyle();
      case VooOverlayStyle.elevated:
        return ElevatedOverlayStyle();
      case VooOverlayStyle.soft:
        return SoftOverlayStyle();
      case VooOverlayStyle.dark:
        return DarkOverlayStyle();
      case VooOverlayStyle.gradient:
        return GradientOverlayStyle();
      case VooOverlayStyle.neumorphic:
        return NeumorphicOverlayStyle();
      case VooOverlayStyle.fluent:
        return FluentOverlayStyle();
      case VooOverlayStyle.brutalist:
        return BrutalistOverlayStyle();
      case VooOverlayStyle.retro:
        return RetroOverlayStyle();
      case VooOverlayStyle.neon:
        return NeonOverlayStyle();
      case VooOverlayStyle.paper:
        return PaperOverlayStyle();
      case VooOverlayStyle.frosted:
        return FrostedOverlayStyle();
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

  /// Gets the text color for this style.
  Color? getTextColor(BuildContext context) => null;

  /// Gets the icon color for this style.
  Color? getIconColor(BuildContext context) => null;
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
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(28));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(28);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(12);
      case VooOverlayType.banner:
        return BorderRadius.zero;
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// iOS/Cupertino style for overlays.
class CupertinoOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.4);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(12));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(14);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(10));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(10);
      case VooOverlayType.banner:
        return BorderRadius.zero;
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, -2),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 5;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
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
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.3);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(24));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(20);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(16);
      case VooOverlayType.banner:
        return BorderRadius.zero;
      case VooOverlayType.fullscreen:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 30,
          offset: const Offset(0, -5),
        ),
      ];

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
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black87;
  }

  @override
  Color? getIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white70 : Colors.black54;
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
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.3);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(12);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(8);
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [];

  @override
  Border? getBorder(BuildContext context) {
    final theme = Theme.of(context);
    return Border.all(color: theme.colorScheme.outlineVariant, width: 1);
  }

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Outlined style with borders and no fill.
class OutlinedOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.4);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(20));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(16);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(12));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(12);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [];

  @override
  Border? getBorder(BuildContext context) {
    final theme = Theme.of(context);
    return Border.all(color: theme.colorScheme.outline, width: 2);
  }

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Elevated style with strong shadows.
class ElevatedOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.5);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(24));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(20);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(16);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 48,
          offset: const Offset(0, 16),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Soft pastel style with gentle colors.
class SoftOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (isDark) {
      return theme.colorScheme.surfaceContainerHighest;
    }
    return theme.colorScheme.primaryContainer.withValues(alpha: 0.3);
  }

  @override
  Color getBarrierColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.primary.withValues(alpha: 0.2);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(32));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(24);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(24));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(20);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    final theme = Theme.of(context);
    return [
      BoxShadow(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Dark mode optimized style.
class DarkOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) =>
      const Color(0xFF1E1E1E);

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.7);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(20));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(16);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(12));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(12);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      );

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => Colors.white;

  @override
  Color? getIconColor(BuildContext context) => Colors.white70;
}

/// Gradient background style.
class GradientOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) =>
      Colors.transparent;

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.5);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(24));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(20);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(16));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(16);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1,
      );

  @override
  double getBlurSigma() => 0;

  LinearGradient getGradient(BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
      ],
    );
  }

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        gradient: getGradient(context),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => Colors.white;

  @override
  Color? getIconColor(BuildContext context) => Colors.white;
}

/// Neumorphism style with soft shadows.
class NeumorphicOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE8E8E8);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.3);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(28));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(24);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(20));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(16);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        const BoxShadow(
          color: Color(0xFF3D3D3D),
          blurRadius: 15,
          offset: Offset(-5, -5),
        ),
        const BoxShadow(
          color: Color(0xFF1D1D1D),
          blurRadius: 15,
          offset: Offset(5, 5),
        ),
      ];
    }
    return [
      const BoxShadow(
        color: Colors.white,
        blurRadius: 15,
        offset: Offset(-5, -5),
      ),
      const BoxShadow(
        color: Color(0xFFD0D0D0),
        blurRadius: 15,
        offset: Offset(5, 5),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Custom style using user-provided style data.
class CustomOverlayStyle implements BaseOverlayStyle {
  final VooOverlayStyleData data;

  CustomOverlayStyle(this.data);

  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) =>
      data.backgroundColor ?? Theme.of(context).colorScheme.surface;

  @override
  Color getBarrierColor(BuildContext context) =>
      data.barrierColor ?? Colors.black.withValues(alpha: 0.54);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    if (data.borderRadius != null) return data.borderRadius!;
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(16);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(8);
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => data.boxShadow ?? [];

  @override
  Border? getBorder(BuildContext context) => data.border;

  @override
  double getBlurSigma() => data.blurSigma ?? 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
        gradient: data.backgroundGradient,
      );

  @override
  Color? getTextColor(BuildContext context) => data.textColor;

  @override
  Color? getIconColor(BuildContext context) => data.iconColor;
}

/// Microsoft Fluent Design style with acrylic/mica effects.
class FluentOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const Color(0xFF2D2D2D).withValues(alpha: 0.85)
        : const Color(0xFFF3F3F3).withValues(alpha: 0.85);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.4);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(8));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(8);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(8));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(4);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.14),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.05),
      width: 1,
    );
  }

  @override
  double getBlurSigma() => 30;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Bold, stark design with hard edges and high contrast.
class BrutalistOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.black : Colors.white;
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.8);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) =>
      BorderRadius.zero;

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [];

  @override
  Border? getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(
      color: isDark ? Colors.white : Colors.black,
      width: 3,
    );
  }

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
      );

  @override
  Color? getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  @override
  Color? getIconColor(BuildContext context) => getTextColor(context);
}

/// Vintage/retro aesthetic with warm colors and rounded forms.
class RetroOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF3D2B1F) : const Color(0xFFFFF8E7);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      const Color(0xFF8B4513).withValues(alpha: 0.3);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(20));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(16);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(12));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(8);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: const Color(0xFF8B4513).withValues(alpha: 0.2),
          blurRadius: 0,
          offset: const Offset(4, 4),
        ),
        BoxShadow(
          color: const Color(0xFF8B4513).withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => Border.all(
        color: const Color(0xFF8B4513).withValues(alpha: 0.3),
        width: 2,
      );

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFFFF8E7) : const Color(0xFF3D2B1F);
  }

  @override
  Color? getIconColor(BuildContext context) =>
      const Color(0xFF8B4513);
}

/// Glowing neon borders on dark backgrounds.
class NeonOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) =>
      const Color(0xFF0A0A0F);

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.85);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(16));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(12);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(12));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(8);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) {
    final theme = Theme.of(context);
    final glowColor = theme.colorScheme.primary;
    return [
      BoxShadow(
        color: glowColor.withValues(alpha: 0.6),
        blurRadius: 20,
        spreadRadius: -2,
      ),
      BoxShadow(
        color: glowColor.withValues(alpha: 0.3),
        blurRadius: 40,
        spreadRadius: -5,
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context) {
    final theme = Theme.of(context);
    return Border.all(
      color: theme.colorScheme.primary,
      width: 2,
    );
  }

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => Colors.white;

  @override
  Color? getIconColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
}

/// Paper/card-like appearance with subtle texture.
class PaperOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFAFAFA);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.35);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(4));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(4);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(2));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(2);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) => null;

  @override
  double getBlurSigma() => 0;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) => null;

  @override
  Color? getIconColor(BuildContext context) => null;
}

/// Heavy frosted glass effect with strong blur.
class FrostedOverlayStyle implements BaseOverlayStyle {
  @override
  Color getBackgroundColor(BuildContext context, VooOverlayType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.6);
  }

  @override
  Color getBarrierColor(BuildContext context) =>
      Colors.black.withValues(alpha: 0.2);

  @override
  BorderRadius getBorderRadius(BuildContext context, VooOverlayType type) {
    switch (type) {
      case VooOverlayType.bottomSheet:
      case VooOverlayType.actionSheet:
        return const BorderRadius.vertical(top: Radius.circular(32));
      case VooOverlayType.modal:
      case VooOverlayType.popup:
      case VooOverlayType.alert:
        return BorderRadius.circular(24);
      case VooOverlayType.sideSheet:
      case VooOverlayType.drawer:
        return const BorderRadius.horizontal(left: Radius.circular(20));
      case VooOverlayType.snackbar:
      case VooOverlayType.tooltip:
        return BorderRadius.circular(16);
      case VooOverlayType.fullscreen:
      case VooOverlayType.banner:
        return BorderRadius.zero;
    }
  }

  @override
  List<BoxShadow> getBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Border? getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.6),
      width: 1.5,
    );
  }

  @override
  double getBlurSigma() => 25;

  @override
  BoxDecoration getDecoration(BuildContext context, VooOverlayType type) =>
      BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context, type),
        border: getBorder(context),
        boxShadow: getBoxShadow(context),
      );

  @override
  Color? getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black87;
  }

  @override
  Color? getIconColor(BuildContext context) => null;
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
