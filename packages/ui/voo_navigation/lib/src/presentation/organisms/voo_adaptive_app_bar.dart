import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_app_bar_leading.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_app_bar_title.dart';
import 'package:voo_navigation/src/presentation/utils/voo_navigation_inherited.dart';

/// Adaptive app bar that adjusts based on screen size and navigation type
class VooAdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Navigation configuration (optional if provided at scaffold level)
  final VooNavigationConfig? config;

  /// Currently selected item ID (optional if config is provided)
  final String? selectedId;

  /// Callback when an item is selected (optional if config is provided)
  final void Function(String itemId)? onNavigationItemSelected;

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
    this.config,
    this.selectedId,
    this.onNavigationItemSelected,
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
  Size get preferredSize => Size.fromHeight((toolbarHeight ?? kToolbarHeight) + 8 + 1);  // Add padding + border

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Try to get config from scaffold if not provided
    final effectiveConfig = config ?? _getConfigFromScaffold(context);
    final effectiveSelectedId =
        selectedId ?? _getSelectedIdFromScaffold(context);

    // Get the selected navigation item for title (if config is available)
    final selectedItem = effectiveConfig != null && effectiveSelectedId != null
        ? effectiveConfig.items.firstWhere(
            (item) => item.id == effectiveSelectedId,
            orElse: () => effectiveConfig.items.first,
          )
        : null;

    final effectiveTitle =
        title ??
        (selectedItem != null
            ? VooAppBarTitle(item: selectedItem, config: effectiveConfig)
            : const Text(''));
    final effectiveLeading =
        leading ?? (showMenuButton
            ? VooAppBarLeading(showMenuButton: showMenuButton, config: effectiveConfig)
            : null);
    final effectiveActions = actions;
    final effectiveCenterTitle =
        centerTitle ?? effectiveConfig?.centerAppBarTitle ?? false;
    // Use same subtle surface color variation as navigation components
    final effectiveBackgroundColor = backgroundColor ??
        effectiveConfig?.navigationBackgroundColor ??
        (theme.brightness == Brightness.light
            ? theme.colorScheme.surface.withValues(alpha: 0.95)
            : theme.colorScheme.surfaceContainerLow);
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.vooRadius.lg),
          topRight: Radius.circular(context.vooRadius.lg),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.vooRadius.lg),
          topRight: Radius.circular(context.vooRadius.lg),
        ),
        child: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.xs),
          child: effectiveTitle,
        ),
        leading: effectiveLeading,
        actions: effectiveActions?.isNotEmpty == true
            ? [
                ...effectiveActions!,
                SizedBox(width: context.vooSpacing.md),
              ]
            : null,
        centerTitle: effectiveCenterTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: effectiveForegroundColor,
        elevation: 0,
        toolbarHeight: (toolbarHeight ?? kToolbarHeight) + context.vooSpacing.sm,
        titleSpacing: context.vooSpacing.md,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: effectiveForegroundColor,
          fontWeight: FontWeight.w600,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: context.vooSize.borderThin,
            color: theme.dividerColor.withValues(alpha: 0.08),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: theme.brightness,
        ),
      ),
      ),
    );
  }

  VooNavigationConfig? _getConfigFromScaffold(BuildContext context) =>
      VooNavigationInherited.maybeOf(context)?.config;

  String? _getSelectedIdFromScaffold(BuildContext context) =>
      VooNavigationInherited.maybeOf(context)?.selectedId;
}

/// Function to determine if a notification should be handled
bool defaultScrollNotificationPredicate(ScrollNotification notification) =>
    notification.depth == 0;
