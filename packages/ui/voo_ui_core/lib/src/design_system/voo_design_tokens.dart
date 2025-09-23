import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/design_system/design_system.dart';

/// Voo Design System implementation
/// Inspired by Discord and GitHub's modern, clean design language
class VooDesignTokens extends DesignSystem {
  final bool isDarkMode;

  VooDesignTokens({this.isDarkMode = false});

  @override
  DesignSystemType get type => DesignSystemType.voo;

  @override
  DesignColorTokens get colors => isDarkMode ? VooDarkColors() : VooLightColors();

  @override
  DesignTypographyTokens get typography => VooTypography();

  @override
  DesignSpacingTokens get spacing => VooSpacing();

  @override
  DesignRadiusTokens get radius => VooRadius();

  @override
  DesignElevationTokens get elevation => VooElevation(isDarkMode: isDarkMode);

  @override
  DesignAnimationTokens get animation => VooAnimation();

  @override
  DesignIconTokens get icons => VooIcons();

  @override
  ComponentStyles get components => VooComponentStyles(this);

  @override
  ThemeData toThemeData({bool isDark = false}) {
    final effectiveColors = isDark ? VooDarkColors() : VooLightColors();

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,

      // Color scheme
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: effectiveColors.primary,
        onPrimary: effectiveColors.onPrimary,
        primaryContainer: effectiveColors.primaryContainer,
        onPrimaryContainer: effectiveColors.onPrimaryContainer,
        secondary: effectiveColors.secondary,
        onSecondary: effectiveColors.onSecondary,
        secondaryContainer: effectiveColors.secondaryContainer,
        onSecondaryContainer: effectiveColors.onSecondaryContainer,
        tertiary: effectiveColors.tertiary,
        onTertiary: effectiveColors.onTertiary,
        tertiaryContainer: effectiveColors.tertiaryContainer,
        onTertiaryContainer: effectiveColors.onTertiaryContainer,
        error: effectiveColors.error,
        onError: effectiveColors.onError,
        errorContainer: effectiveColors.errorContainer,
        onErrorContainer: effectiveColors.onErrorContainer,
        surface: effectiveColors.surface,
        onSurface: effectiveColors.onSurface,
        surfaceContainerHighest: effectiveColors.surfaceVariant,
        onSurfaceVariant: effectiveColors.onSurfaceVariant,
        outline: effectiveColors.outline,
        outlineVariant: effectiveColors.outlineVariant,
        shadow: effectiveColors.shadow,
        scrim: effectiveColors.scrim,
        inverseSurface: effectiveColors.inverseSurface,
        onInverseSurface: effectiveColors.onInverseSurface,
        inversePrimary: effectiveColors.inversePrimary,
        surfaceTint: effectiveColors.surfaceTint,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: typography.displayLarge,
        displayMedium: typography.displayMedium,
        displaySmall: typography.displaySmall,
        headlineLarge: typography.headlineLarge,
        headlineMedium: typography.headlineMedium,
        headlineSmall: typography.headlineSmall,
        titleLarge: typography.titleLarge,
        titleMedium: typography.titleMedium,
        titleSmall: typography.titleSmall,
        bodyLarge: typography.bodyLarge,
        bodyMedium: typography.bodyMedium,
        bodySmall: typography.bodySmall,
        labelLarge: typography.labelLarge,
        labelMedium: typography.labelMedium,
        labelSmall: typography.labelSmall,
      ),

      // Component themes
      appBarTheme: components.appBar,
      cardTheme: components.card,
      chipTheme: components.chip,
      dialogTheme: components.dialog,
      dividerTheme: components.divider,
      drawerTheme: components.drawer,
      inputDecorationTheme: components.inputDecoration,
      navigationBarTheme: components.navigationBar,
      progressIndicatorTheme: components.progressIndicator,
      snackBarTheme: components.snackBar,
      switchTheme: components.switchTheme,
      checkboxTheme: components.checkbox,
      radioTheme: components.radio,
      sliderTheme: components.slider,
      tooltipTheme: components.tooltip,

      // Platform
      platform: TargetPlatform.iOS, // Use iOS-style scrolling like Discord
    );
  }
}

/// Voo Light Color Tokens (GitHub-inspired clean light theme)
class VooLightColors extends DesignColorTokens {
  // Primary - A modern blue similar to GitHub's accent
  @override
  Color get primary => const Color(0xFF0969DA);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFDDF4FF);
  @override
  Color get onPrimaryContainer => const Color(0xFF0550AE);

  // Secondary - A subtle purple like Discord's accent
  @override
  Color get secondary => const Color(0xFF5865F2);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get secondaryContainer => const Color(0xFFE3E5FF);
  @override
  Color get onSecondaryContainer => const Color(0xFF4752C4);

  // Tertiary - Teal accent
  @override
  Color get tertiary => const Color(0xFF1F883D);
  @override
  Color get onTertiary => const Color(0xFFFFFFFF);
  @override
  Color get tertiaryContainer => const Color(0xFFDDFBE2);
  @override
  Color get onTertiaryContainer => const Color(0xFF116329);

  // Semantic colors
  @override
  Color get error => const Color(0xFFCF222E);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFFFFEBE9);
  @override
  Color get onErrorContainer => const Color(0xFFA40E26);

  @override
  Color get success => const Color(0xFF1F883D);
  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
  @override
  Color get successContainer => const Color(0xFFDDFBE2);
  @override
  Color get onSuccessContainer => const Color(0xFF116329);

  @override
  Color get warning => const Color(0xFF9A6700);
  @override
  Color get onWarning => const Color(0xFFFFFFFF);
  @override
  Color get warningContainer => const Color(0xFFFFF8C5);
  @override
  Color get onWarningContainer => const Color(0xFF7D4E00);

  @override
  Color get info => const Color(0xFF0969DA);
  @override
  Color get onInfo => const Color(0xFFFFFFFF);
  @override
  Color get infoContainer => const Color(0xFFDDF4FF);
  @override
  Color get onInfoContainer => const Color(0xFF0550AE);

  // Surface colors - Clean white backgrounds
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get onSurface => const Color(0xFF1C2128);
  @override
  Color get surfaceVariant => const Color(0xFFF6F8FA);
  @override
  Color get onSurfaceVariant => const Color(0xFF656D76);
  @override
  Color get surfaceTint => const Color(0xFF0969DA);

  // Background
  @override
  Color get background => const Color(0xFFFBFCFD);
  @override
  Color get onBackground => const Color(0xFF1C2128);

  // Outline
  @override
  Color get outline => const Color(0xFFD1D9E0);
  @override
  Color get outlineVariant => const Color(0xFFE5E9ED);

  // Inverse
  @override
  Color get inverseSurface => const Color(0xFF1C2128);
  @override
  Color get onInverseSurface => const Color(0xFFFFFFFF);
  @override
  Color get inversePrimary => const Color(0xFF58A6FF);

  // Shadow
  @override
  Color get shadow => const Color(0x1A1C2128);
  @override
  Color get scrim => const Color(0x4D000000);
}

/// Voo Dark Color Tokens (Discord-inspired dark theme)
class VooDarkColors extends DesignColorTokens {
  // Primary - Discord blurple
  @override
  Color get primary => const Color(0xFF5865F2);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFF4752C4);
  @override
  Color get onPrimaryContainer => const Color(0xFFE3E5FF);

  // Secondary - Discord green
  @override
  Color get secondary => const Color(0xFF3BA55C);
  @override
  Color get onSecondary => const Color(0xFF000000);
  @override
  Color get secondaryContainer => const Color(0xFF2D7D46);
  @override
  Color get onSecondaryContainer => const Color(0xFFB7FFCF);

  // Tertiary - Discord pink
  @override
  Color get tertiary => const Color(0xFFEB459E);
  @override
  Color get onTertiary => const Color(0xFFFFFFFF);
  @override
  Color get tertiaryContainer => const Color(0xFFBC3680);
  @override
  Color get onTertiaryContainer => const Color(0xFFFFD1E8);

  // Semantic colors
  @override
  Color get error => const Color(0xFFED4245);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFF8E2424);
  @override
  Color get onErrorContainer => const Color(0xFFFFDAD6);

  @override
  Color get success => const Color(0xFF3BA55C);
  @override
  Color get onSuccess => const Color(0xFF000000);
  @override
  Color get successContainer => const Color(0xFF2D7D46);
  @override
  Color get onSuccessContainer => const Color(0xFFB7FFCF);

  @override
  Color get warning => const Color(0xFFFAA61A);
  @override
  Color get onWarning => const Color(0xFF000000);
  @override
  Color get warningContainer => const Color(0xFFC87F00);
  @override
  Color get onWarningContainer => const Color(0xFFFFE08A);

  @override
  Color get info => const Color(0xFF5865F2);
  @override
  Color get onInfo => const Color(0xFFFFFFFF);
  @override
  Color get infoContainer => const Color(0xFF4752C4);
  @override
  Color get onInfoContainer => const Color(0xFFE3E5FF);

  // Surface colors - Discord dark backgrounds
  @override
  Color get surface => const Color(0xFF313338);
  @override
  Color get onSurface => const Color(0xFFDBDEE1);
  @override
  Color get surfaceVariant => const Color(0xFF2B2D31);
  @override
  Color get onSurfaceVariant => const Color(0xFFB5BAC1);
  @override
  Color get surfaceTint => const Color(0xFF5865F2);

  // Background - Darkest Discord background
  @override
  Color get background => const Color(0xFF1E1F22);
  @override
  Color get onBackground => const Color(0xFFDBDEE1);

  // Outline
  @override
  Color get outline => const Color(0xFF4E5058);
  @override
  Color get outlineVariant => const Color(0xFF3C3F44);

  // Inverse
  @override
  Color get inverseSurface => const Color(0xFFDBDEE1);
  @override
  Color get onInverseSurface => const Color(0xFF1E1F22);
  @override
  Color get inversePrimary => const Color(0xFF4752C4);

  // Shadow
  @override
  Color get shadow => const Color(0xFF000000);
  @override
  Color get scrim => const Color(0xCC000000);
}

/// Voo Typography (Clean, modern typography)
class VooTypography extends DesignTypographyTokens {
  static const String _fontFamily = 'Inter';
  static const String _monospaceFontFamily = 'JetBrains Mono';

  @override
  String get fontFamily => _fontFamily;
  @override
  String get monospaceFontFamily => _monospaceFontFamily;

  @override
  TextStyle get displayLarge => const TextStyle(fontFamily: _fontFamily, fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.25, height: 1.12);

  @override
  TextStyle get displayMedium => const TextStyle(fontFamily: _fontFamily, fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.16);

  @override
  TextStyle get displaySmall => const TextStyle(fontFamily: _fontFamily, fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.22);

  @override
  TextStyle get headlineLarge => const TextStyle(fontFamily: _fontFamily, fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.25);

  @override
  TextStyle get headlineMedium => const TextStyle(fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.29);

  @override
  TextStyle get headlineSmall => const TextStyle(fontFamily: _fontFamily, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.33);

  @override
  TextStyle get titleLarge => const TextStyle(fontFamily: _fontFamily, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0, height: 1.27);

  @override
  TextStyle get titleMedium => const TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, height: 1.5);

  @override
  TextStyle get titleSmall => const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 1.43);

  @override
  TextStyle get bodyLarge => const TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.5);

  @override
  TextStyle get bodyMedium => const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.43);

  @override
  TextStyle get bodySmall => const TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.33);

  @override
  TextStyle get labelLarge => const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, height: 1.43);

  @override
  TextStyle get labelMedium => const TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.33);

  @override
  TextStyle get labelSmall => const TextStyle(fontFamily: _fontFamily, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.45);

  @override
  TextStyle get code => const TextStyle(fontFamily: _monospaceFontFamily, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.43);

  @override
  TextStyle get codeBlock => const TextStyle(fontFamily: _monospaceFontFamily, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0, height: 1.5);

  @override
  TextStyle get caption => const TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, height: 1.33);

  @override
  TextStyle get overline => const TextStyle(fontFamily: _fontFamily, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, height: 1.6);

  @override
  TextStyle get button => const TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5, height: 1.43);
}

/// Voo Spacing Tokens
class VooSpacing extends DesignSpacingTokens {
  @override
  double get xxs => 2;
  @override
  double get xs => 4;
  @override
  double get sm => 8;
  @override
  double get md => 16;
  @override
  double get lg => 24;
  @override
  double get xl => 32;
  @override
  double get xxl => 48;
  @override
  double get xxxl => 64;

  @override
  double get buttonPadding => 12;
  @override
  double get cardPadding => 16;
  @override
  double get listItemPadding => 12;
  @override
  double get inputPadding => 12;
  @override
  double get dialogPadding => 24;

  @override
  double get gapSmall => 8;
  @override
  double get gapMedium => 16;
  @override
  double get gapLarge => 24;
}

/// Voo Radius Tokens
class VooRadius extends DesignRadiusTokens {
  @override
  double get none => 0;
  @override
  double get xs => 2;
  @override
  double get sm => 4;
  @override
  double get md => 8;
  @override
  double get lg => 12;
  @override
  double get xl => 16;
  @override
  double get xxl => 24;
  @override
  double get full => 9999;

  @override
  BorderRadius get button => BorderRadius.circular(md);
  @override
  BorderRadius get card => BorderRadius.circular(lg);
  @override
  BorderRadius get input => BorderRadius.circular(md);
  @override
  BorderRadius get dialog => BorderRadius.circular(xl);
  @override
  BorderRadius get chip => BorderRadius.circular(full);
  @override
  BorderRadius get tooltip => BorderRadius.circular(md);
}

/// Voo Elevation Tokens
class VooElevation extends DesignElevationTokens {
  final bool isDarkMode;

  VooElevation({required this.isDarkMode});

  @override
  double get level0 => 0;
  @override
  double get level1 => 1;
  @override
  double get level2 => 2;
  @override
  double get level3 => 4;
  @override
  double get level4 => 8;
  @override
  double get level5 => 16;

  @override
  List<BoxShadow> shadow0() => [];

  @override
  List<BoxShadow> shadow1() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1)),
  ];

  @override
  List<BoxShadow> shadow2() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
  ];

  @override
  List<BoxShadow> shadow3() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 4)),
  ];

  @override
  List<BoxShadow> shadow4() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.16), blurRadius: 16, offset: const Offset(0, 8)),
  ];

  @override
  List<BoxShadow> shadow5() => [
    BoxShadow(color: isDarkMode ? Colors.black.withValues(alpha: 0.7) : Colors.black.withValues(alpha: 0.24), blurRadius: 24, offset: const Offset(0, 12)),
  ];

  @override
  double get card => level2;
  @override
  double get dialog => level5;
  @override
  double get menu => level3;
  @override
  double get tooltip => level2;
  @override
  double get snackbar => level3;
}

/// Voo Animation Tokens
class VooAnimation extends DesignAnimationTokens {
  @override
  Duration get durationInstant => const Duration(milliseconds: 50);
  @override
  Duration get durationFast => const Duration(milliseconds: 150);
  @override
  Duration get durationNormal => const Duration(milliseconds: 250);
  @override
  Duration get durationSlow => const Duration(milliseconds: 400);
  @override
  Duration get durationSlowest => const Duration(milliseconds: 600);

  @override
  Curve get curveEaseIn => Curves.easeIn;
  @override
  Curve get curveEaseOut => Curves.easeOut;
  @override
  Curve get curveEaseInOut => Curves.easeInOut;
  @override
  Curve get curveLinear => Curves.linear;
  @override
  Curve get curveBounce => Curves.bounceOut;
  @override
  Curve get curveElastic => Curves.elasticOut;

  @override
  Duration get pageTransition => durationNormal;
  @override
  Duration get dialogAnimation => durationFast;
  @override
  Duration get tooltipDelay => const Duration(milliseconds: 500);
  @override
  Duration get rippleDuration => durationNormal;
}

/// Voo Icon Tokens
class VooIcons extends DesignIconTokens {
  @override
  double get sizeXs => 12;
  @override
  double get sizeSm => 16;
  @override
  double get sizeMd => 20;
  @override
  double get sizeLg => 24;
  @override
  double get sizeXl => 32;
  @override
  double get sizeXxl => 48;

  @override
  double get strokeWidth => 2;

  @override
  IconThemeData get defaultTheme => IconThemeData(size: sizeLg, weight: 400, grade: 0, opticalSize: 48);
}

/// Voo Component Styles
class VooComponentStyles extends ComponentStyles {
  final VooDesignTokens design;

  VooComponentStyles(this.design);

  @override
  ButtonStyle get primaryButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return design.colors.primary.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.hovered)) {
        return design.colors.primary.withValues(alpha: 0.9);
      }
      if (states.contains(WidgetState.pressed)) {
        return design.colors.primary.withValues(alpha: 0.8);
      }
      return design.colors.primary;
    }),
    foregroundColor: WidgetStateProperty.all(design.colors.onPrimary),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: design.radius.button)),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.sm)),
    textStyle: WidgetStateProperty.all(design.typography.button),
  );

  @override
  ButtonStyle get secondaryButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return design.colors.surfaceVariant.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.hovered)) {
        return design.colors.surfaceVariant.withValues(alpha: 0.9);
      }
      if (states.contains(WidgetState.pressed)) {
        return design.colors.surfaceVariant.withValues(alpha: 0.8);
      }
      return design.colors.surfaceVariant;
    }),
    foregroundColor: WidgetStateProperty.all(design.colors.onSurface),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: design.radius.button)),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.sm)),
    textStyle: WidgetStateProperty.all(design.typography.button),
  );

  @override
  ButtonStyle get tertiaryButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(design.colors.primary),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: design.radius.button,
        side: BorderSide(color: design.colors.outline),
      ),
    ),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.sm)),
    textStyle: WidgetStateProperty.all(design.typography.button),
  );

  @override
  ButtonStyle get ghostButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(design.colors.onSurface),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: design.radius.button)),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.sm)),
    textStyle: WidgetStateProperty.all(design.typography.button),
  );

  @override
  ButtonStyle get dangerButton => ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return design.colors.error.withValues(alpha: 0.38);
      }
      if (states.contains(WidgetState.hovered)) {
        return design.colors.error.withValues(alpha: 0.9);
      }
      if (states.contains(WidgetState.pressed)) {
        return design.colors.error.withValues(alpha: 0.8);
      }
      return design.colors.error;
    }),
    foregroundColor: WidgetStateProperty.all(design.colors.onError),
    elevation: WidgetStateProperty.all(0),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: design.radius.button)),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.sm)),
    textStyle: WidgetStateProperty.all(design.typography.button),
  );

  @override
  InputDecorationTheme get inputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: design.colors.surfaceVariant,
    border: OutlineInputBorder(borderRadius: design.radius.input, borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(
      borderRadius: design.radius.input,
      borderSide: BorderSide(color: design.colors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: design.radius.input,
      borderSide: BorderSide(color: design.colors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: design.radius.input,
      borderSide: BorderSide(color: design.colors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: design.radius.input,
      borderSide: BorderSide(color: design.colors.error, width: 2),
    ),
    contentPadding: EdgeInsets.all(design.spacing.inputPadding),
    labelStyle: design.typography.bodyMedium,
    hintStyle: design.typography.bodyMedium.copyWith(color: design.colors.onSurfaceVariant),
    errorStyle: design.typography.bodySmall.copyWith(color: design.colors.error),
  );

  @override
  CardThemeData get card => CardThemeData(
    elevation: design.elevation.card,
    shape: RoundedRectangleBorder(borderRadius: design.radius.card),
    color: design.colors.surface,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.all(design.spacing.sm),
  );

  @override
  ChipThemeData get chip => ChipThemeData(
    backgroundColor: design.colors.surfaceVariant,
    deleteIconColor: design.colors.onSurfaceVariant,
    disabledColor: design.colors.surfaceVariant.withValues(alpha: 0.38),
    selectedColor: design.colors.primaryContainer,
    secondarySelectedColor: design.colors.secondaryContainer,
    labelPadding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
    padding: EdgeInsets.all(design.spacing.xs),
    shape: RoundedRectangleBorder(borderRadius: design.radius.chip),
    labelStyle: design.typography.labelMedium,
    secondaryLabelStyle: design.typography.labelSmall,
    brightness: design.isDarkMode ? Brightness.dark : Brightness.light,
    elevation: 0,
    pressElevation: 0,
  );

  @override
  DialogThemeData get dialog => DialogThemeData(
    backgroundColor: design.colors.surface,
    elevation: design.elevation.dialog,
    shape: RoundedRectangleBorder(borderRadius: design.radius.dialog),
    titleTextStyle: design.typography.headlineSmall.copyWith(color: design.colors.onSurface),
    contentTextStyle: design.typography.bodyMedium.copyWith(color: design.colors.onSurfaceVariant),
  );

  @override
  AppBarTheme get appBar => AppBarTheme(
    backgroundColor: design.colors.surface,
    foregroundColor: design.colors.onSurface,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: design.typography.titleLarge.copyWith(color: design.colors.onSurface),
    toolbarTextStyle: design.typography.bodyMedium,
    iconTheme: IconThemeData(color: design.colors.onSurface, size: design.icons.sizeLg),
  );

  @override
  NavigationBarThemeData get navigationBar => NavigationBarThemeData(
    backgroundColor: design.colors.surface,
    elevation: 0,
    height: 64,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorColor: design.colors.primaryContainer,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(color: design.colors.onPrimaryContainer, size: design.icons.sizeLg);
      }
      return IconThemeData(color: design.colors.onSurfaceVariant, size: design.icons.sizeLg);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return design.typography.labelMedium.copyWith(color: design.colors.onSurface);
      }
      return design.typography.labelMedium.copyWith(color: design.colors.onSurfaceVariant);
    }),
  );

  @override
  DrawerThemeData get drawer => DrawerThemeData(
    backgroundColor: design.colors.surface,
    scrimColor: design.colors.scrim,
    elevation: design.elevation.level5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(design.radius.xl), bottomRight: Radius.circular(design.radius.xl)),
    ),
  );

  @override
  SnackBarThemeData get snackBar => SnackBarThemeData(
    backgroundColor: design.colors.inverseSurface,
    contentTextStyle: design.typography.bodyMedium.copyWith(color: design.colors.onInverseSurface),
    actionTextColor: design.colors.inversePrimary,
    elevation: design.elevation.snackbar,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: design.radius.button),
  );

  @override
  TooltipThemeData get tooltip => TooltipThemeData(
    decoration: BoxDecoration(color: design.colors.inverseSurface, borderRadius: design.radius.tooltip),
    textStyle: design.typography.bodySmall.copyWith(color: design.colors.onInverseSurface),
    padding: EdgeInsets.symmetric(horizontal: design.spacing.sm, vertical: design.spacing.xs),
    waitDuration: design.animation.tooltipDelay,
  );

  @override
  DividerThemeData get divider => DividerThemeData(color: design.colors.outlineVariant, thickness: 1, space: design.spacing.md);

  @override
  ProgressIndicatorThemeData get progressIndicator => ProgressIndicatorThemeData(
    color: design.colors.primary,
    linearTrackColor: design.colors.primaryContainer,
    circularTrackColor: design.colors.primaryContainer,
  );

  @override
  SwitchThemeData get switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return design.colors.onPrimary;
      }
      return design.colors.outline;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return design.colors.primary;
      }
      return design.colors.surfaceVariant;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return design.colors.outline;
    }),
  );

  @override
  CheckboxThemeData get checkbox => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return design.colors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(design.colors.onPrimary),
    side: BorderSide(color: design.colors.outline, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(design.radius.xs)),
  );

  @override
  RadioThemeData get radio => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return design.colors.primary;
      }
      return design.colors.outline;
    }),
  );

  @override
  SliderThemeData get slider => SliderThemeData(
    activeTrackColor: design.colors.primary,
    inactiveTrackColor: design.colors.primaryContainer,
    thumbColor: design.colors.primary,
    overlayColor: design.colors.primary.withValues(alpha: 0.12),
    valueIndicatorColor: design.colors.inverseSurface,
    valueIndicatorTextStyle: design.typography.labelMedium.copyWith(color: design.colors.onInverseSurface),
  );
}
