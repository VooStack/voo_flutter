import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/entities/toast_style_data.dart';
import 'package:voo_toast/src/domain/enums/toast_style.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

/// Base class that provides style data for toast components.
///
/// Each style preset (Material, Cupertino, Glass, etc.) has its own
/// implementation that returns appropriate styling for the current theme.
abstract class BaseToastStyle {
  /// Creates the appropriate style instance for the given preset.
  factory BaseToastStyle.fromPreset(
    VooToastStyle style, {
    VooToastStyleData? customData,
  }) {
    switch (style) {
      case VooToastStyle.material:
        return MaterialToastStyle();
      case VooToastStyle.cupertino:
        return CupertinoToastStyle();
      case VooToastStyle.glass:
        return GlassToastStyle();
      case VooToastStyle.minimal:
        return MinimalToastStyle();
      case VooToastStyle.outlined:
        return OutlinedToastStyle();
      case VooToastStyle.elevated:
        return ElevatedToastStyle();
      case VooToastStyle.soft:
        return SoftToastStyle();
      case VooToastStyle.dark:
        return DarkToastStyle();
      case VooToastStyle.gradient:
        return GradientToastStyle();
      case VooToastStyle.neumorphic:
        return NeumorphicToastStyle();
      case VooToastStyle.neon:
        return NeonToastStyle();
      case VooToastStyle.snackbar:
        return SnackbarToastStyle();
      case VooToastStyle.custom:
        return CustomToastStyle(customData ?? const VooToastStyleData());
    }
  }

  /// Gets the background color for the toast surface.
  Color getBackgroundColor(BuildContext context, ToastType type);

  /// Gets the border radius for the toast.
  BorderRadius getBorderRadius(BuildContext context);

  /// Gets the box shadow for the toast.
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type);

  /// Gets the border decoration.
  Border? getBorder(BuildContext context, ToastType type);

  /// Gets the blur sigma for glass effects (0 = no blur).
  double getBlurSigma();

  /// Gets the text color for this style.
  Color getTextColor(BuildContext context, ToastType type);

  /// Gets the icon color for this style.
  Color getIconColor(BuildContext context, ToastType type);

  /// Gets the icon container color.
  Color getIconContainerColor(BuildContext context, ToastType type);

  /// Gets the icon container border color.
  Color getIconContainerBorderColor(BuildContext context, ToastType type);

  /// Gets the padding inside the toast.
  EdgeInsets getPadding(BuildContext context);

  /// Gets the decoration for the toast container.
  BoxDecoration getDecoration(BuildContext context, ToastType type);

  /// Gets the gradient for gradient styles (null for solid colors).
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Material Design 3 style for toasts.
/// Uses type-specific colors from the theme's colorScheme.
class MaterialToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ToastType.success:
        return colorScheme.primary;
      case ToastType.error:
        return colorScheme.error;
      case ToastType.warning:
        return colorScheme.tertiary;
      case ToastType.info:
        return colorScheme.secondary;
      case ToastType.custom:
        return colorScheme.surfaceContainerHighest;
    }
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(16);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) {
    final shadowColor = getBackgroundColor(context, type);
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.25),
        blurRadius: 30,
        offset: const Offset(0, 12),
        spreadRadius: -5,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.15),
        blurRadius: 15,
        offset: const Offset(0, 6),
        spreadRadius: -3,
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context, ToastType type) =>
      Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5);

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ToastType.success:
        return colorScheme.onPrimary;
      case ToastType.error:
        return colorScheme.onError;
      case ToastType.warning:
        return colorScheme.onTertiary;
      case ToastType.info:
        return colorScheme.onSecondary;
      case ToastType.custom:
        return colorScheme.onSurface;
    }
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) => getTextColor(context, type);

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getTextColor(context, type).withValues(alpha: 0.15);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getTextColor(context, type).withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// iOS/Cupertino style for toasts with blur effect.
class CupertinoToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final baseColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
    };

    return baseColor.withValues(alpha: isDark ? 0.85 : 0.9);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(14);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context, ToastType type) => null;

  @override
  double getBlurSigma() => 20;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    if (type == ToastType.custom) {
      return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    }
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ToastType.success:
        return colorScheme.onPrimary;
      case ToastType.error:
        return colorScheme.onError;
      case ToastType.warning:
        return colorScheme.onTertiary;
      case ToastType.info:
        return colorScheme.onSecondary;
      case ToastType.custom:
        return colorScheme.onSurface;
    }
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) => getTextColor(context, type);

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getTextColor(context, type).withValues(alpha: 0.12);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getTextColor(context, type).withValues(alpha: 0.2);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Glassmorphism style with frosted glass effect.
class GlassToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final typeColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => isDark ? Colors.white : Colors.black,
    };

    return isDark
        ? typeColor.withValues(alpha: 0.15)
        : typeColor.withValues(alpha: 0.12);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(20);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ];

  @override
  Border? getBorder(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(
      color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.6),
      width: 1.5,
    );
  }

  @override
  double getBlurSigma() => 25;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black87;
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => getTextColor(context, type),
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.15);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Minimal/clean style with no shadows.
class MinimalToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.surfaceContainerHighest;
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(8);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [];

  @override
  Border? getBorder(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.outlineVariant,
    };
    return Border.all(color: borderColor.withValues(alpha: 0.5));
  }

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) =>
      Theme.of(context).colorScheme.onSurface;

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.onSurface,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.1);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.2);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.symmetric(horizontal: 14, vertical: 12);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Outlined style with borders and no fill.
class OutlinedToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) =>
      Theme.of(context).colorScheme.surface;

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(12);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [];

  @override
  Border? getBorder(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.outline,
    };
    return Border.all(color: borderColor, width: 2);
  }

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) =>
      Theme.of(context).colorScheme.onSurface;

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.onSurface,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.1);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Elevated style with strong 3-level shadows.
class ElevatedToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) =>
      Theme.of(context).colorScheme.surface;

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(16);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
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
  Border? getBorder(BuildContext context, ToastType type) => null;

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) =>
      Theme.of(context).colorScheme.onSurface;

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.onSurface,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.12);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.2);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Soft pastel style with gentle colors.
class SoftToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return colorScheme.surfaceContainerHighest;
    }

    return switch (type) {
      ToastType.success => colorScheme.primaryContainer,
      ToastType.error => colorScheme.errorContainer,
      ToastType.warning => colorScheme.tertiaryContainer,
      ToastType.info => colorScheme.secondaryContainer,
      ToastType.custom => colorScheme.surfaceContainerHighest,
    };
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(20);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.shadow,
    };
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.15),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  @override
  Border? getBorder(BuildContext context, ToastType type) => null;

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return colorScheme.onSurface;
    }

    return switch (type) {
      ToastType.success => colorScheme.onPrimaryContainer,
      ToastType.error => colorScheme.onErrorContainer,
      ToastType.warning => colorScheme.onTertiaryContainer,
      ToastType.info => colorScheme.onSecondaryContainer,
      ToastType.custom => colorScheme.onSurface,
    };
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.onSurface,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.15);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.25);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Dark mode optimized style.
class DarkToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) => const Color(0xFF1E1E1E);

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(12);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => Colors.white.withValues(alpha: 0.1),
    };
    return Border.all(color: borderColor.withValues(alpha: 0.5), width: 1);
  }

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) => Colors.white;

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => Colors.white70,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.15);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Gradient background style.
class GradientToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) => Colors.transparent;

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(16);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  Border? getBorder(BuildContext context, ToastType type) =>
      Border.all(color: Colors.white.withValues(alpha: 0.2));

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) => Colors.white;

  @override
  Color getIconColor(BuildContext context, ToastType type) => Colors.white;

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      Colors.white.withValues(alpha: 0.2);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      Colors.white.withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        gradient: getGradient(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient getGradient(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = switch (type) {
      ToastType.success => [colorScheme.primary, colorScheme.primaryContainer],
      ToastType.error => [colorScheme.error, colorScheme.errorContainer],
      ToastType.warning => [colorScheme.tertiary, colorScheme.tertiaryContainer],
      ToastType.info => [colorScheme.secondary, colorScheme.secondaryContainer],
      ToastType.custom => [colorScheme.primary, colorScheme.secondary],
    };
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}

/// Neumorphism style with soft shadows.
class NeumorphicToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE8E8E8);
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(20);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) {
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
  Border? getBorder(BuildContext context, ToastType type) => null;

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black87;
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => getTextColor(context, type),
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.12);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.2);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Neon/cyberpunk style with glowing borders.
class NeonToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) => const Color(0xFF0A0A0F);

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(12);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final glowColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.primary,
    };
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
  Border? getBorder(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.primary,
    };
    return Border.all(color: borderColor, width: 2);
  }

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) => Colors.white;

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.primary,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.2);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.5);

  @override
  EdgeInsets getPadding(BuildContext context) => const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Material snackbar style optimized for mobile devices.
///
/// Uses theme-semantic container colors for clear visual distinction:
/// - Success: primaryContainer / onPrimaryContainer
/// - Error: errorContainer / onErrorContainer
/// - Warning: tertiaryContainer / onTertiaryContainer
/// - Info: secondaryContainer / onSecondaryContainer
/// - Custom: inverseSurface / onInverseSurface (classic snackbar)
///
/// Full-width design with minimal border radius for a modern mobile look.
class SnackbarToastStyle implements BaseToastStyle {
  @override
  Color getBackgroundColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.primaryContainer,
      ToastType.error => colorScheme.errorContainer,
      ToastType.warning => colorScheme.tertiaryContainer,
      ToastType.info => colorScheme.secondaryContainer,
      ToastType.custom => colorScheme.inverseSurface,
    };
  }

  @override
  BorderRadius getBorderRadius(BuildContext context) => BorderRadius.circular(8);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Border? getBorder(BuildContext context, ToastType type) => null;

  @override
  double getBlurSigma() => 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (type) {
      ToastType.success => colorScheme.onPrimaryContainer,
      ToastType.error => colorScheme.onErrorContainer,
      ToastType.warning => colorScheme.onTertiaryContainer,
      ToastType.info => colorScheme.onSecondaryContainer,
      ToastType.custom => colorScheme.onInverseSurface,
    };
  }

  @override
  Color getIconColor(BuildContext context, ToastType type) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use the main semantic color for clear visual indication
    return switch (type) {
      ToastType.success => colorScheme.primary,
      ToastType.error => colorScheme.error,
      ToastType.warning => colorScheme.tertiary,
      ToastType.info => colorScheme.secondary,
      ToastType.custom => colorScheme.onInverseSurface,
    };
  }

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.15);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      getIconColor(context, type).withValues(alpha: 0.3);

  @override
  EdgeInsets getPadding(BuildContext context) =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: getBackgroundColor(context, type),
        borderRadius: getBorderRadius(context),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => null;
}

/// Custom style using user-provided style data.
class CustomToastStyle implements BaseToastStyle {
  final VooToastStyleData data;

  CustomToastStyle(this.data);

  @override
  Color getBackgroundColor(BuildContext context, ToastType type) =>
      data.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;

  @override
  BorderRadius getBorderRadius(BuildContext context) =>
      data.borderRadius ?? BorderRadius.circular(12);

  @override
  List<BoxShadow> getBoxShadow(BuildContext context, ToastType type) =>
      data.boxShadow ?? [];

  @override
  Border? getBorder(BuildContext context, ToastType type) => data.border;

  @override
  double getBlurSigma() => data.blurSigma ?? 0;

  @override
  Color getTextColor(BuildContext context, ToastType type) =>
      data.textColor ?? Theme.of(context).colorScheme.onSurface;

  @override
  Color getIconColor(BuildContext context, ToastType type) =>
      data.iconColor ?? getTextColor(context, type);

  @override
  Color getIconContainerColor(BuildContext context, ToastType type) =>
      data.iconContainerColor ?? getIconColor(context, type).withValues(alpha: 0.12);

  @override
  Color getIconContainerBorderColor(BuildContext context, ToastType type) =>
      data.iconContainerBorderColor ?? getIconColor(context, type).withValues(alpha: 0.2);

  @override
  EdgeInsets getPadding(BuildContext context) =>
      data.padding ?? const EdgeInsets.all(16);

  @override
  BoxDecoration getDecoration(BuildContext context, ToastType type) => BoxDecoration(
        color: data.backgroundGradient == null ? getBackgroundColor(context, type) : null,
        gradient: data.backgroundGradient,
        borderRadius: getBorderRadius(context),
        border: getBorder(context, type),
      );

  @override
  Gradient? getGradient(BuildContext context, ToastType type) => data.backgroundGradient;
}

/// Extension to apply glass effect with blur.
extension GlassEffect on Widget {
  /// Wraps the widget with a backdrop blur filter.
  Widget withGlassEffect(double sigma, {BorderRadius? borderRadius}) {
    if (sigma <= 0) return this;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: this,
      ),
    );
  }
}
