import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_desktop_scaffold.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_mobile_scaffold.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_tablet_scaffold.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Builder widget that creates the appropriate scaffold based on navigation type
class VooScaffoldBuilder extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Navigation type to use
  final VooNavigationType navigationType;

  /// Screen information
  final ScreenInfo screenInfo;

  /// Body widget to display
  final Widget body;

  /// Currently selected navigation item ID
  final String selectedId;

  /// Callback when a navigation item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Animation controller for transitions
  final AnimationController animationController;

  /// Fade animation
  final Animation<double> fadeAnimation;

  /// Slide animation
  final Animation<Offset> slideAnimation;

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

  /// Scaffold key for external control
  final GlobalKey<ScaffoldState>? scaffoldKey;

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

  /// Padding to apply to the body content
  final EdgeInsetsGeometry? bodyPadding;

  /// Whether to wrap body in a card with elevation
  final bool useBodyCard;

  /// Elevation for body card
  final double bodyCardElevation;

  /// Border radius for body card
  final BorderRadius? bodyCardBorderRadius;

  /// Color for body card
  final Color? bodyCardColor;

  const VooScaffoldBuilder({
    super.key,
    required this.config,
    required this.navigationType,
    required this.screenInfo,
    required this.body,
    required this.selectedId,
    required this.onNavigationItemSelected,
    required this.animationController,
    required this.fadeAnimation,
    required this.slideAnimation,
    this.appBar,
    required this.showAppBar,
    this.endDrawer,
    required this.drawerEdgeDragWidth,
    required this.drawerEnableOpenDragGesture,
    required this.endDrawerEnableOpenDragGesture,
    this.scaffoldKey,
    this.backgroundColor,
    required this.resizeToAvoidBottomInset,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
    this.bodyPadding,
    required this.useBodyCard,
    required this.bodyCardElevation,
    this.bodyCardBorderRadius,
    this.bodyCardColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        config.backgroundColor ??
        theme.scaffoldBackgroundColor;

    // Prepare the body - let each scaffold type handle its own padding
    // This follows the KISS principle - each scaffold knows best how to position its content
    Widget processedBody = body;

    // Wrap in card if requested
    if (useBodyCard && navigationType != VooNavigationType.bottomNavigation) {
      final tokens = context.vooTokens;
      final cardColor = bodyCardColor ?? theme.colorScheme.surface;
      final borderRadius = bodyCardBorderRadius ?? tokens.radius.card;

      processedBody = Material(
        elevation: bodyCardElevation == 0
            ? tokens.elevation.card
            : bodyCardElevation,
        borderRadius: borderRadius,
        color: cardColor,
        child: ClipRRect(borderRadius: borderRadius, child: processedBody),
      );
    }

    if (config.enableAnimations) {
      processedBody = FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: slideAnimation, child: processedBody),
      );
    }

    // Build the scaffold based on navigation type with animation
    Widget scaffold;
    switch (navigationType) {
      case VooNavigationType.bottomNavigation:
        scaffold = KeyedSubtree(
          key: const ValueKey('mobile_scaffold'),
          child: VooMobileScaffold(
            config: config,
            body: processedBody,
            backgroundColor: effectiveBackgroundColor,
            selectedId: selectedId,
            onNavigationItemSelected: onNavigationItemSelected,
            scaffoldKey: scaffoldKey,
            appBar: appBar,
            showAppBar: showAppBar,
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
          ),
        );
        break;

      case VooNavigationType.navigationRail:
      case VooNavigationType.extendedNavigationRail:
        // Only show extended rail if config allows it AND we're in the right width range
        final shouldExtend =
            config.useExtendedRail &&
            navigationType == VooNavigationType.extendedNavigationRail;
        scaffold = KeyedSubtree(
          key: ValueKey('tablet_scaffold_$navigationType'),
          child: VooTabletScaffold(
            config: config,
            body: processedBody,
            backgroundColor: effectiveBackgroundColor,
            extended: shouldExtend,
            selectedId: selectedId,
            onNavigationItemSelected: onNavigationItemSelected,
            scaffoldKey: scaffoldKey,
            appBar: appBar,
            showAppBar: showAppBar,
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
          ),
        );
        break;

      case VooNavigationType.navigationDrawer:
        scaffold = KeyedSubtree(
          key: const ValueKey('desktop_scaffold'),
          child: VooDesktopScaffold(
            config: config,
            body: processedBody,
            backgroundColor: effectiveBackgroundColor,
            selectedId: selectedId,
            onNavigationItemSelected: onNavigationItemSelected,
            scaffoldKey: scaffoldKey,
            appBar: appBar,
            showAppBar: showAppBar,
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
          ),
        );
        break;
    }

    // Wrap in AnimatedSwitcher to handle transitions smoothly
    return AnimatedSwitcher(
      duration: config.animationDuration,
      child: scaffold,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
