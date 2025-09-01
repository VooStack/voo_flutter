import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// Adaptive app bar that adjusts based on screen size and navigation type
class VooAdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Navigation configuration
  final VooNavigationConfig config;
  
  /// Currently selected item ID
  final String selectedId;
  
  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;
  
  /// Whether to show menu button (for drawer)
  final bool showMenuButton;
  
  /// Custom title widget
  final Widget? title;
  
  /// Custom leading widget
  final Widget? leading;
  
  /// Custom actions
  final List<Widget>? actions;
  
  /// Whether to center the title
  final bool? centerTitle;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Custom foreground color
  final Color? foregroundColor;
  
  /// Custom elevation
  final double? elevation;
  
  /// Custom toolbar height
  final double? toolbarHeight;
  
  /// Whether to show bottom border
  final bool showBottomBorder;
  
  /// Custom scroll behavior
  final ScrollNotificationPredicate notificationPredicate;
  
  const VooAdaptiveAppBar({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.showMenuButton = true,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.toolbarHeight,
    this.showBottomBorder = false,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Get the selected navigation item for title
    final selectedItem = config.items.firstWhere(
      (item) => item.id == selectedId,
      orElse: () => config.items.first,
    );
    
    final effectiveTitle = title ?? _buildTitle(selectedItem, theme);
    final effectiveLeading = leading ?? _buildLeading(context, theme);
    final effectiveActions = actions ?? _buildActions(context, theme);
    final effectiveCenterTitle = centerTitle ?? config.centerAppBarTitle;
    final effectiveBackgroundColor = backgroundColor ?? 
        colorScheme.surface;
    final effectiveForegroundColor = foregroundColor ?? 
        colorScheme.onSurface;
    final effectiveElevation = elevation ?? 
        (showBottomBorder ? 0 : theme.appBarTheme.elevation ?? 0);
    
    return AppBar(
      title: effectiveTitle,
      leading: effectiveLeading,
      actions: effectiveActions,
      centerTitle: effectiveCenterTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      toolbarHeight: toolbarHeight,
      bottom: showBottomBorder ? PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: theme.dividerColor.withAlpha((0.2 * 255).round()),
        ),
      ) : null,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }
  
  Widget? _buildLeading(BuildContext context, ThemeData theme) {
    if (!showMenuButton) return null;
    
    if (config.appBarLeading != null) {
      return config.appBarLeading!;
    }
    
    // Show menu button for drawer on mobile
    if (Scaffold.of(context).hasDrawer) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
          if (config.enableHapticFeedback) {
            HapticFeedback.lightImpact();
          }
        },
        tooltip: 'Open navigation menu',
      );
    }
    
    // Show back button if can pop
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
          if (config.enableHapticFeedback) {
            HapticFeedback.lightImpact();
          }
        },
        tooltip: 'Go back',
      );
    }
    
    return null;
  }
  
  Widget _buildTitle(VooNavigationItem item, ThemeData theme) {
    if (config.appBarTitle != null) {
      return config.appBarTitle!;
    }
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      child: Text(
        item.label,
        key: ValueKey(item.id),
        style: theme.appBarTheme.titleTextStyle ?? 
            theme.textTheme.titleLarge,
      ),
    );
  }
  
  List<Widget> _buildActions(BuildContext context, ThemeData theme) {
    final actions = <Widget>[];
    
    // Add custom actions from config
    if (config.appBarActions != null) {
      actions.addAll(config.appBarActions!);
    }
    
    // Add notification bell if there are any badges
    if (config.showNotificationBadges) {
      final totalBadgeCount = config.items
          .where((item) => item.badgeCount != null)
          .fold<int>(0, (sum, item) => sum + item.badgeCount!);
      
      if (totalBadgeCount > 0) {
        actions.add(
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Handle notification tap
                  if (config.enableHapticFeedback) {
                    HapticFeedback.lightImpact();
                  }
                },
                tooltip: 'Notifications',
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      totalBadgeCount > 99 ? '99+' : totalBadgeCount.toString(),
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    
    // Add search action if configured
    if (actions.isEmpty && MediaQuery.of(context).size.width > 600) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
          },
          tooltip: 'Search',
        ),
      );
    }
    
    // Add more options menu
    if (actions.isNotEmpty) {
      actions.add(
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (config.enableHapticFeedback) {
              HapticFeedback.lightImpact();
            }
            // Handle menu item selection
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help & Feedback'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }
    
    return actions;
  }
}

/// Function to determine if a notification should be handled
bool defaultScrollNotificationPredicate(ScrollNotification notification) => notification.depth == 0;