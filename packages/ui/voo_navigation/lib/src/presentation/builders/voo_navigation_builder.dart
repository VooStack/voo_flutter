import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/domain/entities/navigation_route.dart';
import 'package:voo_navigation/src/presentation/providers/voo_go_router.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Builder class for creating navigation configurations with fluent API
class VooNavigationBuilder {
  final List<VooNavigationItem> _items = [];
  final List<VooNavigationRoute> _routes = [];
  final Map<String, Widget> _pages = {};

  // Configuration properties
  String? _selectedId;
  ThemeData? _theme;
  NavigationRailLabelType _railLabelType = NavigationRailLabelType.selected;
  bool _useExtendedRail = true;
  Widget? _drawerHeader;
  Widget? _drawerFooter;
  Widget? _appBarTitle;
  bool _centerAppBarTitle = false;
  Widget? _floatingActionButton;
  FloatingActionButtonLocation? _floatingActionButtonLocation;
  bool _showFloatingActionButton = true;
  Color? _backgroundColor;
  Color? _navigationBackgroundColor;
  Color? _selectedItemColor;
  Color? _unselectedItemColor;
  Color? _indicatorColor;
  ShapeBorder? _indicatorShape;
  double? _elevation;
  bool _showNavigationRailDivider = true;
  Duration _animationDuration = const Duration(milliseconds: 300);
  Curve _animationCurve = Curves.easeInOutCubic;
  bool _enableHapticFeedback = true;
  bool _enableAnimations = true;
  bool _persistNavigationState = true;
  bool _showNotificationBadges = true;
  Duration _badgeAnimationDuration = const Duration(milliseconds: 150);
  void Function(String itemId)? _onNavigationItemSelected;

  /// Creates a new navigation builder
  VooNavigationBuilder();

  /// Factory constructor for Material You theme
  factory VooNavigationBuilder.materialYou({
    required BuildContext context,
    Color? seedColor,
    Brightness? brightness,
  }) {
    final theme = Theme.of(context);
    final colorScheme = seedColor != null
        ? ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: brightness ?? theme.brightness,
          )
        : theme.colorScheme;

    return VooNavigationBuilder()
      ..theme(
        ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
        ),
      )
      ..selectedItemColor(colorScheme.primary)
      ..unselectedItemColor(colorScheme.onSurfaceVariant)
      ..indicatorColor(colorScheme.primaryContainer)
      ..navigationBackgroundColor(colorScheme.surface)
      ..indicatorShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.vooRadius.xl),
        ),
      );
  }

  /// Adds a navigation item
  VooNavigationBuilder addItem({
    required String id,
    required String label,
    required IconData icon,
    IconData? selectedIcon,
    String? route,
    Widget? destination,
    int? badgeCount,
    String? badgeText,
    Color? badgeColor,
    bool showDot = false,
    String? tooltip,
    VoidCallback? onTap,
    Color? iconColor,
    Color? selectedIconColor,
    bool isEnabled = true,
    bool isVisible = true,
  }) {
    _items.add(
      VooNavigationItem(
        id: id,
        label: label,
        icon: icon,
        selectedIcon: selectedIcon,
        route: route ?? '/$id',
        destination: destination,
        badgeCount: badgeCount,
        badgeText: badgeText,
        badgeColor: badgeColor,
        showDot: showDot,
        tooltip: tooltip,
        onTap: onTap,
        iconColor: iconColor,
        selectedIconColor: selectedIconColor,
        isEnabled: isEnabled,
        isVisible: isVisible,
      ),
    );
    return this;
  }

  /// Adds multiple navigation items
  VooNavigationBuilder addItems(List<VooNavigationItem> items) {
    _items.addAll(items);
    return this;
  }

  /// Adds a divider
  VooNavigationBuilder addDivider() {
    _items.add(VooNavigationItem.divider());
    return this;
  }

  /// Adds a section with children
  VooNavigationBuilder addSection({
    required String label,
    String? id,
    required List<VooNavigationItem> children,
    bool isExpanded = true,
  }) {
    _items.add(
      VooNavigationItem.section(
        label: label,
        id: id,
        children: children,
        isExpanded: isExpanded,
      ),
    );
    return this;
  }

  /// Adds a route
  VooNavigationBuilder addRoute(VooNavigationRoute route) {
    _routes.add(route);
    return this;
  }

  /// Adds a simple page
  VooNavigationBuilder addPage({
    required String id,
    required Widget page,
    String? path,
  }) {
    _pages[id] = page;
    if (path != null) {
      _routes.add(
        VooNavigationRoute.fade(
          id: id,
          path: path,
          builder: (context, state) => page,
        ),
      );
    }
    return this;
  }

  /// Sets the initially selected item
  VooNavigationBuilder selectedId(String? id) {
    _selectedId = id;
    return this;
  }

  /// Sets the theme
  VooNavigationBuilder theme(ThemeData? theme) {
    _theme = theme;
    return this;
  }

  /// Sets the rail label type
  VooNavigationBuilder railLabelType(NavigationRailLabelType type) {
    _railLabelType = type;
    return this;
  }

  /// Sets whether to use extended rail
  VooNavigationBuilder useExtendedRail(bool use) {
    _useExtendedRail = use;
    return this;
  }

  /// Sets the drawer header
  VooNavigationBuilder drawerHeader(Widget? header) {
    _drawerHeader = header;
    return this;
  }

  /// Sets the drawer footer
  VooNavigationBuilder drawerFooter(Widget? footer) {
    _drawerFooter = footer;
    return this;
  }

  /// Sets the app bar title
  VooNavigationBuilder appBarTitle(Widget? title) {
    _appBarTitle = title;
    return this;
  }

  /// Sets whether to center the app bar title
  VooNavigationBuilder centerAppBarTitle(bool center) {
    _centerAppBarTitle = center;
    return this;
  }

  /// Sets the floating action button
  VooNavigationBuilder floatingActionButton(Widget? fab) {
    _floatingActionButton = fab;
    return this;
  }

  /// Sets the floating action button location
  VooNavigationBuilder floatingActionButtonLocation(
    FloatingActionButtonLocation? location,
  ) {
    _floatingActionButtonLocation = location;
    return this;
  }

  /// Sets whether to show the floating action button
  VooNavigationBuilder showFloatingActionButton(bool show) {
    _showFloatingActionButton = show;
    return this;
  }

  /// Sets the background color
  VooNavigationBuilder backgroundColor(Color? color) {
    _backgroundColor = color;
    return this;
  }

  /// Sets the navigation background color
  VooNavigationBuilder navigationBackgroundColor(Color? color) {
    _navigationBackgroundColor = color;
    return this;
  }

  /// Sets the selected item color
  VooNavigationBuilder selectedItemColor(Color? color) {
    _selectedItemColor = color;
    return this;
  }

  /// Sets the unselected item color
  VooNavigationBuilder unselectedItemColor(Color? color) {
    _unselectedItemColor = color;
    return this;
  }

  /// Sets the indicator color
  VooNavigationBuilder indicatorColor(Color? color) {
    _indicatorColor = color;
    return this;
  }

  /// Sets the indicator shape
  VooNavigationBuilder indicatorShape(ShapeBorder? shape) {
    _indicatorShape = shape;
    return this;
  }

  /// Sets the elevation
  VooNavigationBuilder elevation(double? elevation) {
    _elevation = elevation;
    return this;
  }

  /// Sets whether to show the navigation rail divider
  VooNavigationBuilder showNavigationRailDivider(bool show) {
    _showNavigationRailDivider = show;
    return this;
  }

  /// Sets the animation duration
  VooNavigationBuilder animationDuration(Duration duration) {
    _animationDuration = duration;
    return this;
  }

  /// Sets the animation curve
  VooNavigationBuilder animationCurve(Curve curve) {
    _animationCurve = curve;
    return this;
  }

  /// Sets whether to enable haptic feedback
  VooNavigationBuilder enableHapticFeedback(bool enable) {
    _enableHapticFeedback = enable;
    return this;
  }

  /// Sets whether to enable animations
  VooNavigationBuilder enableAnimations(bool enable) {
    _enableAnimations = enable;
    return this;
  }

  /// Sets whether to persist navigation state
  VooNavigationBuilder persistNavigationState(bool persist) {
    _persistNavigationState = persist;
    return this;
  }

  /// Sets whether to show notification badges
  VooNavigationBuilder showNotificationBadges(bool show) {
    _showNotificationBadges = show;
    return this;
  }

  /// Sets the badge animation duration
  VooNavigationBuilder badgeAnimationDuration(Duration duration) {
    _badgeAnimationDuration = duration;
    return this;
  }

  /// Sets the navigation item selected callback
  VooNavigationBuilder onNavigationItemSelected(
    void Function(String itemId)? callback,
  ) {
    _onNavigationItemSelected = callback;
    return this;
  }

  /// Builds the navigation configuration
  VooNavigationConfig buildConfig() {
    return VooNavigationConfig(
      items: _items,
      selectedId: _selectedId,
      theme: _theme,
      railLabelType: _railLabelType,
      useExtendedRail: _useExtendedRail,
      drawerHeader: _drawerHeader,
      drawerFooter: _drawerFooter,
      appBarTitle: _appBarTitle,
      centerAppBarTitle: _centerAppBarTitle,
      floatingActionButton: _floatingActionButton,
      floatingActionButtonLocation: _floatingActionButtonLocation,
      showFloatingActionButton: _showFloatingActionButton,
      backgroundColor: _backgroundColor,
      navigationBackgroundColor: _navigationBackgroundColor,
      selectedItemColor: _selectedItemColor,
      unselectedItemColor: _unselectedItemColor,
      indicatorColor: _indicatorColor,
      indicatorShape: _indicatorShape,
      elevation: _elevation,
      showNavigationRailDivider: _showNavigationRailDivider,
      animationDuration: _animationDuration,
      animationCurve: _animationCurve,
      enableHapticFeedback: _enableHapticFeedback,
      enableAnimations: _enableAnimations,
      persistNavigationState: _persistNavigationState,
      showNotificationBadges: _showNotificationBadges,
      badgeAnimationDuration: _badgeAnimationDuration,
      onNavigationItemSelected: _onNavigationItemSelected,
    );
  }

  /// Builds a GoRouter with the configuration
  GoRouter buildRouter({
    String? initialLocation,
    Widget Function(BuildContext, GoRouterState)? errorBuilder,
    Widget Function(BuildContext, Widget)? builder,
    List<NavigatorObserver>? observers,
    bool debugLogDiagnostics = false,
  }) {
    final config = buildConfig();

    // If routes are explicitly added, use them
    if (_routes.isNotEmpty) {
      return VooGoRouter.create(
        config: config,
        routes: _routes,
        initialLocation: initialLocation,
        errorBuilder: errorBuilder,
        builder: builder,
        observers: observers,
        debugLogDiagnostics: debugLogDiagnostics,
      );
    }

    // If pages are added, use simple router
    if (_pages.isNotEmpty) {
      return VooGoRouter.simple(
        config: config,
        pages: _pages,
        initialLocation: initialLocation,
        observer: observers?.firstOrNull,
        observers: observers,
        debugLogDiagnostics: debugLogDiagnostics,
      );
    }

    // Otherwise, generate routes from items
    return VooGoRouter.fromNavigationItems(
      config: config,
      pageBuilder: (context, item) => _DefaultNavigationPage(item: item),
      initialLocation: initialLocation,
      errorBuilder: errorBuilder,
      builder: builder,
      observers: observers,
      debugLogDiagnostics: debugLogDiagnostics,
    );
  }
}

/// Default navigation page widget
class _DefaultNavigationPage extends StatelessWidget {
  final VooNavigationItem item;

  const _DefaultNavigationPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.effectiveSelectedIcon,
              size: context.vooSize.avatarXLarge,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: context.vooSpacing.lg),
            Text(
              item.label,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.vooSpacing.sm),
            Text(
              'Page for ${item.label}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
