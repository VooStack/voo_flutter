import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_app_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_bottom_navigation.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_navigation_drawer.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_navigation_rail.dart';
import 'package:voo_navigation/src/presentation/utils/voo_navigation_inherited.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Adaptive scaffold that automatically adjusts navigation based on screen size
class VooAdaptiveScaffold extends StatefulWidget {
  /// Configuration for the navigation system
  final VooNavigationConfig config;

  /// Main content body (can be a StatefulNavigationShell from go_router)
  final Widget body;

  /// Optional custom app bar (overrides config.appBarTitle)
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

  /// Whether to extend body behind app bar
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

  /// Elevation for body card (if useBodyCard is true)
  final double bodyCardElevation;

  /// Border radius for body card (if useBodyCard is true)
  final BorderRadius? bodyCardBorderRadius;

  /// Color for body card (if useBodyCard is true)
  final Color? bodyCardColor;

  const VooAdaptiveScaffold({
    super.key,
    required this.config,
    required this.body,
    this.appBar,
    this.showAppBar = true,
    this.endDrawer,
    this.drawerEdgeDragWidth = 20.0,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.scaffoldKey,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.restorationId,
    this.bodyPadding,
    this.useBodyCard = false,
    this.bodyCardElevation = 0,
    this.bodyCardBorderRadius,
    this.bodyCardColor,
  });

  @override
  State<VooAdaptiveScaffold> createState() => _VooAdaptiveScaffoldState();
}

class _VooAdaptiveScaffoldState extends State<VooAdaptiveScaffold>
    with SingleTickerProviderStateMixin {
  late String _selectedId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  VooNavigationType? _previousNavigationType;

  @override
  void initState() {
    super.initState();
    _selectedId =
        widget.config.selectedId ??
        widget.config.items.firstWhere((item) => item.isEnabled).id;

    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.config.animationCurve,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavigationItemSelected(String itemId) {
    final item = widget.config.items.firstWhere((item) => item.id == itemId);

    if (!item.isEnabled) return;

    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      _selectedId = itemId;
    });

    // Handle navigation
    if (item.route != null && context.mounted) {
      Navigator.of(context).pushNamed(item.route!);
    }

    // Call custom callback
    item.onTap?.call();
    widget.config.onNavigationItemSelected?.call(itemId);

    // Animate content change if enabled
    if (widget.config.enableAnimations) {
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) => VooNavigationInherited(
    config: widget.config,
    selectedId: _selectedId,
    onNavigationItemSelected: _onNavigationItemSelected,
    child: VooResponsiveBuilder(
      builder: (context, screenInfo) {
        final screenWidth = screenInfo.width;
        final navigationType = widget.config.getNavigationType(screenWidth);

        // Animate navigation type changes
        if (_previousNavigationType != null &&
            _previousNavigationType != navigationType &&
            widget.config.enableAnimations) {
          _animationController.forward(from: 0);
        }
        _previousNavigationType = navigationType;

        // Build appropriate scaffold based on navigation type
        return _buildScaffold(context, navigationType, screenInfo);
      },
    ),
  );

  Widget _buildScaffold(
    BuildContext context,
    VooNavigationType navigationType,
    ScreenInfo screenInfo,
  ) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.backgroundColor ??
        theme.scaffoldBackgroundColor;

    // Apply body padding based on navigation type and screen size
    final defaultPadding = _getDefaultBodyPadding(navigationType, screenInfo);
    final effectiveBodyPadding = widget.bodyPadding ?? defaultPadding;

    // Prepare the body with optional card wrapper
    Widget body = widget.body;

    // Wrap in card if requested
    if (widget.useBodyCard &&
        navigationType != VooNavigationType.bottomNavigation) {
      final tokens = context.vooTokens;
      final cardColor =
          widget.bodyCardColor ??
          (theme.brightness == Brightness.light
              ? Colors.white
              : theme.colorScheme.surface);
      final borderRadius = widget.bodyCardBorderRadius ?? tokens.radius.card;

      body = Material(
        elevation: widget.bodyCardElevation == 0
            ? tokens.elevation.card
            : widget.bodyCardElevation,
        borderRadius: borderRadius,
        color: cardColor,
        child: ClipRRect(borderRadius: borderRadius, child: body),
      );
    }

    // Apply padding
    if (effectiveBodyPadding != EdgeInsets.zero) {
      body = Padding(padding: effectiveBodyPadding, child: body);
    }

    if (widget.config.enableAnimations) {
      body = FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: body),
      );
    }

    // Build the scaffold based on navigation type with animation
    Widget scaffold;
    switch (navigationType) {
      case VooNavigationType.bottomNavigation:
        scaffold = KeyedSubtree(
          key: const ValueKey('mobile_scaffold'),
          child: _buildMobileScaffold(context, body, effectiveBackgroundColor),
        );
        break;

      case VooNavigationType.navigationRail:
      case VooNavigationType.extendedNavigationRail:
        // Only show extended rail if config allows it AND we're in the right width range
        final shouldExtend = widget.config.useExtendedRail &&
            navigationType == VooNavigationType.extendedNavigationRail;
        scaffold = KeyedSubtree(
          key: ValueKey('tablet_scaffold_$navigationType'),
          child: _buildTabletScaffold(
            context,
            body,
            effectiveBackgroundColor,
            shouldExtend,
          ),
        );
        break;

      case VooNavigationType.navigationDrawer:
        scaffold = KeyedSubtree(
          key: const ValueKey('desktop_scaffold'),
          child: _buildDesktopScaffold(context, body, effectiveBackgroundColor),
        );
        break;
    }

    // Wrap in AnimatedSwitcher to handle transitions smoothly
    return AnimatedSwitcher(
      duration: widget.config.animationDuration,
      child: scaffold,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  Widget _buildMobileScaffold(
    BuildContext context,
    Widget body,
    Color backgroundColor,
  ) => Scaffold(
    key: widget.scaffoldKey,
    backgroundColor: backgroundColor,
    appBar: widget.showAppBar
        ? (widget.appBar ?? const VooAdaptiveAppBar())
        : null,
    body: body,
    bottomNavigationBar: VooAdaptiveBottomNavigation(
      config: widget.config,
      selectedId: _selectedId,
      onNavigationItemSelected: _onNavigationItemSelected,
      type: widget.config.bottomNavigationType,
    ),
    floatingActionButton: widget.config.showFloatingActionButton
        ? widget.config.floatingActionButton
        : null,
    floatingActionButtonLocation:
        widget.config.floatingActionButtonLocation ??
        FloatingActionButtonLocation.centerDocked,
    floatingActionButtonAnimator: widget.config.floatingActionButtonAnimator,
    endDrawer: widget.endDrawer,
    drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
    drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
    endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
    resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    extendBody: widget.extendBody,
    extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
    bottomSheet: widget.bottomSheet,
    persistentFooterButtons: widget.persistentFooterButtons,
    restorationId: widget.restorationId,
  );

  Widget _buildTabletScaffold(
    BuildContext context,
    Widget body,
    Color backgroundColor,
    bool extended,
  ) {
    final theme = Theme.of(context);
    final navigationRail = ClipRect(
      child: VooAdaptiveNavigationRail(
        config: widget.config,
        selectedId: _selectedId,
        onNavigationItemSelected: _onNavigationItemSelected,
        extended: extended,
      ),
    );

    // When app bar is alongside rail, wrap the content area with its own scaffold
    if (widget.config.appBarAlongsideRail && widget.showAppBar) {
      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            navigationRail,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: widget.config.navigationRailMargin,
                  right: widget.config.navigationRailMargin,
                  bottom: widget.config.navigationRailMargin,
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
                    appBar: widget.appBar ?? const VooAdaptiveAppBar(showMenuButton: false),
                    body: body,
                    floatingActionButton: widget.config.showFloatingActionButton
                        ? widget.config.floatingActionButton
                        : null,
                    floatingActionButtonLocation: widget.config.floatingActionButtonLocation,
                    floatingActionButtonAnimator: widget.config.floatingActionButtonAnimator,
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: widget.endDrawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        bottomSheet: widget.bottomSheet,
        persistentFooterButtons: widget.persistentFooterButtons,
        restorationId: widget.restorationId,
      );
    }

    // Original behavior: app bar spans full width
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar
          ? (widget.appBar ?? const VooAdaptiveAppBar(showMenuButton: false))
          : null,
      body: Row(
        children: [
          navigationRail,
          Expanded(child: body),
        ],
      ),
      floatingActionButton: widget.config.showFloatingActionButton
          ? widget.config.floatingActionButton
          : null,
      floatingActionButtonLocation: widget.config.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.config.floatingActionButtonAnimator,
      endDrawer: widget.endDrawer,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomSheet: widget.bottomSheet,
      persistentFooterButtons: widget.persistentFooterButtons,
      restorationId: widget.restorationId,
    );
  }

  Widget _buildDesktopScaffold(
    BuildContext context,
    Widget body,
    Color backgroundColor,
  ) {
    final theme = Theme.of(context);
    final navigationDrawer = ClipRect(
      child: VooAdaptiveNavigationDrawer(
        config: widget.config,
        selectedId: _selectedId,
        onNavigationItemSelected: _onNavigationItemSelected,
      ),
    );

    // When app bar is alongside drawer, wrap the content area with its own scaffold
    if (widget.config.appBarAlongsideRail && widget.showAppBar) {
      return Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: backgroundColor,
        body: Row(
          children: [
            navigationDrawer,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: widget.config.navigationRailMargin,
                  right: widget.config.navigationRailMargin,
                  bottom: widget.config.navigationRailMargin,
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
                    appBar: widget.appBar ?? const VooAdaptiveAppBar(showMenuButton: false),
                    body: body,
                    floatingActionButton: widget.config.showFloatingActionButton
                        ? widget.config.floatingActionButton
                        : null,
                    floatingActionButtonLocation: widget.config.floatingActionButtonLocation,
                    floatingActionButtonAnimator: widget.config.floatingActionButtonAnimator,
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: widget.endDrawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        bottomSheet: widget.bottomSheet,
        persistentFooterButtons: widget.persistentFooterButtons,
        restorationId: widget.restorationId,
      );
    }

    // Original behavior: app bar spans full width
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar
          ? (widget.appBar ?? const VooAdaptiveAppBar(showMenuButton: false))
          : null,
      body: Row(
        children: [
          navigationDrawer,
          Expanded(child: body),
        ],
      ),
      floatingActionButton: widget.config.showFloatingActionButton
          ? widget.config.floatingActionButton
          : null,
      floatingActionButtonLocation: widget.config.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.config.floatingActionButtonAnimator,
      endDrawer: widget.endDrawer,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomSheet: widget.bottomSheet,
      persistentFooterButtons: widget.persistentFooterButtons,
      restorationId: widget.restorationId,
    );
  }

  /// Get default body padding based on navigation type and screen size
  EdgeInsetsGeometry _getDefaultBodyPadding(
    VooNavigationType navigationType,
    ScreenInfo screenInfo,
  ) {
    final tokens = context.vooTokens;
    final spacing = tokens.spacing;
    final screenWidth = screenInfo.width;

    // Responsive padding based on screen size
    double horizontalPadding;
    double verticalPadding;

    if (screenWidth < 600) {
      // Mobile: smaller padding
      horizontalPadding = spacing.md;
      verticalPadding = spacing.md;
    } else if (screenWidth < 1240) {
      // Tablet: medium padding
      horizontalPadding = spacing.lg;
      verticalPadding = spacing.lg;
    } else {
      // Desktop: larger padding for spacious feel
      horizontalPadding = spacing.xl;
      verticalPadding = spacing.lg;
    }

    // Adjust for navigation type
    switch (navigationType) {
      case VooNavigationType.bottomNavigation:
        // Mobile: padding on all sides
        return EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        );
      case VooNavigationType.navigationRail:
      case VooNavigationType.extendedNavigationRail:
      case VooNavigationType.navigationDrawer:
        // Desktop/Tablet: no left padding since navigation is there
        return EdgeInsets.only(
          right: horizontalPadding,
          top: verticalPadding,
          bottom: verticalPadding,
        );
    }
  }
}
