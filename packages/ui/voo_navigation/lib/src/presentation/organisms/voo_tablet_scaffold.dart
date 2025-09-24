import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_app_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_navigation_rail.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Tablet scaffold with navigation rail
class VooTabletScaffold extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Body widget to display
  final Widget body;

  /// Background color
  final Color backgroundColor;

  /// Whether to show extended navigation rail
  final bool extended;

  /// Currently selected navigation item ID
  final String selectedId;

  /// Callback when a navigation item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Scaffold key for external control
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Optional custom app bar
  final PreferredSizeWidget? appBar;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Custom end drawer
  final Widget? endDrawer;

  /// Drawer edge drag width
  final double drawerEdgeDragWidth;

  /// Whether drawer is open initially
  final bool drawerEnableOpenDragGesture;

  /// Whether end drawer is open initially
  final bool endDrawerEnableOpenDragGesture;

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

  const VooTabletScaffold({
    super.key,
    required this.config,
    required this.body,
    required this.backgroundColor,
    required this.extended,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.scaffoldKey,
    this.appBar,
    required this.showAppBar,
    this.endDrawer,
    required this.drawerEdgeDragWidth,
    required this.drawerEnableOpenDragGesture,
    required this.endDrawerEnableOpenDragGesture,
    required this.resizeToAvoidBottomInset,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationRail = ClipRect(
      child: VooAdaptiveNavigationRail(
        config: config,
        selectedId: selectedId,
        onNavigationItemSelected: onNavigationItemSelected,
        extended: extended,
      ),
    );

    // When app bar is alongside rail, wrap the content area with its own scaffold
    if (config.appBarAlongsideRail && showAppBar) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            navigationRail,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: config.navigationRailMargin,
                  right: config.navigationRailMargin,
                  bottom: config.navigationRailMargin,
                  // No left margin to avoid double spacing with navigation
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.vooRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.vooRadius.lg),
                  child: Scaffold(
                    backgroundColor: backgroundColor,
                    appBar: appBar ?? const VooAdaptiveAppBar(showMenuButton: false),
                    body: body,
                    floatingActionButton: config.showFloatingActionButton
                        ? config.floatingActionButton
                        : null,
                    floatingActionButtonLocation: config.floatingActionButtonLocation,
                    floatingActionButtonAnimator: config.floatingActionButtonAnimator,
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: endDrawer,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        bottomSheet: bottomSheet,
        persistentFooterButtons: persistentFooterButtons,
        restorationId: restorationId,
      );
    }

    // Original behavior: app bar spans full width
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? (appBar ?? const VooAdaptiveAppBar(showMenuButton: false))
          : null,
      body: Row(
        children: [
          navigationRail,
          Expanded(child: body),
        ],
      ),
      floatingActionButton: config.showFloatingActionButton
          ? config.floatingActionButton
          : null,
      floatingActionButtonLocation: config.floatingActionButtonLocation,
      floatingActionButtonAnimator: config.floatingActionButtonAnimator,
      endDrawer: endDrawer,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      bottomSheet: bottomSheet,
      persistentFooterButtons: persistentFooterButtons,
      restorationId: restorationId,
    );
  }
}