import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_config.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/atoms/overlay_barrier.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// Custom modal route for adaptive overlays.
///
/// Provides custom animations and barrier handling based on overlay type.
class VooOverlayRoute<T> extends PopupRoute<T> {
  /// The overlay configuration.
  final VooOverlayConfig config;

  /// The determined overlay type.
  final VooOverlayType overlayType;

  /// Builder for the overlay content.
  final WidgetBuilder builder;

  VooOverlayRoute({
    required this.config,
    required this.overlayType,
    required this.builder,
  }) : super(settings: config.routeSettings);

  @override
  Color? get barrierColor {
    // Barrier is handled by OverlayBarrier widget
    return null;
  }

  @override
  bool get barrierDismissible => config.behavior.isDismissible;

  @override
  String? get barrierLabel => config.semanticLabel ?? 'Dismiss';

  @override
  Duration get transitionDuration {
    return config.animationDuration ?? const Duration(milliseconds: 250);
  }

  @override
  Duration get reverseTransitionDuration {
    return config.animationDuration ?? const Duration(milliseconds: 200);
  }

  Curve get _enterCurve => config.enterCurve ?? Curves.easeOutCubic;
  Curve get _exitCurve => config.exitCurve ?? Curves.easeInCubic;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final overlayStyle = BaseOverlayStyle.fromPreset(config.style, customData: config.customStyle);
    final barrierColor = overlayStyle.getBarrierColor(context);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: _enterCurve,
      reverseCurve: _exitCurve,
    );

    return Stack(
      children: [
        // Barrier
        OverlayBarrier(
          color: barrierColor,
          style: config.style,
          isDismissible: config.behavior.isDismissible,
          onTap: config.behavior.isDismissible ? () => Navigator.of(context).pop() : null,
          animation: curvedAnimation,
          blurSigma: overlayStyle.getBlurSigma(),
        ),
        // Overlay content with animation
        _buildAnimatedOverlay(context, curvedAnimation, child),
      ],
    );
  }

  Widget _buildAnimatedOverlay(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    switch (overlayType) {
      case VooOverlayType.bottomSheet:
        return _buildBottomSheetAnimation(animation, child);
      case VooOverlayType.modal:
        return _buildModalAnimation(animation, child);
      case VooOverlayType.sideSheet:
        return _buildSideSheetAnimation(context, animation, child);
      case VooOverlayType.fullscreen:
        return _buildFullscreenAnimation(animation, child);
    }
  }

  Widget _buildBottomSheetAnimation(Animation<double> animation, Widget child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildModalAnimation(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildSideSheetAnimation(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    final beginOffset = config.anchorRight
        ? const Offset(1, 0)
        : const Offset(-1, 0);

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  Widget _buildFullscreenAnimation(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
