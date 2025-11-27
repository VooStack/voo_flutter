import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Custom style data for toasts when using [VooToastStyle.custom].
///
/// This class provides full control over toast appearance, allowing
/// you to customize every visual aspect of the toast.
///
/// Example:
/// ```dart
/// VooToast.showSuccess(
///   message: 'Custom styled toast',
///   style: VooToastStyle.custom,
///   customStyleData: VooToastStyleData(
///     backgroundColor: Colors.purple,
///     textColor: Colors.white,
///     borderRadius: BorderRadius.circular(20),
///     blurSigma: 10,
///   ),
/// );
/// ```
class VooToastStyleData extends Equatable {
  const VooToastStyleData({
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.blurSigma,
    this.backgroundGradient,
    this.iconContainerColor,
    this.iconContainerBorderColor,
    this.closeButtonColor,
    this.progressBarColor,
    this.padding,
    this.titleStyle,
    this.messageStyle,
  });

  /// Background color of the toast.
  final Color? backgroundColor;

  /// Text color for the message.
  final Color? textColor;

  /// Color for the icon.
  final Color? iconColor;

  /// Border radius for the toast container.
  final BorderRadius? borderRadius;

  /// Border decoration for the toast.
  final Border? border;

  /// Box shadow for the toast.
  final List<BoxShadow>? boxShadow;

  /// Blur sigma for glass effects (0 = no blur).
  final double? blurSigma;

  /// Gradient background (overrides backgroundColor if set).
  final Gradient? backgroundGradient;

  /// Background color for the icon container.
  final Color? iconContainerColor;

  /// Border color for the icon container.
  final Color? iconContainerBorderColor;

  /// Color for the close button.
  final Color? closeButtonColor;

  /// Color for the progress bar.
  final Color? progressBarColor;

  /// Padding inside the toast.
  final EdgeInsets? padding;

  /// Text style for the title.
  final TextStyle? titleStyle;

  /// Text style for the message.
  final TextStyle? messageStyle;

  /// Creates a copy with the given fields replaced.
  VooToastStyleData copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    double? blurSigma,
    Gradient? backgroundGradient,
    Color? iconContainerColor,
    Color? iconContainerBorderColor,
    Color? closeButtonColor,
    Color? progressBarColor,
    EdgeInsets? padding,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) =>
      VooToastStyleData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        textColor: textColor ?? this.textColor,
        iconColor: iconColor ?? this.iconColor,
        borderRadius: borderRadius ?? this.borderRadius,
        border: border ?? this.border,
        boxShadow: boxShadow ?? this.boxShadow,
        blurSigma: blurSigma ?? this.blurSigma,
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
        iconContainerColor: iconContainerColor ?? this.iconContainerColor,
        iconContainerBorderColor: iconContainerBorderColor ?? this.iconContainerBorderColor,
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
        progressBarColor: progressBarColor ?? this.progressBarColor,
        padding: padding ?? this.padding,
        titleStyle: titleStyle ?? this.titleStyle,
        messageStyle: messageStyle ?? this.messageStyle,
      );

  @override
  List<Object?> get props => [
        backgroundColor,
        textColor,
        iconColor,
        borderRadius,
        border,
        boxShadow,
        blurSigma,
        backgroundGradient,
        iconContainerColor,
        iconContainerBorderColor,
        closeButtonColor,
        progressBarColor,
        padding,
        titleStyle,
        messageStyle,
      ];
}
