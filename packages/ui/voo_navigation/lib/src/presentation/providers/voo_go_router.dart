import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/domain/entities/navigation_route.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_router_shell.dart';

/// Provider for creating a GoRouter with VooNavigation integration
class VooGoRouter {
  static const _animationTokens = VooAnimationTokens();
  /// Creates a GoRouter configured with VooNavigation
  static GoRouter create({
    required VooNavigationConfig config,
    required List<VooNavigationRoute> routes,
    String? initialLocation,
    String? Function(BuildContext, GoRouterState)? redirect,
    void Function(BuildContext, GoRouterState, Object)? onException,
    Widget Function(BuildContext, GoRouterState)? errorBuilder,
    Widget Function(BuildContext, Widget)? builder,
    NavigatorObserver? observer,
    List<NavigatorObserver>? observers,
    String? restorationScopeId,
    bool debugLogDiagnostics = false,
    bool requestFocus = true,
  }) {
    // Convert navigation items to routes if needed
    final shellRoutes = _createShellRoutes(config, routes);

    return GoRouter(
      initialLocation: initialLocation ?? '/',
      redirect: redirect,
      onException: onException,
      errorBuilder: errorBuilder,
      observers: [
        if (observer != null) observer,
        ...observers ?? [],
        _VooNavigationObserver(config),
      ],
      debugLogDiagnostics: debugLogDiagnostics,
      restorationScopeId: restorationScopeId,
      requestFocus: requestFocus,
      routes: [
        ShellRoute(
          builder: (context, state, child) => VooRouterShell(
            config: config,
            state: state,
            customBuilder: builder,
            child: child,
          ),
          routes: shellRoutes,
        ),
      ],
    );
  }

  /// Creates a GoRouter with automatic route generation from navigation items
  static GoRouter fromNavigationItems({
    required VooNavigationConfig config,
    required Widget Function(BuildContext context, VooNavigationItem item)
    pageBuilder,
    String? initialLocation,
    String? Function(BuildContext, GoRouterState)? redirect,
    void Function(BuildContext, GoRouterState, Object)? onException,
    Widget Function(BuildContext, GoRouterState)? errorBuilder,
    Widget Function(BuildContext, Widget)? builder,
    NavigatorObserver? observer,
    List<NavigatorObserver>? observers,
    String? restorationScopeId,
    bool debugLogDiagnostics = false,
    bool requestFocus = true,
    bool useAnimatedTransitions = true,
    Duration? transitionDuration,
  }) {
    // Generate routes from navigation items
    final routes = _generateRoutesFromItems(
      config.items,
      pageBuilder,
      useAnimatedTransitions,
      transitionDuration ?? _animationTokens.durationNormal,
    );

    return create(
      config: config,
      routes: routes,
      initialLocation: initialLocation,
      redirect: redirect,
      onException: onException,
      errorBuilder: errorBuilder,
      builder: builder,
      observer: observer,
      observers: observers,
      restorationScopeId: restorationScopeId,
      debugLogDiagnostics: debugLogDiagnostics,
      requestFocus: requestFocus,
    );
  }

  /// Creates a simple GoRouter with predefined pages
  static GoRouter simple({
    required VooNavigationConfig config,
    required Map<String, Widget> pages,
    String? initialLocation,
    bool useAnimatedTransitions = true,
    Duration? transitionDuration,
    String? Function(BuildContext, GoRouterState)? redirect,
    Widget? errorPage,
    NavigatorObserver? observer,
    List<NavigatorObserver>? observers,
    bool debugLogDiagnostics = false,
  }) {
    // Ensure all navigation items have corresponding pages
    final routes = <VooNavigationRoute>[];

    for (final item in config.items) {
      if (item.route != null && pages.containsKey(item.id)) {
        final route = useAnimatedTransitions
            ? VooNavigationRoute.fade(
                id: item.id,
                path: item.route!,
                name: item.id,
                builder: (context, state) => pages[item.id]!,
                transitionDuration: transitionDuration,
              )
            : VooNavigationRoute.material(
                id: item.id,
                path: item.route!,
                name: item.id,
                builder: (context, state) => pages[item.id]!,
              );
        routes.add(route);
      }
    }

    return create(
      config: config,
      routes: routes,
      initialLocation: initialLocation,
      redirect: redirect,
      errorBuilder: errorPage != null ? (context, state) => errorPage : null,
      observer: observer,
      observers: observers,
      debugLogDiagnostics: debugLogDiagnostics,
    );
  }

  /// Creates shell routes from VooNavigationRoute list
  static List<RouteBase> _createShellRoutes(
    VooNavigationConfig config,
    List<VooNavigationRoute> routes,
  ) {
    return routes.map((route) => route.toGoRoute()).toList();
  }

  /// Generates routes from navigation items
  static List<VooNavigationRoute> _generateRoutesFromItems(
    List<VooNavigationItem> items,
    Widget Function(BuildContext context, VooNavigationItem item) pageBuilder,
    bool useAnimatedTransitions,
    Duration transitionDuration,
  ) {
    final routes = <VooNavigationRoute>[];

    for (final item in items) {
      if (item.route != null && !item.isDivider) {
        final route = useAnimatedTransitions
            ? VooNavigationRoute.fade(
                id: item.id,
                path: item.route!,
                name: item.id,
                builder: (context, state) => pageBuilder(context, item),
                transitionDuration: transitionDuration,
                routes: item.children != null
                    ? _generateRoutesFromItems(
                        item.children!,
                        pageBuilder,
                        useAnimatedTransitions,
                        transitionDuration,
                      )
                    : [],
              )
            : VooNavigationRoute.material(
                id: item.id,
                path: item.route!,
                name: item.id,
                builder: (context, state) => pageBuilder(context, item),
                routes: item.children != null
                    ? _generateRoutesFromItems(
                        item.children!,
                        pageBuilder,
                        useAnimatedTransitions,
                        transitionDuration,
                      )
                    : [],
              );
        routes.add(route);
      }

      // Process children even if parent doesn't have a route
      if (item.children != null && item.route == null) {
        routes.addAll(
          _generateRoutesFromItems(
            item.children!,
            pageBuilder,
            useAnimatedTransitions,
            transitionDuration,
          ),
        );
      }
    }

    return routes;
  }

}

/// Navigation observer for VooNavigation
class _VooNavigationObserver extends NavigatorObserver {
  final VooNavigationConfig config;

  _VooNavigationObserver(this.config);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRouteChange(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _handleRouteChange(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _handleRouteChange(newRoute);
    }
  }

  void _handleRouteChange(Route<dynamic> route) {
    // Handle route change callbacks if needed
    final routeName = route.settings.name;
    if (routeName != null) {
      // Find matching navigation item
      for (final item in config.items) {
        if (item.route == routeName || item.id == routeName) {
          config.onNavigationItemSelected?.call(item.id);
          break;
        }
      }
    }
  }
}
