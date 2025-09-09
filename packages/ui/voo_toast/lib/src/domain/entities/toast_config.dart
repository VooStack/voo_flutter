import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';

class ToastConfig extends Equatable {
  const ToastConfig({
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
    this.mobilePosition = ToastPosition.bottom,
    this.webPosition = ToastPosition.topRight,
    this.tabletPosition = ToastPosition.topRight,
    this.breakpointMobile = 600,
    this.breakpointTablet = 900,
  });

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

  ToastConfig copyWith({
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
  }) {
    return ToastConfig(
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
    );
  }

  @override
  List<Object?> get props => [
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
      ];
}