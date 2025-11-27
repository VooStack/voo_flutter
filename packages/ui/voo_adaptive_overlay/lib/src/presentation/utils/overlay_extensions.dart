import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_config.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_adaptive_overlay.dart';

/// Extension methods on [BuildContext] for showing adaptive overlays.
///
/// Provides a convenient syntax for showing overlays:
/// ```dart
/// context.showAdaptiveOverlay(
///   title: Text('Hello'),
///   content: Text('World'),
/// );
/// ```
extension VooAdaptiveOverlayExtension on BuildContext {
  /// Shows an adaptive overlay that automatically selects the presentation
  /// type based on screen size.
  Future<T?> showAdaptiveOverlay<T>({
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      VooAdaptiveOverlay.show<T>(
        context: this,
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        config: config,
      );

  /// Shows a confirmation dialog with Yes/No actions.
  Future<bool?> showConfirmation({
    required String message,
    String title = 'Confirm',
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      showAdaptiveOverlay<bool>(
        title: Text(title),
        content: Text(message),
        actions: [
          VooOverlayAction.cancel(label: cancelLabel),
          isDestructive
              ? VooOverlayAction.destructive(
                  label: confirmLabel,
                  onPressed: () => Navigator.of(this).pop(true),
                )
              : VooOverlayAction.confirm(
                  label: confirmLabel,
                  onPressed: () => Navigator.of(this).pop(true),
                ),
        ],
        config: config,
      );

  /// Shows an alert dialog with just an OK button.
  Future<void> showAlert({
    required String message,
    String title = 'Alert',
    String buttonLabel = 'OK',
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      showAdaptiveOverlay<void>(
        title: Text(title),
        content: Text(message),
        actions: [
          VooOverlayAction.ok(label: buttonLabel),
        ],
        config: config,
      );

  /// Shows a bottom sheet overlay.
  Future<T?> showBottomSheet<T>({
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      VooAdaptiveOverlay.showBottomSheet<T>(
        context: this,
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        config: config,
      );

  /// Shows a modal dialog overlay.
  Future<T?> showModal<T>({
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      VooAdaptiveOverlay.showModal<T>(
        context: this,
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        config: config,
      );

  /// Shows a side sheet overlay.
  Future<T?> showSideSheet<T>({
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      VooAdaptiveOverlay.showSideSheet<T>(
        context: this,
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        config: config,
      );

  /// Shows a fullscreen overlay.
  Future<T?> showFullscreenOverlay<T>({
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = VooOverlayConfig.material,
  }) =>
      VooAdaptiveOverlay.showFullscreen<T>(
        context: this,
        title: title,
        content: content,
        builder: builder,
        actions: actions,
        config: config,
      );
}
