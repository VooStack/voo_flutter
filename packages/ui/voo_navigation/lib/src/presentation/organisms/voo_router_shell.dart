import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_navigation_shell.dart';

/// Router shell widget that wraps navigation with GoRouter state management
class VooRouterShell extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Current GoRouter state
  final GoRouterState state;

  /// Child widget to display
  final Widget child;

  /// Optional custom builder
  final Widget Function(BuildContext, Widget)? customBuilder;

  const VooRouterShell({
    super.key,
    required this.config,
    required this.state,
    this.customBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Update selected ID based on current route
    final currentPath = state.uri.toString();
    String? selectedId;

    // Find matching navigation item by route
    for (final item in config.items) {
      if (item.route != null && currentPath.startsWith(item.route!)) {
        selectedId = item.id;
        break;
      }
      // Check children
      if (item.children != null) {
        for (final childItem in item.children!) {
          if (childItem.route != null &&
              currentPath.startsWith(childItem.route!)) {
            selectedId = childItem.id;
            break;
          }
        }
      }
    }

    final updatedConfig = config.copyWith(selectedId: selectedId);

    final shell = VooNavigationShell(
      config: updatedConfig,
      child: child,
    );

    return customBuilder != null ? customBuilder!(context, shell) : shell;
  }
}