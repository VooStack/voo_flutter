import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_scaffold.dart';

/// Shell widget that integrates VooAdaptiveScaffold with go_router
class VooNavigationShell extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Child widget (from go_router)
  final Widget child;

  /// Optional custom app bar
  final PreferredSizeWidget? appBar;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Custom end drawer
  final Widget? endDrawer;

  /// Background color
  final Color? backgroundColor;

  /// Whether to resize to avoid bottom inset
  final bool resizeToAvoidBottomInset;

  /// Whether to extend body
  final bool extendBody;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Custom bottom sheet
  final Widget? bottomSheet;

  /// Persistent footer buttons
  final List<Widget>? persistentFooterButtons;

  /// Restoration ID for state restoration
  final String? restorationId;

  /// Scaffold key for external control
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const VooNavigationShell({
    super.key,
    required this.config,
    required this.child,
    this.appBar,
    this.showAppBar = true,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
    this.scaffoldKey,
  });

  @override
  State<VooNavigationShell> createState() => _VooNavigationShellState();
}

class _VooNavigationShellState extends State<VooNavigationShell> {
  late VooNavigationConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(VooNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _config = widget.config;
    }
  }

  void _handleNavigationItemSelected(String itemId) {
    // Find the selected item
    final item = _findNavigationItem(itemId, _config.items);
    if (item == null || !item.isEnabled) return;

    // Update the config with new selected ID
    setState(() {
      _config = _config.copyWith(selectedId: itemId);
    });

    // Navigate using go_router
    if (item.route != null && context.mounted) {
      context.go(item.route!);
    }

    // Call callbacks
    item.onTap?.call();
    widget.config.onNavigationItemSelected?.call(itemId);
  }

  VooNavigationItem? _findNavigationItem(String id, List<VooNavigationItem> items) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.children != null) {
        final found = _findNavigationItem(id, item.children!);
        if (found != null) return found;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Update selected ID based on current route if not explicitly set
    if (_config.selectedId == null) {
      final String location = GoRouterState.of(context).uri.toString();
      _updateSelectedIdFromRoute(location);
    }

    return VooAdaptiveScaffold(
      config: _config.copyWith(
        onNavigationItemSelected: _handleNavigationItemSelected,
      ),
      body: AnimatedSwitcher(
        duration: widget.config.animationDuration,
        switchInCurve: widget.config.animationCurve,
        switchOutCurve: widget.config.animationCurve.flipped,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.02),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
      appBar: widget.appBar,
      showAppBar: widget.showAppBar,
      endDrawer: widget.endDrawer,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomSheet: widget.bottomSheet,
      persistentFooterButtons: widget.persistentFooterButtons,
      restorationId: widget.restorationId,
      scaffoldKey: widget.scaffoldKey,
    );
  }

  void _updateSelectedIdFromRoute(String location) {
    // Find matching navigation item by route
    for (final item in _config.items) {
      if (item.route != null && location.startsWith(item.route!)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _config = _config.copyWith(selectedId: item.id);
            });
          }
        });
        return;
      }
      // Check children
      if (item.children != null) {
        for (final childItem in item.children!) {
          if (childItem.route != null && location.startsWith(childItem.route!)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _config = _config.copyWith(selectedId: childItem.id);
                });
              }
            });
            return;
          }
        }
      }
    }
  }
}

/// Extension to easily access VooNavigationShell from context
extension VooNavigationShellExtension on BuildContext {
  /// Gets the current VooNavigationShell if available
  VooNavigationShell? get vooNavigationShell {
    return findAncestorWidgetOfExactType<VooNavigationShell>();
  }

  /// Gets the current navigation configuration
  VooNavigationConfig? get vooNavigationConfig {
    return vooNavigationShell?.config;
  }

  /// Navigates to a specific navigation item by ID
  void vooNavigateTo(String itemId) {
    final shell = vooNavigationShell;
    if (shell != null) {
      final state = shell.createState() as _VooNavigationShellState;
      state._handleNavigationItemSelected(itemId);
    }
  }
}