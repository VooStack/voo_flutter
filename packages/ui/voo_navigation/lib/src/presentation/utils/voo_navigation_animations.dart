import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation animation utilities
class VooNavigationAnimations {
  const VooNavigationAnimations._();

  /// Default animation duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Default animation curve
  static const Curve defaultCurve = Curves.easeInOutCubic;

  /// Fast animation duration
  static const Duration fastDuration = Duration(milliseconds: 150);

  /// Slow animation duration
  static const Duration slowDuration = Duration(milliseconds: 500);

  /// Page transition animation
  static Route<T> pageRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration? duration,
    Curve curve = defaultCurve,
    VooTransitionType type = VooTransitionType.fadeScale,
  }) => PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    settings: settings,
    transitionDuration: duration ?? defaultDuration,
    reverseTransitionDuration: duration ?? defaultDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case VooTransitionType.fade:
          return _fadeTransition(animation, child);
        case VooTransitionType.slide:
          return _slideTransition(animation, child, curve);
        case VooTransitionType.scale:
          return _scaleTransition(animation, child, curve);
        case VooTransitionType.fadeScale:
          return _fadeScaleTransition(animation, child, curve);
        case VooTransitionType.slideUp:
          return _slideUpTransition(animation, child, curve);
        case VooTransitionType.slideDown:
          return _slideDownTransition(animation, child, curve);
        case VooTransitionType.custom:
          return child;
      }
    },
  );

  /// Fade transition
  static Widget _fadeTransition(Animation<double> animation, Widget child) =>
      FadeTransition(opacity: animation, child: child);

  /// Slide transition from right
  static Widget _slideTransition(
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final tween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Scale transition
  static Widget _scaleTransition(
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

    return ScaleTransition(scale: animation.drive(tween), child: child);
  }

  /// Combined fade and scale transition
  static Widget _fadeScaleTransition(
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final scaleTween = Tween(
      begin: 0.95,
      end: 1.0,
    ).chain(CurveTween(curve: curve));

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
    );
  }

  /// Slide up transition
  static Widget _slideUpTransition(
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final tween = Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Slide down transition
  static Widget _slideDownTransition(
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final tween = Tween(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Navigation item animation wrapper
  static Widget itemAnimation({
    required Widget child,
    required bool isSelected,
    Duration? duration,
    Curve curve = defaultCurve,
    bool enableScale = true,
    bool enableFade = false,
  }) {
    if (!enableScale && !enableFade) {
      return child;
    }

    Widget result = child;

    if (enableScale) {
      result = AnimatedScale(
        scale: isSelected ? 1.0 : 0.95,
        duration: duration ?? defaultDuration,
        curve: curve,
        child: result,
      );
    }

    if (enableFade) {
      result = AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.7,
        duration: duration ?? defaultDuration,
        curve: curve,
        child: result,
      );
    }

    return result;
  }

  /// Badge animation wrapper
  static Widget badgeAnimation({
    required Widget child,
    required bool show,
    Duration? duration,
    Curve curve = Curves.elasticOut,
  }) => AnimatedScale(
    scale: show ? 1.0 : 0.0,
    duration: duration ?? fastDuration,
    curve: curve,
    child: AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: duration ?? fastDuration,
      child: child,
    ),
  );

  /// Staggered animation for list items
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    required int itemCount,
    Duration? baseDuration,
    Duration? staggerDelay,
    Curve curve = defaultCurve,
  }) {
    final effectiveBaseDuration = baseDuration ?? defaultDuration;
    final effectiveStaggerDelay =
        staggerDelay ??
        Duration(milliseconds: (fastDuration.inMilliseconds * 0.33).round());
    final delay = effectiveStaggerDelay * index;
    final totalDuration = effectiveBaseDuration + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: totalDuration,
      curve: Interval(
        delay.inMilliseconds / totalDuration.inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }

  /// Ripple animation for touch feedback
  static Widget rippleAnimation({
    required Widget child,
    required VoidCallback onTap,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
    required BuildContext context,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? context.vooRadius.button,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: child,
    ),
  );

  /// Drawer slide animation
  static Widget drawerSlideAnimation({
    required Widget child,
    required bool isOpen,
    Duration? duration,
    Curve curve = defaultCurve,
    double slideDistance = 250,
  }) => AnimatedSlide(
    offset: isOpen ? Offset.zero : Offset(-slideDistance, 0),
    duration: duration ?? defaultDuration,
    curve: curve,
    child: child,
  );

  /// Navigation rail expand animation
  static Widget railExpandAnimation({
    required Widget child,
    required bool isExpanded,
    Duration? duration,
    Curve curve = defaultCurve,
  }) => AnimatedContainer(
    duration: duration ?? defaultDuration,
    curve: curve,
    width: isExpanded ? 256 : 80,
    child: child,
  );

  /// FAB entrance animation
  static Widget fabEntranceAnimation({
    required Widget child,
    Duration? duration,
    Curve curve = Curves.elasticOut,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: duration ?? slowDuration,
    curve: curve,
    builder: (context, value, child) => Transform.scale(
      scale: value,
      child: Opacity(opacity: value, child: child),
    ),
    child: child,
  );

  /// Navigation type transition
  static Widget navigationTypeTransition({
    required Widget child,
    required String transitionKey,
    Duration? duration,
  }) => AnimatedSwitcher(
    duration: duration ?? defaultDuration,
    switchInCurve: Curves.easeInOut,
    switchOutCurve: Curves.easeInOut,
    transitionBuilder: (child, animation) => FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
        child: child,
      ),
    ),
    child: KeyedSubtree(key: ValueKey(transitionKey), child: child),
  );
}

/// Transition types for page routes
enum VooTransitionType {
  /// Fade transition
  fade,

  /// Slide from right
  slide,

  /// Scale transition
  scale,

  /// Combined fade and scale
  fadeScale,

  /// Slide up from bottom
  slideUp,

  /// Slide down from top
  slideDown,

  /// Custom transition
  custom,
}
