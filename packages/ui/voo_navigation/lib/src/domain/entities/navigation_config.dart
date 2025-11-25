import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/breakpoint.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation/src/presentation/organisms/voo_adaptive_bottom_navigation.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Configuration for the adaptive navigation system
class VooNavigationConfig {
  /// Default animation tokens for the navigation
  static const _animationTokens = VooAnimationTokens();
  static const _spacingTokens = VooSpacingTokens();

  /// List of navigation items to display
  final List<VooNavigationItem> items;

  /// Currently selected navigation item ID
  final String? selectedId;

  /// Custom breakpoints (defaults to Material 3 breakpoints)
  final List<VooBreakpoint> breakpoints;

  /// Whether to automatically select navigation type based on screen size
  final bool isAdaptive;

  /// Force a specific navigation type (overrides adaptive behavior)
  final VooNavigationType? forcedNavigationType;

  /// Theme data for styling
  final ThemeData? theme;

  /// Whether to show labels in navigation rail
  final NavigationRailLabelType railLabelType;

  /// Whether to use extended navigation rail when possible
  final bool useExtendedRail;

  /// Custom header widget for navigation drawer
  final Widget? drawerHeader;

  /// Custom footer widget for navigation drawer
  final Widget? drawerFooter;

  /// Custom leading widget builder for app bar
  final Widget? Function(String? selectedId)? appBarLeadingBuilder;

  /// Custom actions builder for app bar
  final List<Widget>? Function(String? selectedId)? appBarActionsBuilder;

  /// App bar title builder
  final Widget? Function(String? selectedId)? appBarTitleBuilder;

  /// Whether to center the app bar title
  final bool centerAppBarTitle;

  /// Whether the app bar should be positioned alongside the navigation rail
  /// When true (default), app bar only spans the content area to the right of the rail
  /// When false, app bar spans the full width above the rail
  final bool appBarAlongsideRail;

  /// Custom floating action button
  final Widget? floatingActionButton;

  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Floating action button animator
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Whether to show floating action button
  final bool showFloatingActionButton;

  /// Background color for the scaffold
  final Color? backgroundColor;

  /// Background color for navigation components
  final Color? navigationBackgroundColor;

  /// Selected item color
  final Color? selectedItemColor;

  /// Unselected item color
  final Color? unselectedItemColor;

  /// Indicator color for selected items
  final Color? indicatorColor;

  /// Indicator shape
  final ShapeBorder? indicatorShape;

  /// Elevation for navigation components
  final double? elevation;

  /// Whether to show divider in navigation rail
  final bool showNavigationRailDivider;

  /// Custom navigation rail width
  final double? navigationRailWidth;

  final double navigationRailMargin;

  /// Custom extended navigation rail width
  final double? extendedNavigationRailWidth;

  /// Custom navigation drawer width
  final double? navigationDrawerWidth;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Animation curve for transitions
  final Curve animationCurve;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Custom transition builder for navigation animations
  final Widget Function(Widget child, Animation<double> animation)?
  transitionBuilder;

  /// Callback when navigation item is selected
  final void Function(String itemId)? onNavigationItemSelected;

  /// Whether to persist navigation state
  final bool persistNavigationState;

  /// Custom scroll controller for navigation drawer
  final ScrollController? drawerScrollController;

  /// Whether to show notification badge
  final bool showNotificationBadges;

  /// Badge animation duration
  final Duration badgeAnimationDuration;

  /// Whether to group items by sections
  final bool groupItemsBySections;

  /// Whether to allow item reordering
  final bool allowItemReordering;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom error widget
  final Widget Function(Object error)? errorBuilder;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Type of bottom navigation bar to use
  final VooNavigationBarType bottomNavigationType;

  /// Whether to use floating style for bottom navigation
  final bool floatingBottomNav;

  /// Horizontal margin for floating bottom navigation
  final double? floatingBottomNavMargin;

  /// Bottom margin for floating bottom navigation
  final double? floatingBottomNavBottomMargin;

  /// Whether to show user profile in drawer/rail footer
  final bool showUserProfile;

  /// User profile widget for drawer/rail footer
  final Widget? userProfileWidget;

  /// Whether the rail/drawer supports collapsing
  final bool enableCollapsibleRail;

  /// Custom collapse toggle builder
  final Widget Function(bool isExpanded, VoidCallback onToggle)?
      collapseToggleBuilder;

  /// Visual theme for navigation styling
  ///
  /// Use preset themes via factory constructors:
  /// - [VooNavigationConfig.glassmorphism]
  /// - [VooNavigationConfig.neomorphism]
  /// - [VooNavigationConfig.material3Enhanced]
  /// - [VooNavigationConfig.minimalModern]
  final VooNavigationTheme? navigationTheme;

  /// Gets the effective theme, defaulting to Material 3 Enhanced
  VooNavigationTheme get effectiveTheme =>
      navigationTheme ?? VooNavigationTheme.material3Enhanced();

  VooNavigationConfig({
    required this.items,
    this.selectedId,
    List<VooBreakpoint>? breakpoints,
    this.isAdaptive = true,
    this.forcedNavigationType,
    this.theme,
    this.railLabelType = NavigationRailLabelType.selected,
    this.useExtendedRail = true,
    this.drawerHeader,
    this.drawerFooter,
    this.appBarLeadingBuilder,
    this.appBarActionsBuilder,
    this.appBarTitleBuilder,
    this.centerAppBarTitle = false,
    this.appBarAlongsideRail = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.showFloatingActionButton = true,
    this.backgroundColor,
    this.navigationBackgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.indicatorColor,
    this.indicatorShape,
    this.elevation,
    this.showNavigationRailDivider = true,
    this.navigationRailWidth,
    this.extendedNavigationRailWidth,
    this.navigationDrawerWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    this.enableHapticFeedback = true,
    this.enableAnimations = true,
    this.transitionBuilder,
    this.onNavigationItemSelected,
    this.persistNavigationState = true,
    this.drawerScrollController,
    this.showNotificationBadges = true,
    Duration? badgeAnimationDuration,
    this.groupItemsBySections = false,
    this.allowItemReordering = false,
    this.emptyStateWidget,
    this.errorBuilder,
    this.loadingWidget,
    this.bottomNavigationType = VooNavigationBarType.custom,
    this.floatingBottomNav = false,
    this.floatingBottomNavMargin,
    this.floatingBottomNavBottomMargin,
    this.showUserProfile = false,
    this.userProfileWidget,
    this.enableCollapsibleRail = false,
    this.collapseToggleBuilder,
    this.navigationTheme,
    double? navigationRailMargin,
  }) : breakpoints = breakpoints ?? VooBreakpoint.material3Breakpoints,
       animationDuration = animationDuration ?? _animationTokens.durationNormal,
       animationCurve = animationCurve ?? _animationTokens.curveEaseInOut,
       badgeAnimationDuration =
           badgeAnimationDuration ?? _animationTokens.durationFast,
       navigationRailMargin = navigationRailMargin ?? _spacingTokens.sm;

  /// Creates a copy of this configuration with the given fields replaced
  VooNavigationConfig copyWith({
    List<VooNavigationItem>? items,
    String? selectedId,
    List<VooBreakpoint>? breakpoints,
    bool? isAdaptive,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType? railLabelType,
    bool? useExtendedRail,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool? centerAppBarTitle,
    bool? appBarAlongsideRail,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    bool? showFloatingActionButton,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    ShapeBorder? indicatorShape,
    double? elevation,
    bool? showNavigationRailDivider,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableHapticFeedback,
    bool? enableAnimations,
    Widget Function(Widget child, Animation<double> animation)?
    transitionBuilder,
    void Function(String itemId)? onNavigationItemSelected,
    bool? persistNavigationState,
    ScrollController? drawerScrollController,
    bool? showNotificationBadges,
    Duration? badgeAnimationDuration,
    bool? groupItemsBySections,
    bool? allowItemReordering,
    Widget? emptyStateWidget,
    Widget Function(Object error)? errorBuilder,
    Widget? loadingWidget,
    VooNavigationBarType? bottomNavigationType,
    bool? floatingBottomNav,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool? showUserProfile,
    Widget? userProfileWidget,
    bool? enableCollapsibleRail,
    Widget Function(bool isExpanded, VoidCallback onToggle)?
        collapseToggleBuilder,
    VooNavigationTheme? navigationTheme,
    double? navigationRailMargin,
  }) => VooNavigationConfig(
    items: items ?? this.items,
    selectedId: selectedId ?? this.selectedId,
    breakpoints: breakpoints ?? this.breakpoints,
    isAdaptive: isAdaptive ?? this.isAdaptive,
    forcedNavigationType: forcedNavigationType ?? this.forcedNavigationType,
    theme: theme ?? this.theme,
    railLabelType: railLabelType ?? this.railLabelType,
    useExtendedRail: useExtendedRail ?? this.useExtendedRail,
    drawerHeader: drawerHeader ?? this.drawerHeader,
    drawerFooter: drawerFooter ?? this.drawerFooter,
    appBarLeadingBuilder: appBarLeadingBuilder ?? this.appBarLeadingBuilder,
    appBarActionsBuilder: appBarActionsBuilder ?? this.appBarActionsBuilder,
    appBarTitleBuilder: appBarTitleBuilder ?? this.appBarTitleBuilder,
    centerAppBarTitle: centerAppBarTitle ?? this.centerAppBarTitle,
    appBarAlongsideRail: appBarAlongsideRail ?? this.appBarAlongsideRail,
    floatingActionButton: floatingActionButton ?? this.floatingActionButton,
    floatingActionButtonLocation:
        floatingActionButtonLocation ?? this.floatingActionButtonLocation,
    floatingActionButtonAnimator:
        floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
    showFloatingActionButton:
        showFloatingActionButton ?? this.showFloatingActionButton,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    navigationBackgroundColor:
        navigationBackgroundColor ?? this.navigationBackgroundColor,
    selectedItemColor: selectedItemColor ?? this.selectedItemColor,
    unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorShape: indicatorShape ?? this.indicatorShape,
    elevation: elevation ?? this.elevation,
    showNavigationRailDivider:
        showNavigationRailDivider ?? this.showNavigationRailDivider,
    navigationRailWidth: navigationRailWidth ?? this.navigationRailWidth,
    extendedNavigationRailWidth:
        extendedNavigationRailWidth ?? this.extendedNavigationRailWidth,
    navigationDrawerWidth: navigationDrawerWidth ?? this.navigationDrawerWidth,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    enableAnimations: enableAnimations ?? this.enableAnimations,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    onNavigationItemSelected:
        onNavigationItemSelected ?? this.onNavigationItemSelected,
    persistNavigationState:
        persistNavigationState ?? this.persistNavigationState,
    drawerScrollController:
        drawerScrollController ?? this.drawerScrollController,
    showNotificationBadges:
        showNotificationBadges ?? this.showNotificationBadges,
    badgeAnimationDuration:
        badgeAnimationDuration ?? this.badgeAnimationDuration,
    groupItemsBySections: groupItemsBySections ?? this.groupItemsBySections,
    allowItemReordering: allowItemReordering ?? this.allowItemReordering,
    emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
    errorBuilder: errorBuilder ?? this.errorBuilder,
    loadingWidget: loadingWidget ?? this.loadingWidget,
    bottomNavigationType: bottomNavigationType ?? this.bottomNavigationType,
    floatingBottomNav: floatingBottomNav ?? this.floatingBottomNav,
    floatingBottomNavMargin:
        floatingBottomNavMargin ?? this.floatingBottomNavMargin,
    floatingBottomNavBottomMargin:
        floatingBottomNavBottomMargin ?? this.floatingBottomNavBottomMargin,
    showUserProfile: showUserProfile ?? this.showUserProfile,
    userProfileWidget: userProfileWidget ?? this.userProfileWidget,
    enableCollapsibleRail: enableCollapsibleRail ?? this.enableCollapsibleRail,
    collapseToggleBuilder: collapseToggleBuilder ?? this.collapseToggleBuilder,
    navigationTheme: navigationTheme ?? this.navigationTheme,
    navigationRailMargin: navigationRailMargin ?? this.navigationRailMargin,
  );

  /// Gets the current navigation type based on screen width
  VooNavigationType getNavigationType(double screenWidth) {
    if (!isAdaptive || forcedNavigationType != null) {
      return forcedNavigationType ?? VooNavigationType.bottomNavigation;
    }

    final breakpoint = VooBreakpoint.fromWidth(screenWidth, breakpoints);
    return breakpoint.navigationType;
  }

  /// Gets visible navigation items
  List<VooNavigationItem> get visibleItems =>
      items.where((item) => item.isVisible).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Gets mobile priority navigation items (max 4 items for bottom navigation)
  /// Includes both direct items and children of sections marked with mobilePriority
  List<VooNavigationItem> get mobilePriorityItems {
    final priorityItems = <VooNavigationItem>[];

    for (final item in items) {
      // Check direct item mobilePriority
      if (item.isVisible && item.mobilePriority) {
        priorityItems.add(item);
      }

      // Check children mobilePriority (for sections)
      if (item.hasChildren && item.children != null) {
        for (final child in item.children!) {
          if (child.isVisible && child.mobilePriority) {
            priorityItems.add(child);
          }
        }
      }
    }

    // Sort by sortOrder and take first 4
    priorityItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return priorityItems.take(4).toList();
  }

  /// Gets the selected navigation item
  VooNavigationItem? get selectedItem {
    if (selectedId == null) return null;
    try {
      return items.firstWhere((item) => item.id == selectedId);
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // THEME PRESET FACTORY CONSTRUCTORS
  // ============================================================================

  /// Creates a glassmorphism-themed navigation configuration
  ///
  /// Features frosted glass effect with blur, translucent surfaces,
  /// subtle borders, and glow indicators.
  ///
  /// ```dart
  /// VooNavigationConfig.glassmorphism(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.glassmorphism({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.selected,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = true,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = false,
    Widget? userProfileWidget,
    bool enableCollapsibleRail = false,
    double? navigationRailMargin,
    // Glassmorphism-specific options
    double surfaceOpacity = 0.75,
    double blurSigma = 16,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationNormal,
      animationCurve: Curves.easeInOut,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin ?? _spacingTokens.md,
      floatingBottomNavBottomMargin:
          floatingBottomNavBottomMargin ?? _spacingTokens.lg,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin,
      navigationTheme: VooNavigationTheme.glassmorphism(
        surfaceOpacity: surfaceOpacity,
        blurSigma: blurSigma,
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a neomorphism-themed navigation configuration
  ///
  /// Features soft embossed/debossed effect with dual shadows,
  /// no visible borders, and pressed-in indicators.
  ///
  /// ```dart
  /// VooNavigationConfig.neomorphism(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.neomorphism({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.selected,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = false,
    Widget? userProfileWidget,
    bool enableCollapsibleRail = false,
    double? navigationRailMargin,
    // Neomorphism-specific options
    double shadowBlur = 12,
    double shadowOffset = 6,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationFast,
      animationCurve: Curves.easeOut,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin ?? _spacingTokens.lg,
      navigationTheme: VooNavigationTheme.neomorphism(
        shadowBlur: shadowBlur,
        shadowOffset: shadowOffset,
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a Material 3 Enhanced themed navigation configuration
  ///
  /// Features polished Material 3 styling with richer animations,
  /// animated pill indicators, and subtle glow effects.
  ///
  /// ```dart
  /// VooNavigationConfig.material3Enhanced(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.material3Enhanced({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.all,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = true,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = false,
    Widget? userProfileWidget,
    bool enableCollapsibleRail = false,
    double? navigationRailMargin,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),
      elevation: 2,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationNormal,
      animationCurve: Curves.easeOutBack,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin,
      navigationTheme: VooNavigationTheme.material3Enhanced(
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a minimal modern themed navigation configuration
  ///
  /// Features clean flat design with no shadows, thin line indicators,
  /// and fast linear animations.
  ///
  /// ```dart
  /// VooNavigationConfig.minimalModern(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.minimalModern({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.none,
    bool useExtendedRail = false,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = false,
    Widget? userProfileWidget,
    bool enableCollapsibleRail = false,
    double? navigationRailMargin,
    // Minimal-specific options
    double borderWidth = 1,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const RoundedRectangleBorder(),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationFast,
      animationCurve: Curves.linear,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin ?? _spacingTokens.xl,
      navigationTheme: VooNavigationTheme.minimalModern(
        borderWidth: borderWidth,
        indicatorColor: indicatorColor,
      ),
    );
  }
}
