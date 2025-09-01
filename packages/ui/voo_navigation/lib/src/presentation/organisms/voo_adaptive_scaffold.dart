import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_app_bar.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_bottom_navigation.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_navigation_drawer.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_navigation_rail.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Adaptive scaffold that automatically adjusts navigation based on screen size
class VooAdaptiveScaffold extends StatefulWidget {
  /// Configuration for the navigation system
  final VooNavigationConfig config;
  
  /// Main content body
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
    _selectedId = widget.config.selectedId ?? 
        widget.config.items.firstWhere((item) => item.isEnabled).id;
    
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    ),);
    
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
  Widget build(BuildContext context) => VooResponsiveBuilder(
      child: Builder(
        builder: (context) {
          final responsive = VooResponsive.of(context);
          final screenWidth = responsive.screenDimensions.width;
          final navigationType = widget.config.getNavigationType(screenWidth);
          
          // Animate navigation type changes
          if (_previousNavigationType != null && 
              _previousNavigationType != navigationType &&
              widget.config.enableAnimations) {
            _animationController.forward(from: 0);
          }
          _previousNavigationType = navigationType;
          
          // Build appropriate scaffold based on navigation type
          return _buildScaffold(context, navigationType, responsive);
        },
      ),
    );
  
  Widget _buildScaffold(
    BuildContext context,
    VooNavigationType navigationType,
    VooResponsive responsive,
  ) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = widget.backgroundColor ?? 
        widget.config.backgroundColor ?? 
        theme.scaffoldBackgroundColor;
    
    // Prepare the body with animations
    final Widget body = widget.config.enableAnimations
        ? FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.body,
            ),
          )
        : widget.body;
    
    // Build the scaffold based on navigation type
    switch (navigationType) {
      case VooNavigationType.bottomNavigation:
        return _buildMobileScaffold(context, body, effectiveBackgroundColor);
        
      case VooNavigationType.navigationRail:
      case VooNavigationType.extendedNavigationRail:
        return _buildTabletScaffold(
          context, 
          body, 
          effectiveBackgroundColor,
          navigationType == VooNavigationType.extendedNavigationRail,
        );
        
      case VooNavigationType.navigationDrawer:
        return _buildDesktopScaffold(context, body, effectiveBackgroundColor);
    }
  }
  
  Widget _buildMobileScaffold(
    BuildContext context,
    Widget body,
    Color backgroundColor,
  ) => Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar 
          ? (widget.appBar ?? VooAdaptiveAppBar(
              config: widget.config,
              selectedId: _selectedId,
              onNavigationItemSelected: _onNavigationItemSelected,
            ))
          : null,
      body: body,
      bottomNavigationBar: VooAdaptiveBottomNavigation(
        config: widget.config,
        selectedId: _selectedId,
        onNavigationItemSelected: _onNavigationItemSelected,
      ),
      floatingActionButton: widget.config.showFloatingActionButton
          ? widget.config.floatingActionButton
          : null,
      floatingActionButtonLocation: widget.config.floatingActionButtonLocation ??
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
  ) => Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar 
          ? (widget.appBar ?? VooAdaptiveAppBar(
              config: widget.config,
              selectedId: _selectedId,
              onNavigationItemSelected: _onNavigationItemSelected,
              showMenuButton: false,
            ))
          : null,
      body: Row(
        children: [
          VooAdaptiveNavigationRail(
            config: widget.config,
            selectedId: _selectedId,
            onNavigationItemSelected: _onNavigationItemSelected,
            extended: extended,
          ),
          if (widget.config.showNavigationRailDivider)
            const VerticalDivider(width: 1, thickness: 1),
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
  
  Widget _buildDesktopScaffold(
    BuildContext context,
    Widget body,
    Color backgroundColor,
  ) => Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: widget.showAppBar 
          ? (widget.appBar ?? VooAdaptiveAppBar(
              config: widget.config,
              selectedId: _selectedId,
              onNavigationItemSelected: _onNavigationItemSelected,
              showMenuButton: false,
            ))
          : null,
      body: Row(
        children: [
          VooAdaptiveNavigationDrawer(
            config: widget.config,
            selectedId: _selectedId,
            onNavigationItemSelected: _onNavigationItemSelected,
          ),
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