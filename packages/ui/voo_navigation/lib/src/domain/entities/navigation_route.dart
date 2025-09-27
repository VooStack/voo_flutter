import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Represents a route in the navigation system with go_router integration
class VooNavigationRoute {
  /// Default animation tokens for the navigation
  static const _animationTokens = VooAnimationTokens();

  /// Unique identifier for the route
  final String id;

  /// Path for the route (e.g., '/dashboard')
  final String path;

  /// Name of the route for navigation
  final String? name;

  /// Builder for the page content
  final Widget Function(BuildContext context, GoRouterState state) builder;

  /// Page builder for custom transitions
  final Page<dynamic> Function(BuildContext context, GoRouterState state)?
  pageBuilder;

  /// Child routes
  final List<VooNavigationRoute> routes;

  /// Redirect logic
  final String? Function(BuildContext context, GoRouterState state)? redirect;

  /// Route guard/middleware
  final Future<bool> Function(BuildContext context, GoRouterState state)? guard;

  /// Custom transition animation
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )?
  transitionBuilder;

  /// Transition duration
  final Duration transitionDuration;

  /// Whether this route should be full screen (hides navigation)
  final bool fullScreenDialog;

  /// Whether to maintain state when switching routes
  final bool maintainState;

  /// Route metadata
  final Map<String, dynamic>? metadata;

  VooNavigationRoute({
    required this.id,
    required this.path,
    required this.builder,
    this.name,
    this.pageBuilder,
    this.routes = const [],
    this.redirect,
    this.guard,
    this.transitionBuilder,
    Duration? transitionDuration,
    this.fullScreenDialog = false,
    this.maintainState = true,
    this.metadata,
  }) : transitionDuration =
           transitionDuration ?? _animationTokens.durationNormal;

  /// Factory constructor for creating a route with Material page transition
  factory VooNavigationRoute.material({
    required String id,
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    String? name,
    List<VooNavigationRoute> routes = const [],
    String? Function(BuildContext context, GoRouterState state)? redirect,
    Future<bool> Function(BuildContext context, GoRouterState state)? guard,
    Duration? transitionDuration,
    bool fullScreenDialog = false,
    bool maintainState = true,
    Map<String, dynamic>? metadata,
  }) {
    return VooNavigationRoute(
      id: id,
      path: path,
      name: name,
      builder: builder,
      routes: routes,
      redirect: redirect,
      guard: guard,
      transitionDuration: transitionDuration,
      fullScreenDialog: fullScreenDialog,
      maintainState: maintainState,
      metadata: metadata,
      pageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: builder(context, state),
        fullscreenDialog: fullScreenDialog,
        maintainState: maintainState,
      ),
    );
  }

  /// Factory constructor for creating a route with custom page transition
  factory VooNavigationRoute.custom({
    required String id,
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    String? name,
    required Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )
    transitionBuilder,
    List<VooNavigationRoute> routes = const [],
    String? Function(BuildContext context, GoRouterState state)? redirect,
    Future<bool> Function(BuildContext context, GoRouterState state)? guard,
    Duration? transitionDuration,
    bool fullScreenDialog = false,
    bool maintainState = true,
    Map<String, dynamic>? metadata,
  }) {
    return VooNavigationRoute(
      id: id,
      path: path,
      name: name,
      builder: builder,
      transitionBuilder: transitionBuilder,
      routes: routes,
      redirect: redirect,
      guard: guard,
      transitionDuration: transitionDuration,
      fullScreenDialog: fullScreenDialog,
      maintainState: maintainState,
      metadata: metadata,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: builder(context, state),
        transitionDuration:
            transitionDuration ?? _animationTokens.durationNormal,
        transitionsBuilder: transitionBuilder,
        fullscreenDialog: fullScreenDialog,
        maintainState: maintainState,
      ),
    );
  }

  /// Factory constructor for creating a fade transition route
  factory VooNavigationRoute.fade({
    required String id,
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    String? name,
    List<VooNavigationRoute> routes = const [],
    String? Function(BuildContext context, GoRouterState state)? redirect,
    Future<bool> Function(BuildContext context, GoRouterState state)? guard,
    Duration? transitionDuration,
    bool fullScreenDialog = false,
    bool maintainState = true,
    Map<String, dynamic>? metadata,
  }) {
    return VooNavigationRoute.custom(
      id: id,
      path: path,
      name: name,
      builder: builder,
      routes: routes,
      redirect: redirect,
      guard: guard,
      transitionDuration: transitionDuration,
      fullScreenDialog: fullScreenDialog,
      maintainState: maintainState,
      metadata: metadata,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Factory constructor for creating a slide transition route
  factory VooNavigationRoute.slide({
    required String id,
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    String? name,
    Offset beginOffset = const Offset(1.0, 0.0),
    Offset endOffset = Offset.zero,
    Curve curve = Curves.easeInOutCubic,
    List<VooNavigationRoute> routes = const [],
    String? Function(BuildContext context, GoRouterState state)? redirect,
    Future<bool> Function(BuildContext context, GoRouterState state)? guard,
    Duration? transitionDuration,
    bool fullScreenDialog = false,
    bool maintainState = true,
    Map<String, dynamic>? metadata,
  }) {
    return VooNavigationRoute.custom(
      id: id,
      path: path,
      name: name,
      builder: builder,
      routes: routes,
      redirect: redirect,
      guard: guard,
      transitionDuration: transitionDuration,
      fullScreenDialog: fullScreenDialog,
      maintainState: maintainState,
      metadata: metadata,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: beginOffset, end: endOffset);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Factory constructor for creating a scale transition route
  factory VooNavigationRoute.scale({
    required String id,
    required String path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
    String? name,
    double beginScale = 0.0,
    double endScale = 1.0,
    Curve curve = Curves.easeInOutCubic,
    Alignment alignment = Alignment.center,
    List<VooNavigationRoute> routes = const [],
    String? Function(BuildContext context, GoRouterState state)? redirect,
    Future<bool> Function(BuildContext context, GoRouterState state)? guard,
    Duration? transitionDuration,
    bool fullScreenDialog = false,
    bool maintainState = true,
    Map<String, dynamic>? metadata,
  }) {
    return VooNavigationRoute.custom(
      id: id,
      path: path,
      name: name,
      builder: builder,
      routes: routes,
      redirect: redirect,
      guard: guard,
      transitionDuration: transitionDuration,
      fullScreenDialog: fullScreenDialog,
      maintainState: maintainState,
      metadata: metadata,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: beginScale, end: endScale);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return ScaleTransition(
          scale: tween.animate(curvedAnimation),
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  /// Converts this route to a GoRoute
  GoRoute toGoRoute() {
    return GoRoute(
      path: path,
      name: name,
      builder: pageBuilder == null ? builder : null,
      pageBuilder: pageBuilder,
      routes: routes.map((r) => r.toGoRoute()).toList(),
      redirect: redirect,
    );
  }
}
