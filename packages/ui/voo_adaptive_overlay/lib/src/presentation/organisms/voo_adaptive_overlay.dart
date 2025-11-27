import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_config.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_bottom_sheet.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_fullscreen_overlay.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_modal_dialog.dart';
import 'package:voo_adaptive_overlay/src/presentation/organisms/voo_side_sheet.dart';
import 'package:voo_adaptive_overlay/src/presentation/utils/overlay_route.dart';
import 'package:voo_responsive/voo_responsive.dart';

/// Main adaptive overlay widget that automatically selects the appropriate
/// overlay type based on screen size.
///
/// This is the primary API for showing adaptive overlays in your app.
class VooAdaptiveOverlay {
  VooAdaptiveOverlay._();

  /// Shows an adaptive overlay that automatically selects the presentation
  /// type based on screen size.
  ///
  /// Returns a [Future] that resolves to the value passed to [Navigator.pop]
  /// when the overlay is dismissed.
  ///
  /// ```dart
  /// final result = await VooAdaptiveOverlay.show<bool>(
  ///   context: context,
  ///   title: Text('Confirm'),
  ///   content: Text('Are you sure?'),
  ///   actions: [
  ///     VooOverlayAction.cancel(),
  ///     VooOverlayAction.confirm(onPressed: () => Navigator.pop(context, true)),
  ///   ],
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = const VooOverlayConfig(),
  }) {
    final screenInfo = ScreenInfo.fromContext(context);
    final overlayType = _determineOverlayType(screenInfo, config);

    return Navigator.of(context, rootNavigator: config.useRootNavigator).push<T>(
      VooOverlayRoute<T>(
        config: config,
        overlayType: overlayType,
        builder: (context) => _buildOverlay(
          context: context,
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          config: config,
          overlayType: overlayType,
        ),
      ),
    );
  }

  /// Shows a bottom sheet overlay regardless of screen size.
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = const VooOverlayConfig(),
  }) {
    return show<T>(
      context: context,
      title: title,
      content: content,
      builder: builder,
      actions: actions,
      config: config.copyWith(forceType: VooOverlayType.bottomSheet),
    );
  }

  /// Shows a modal dialog overlay regardless of screen size.
  static Future<T?> showModal<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = const VooOverlayConfig(),
  }) {
    return show<T>(
      context: context,
      title: title,
      content: content,
      builder: builder,
      actions: actions,
      config: config.copyWith(forceType: VooOverlayType.modal),
    );
  }

  /// Shows a side sheet overlay regardless of screen size.
  static Future<T?> showSideSheet<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = const VooOverlayConfig(),
  }) {
    return show<T>(
      context: context,
      title: title,
      content: content,
      builder: builder,
      actions: actions,
      config: config.copyWith(forceType: VooOverlayType.sideSheet),
    );
  }

  /// Shows a fullscreen overlay regardless of screen size.
  static Future<T?> showFullscreen<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    VooOverlayConfig config = const VooOverlayConfig(),
  }) {
    return show<T>(
      context: context,
      title: title,
      content: content,
      builder: builder,
      actions: actions,
      config: config.copyWith(forceType: VooOverlayType.fullscreen),
    );
  }

  /// Determines the appropriate overlay type based on screen info and config.
  static VooOverlayType _determineOverlayType(
    ScreenInfo screenInfo,
    VooOverlayConfig config,
  ) {
    // If forced type is specified, use it
    if (config.forceType != null) {
      return config.forceType!;
    }

    final width = screenInfo.width;
    final breakpoints = config.breakpoints;

    // Check for fullscreen on very small screens
    if (breakpoints.useFullscreenForCompact && width < breakpoints.fullscreenThreshold) {
      return VooOverlayType.fullscreen;
    }

    // Bottom sheet for mobile
    if (width < breakpoints.bottomSheetMaxWidth) {
      return VooOverlayType.bottomSheet;
    }

    // Modal for tablet
    if (width < breakpoints.modalMaxWidth) {
      return VooOverlayType.modal;
    }

    // Desktop - choose between side sheet and modal
    if (breakpoints.preferSideSheetOnDesktop) {
      return VooOverlayType.sideSheet;
    }

    return VooOverlayType.modal;
  }

  /// Builds the appropriate overlay widget based on the determined type.
  static Widget _buildOverlay({
    required BuildContext context,
    Widget? title,
    Widget? content,
    Widget Function(BuildContext, ScrollController?)? builder,
    List<VooOverlayAction>? actions,
    required VooOverlayConfig config,
    required VooOverlayType overlayType,
  }) {
    switch (overlayType) {
      case VooOverlayType.bottomSheet:
        return VooBottomSheet(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
        );
      case VooOverlayType.modal:
        return VooModalDialog(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
        );
      case VooOverlayType.sideSheet:
        return VooSideSheet(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
          constraints: config.constraints,
          anchorRight: config.anchorRight,
        );
      case VooOverlayType.fullscreen:
        return VooFullscreenOverlay(
          title: title,
          content: content,
          builder: builder,
          actions: actions,
          style: config.style,
          behavior: config.behavior,
        );
    }
  }
}
