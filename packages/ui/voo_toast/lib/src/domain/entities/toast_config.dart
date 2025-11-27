import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/entities/toast_style_data.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_style.dart';

class ToastConfig extends Equatable {
  /// Creates a toast configuration with adaptive mobile behavior by default.
  ///
  /// By default, toasts automatically use [VooToastStyle.snackbar] on mobile
  /// devices (screen width < [breakpointMobile]) for a native-feeling experience.
  /// On tablet and web, the [defaultStyle] is used.
  ///
  /// To disable automatic snackbar on mobile, use [ToastConfig.classic] or set
  /// [useSnackbarOnMobile] to `false`.
  const ToastConfig({
    this.defaultStyle = VooToastStyle.material,
    this.defaultCustomStyleData,
    this.defaultDuration = const Duration(seconds: 3),
    this.defaultPosition = ToastPosition.auto,
    this.defaultAnimation = ToastAnimation.slideIn,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxToasts = 3,
    this.queueMode = true,
    this.dismissOnTap = true,
    this.dismissDirection = DismissDirection.horizontal,
    this.preventDuplicates = false,
    this.defaultMargin,
    this.defaultPadding,
    this.defaultBorderRadius,
    this.defaultElevation = 4.0,
    this.defaultMaxWidth = 400.0,
    this.textStyle,
    this.titleStyle,
    this.iconSize = 24.0,
    this.closeButtonSize = 20.0,
    this.progressBarHeight = 3.0,
    this.successColor,
    this.errorColor,
    this.warningColor,
    this.infoColor,
    this.mobilePosition = ToastPosition.bottomCenter,
    this.webPosition = ToastPosition.topRight,
    this.tabletPosition = ToastPosition.topRight,
    this.breakpointMobile = 600,
    this.breakpointTablet = 900,
    this.useSnackbarOnMobile = true,
    this.mobileStyle,
  });

  /// Creates a material-styled config with adaptive mobile (default behavior).
  ///
  /// Uses Material style on tablet/web, automatically switches to snackbar
  /// on mobile for a native-feeling experience.
  const ToastConfig.material() : this(defaultStyle: VooToastStyle.material);

  /// Creates a glass/glassmorphism-styled config with adaptive mobile.
  const ToastConfig.glass() : this(defaultStyle: VooToastStyle.glass);

  /// Creates a cupertino/iOS-styled config with adaptive mobile.
  const ToastConfig.cupertino() : this(defaultStyle: VooToastStyle.cupertino);

  /// Creates a minimal-styled config with adaptive mobile.
  const ToastConfig.minimal() : this(defaultStyle: VooToastStyle.minimal);

  /// Creates a dark-themed config with adaptive mobile.
  const ToastConfig.dark() : this(defaultStyle: VooToastStyle.dark);

  /// Creates a neon/cyberpunk-styled config with adaptive mobile.
  const ToastConfig.neon() : this(defaultStyle: VooToastStyle.neon);

  /// Creates an elevated-styled config with adaptive mobile.
  const ToastConfig.elevated() : this(defaultStyle: VooToastStyle.elevated);

  /// Creates a soft pastel-styled config with adaptive mobile.
  const ToastConfig.soft() : this(defaultStyle: VooToastStyle.soft);

  /// Creates a snackbar-only config.
  ///
  /// Uses snackbar style on ALL platforms (mobile, tablet, and web).
  /// For automatic mobile-only snackbar, use the default [ToastConfig] instead.
  const ToastConfig.snackbar()
      : this(
          defaultStyle: VooToastStyle.snackbar,
          useSnackbarOnMobile: false, // Already snackbar, no need to switch
        );

  /// Creates a classic config that uses the same style on all platforms.
  ///
  /// Unlike the default [ToastConfig], this does NOT automatically switch to
  /// snackbar style on mobile. Use this if you want consistent toast appearance
  /// across all screen sizes.
  ///
  /// Example:
  /// ```dart
  /// // Use glass style everywhere, including mobile
  /// VooToastController.init(
  ///   config: const ToastConfig.classic(defaultStyle: VooToastStyle.glass),
  /// );
  /// ```
  const ToastConfig.classic({
    VooToastStyle defaultStyle = VooToastStyle.material,
  }) : this(
          defaultStyle: defaultStyle,
          useSnackbarOnMobile: false,
          mobilePosition: ToastPosition.bottom,
        );

  /// Creates a config that uses a custom style on mobile instead of snackbar.
  ///
  /// By default, mobile devices get [VooToastStyle.snackbar]. Use this
  /// constructor to specify a different style for mobile while keeping
  /// the adaptive behavior.
  ///
  /// Example:
  /// ```dart
  /// // Use material on web/tablet, cupertino on mobile
  /// VooToastController.init(
  ///   config: const ToastConfig.withMobileStyle(
  ///     defaultStyle: VooToastStyle.material,
  ///     mobileStyle: VooToastStyle.cupertino,
  ///   ),
  /// );
  /// ```
  const ToastConfig.withMobileStyle({
    VooToastStyle defaultStyle = VooToastStyle.material,
    required VooToastStyle mobileStyle,
  }) : this(
          defaultStyle: defaultStyle,
          mobileStyle: mobileStyle,
          useSnackbarOnMobile: true,
        );

  factory ToastConfig.fromTheme(BuildContext context, {VooToastStyle style = VooToastStyle.material}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ToastConfig(
      defaultStyle: style,
      defaultMargin: const EdgeInsets.all(16),
      defaultPadding: const EdgeInsets.all(16),
      defaultBorderRadius: BorderRadius.circular(12),
      defaultElevation: theme.cardTheme.elevation ?? 4.0,
      textStyle: theme.textTheme.bodyMedium,
      titleStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      successColor: colorScheme.primary,
      errorColor: colorScheme.error,
      warningColor: colorScheme.tertiary,
      infoColor: colorScheme.secondary,
    );
  }

  /// Default visual style for all toasts.
  final VooToastStyle defaultStyle;

  /// Custom style data when [defaultStyle] is [VooToastStyle.custom].
  final VooToastStyleData? defaultCustomStyleData;

  final Duration defaultDuration;
  final ToastPosition defaultPosition;
  final ToastAnimation defaultAnimation;
  final Duration animationDuration;
  final int maxToasts;
  final bool queueMode;
  final bool dismissOnTap;
  final DismissDirection dismissDirection;
  final bool preventDuplicates;
  final EdgeInsets? defaultMargin;
  final EdgeInsets? defaultPadding;
  final BorderRadius? defaultBorderRadius;
  final double defaultElevation;
  final double defaultMaxWidth;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final double iconSize;
  final double closeButtonSize;
  final double progressBarHeight;
  final Color? successColor;
  final Color? errorColor;
  final Color? warningColor;
  final Color? infoColor;
  final ToastPosition mobilePosition;
  final ToastPosition webPosition;
  final ToastPosition tabletPosition;
  final double breakpointMobile;
  final double breakpointTablet;

  /// Whether to automatically use a different style on mobile devices.
  ///
  /// When `true` (default) and on mobile (screen width < [breakpointMobile]),
  /// toasts automatically switch to [mobileStyle] or [VooToastStyle.snackbar].
  /// This provides a native-feeling experience on mobile devices.
  ///
  /// Set to `false` to use the same [defaultStyle] on all platforms.
  /// See [ToastConfig.classic] for a convenient way to disable this.
  final bool useSnackbarOnMobile;

  /// Override style specifically for mobile devices.
  ///
  /// Only applied when [useSnackbarOnMobile] is `true`.
  /// Defaults to [VooToastStyle.snackbar] when `null`.
  ///
  /// Use [ToastConfig.withMobileStyle] to easily configure a custom mobile style.
  final VooToastStyle? mobileStyle;

  ToastConfig copyWith({
    VooToastStyle? defaultStyle,
    VooToastStyleData? defaultCustomStyleData,
    Duration? defaultDuration,
    ToastPosition? defaultPosition,
    ToastAnimation? defaultAnimation,
    Duration? animationDuration,
    int? maxToasts,
    bool? queueMode,
    bool? dismissOnTap,
    DismissDirection? dismissDirection,
    bool? preventDuplicates,
    EdgeInsets? defaultMargin,
    EdgeInsets? defaultPadding,
    BorderRadius? defaultBorderRadius,
    double? defaultElevation,
    double? defaultMaxWidth,
    TextStyle? textStyle,
    TextStyle? titleStyle,
    double? iconSize,
    double? closeButtonSize,
    double? progressBarHeight,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    ToastPosition? mobilePosition,
    ToastPosition? webPosition,
    ToastPosition? tabletPosition,
    double? breakpointMobile,
    double? breakpointTablet,
    bool? useSnackbarOnMobile,
    VooToastStyle? mobileStyle,
  }) => ToastConfig(
    defaultStyle: defaultStyle ?? this.defaultStyle,
    defaultCustomStyleData: defaultCustomStyleData ?? this.defaultCustomStyleData,
    defaultDuration: defaultDuration ?? this.defaultDuration,
    defaultPosition: defaultPosition ?? this.defaultPosition,
    defaultAnimation: defaultAnimation ?? this.defaultAnimation,
    animationDuration: animationDuration ?? this.animationDuration,
    maxToasts: maxToasts ?? this.maxToasts,
    queueMode: queueMode ?? this.queueMode,
    dismissOnTap: dismissOnTap ?? this.dismissOnTap,
    dismissDirection: dismissDirection ?? this.dismissDirection,
    preventDuplicates: preventDuplicates ?? this.preventDuplicates,
    defaultMargin: defaultMargin ?? this.defaultMargin,
    defaultPadding: defaultPadding ?? this.defaultPadding,
    defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
    defaultElevation: defaultElevation ?? this.defaultElevation,
    defaultMaxWidth: defaultMaxWidth ?? this.defaultMaxWidth,
    textStyle: textStyle ?? this.textStyle,
    titleStyle: titleStyle ?? this.titleStyle,
    iconSize: iconSize ?? this.iconSize,
    closeButtonSize: closeButtonSize ?? this.closeButtonSize,
    progressBarHeight: progressBarHeight ?? this.progressBarHeight,
    successColor: successColor ?? this.successColor,
    errorColor: errorColor ?? this.errorColor,
    warningColor: warningColor ?? this.warningColor,
    infoColor: infoColor ?? this.infoColor,
    mobilePosition: mobilePosition ?? this.mobilePosition,
    webPosition: webPosition ?? this.webPosition,
    tabletPosition: tabletPosition ?? this.tabletPosition,
    breakpointMobile: breakpointMobile ?? this.breakpointMobile,
    breakpointTablet: breakpointTablet ?? this.breakpointTablet,
    useSnackbarOnMobile: useSnackbarOnMobile ?? this.useSnackbarOnMobile,
    mobileStyle: mobileStyle ?? this.mobileStyle,
  );

  @override
  List<Object?> get props => [
    defaultStyle,
    defaultCustomStyleData,
    defaultDuration,
    defaultPosition,
    defaultAnimation,
    animationDuration,
    maxToasts,
    queueMode,
    dismissOnTap,
    dismissDirection,
    preventDuplicates,
    defaultMargin,
    defaultPadding,
    defaultBorderRadius,
    defaultElevation,
    defaultMaxWidth,
    textStyle,
    titleStyle,
    iconSize,
    closeButtonSize,
    progressBarHeight,
    successColor,
    errorColor,
    warningColor,
    infoColor,
    mobilePosition,
    webPosition,
    tabletPosition,
    breakpointMobile,
    breakpointTablet,
    useSnackbarOnMobile,
    mobileStyle,
  ];
}
