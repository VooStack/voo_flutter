import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/enums/toast_animation.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

class Toast extends Equatable {
  const Toast({
    required this.id,
    required this.message,
    this.title,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
    this.position = ToastPosition.auto,
    this.animation = ToastAnimation.slideIn,
    this.isDismissible = true,
    this.showCloseButton = true,
    this.showProgressBar = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.elevation,
    this.width,
    this.maxWidth,
    this.actions,
    this.customContent,
    this.onDismissed,
    this.onTap,
    this.priority = 0,
    this.showTimestamp = false,
    this.timestamp,
    this.isLoading = false,
    this.textStyle,
    this.titleStyle,
  });

  final String id;
  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
  final ToastPosition position;
  final ToastAnimation animation;
  final bool isDismissible;
  final bool showCloseButton;
  final bool showProgressBar;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? elevation;
  final double? width;
  final double? maxWidth;
  final List<ToastAction>? actions;
  final Widget? customContent;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;
  final int priority;
  final bool showTimestamp;
  final DateTime? timestamp;
  final bool isLoading;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;

  Toast copyWith({
    String? id,
    String? message,
    String? title,
    ToastType? type,
    Duration? duration,
    ToastPosition? position,
    ToastAnimation? animation,
    bool? isDismissible,
    bool? showCloseButton,
    bool? showProgressBar,
    Widget? icon,
    Color? backgroundColor,
    Color? textColor,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
    double? width,
    double? maxWidth,
    List<ToastAction>? actions,
    Widget? customContent,
    VoidCallback? onDismissed,
    VoidCallback? onTap,
    int? priority,
    bool? showTimestamp,
    DateTime? timestamp,
    bool? isLoading,
    TextStyle? textStyle,
    TextStyle? titleStyle,
  }) => Toast(
    id: id ?? this.id,
    message: message ?? this.message,
    title: title ?? this.title,
    type: type ?? this.type,
    duration: duration ?? this.duration,
    position: position ?? this.position,
    animation: animation ?? this.animation,
    isDismissible: isDismissible ?? this.isDismissible,
    showCloseButton: showCloseButton ?? this.showCloseButton,
    showProgressBar: showProgressBar ?? this.showProgressBar,
    icon: icon ?? this.icon,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    textColor: textColor ?? this.textColor,
    borderRadius: borderRadius ?? this.borderRadius,
    margin: margin ?? this.margin,
    padding: padding ?? this.padding,
    elevation: elevation ?? this.elevation,
    width: width ?? this.width,
    maxWidth: maxWidth ?? this.maxWidth,
    actions: actions ?? this.actions,
    customContent: customContent ?? this.customContent,
    onDismissed: onDismissed ?? this.onDismissed,
    onTap: onTap ?? this.onTap,
    priority: priority ?? this.priority,
    showTimestamp: showTimestamp ?? this.showTimestamp,
    timestamp: timestamp ?? this.timestamp,
    isLoading: isLoading ?? this.isLoading,
    textStyle: textStyle ?? this.textStyle,
    titleStyle: titleStyle ?? this.titleStyle,
  );

  @override
  List<Object?> get props => [
    id,
    message,
    title,
    type,
    duration,
    position,
    animation,
    isDismissible,
    showCloseButton,
    showProgressBar,
    icon,
    backgroundColor,
    textColor,
    borderRadius,
    margin,
    padding,
    elevation,
    width,
    maxWidth,
    actions,
    customContent,
    priority,
    showTimestamp,
    timestamp,
    isLoading,
    textStyle,
    titleStyle,
  ];
}

class ToastAction extends Equatable {
  const ToastAction({required this.label, required this.onPressed, this.textColor, this.backgroundColor});

  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  List<Object?> get props => [label, textColor, backgroundColor];
}
