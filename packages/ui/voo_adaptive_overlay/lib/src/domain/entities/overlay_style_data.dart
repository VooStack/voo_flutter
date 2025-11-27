import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Custom style data for overlays.
///
/// Use this when [VooOverlayStyle.custom] is selected to define
/// your own colors, shapes, and decorations.
class VooOverlayStyleData extends Equatable {
  /// Background color of the overlay surface.
  final Color? backgroundColor;

  /// Color of the barrier/scrim behind the overlay.
  final Color? barrierColor;

  /// Border radius for the overlay container.
  final BorderRadius? borderRadius;

  /// Box shadow for the overlay container.
  final List<BoxShadow>? boxShadow;

  /// Border for the overlay container.
  final Border? border;

  /// Padding inside the overlay content area.
  final EdgeInsets? contentPadding;

  /// Padding for the header area.
  final EdgeInsets? headerPadding;

  /// Color for the drag handle.
  final Color? handleColor;

  /// Width of the drag handle.
  final double? handleWidth;

  /// Height of the drag handle.
  final double? handleHeight;

  /// Border radius for the drag handle.
  final BorderRadius? handleBorderRadius;

  /// Color for the close button icon.
  final Color? closeButtonColor;

  /// Size of the close button icon.
  final double? closeButtonSize;

  /// Background color for the close button.
  final Color? closeButtonBackgroundColor;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Blur amount for glassmorphism effect (sigma value).
  final double? blurSigma;

  /// Whether to apply a gradient to the background.
  final Gradient? backgroundGradient;

  /// Text color for content text.
  final Color? textColor;

  /// Icon color for icons in the overlay.
  final Color? iconColor;

  /// Primary button style.
  final ButtonStyle? primaryButtonStyle;

  /// Secondary button style.
  final ButtonStyle? secondaryButtonStyle;

  const VooOverlayStyleData({
    this.backgroundColor,
    this.barrierColor,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.contentPadding,
    this.headerPadding,
    this.handleColor,
    this.handleWidth,
    this.handleHeight,
    this.handleBorderRadius,
    this.closeButtonColor,
    this.closeButtonSize,
    this.closeButtonBackgroundColor,
    this.titleStyle,
    this.blurSigma,
    this.backgroundGradient,
    this.textColor,
    this.iconColor,
    this.primaryButtonStyle,
    this.secondaryButtonStyle,
  });

  VooOverlayStyleData copyWith({
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Border? border,
    EdgeInsets? contentPadding,
    EdgeInsets? headerPadding,
    Color? handleColor,
    double? handleWidth,
    double? handleHeight,
    BorderRadius? handleBorderRadius,
    Color? closeButtonColor,
    double? closeButtonSize,
    Color? closeButtonBackgroundColor,
    TextStyle? titleStyle,
    double? blurSigma,
    Gradient? backgroundGradient,
    Color? textColor,
    Color? iconColor,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? secondaryButtonStyle,
  }) => VooOverlayStyleData(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    barrierColor: barrierColor ?? this.barrierColor,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    border: border ?? this.border,
    contentPadding: contentPadding ?? this.contentPadding,
    headerPadding: headerPadding ?? this.headerPadding,
    handleColor: handleColor ?? this.handleColor,
    handleWidth: handleWidth ?? this.handleWidth,
    handleHeight: handleHeight ?? this.handleHeight,
    handleBorderRadius: handleBorderRadius ?? this.handleBorderRadius,
    closeButtonColor: closeButtonColor ?? this.closeButtonColor,
    closeButtonSize: closeButtonSize ?? this.closeButtonSize,
    closeButtonBackgroundColor: closeButtonBackgroundColor ?? this.closeButtonBackgroundColor,
    titleStyle: titleStyle ?? this.titleStyle,
    blurSigma: blurSigma ?? this.blurSigma,
    backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    textColor: textColor ?? this.textColor,
    iconColor: iconColor ?? this.iconColor,
    primaryButtonStyle: primaryButtonStyle ?? this.primaryButtonStyle,
    secondaryButtonStyle: secondaryButtonStyle ?? this.secondaryButtonStyle,
  );

  @override
  List<Object?> get props => [
    backgroundColor,
    barrierColor,
    borderRadius,
    boxShadow,
    border,
    contentPadding,
    headerPadding,
    handleColor,
    handleWidth,
    handleHeight,
    handleBorderRadius,
    closeButtonColor,
    closeButtonSize,
    closeButtonBackgroundColor,
    titleStyle,
    blurSigma,
    backgroundGradient,
    textColor,
    iconColor,
    primaryButtonStyle,
    secondaryButtonStyle,
  ];
}
