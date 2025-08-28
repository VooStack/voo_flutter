import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/design_system/design_system.dart';

/// Material Design System implementation
/// Standard Material Design 3 tokens
class MaterialDesignTokens extends DesignSystem {
  final bool isDarkMode;
  final ColorScheme? colorScheme;
  
  MaterialDesignTokens({this.isDarkMode = false, this.colorScheme});
  
  @override
  DesignSystemType get type => DesignSystemType.material;
  
  @override
  DesignColorTokens get colors => MaterialColorTokens(
    colorScheme: colorScheme ?? (isDarkMode 
      ? const ColorScheme.dark() 
      : const ColorScheme.light()),
  );
  
  @override
  DesignTypographyTokens get typography => MaterialTypography();
  
  @override
  DesignSpacingTokens get spacing => MaterialSpacing();
  
  @override
  DesignRadiusTokens get radius => MaterialRadius();
  
  @override
  DesignElevationTokens get elevation => MaterialElevation();
  
  @override
  DesignAnimationTokens get animation => MaterialAnimation();
  
  @override
  DesignIconTokens get icons => MaterialIcons();
  
  @override
  ComponentStyles get components => MaterialComponentStyles(this);
  
  @override
  ThemeData toThemeData({bool isDark = false}) {
    // Use standard Material Theme generation
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? (isDark 
        ? const ColorScheme.dark() 
        : const ColorScheme.light()),
    );
  }
}

/// Material Color Tokens
class MaterialColorTokens extends DesignColorTokens {
  final ColorScheme colorScheme;
  
  MaterialColorTokens({required this.colorScheme});
  
  @override Color get primary => colorScheme.primary;
  @override Color get onPrimary => colorScheme.onPrimary;
  @override Color get primaryContainer => colorScheme.primaryContainer;
  @override Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  
  @override Color get secondary => colorScheme.secondary;
  @override Color get onSecondary => colorScheme.onSecondary;
  @override Color get secondaryContainer => colorScheme.secondaryContainer;
  @override Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  
  @override Color get tertiary => colorScheme.tertiary;
  @override Color get onTertiary => colorScheme.onTertiary;
  @override Color get tertiaryContainer => colorScheme.tertiaryContainer;
  @override Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  
  @override Color get error => colorScheme.error;
  @override Color get onError => colorScheme.onError;
  @override Color get errorContainer => colorScheme.errorContainer;
  @override Color get onErrorContainer => colorScheme.onErrorContainer;
  
  // Material doesn't have explicit success/warning/info, so we use semantic colors
  @override Color get success => Colors.green;
  @override Color get onSuccess => Colors.white;
  @override Color get successContainer => Colors.green.shade100;
  @override Color get onSuccessContainer => Colors.green.shade900;
  
  @override Color get warning => Colors.orange;
  @override Color get onWarning => Colors.white;
  @override Color get warningContainer => Colors.orange.shade100;
  @override Color get onWarningContainer => Colors.orange.shade900;
  
  @override Color get info => Colors.blue;
  @override Color get onInfo => Colors.white;
  @override Color get infoContainer => Colors.blue.shade100;
  @override Color get onInfoContainer => Colors.blue.shade900;
  
  @override Color get surface => colorScheme.surface;
  @override Color get onSurface => colorScheme.onSurface;
  @override Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  @override Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  @override Color get surfaceTint => colorScheme.surfaceTint;
  
  @override Color get background => colorScheme.surface;
  @override Color get onBackground => colorScheme.onSurface;
  
  @override Color get outline => colorScheme.outline;
  @override Color get outlineVariant => colorScheme.outlineVariant;
  
  @override Color get inverseSurface => colorScheme.inverseSurface;
  @override Color get onInverseSurface => colorScheme.onInverseSurface;
  @override Color get inversePrimary => colorScheme.inversePrimary;
  
  @override Color get shadow => colorScheme.shadow;
  @override Color get scrim => colorScheme.scrim;
}

/// Material Typography
class MaterialTypography extends DesignTypographyTokens {
  @override String get fontFamily => 'Roboto';
  @override String get monospaceFontFamily => 'Roboto Mono';
  
  // Material 3 Typography Scale
  @override TextStyle get displayLarge => const TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  @override TextStyle get displayMedium => const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );
  
  @override TextStyle get displaySmall => const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );
  
  @override TextStyle get headlineLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );
  
  @override TextStyle get headlineMedium => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );
  
  @override TextStyle get headlineSmall => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );
  
  @override TextStyle get titleLarge => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );
  
  @override TextStyle get titleMedium => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  @override TextStyle get titleSmall => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  @override TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  @override TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  @override TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  @override TextStyle get labelLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  @override TextStyle get labelMedium => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  @override TextStyle get labelSmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
  
  @override TextStyle get code => const TextStyle(
    fontFamily: 'Roboto Mono',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.43,
  );
  
  @override TextStyle get codeBlock => const TextStyle(
    fontFamily: 'Roboto Mono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );
  
  @override TextStyle get caption => bodySmall;
  @override TextStyle get overline => labelSmall;
  @override TextStyle get button => labelLarge;
}

/// Material Spacing
class MaterialSpacing extends DesignSpacingTokens {
  // Material Design spacing scale
  @override double get xxs => 2;
  @override double get xs => 4;
  @override double get sm => 8;
  @override double get md => 16;
  @override double get lg => 24;
  @override double get xl => 32;
  @override double get xxl => 48;
  @override double get xxxl => 64;
  
  @override double get buttonPadding => 16;
  @override double get cardPadding => 16;
  @override double get listItemPadding => 16;
  @override double get inputPadding => 12;
  @override double get dialogPadding => 24;
  
  @override double get gapSmall => 8;
  @override double get gapMedium => 16;
  @override double get gapLarge => 24;
}

/// Material Radius
class MaterialRadius extends DesignRadiusTokens {
  @override double get none => 0;
  @override double get xs => 4;
  @override double get sm => 8;
  @override double get md => 12;
  @override double get lg => 16;
  @override double get xl => 20;
  @override double get xxl => 28;
  @override double get full => 9999;
  
  @override BorderRadius get button => BorderRadius.circular(20);
  @override BorderRadius get card => BorderRadius.circular(12);
  @override BorderRadius get input => BorderRadius.circular(4);
  @override BorderRadius get dialog => BorderRadius.circular(28);
  @override BorderRadius get chip => BorderRadius.circular(8);
  @override BorderRadius get tooltip => BorderRadius.circular(4);
}

/// Material Elevation
class MaterialElevation extends DesignElevationTokens {
  @override double get level0 => 0;
  @override double get level1 => 1;
  @override double get level2 => 3;
  @override double get level3 => 6;
  @override double get level4 => 8;
  @override double get level5 => 12;
  
  @override List<BoxShadow> shadow0() => const [];
  
  @override List<BoxShadow> shadow1() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
  
  @override List<BoxShadow> shadow2() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];
  
  @override List<BoxShadow> shadow3() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
  
  @override List<BoxShadow> shadow4() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  @override List<BoxShadow> shadow5() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
  
  @override double get card => level1;
  @override double get dialog => level5;
  @override double get menu => level2;
  @override double get tooltip => level0;
  @override double get snackbar => level3;
}

/// Material Animation
class MaterialAnimation extends DesignAnimationTokens {
  @override Duration get durationInstant => const Duration(milliseconds: 100);
  @override Duration get durationFast => const Duration(milliseconds: 200);
  @override Duration get durationNormal => const Duration(milliseconds: 300);
  @override Duration get durationSlow => const Duration(milliseconds: 500);
  @override Duration get durationSlowest => const Duration(milliseconds: 700);
  
  @override Curve get curveEaseIn => Curves.easeIn;
  @override Curve get curveEaseOut => Curves.easeOut;
  @override Curve get curveEaseInOut => Curves.easeInOut;
  @override Curve get curveLinear => Curves.linear;
  @override Curve get curveBounce => Curves.bounceOut;
  @override Curve get curveElastic => Curves.elasticOut;
  
  @override Duration get pageTransition => durationNormal;
  @override Duration get dialogAnimation => durationFast;
  @override Duration get tooltipDelay => const Duration(milliseconds: 1500);
  @override Duration get rippleDuration => durationNormal;
}

/// Material Icons
class MaterialIcons extends DesignIconTokens {
  @override double get sizeXs => 18;
  @override double get sizeSm => 20;
  @override double get sizeMd => 24;
  @override double get sizeLg => 24;
  @override double get sizeXl => 36;
  @override double get sizeXxl => 48;
  
  @override double get strokeWidth => 2;
  
  @override IconThemeData get defaultTheme => const IconThemeData(
    size: 24,
  );
}

/// Material Component Styles
class MaterialComponentStyles extends ComponentStyles {
  final MaterialDesignTokens design;
  
  MaterialComponentStyles(this.design);
  
  // Use standard Material button styles
  @override ButtonStyle get primaryButton => ElevatedButton.styleFrom();
  
  @override ButtonStyle get secondaryButton => FilledButton.styleFrom();
  
  @override ButtonStyle get tertiaryButton => OutlinedButton.styleFrom();
  
  @override ButtonStyle get ghostButton => TextButton.styleFrom();
  
  @override ButtonStyle get dangerButton => ElevatedButton.styleFrom(
    backgroundColor: design.colors.error,
    foregroundColor: design.colors.onError,
  );
  
  @override
  InputDecorationTheme get inputDecoration => const InputDecorationTheme();
  
  @override
  CardThemeData get card => const CardThemeData();
  
  @override
  ChipThemeData get chip => const ChipThemeData();
  
  @override
  DialogThemeData get dialog => const DialogThemeData();
  
  @override
  AppBarTheme get appBar => const AppBarTheme();
  
  @override
  NavigationBarThemeData get navigationBar => const NavigationBarThemeData();
  
  @override
  DrawerThemeData get drawer => const DrawerThemeData();
  
  @override
  SnackBarThemeData get snackBar => const SnackBarThemeData();
  
  @override
  TooltipThemeData get tooltip => const TooltipThemeData();
  
  @override
  DividerThemeData get divider => const DividerThemeData();
  
  @override
  ProgressIndicatorThemeData get progressIndicator => const ProgressIndicatorThemeData();
  
  @override
  SwitchThemeData get switchTheme => const SwitchThemeData();
  
  @override
  CheckboxThemeData get checkbox => const CheckboxThemeData();
  
  @override
  RadioThemeData get radio => const RadioThemeData();
  
  @override
  SliderThemeData get slider => const SliderThemeData();
}