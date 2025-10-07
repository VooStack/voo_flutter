import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_mobile_app_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_bottom_navigation.dart';

/// Mobile scaffold with bottom navigation
class VooMobileScaffold extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Body widget to display
  final Widget body;

  /// Background color
  final Color backgroundColor;

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

  const VooMobileScaffold({
    super.key,
    required this.config,
    required this.body,
    required this.backgroundColor,
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
    // Get the selected item from the config
    final selectedItem = config.items.firstWhere(
      (item) => item.id == selectedId,
      orElse: () => config.items.first,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar:
          showAppBar
              ? (appBar ??
                  VooMobileAppBar(
                    config: config,
                    selectedItem: selectedItem,
                    showMenuButton: false,
                  ))
              : null,
      body: body,
      bottomNavigationBar: VooAdaptiveBottomNavigation(
        config: config,
        selectedId: selectedId,
        onNavigationItemSelected: onNavigationItemSelected,
        type: config.bottomNavigationType,
      ),
      floatingActionButton: config.showFloatingActionButton
          ? config.floatingActionButton
          : null,
      floatingActionButtonLocation:
          config.floatingActionButtonLocation ??
          FloatingActionButtonLocation.centerDocked,
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
