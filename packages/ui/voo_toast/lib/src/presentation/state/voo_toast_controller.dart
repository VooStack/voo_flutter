import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voo_toast/src/data/repositories/toast_repository_impl.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/entities/toast_config.dart';
import 'package:voo_toast/src/domain/enums/toast_position.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/domain/repositories/toast_repository.dart';
import 'package:voo_toast/src/domain/use_cases/dismiss_toast_use_case.dart';
import 'package:voo_toast/src/domain/use_cases/show_toast_use_case.dart';

class VooToastController {
  factory VooToastController({BuildContext? context, ToastConfig? config}) {
    if (_instance != null) {
      return _instance!;
    }

    // Create config with theme-aware defaults if context is provided
    final effectiveConfig = config ?? (context != null ? ToastConfig.fromTheme(context) : const ToastConfig());

    _instance = VooToastController._internal(config: effectiveConfig);
    return _instance!;
  }

  VooToastController._internal({required ToastConfig config}) : _config = config {
    _repository = ToastRepositoryImpl(config: _config);
    _showToastUseCase = ShowToastUseCase(_repository);
    _dismissToastUseCase = DismissToastUseCase(_repository);
  }

  static VooToastController? _instance;

  static VooToastController get instance {
    _instance ??= VooToastController._internal(config: const ToastConfig());
    return _instance!;
  }

  static void init({BuildContext? context, ToastConfig? config}) {
    if (_instance != null) {
      _instance!.dispose();
    }

    final effectiveConfig = config ?? (context != null ? ToastConfig.fromTheme(context) : const ToastConfig());

    _instance = VooToastController._internal(config: effectiveConfig);
  }

  static void reset() {
    _instance?.dispose();
    _instance = null;
  }

  final ToastConfig _config;
  late final ToastRepository _repository;
  late final ShowToastUseCase _showToastUseCase;
  late final DismissToastUseCase _dismissToastUseCase;

  int _toastCounter = 0;

  Stream<List<Toast>> get toastsStream => _repository.toastsStream;
  List<Toast> get currentToasts => _repository.currentToasts;
  ToastConfig get config => _config;

  String _generateToastId() => 'toast_${++_toastCounter}_${DateTime.now().millisecondsSinceEpoch}';

  ToastPosition _getPositionForPlatform(BuildContext context) {
    if (_config.defaultPosition != ToastPosition.auto) {
      return _config.defaultPosition;
    }

    final width = MediaQuery.of(context).size.width;

    if (kIsWeb) {
      return _config.webPosition;
    } else if (width < _config.breakpointMobile) {
      return _config.mobilePosition;
    } else if (width < _config.breakpointTablet) {
      return _config.tabletPosition;
    } else {
      return _config.webPosition;
    }
  }

  void showSuccess({
    required String message,
    String? title,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    List<ToastAction>? actions,
  }) {
    _show(
      message: message,
      title: title,
      type: ToastType.success,
      duration: duration,
      position: position,
      context: context,
      onTap: onTap,
      onDismissed: onDismissed,
      actions: actions,
    );
  }

  void showError({
    required String message,
    String? title,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    List<ToastAction>? actions,
  }) {
    _show(
      message: message,
      title: title,
      type: ToastType.error,
      duration: duration,
      position: position,
      context: context,
      onTap: onTap,
      onDismissed: onDismissed,
      actions: actions,
    );
  }

  void showWarning({
    required String message,
    String? title,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    List<ToastAction>? actions,
  }) {
    _show(
      message: message,
      title: title,
      type: ToastType.warning,
      duration: duration,
      position: position,
      context: context,
      onTap: onTap,
      onDismissed: onDismissed,
      actions: actions,
    );
  }

  void showInfo({
    required String message,
    String? title,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    List<ToastAction>? actions,
  }) {
    _show(
      message: message,
      title: title,
      type: ToastType.info,
      duration: duration,
      position: position,
      context: context,
      onTap: onTap,
      onDismissed: onDismissed,
      actions: actions,
    );
  }

  void showCustom({
    required Widget content,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
    double? width,
    double? maxWidth,
  }) {
    final toast = Toast(
      id: _generateToastId(),
      message: '',
      type: ToastType.custom,
      customContent: content,
      duration: duration ?? _config.defaultDuration,
      position: context != null ? (position ?? _getPositionForPlatform(context)) : (position ?? _config.defaultPosition),
      animation: _config.defaultAnimation,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius ?? _config.defaultBorderRadius,
      padding: padding ?? _config.defaultPadding,
      margin: margin ?? _config.defaultMargin,
      elevation: elevation ?? _config.defaultElevation,
      width: width,
      maxWidth: maxWidth ?? _config.defaultMaxWidth,
      onTap: onTap,
      onDismissed: onDismissed,
    );

    _showToastUseCase(toast);
  }

  void _show({
    required String message,
    String? title,
    required ToastType type,
    Duration? duration,
    ToastPosition? position,
    BuildContext? context,
    VoidCallback? onTap,
    VoidCallback? onDismissed,
    List<ToastAction>? actions,
  }) {
    // Get theme-aware colors if context is provided
    final themeConfig = context != null ? ToastConfig.fromTheme(context) : _config;
    final toast = Toast(
      id: _generateToastId(),
      message: message,
      title: title,
      type: type,
      duration: duration ?? themeConfig.defaultDuration,
      position: context != null ? (position ?? _getPositionForPlatform(context)) : (position ?? themeConfig.defaultPosition),
      animation: themeConfig.defaultAnimation,
      margin: themeConfig.defaultMargin,
      padding: themeConfig.defaultPadding,
      borderRadius: themeConfig.defaultBorderRadius,
      elevation: themeConfig.defaultElevation,
      maxWidth: themeConfig.defaultMaxWidth,
      textStyle: themeConfig.textStyle,
      titleStyle: themeConfig.titleStyle,
      actions: actions,
      onTap: onTap,
      onDismissed: onDismissed,
      isDismissible: themeConfig.dismissOnTap,
      showProgressBar: duration != Duration.zero,
    );

    _showToastUseCase(toast);
  }

  void dismiss(String toastId) {
    _dismissToastUseCase(toastId);
  }

  void dismissAll() {
    _repository.dismissAll();
  }

  void clearQueue() {
    _repository.clearQueue();
  }

  Future<T> showFutureToast<T>({
    required Future<T> future,
    String loadingMessage = 'Loading...',
    String? loadingTitle,
    String Function(T result)? successMessage,
    String? successTitle,
    String Function(Object error)? errorMessage,
    String? errorTitle,
    bool showSuccessToast = true,
    bool showErrorToast = true,
    Widget? loadingIcon,
    Duration? successDuration,
    Duration? errorDuration,
    ToastPosition? position,
    BuildContext? context,
  }) async {
    // Show loading toast
    final loadingToastId = _generateToastId();
    final loadingToast = Toast(
      id: loadingToastId,
      message: loadingMessage,
      title: loadingTitle,
      duration: Duration.zero, // Infinite duration
      position: context != null ? (position ?? _getPositionForPlatform(context)) : (position ?? _config.defaultPosition),
      animation: _config.defaultAnimation,
      margin: _config.defaultMargin,
      padding: _config.defaultPadding,
      borderRadius: _config.defaultBorderRadius,
      elevation: _config.defaultElevation,
      maxWidth: _config.defaultMaxWidth,
      icon: loadingIcon,
      isDismissible: false,
      showCloseButton: false,
      isLoading: true,
    );

    _showToastUseCase(loadingToast);

    try {
      final result = await future;

      // Dismiss loading toast
      dismiss(loadingToastId);

      // Show success toast if configured
      if (showSuccessToast) {
        final message = successMessage?.call(result) ?? 'Operation completed successfully';
        // Check if context is still valid before using it
        if (context != null && context.mounted) {
          showSuccess(message: message, title: successTitle, duration: successDuration, position: position, context: context);
        } else {
          showSuccess(message: message, title: successTitle, duration: successDuration, position: position);
        }
      }

      return result;
    } catch (error) {
      // Dismiss loading toast
      dismiss(loadingToastId);

      // Show error toast if configured
      if (showErrorToast) {
        final message = errorMessage?.call(error) ?? error.toString();
        // Check if context is still valid before using it
        if (context != null && context.mounted) {
          showError(message: message, title: errorTitle ?? 'Error', duration: errorDuration, position: position, context: context);
        } else {
          showError(message: message, title: errorTitle ?? 'Error', duration: errorDuration, position: position);
        }
      }

      rethrow;
    }
  }

  void dispose() {
    if (_repository is ToastRepositoryImpl) {
      _repository.dispose();
    }
  }
}
