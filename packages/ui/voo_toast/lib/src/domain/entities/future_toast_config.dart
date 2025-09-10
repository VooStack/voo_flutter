import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';

class FutureToastConfig extends Equatable {
  const FutureToastConfig({
    this.loadingMessage = 'Loading...',
    this.loadingTitle,
    this.successMessage,
    this.successTitle,
    this.errorMessage,
    this.errorTitle,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.loadingIcon,
    this.successIcon,
    this.errorIcon,
    this.position,
    this.successDuration = const Duration(seconds: 3),
    this.errorDuration = const Duration(seconds: 5),
  });

  final String loadingMessage;
  final String? loadingTitle;
  final String? successMessage;
  final String? successTitle;
  final String? errorMessage;
  final String? errorTitle;
  final bool showSuccessToast;
  final bool showErrorToast;
  final Widget? loadingIcon;
  final Widget? successIcon;
  final Widget? errorIcon;
  final ToastPosition? position;
  final Duration successDuration;
  final Duration errorDuration;

  @override
  List<Object?> get props => [
        loadingMessage,
        loadingTitle,
        successMessage,
        successTitle,
        errorMessage,
        errorTitle,
        showSuccessToast,
        showErrorToast,
        loadingIcon,
        successIcon,
        errorIcon,
        position,
        successDuration,
        errorDuration,
      ];
}