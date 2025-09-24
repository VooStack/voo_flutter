import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_scaffold_builder.dart';
import 'package:voo_navigation/src/presentation/utils/voo_navigation_inherited.dart';
import 'package:voo_responsive/voo_responsive.dart';

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
        return VooScaffoldBuilder(
          config: widget.config,
          navigationType: navigationType,
          screenInfo: screenInfo,
          body: widget.body,
          selectedId: _selectedId,
          onNavigationItemSelected: _onNavigationItemSelected,
          animationController: _animationController,
          fadeAnimation: _fadeAnimation,
          slideAnimation: _slideAnimation,
          appBar: widget.appBar,
          showAppBar: widget.showAppBar,
          endDrawer: widget.endDrawer,
          drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
          drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
          endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
          scaffoldKey: widget.scaffoldKey,
          backgroundColor: widget.backgroundColor,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          extendBody: widget.extendBody,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          bottomSheet: widget.bottomSheet,
          persistentFooterButtons: widget.persistentFooterButtons,
          restorationId: widget.restorationId,
          bodyPadding: widget.bodyPadding,
          useBodyCard: widget.useBodyCard,
          bodyCardElevation: widget.bodyCardElevation,
          bodyCardBorderRadius: widget.bodyCardBorderRadius,
          bodyCardColor: widget.bodyCardColor,
        );
      },
    ),
  );

}
