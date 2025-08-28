import 'package:flutter/material.dart';

/// Available design systems
enum DesignSystemType {
  /// Google's Material Design 3
  material,

  /// Voo Design System (inspired by Discord and GitHub)
  voo,
}

/// Base class for design system configuration
abstract class DesignSystem {
  /// The type of design system
  DesignSystemType get type;

  /// Design tokens for colors
  DesignColorTokens get colors;

  /// Design tokens for typography
  DesignTypographyTokens get typography;

  /// Design tokens for spacing
  DesignSpacingTokens get spacing;

  /// Design tokens for radius
  DesignRadiusTokens get radius;

  /// Design tokens for elevation/shadows
  DesignElevationTokens get elevation;

  /// Design tokens for animations
  DesignAnimationTokens get animation;

  /// Design tokens for icons
  DesignIconTokens get icons;

  /// Generate a Flutter theme from the design system
  ThemeData toThemeData({bool isDark = false});

  /// Get component-specific styling
  ComponentStyles get components;
}

/// Color tokens for design systems
abstract class DesignColorTokens {
  // Primary colors
  Color get primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;

  // Secondary colors
  Color get secondary;
  Color get onSecondary;
  Color get secondaryContainer;
  Color get onSecondaryContainer;

  // Tertiary colors
  Color get tertiary;
  Color get onTertiary;
  Color get tertiaryContainer;
  Color get onTertiaryContainer;

  // Error colors
  Color get error;
  Color get onError;
  Color get errorContainer;
  Color get onErrorContainer;

  // Success colors (not in Material but useful)
  Color get success;
  Color get onSuccess;
  Color get successContainer;
  Color get onSuccessContainer;

  // Warning colors
  Color get warning;
  Color get onWarning;
  Color get warningContainer;
  Color get onWarningContainer;

  // Info colors
  Color get info;
  Color get onInfo;
  Color get infoContainer;
  Color get onInfoContainer;

  // Surface colors
  Color get surface;
  Color get onSurface;
  Color get surfaceVariant;
  Color get onSurfaceVariant;
  Color get surfaceTint;

  // Background colors
  Color get background;
  Color get onBackground;

  // Outline colors
  Color get outline;
  Color get outlineVariant;

  // Inverse colors
  Color get inverseSurface;
  Color get onInverseSurface;
  Color get inversePrimary;

  // Shadow color
  Color get shadow;
  Color get scrim;
}

/// Typography tokens for design systems
abstract class DesignTypographyTokens {
  TextStyle get displayLarge;
  TextStyle get displayMedium;
  TextStyle get displaySmall;

  TextStyle get headlineLarge;
  TextStyle get headlineMedium;
  TextStyle get headlineSmall;

  TextStyle get titleLarge;
  TextStyle get titleMedium;
  TextStyle get titleSmall;

  TextStyle get bodyLarge;
  TextStyle get bodyMedium;
  TextStyle get bodySmall;

  TextStyle get labelLarge;
  TextStyle get labelMedium;
  TextStyle get labelSmall;

  // Additional Voo-specific text styles
  TextStyle get code;
  TextStyle get codeBlock;
  TextStyle get caption;
  TextStyle get overline;
  TextStyle get button;

  // Font families
  String get fontFamily;
  String get monospaceFontFamily;
}

/// Spacing tokens for design systems
abstract class DesignSpacingTokens {
  // Base spacing scale (Discord/GitHub inspired)
  double get xxs; // 2px
  double get xs; // 4px
  double get sm; // 8px
  double get md; // 16px
  double get lg; // 24px
  double get xl; // 32px
  double get xxl; // 48px
  double get xxxl; // 64px

  // Component-specific spacing
  double get buttonPadding;
  double get cardPadding;
  double get listItemPadding;
  double get inputPadding;
  double get dialogPadding;

  // Gap spacing for flex layouts
  double get gapSmall;
  double get gapMedium;
  double get gapLarge;
}

/// Radius tokens for design systems
abstract class DesignRadiusTokens {
  double get none; // 0px
  double get xs; // 2px
  double get sm; // 4px
  double get md; // 8px
  double get lg; // 12px
  double get xl; // 16px
  double get xxl; // 24px
  double get full; // 9999px (pill shape)

  // Component-specific radius
  BorderRadius get button;
  BorderRadius get card;
  BorderRadius get input;
  BorderRadius get dialog;
  BorderRadius get chip;
  BorderRadius get tooltip;
}

/// Elevation tokens for design systems
abstract class DesignElevationTokens {
  // Elevation levels
  double get level0;
  double get level1;
  double get level2;
  double get level3;
  double get level4;
  double get level5;

  // Shadow definitions
  List<BoxShadow> shadow0();
  List<BoxShadow> shadow1();
  List<BoxShadow> shadow2();
  List<BoxShadow> shadow3();
  List<BoxShadow> shadow4();
  List<BoxShadow> shadow5();

  // Component-specific elevations
  double get card;
  double get dialog;
  double get menu;
  double get tooltip;
  double get snackbar;
}

/// Animation tokens for design systems
abstract class DesignAnimationTokens {
  // Durations
  Duration get durationInstant; // 50ms
  Duration get durationFast; // 150ms
  Duration get durationNormal; // 250ms
  Duration get durationSlow; // 400ms
  Duration get durationSlowest; // 600ms

  // Curves
  Curve get curveEaseIn;
  Curve get curveEaseOut;
  Curve get curveEaseInOut;
  Curve get curveLinear;
  Curve get curveBounce;
  Curve get curveElastic;

  // Component-specific animations
  Duration get pageTransition;
  Duration get dialogAnimation;
  Duration get tooltipDelay;
  Duration get rippleDuration;
}

/// Icon tokens for design systems
abstract class DesignIconTokens {
  // Icon sizes
  double get sizeXs; // 12px
  double get sizeSm; // 16px
  double get sizeMd; // 20px
  double get sizeLg; // 24px
  double get sizeXl; // 32px
  double get sizeXxl; // 48px

  // Icon styles
  double get strokeWidth;
  IconThemeData get defaultTheme;
}

/// Component-specific styling
abstract class ComponentStyles {
  ButtonStyle get primaryButton;
  ButtonStyle get secondaryButton;
  ButtonStyle get tertiaryButton;
  ButtonStyle get ghostButton;
  ButtonStyle get dangerButton;

  InputDecorationTheme get inputDecoration;

  CardThemeData get card;

  ChipThemeData get chip;

  DialogThemeData get dialog;

  AppBarTheme get appBar;

  NavigationBarThemeData get navigationBar;

  DrawerThemeData get drawer;

  SnackBarThemeData get snackBar;

  TooltipThemeData get tooltip;

  DividerThemeData get divider;

  ProgressIndicatorThemeData get progressIndicator;

  SwitchThemeData get switchTheme;

  CheckboxThemeData get checkbox;

  RadioThemeData get radio;

  SliderThemeData get slider;
}

/// Design system provider widget
class DesignSystemProvider extends InheritedWidget {
  final DesignSystem designSystem;
  final DesignSystemType systemType;

  const DesignSystemProvider({
    super.key,
    required this.designSystem,
    required this.systemType,
    required super.child,
  });

  static DesignSystemProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DesignSystemProvider>();
  }

  static DesignSystemProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'No DesignSystemProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(DesignSystemProvider oldWidget) {
    return designSystem != oldWidget.designSystem ||
        systemType != oldWidget.systemType;
  }
}

/// Extension for easy access to design system
extension DesignSystemContext on BuildContext {
  DesignSystem get designSystem {
    return DesignSystemProvider.of(this).designSystem;
  }

  DesignSystemType get designSystemType {
    return DesignSystemProvider.of(this).systemType;
  }

  DesignColorTokens get designColors {
    return designSystem.colors;
  }

  DesignTypographyTokens get designTypography {
    return designSystem.typography;
  }

  DesignSpacingTokens get designSpacing {
    return designSystem.spacing;
  }

  DesignRadiusTokens get designRadius {
    return designSystem.radius;
  }

  DesignElevationTokens get designElevation {
    return designSystem.elevation;
  }

  DesignAnimationTokens get designAnimation {
    return designSystem.animation;
  }

  DesignIconTokens get designIcons {
    return designSystem.icons;
  }

  ComponentStyles get componentStyles {
    return designSystem.components;
  }
}
