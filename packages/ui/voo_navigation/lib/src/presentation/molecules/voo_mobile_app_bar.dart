import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_app_bar_leading.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_app_bar_title.dart';

/// Mobile app bar molecule - a simpler app bar specifically for mobile layouts
class VooMobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Navigation configuration
  final VooNavigationConfig? config;

  /// Currently selected navigation item
  final VooNavigationItem? selectedItem;

  /// Currently selected navigation item ID
  final String? selectedId;

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

  /// Whether to show menu button (for drawer)
  final bool showMenuButton;

  /// Custom toolbar height
  final double? toolbarHeight;

  const VooMobileAppBar({
    super.key,
    this.config,
    this.selectedItem,
    this.selectedId,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.showMenuButton = false,
    this.toolbarHeight,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight((toolbarHeight ?? kToolbarHeight) + 8 + 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSelectedId = selectedId ?? selectedItem?.id;

    final effectiveTitle =
        title ??
        config?.appBarTitleBuilder?.call(effectiveSelectedId) ??
        (selectedItem != null
            ? VooAppBarTitle(item: selectedItem!, config: config)
            : const Text(''));

    final effectiveLeading =
        leading ??
        config?.appBarLeadingBuilder?.call(effectiveSelectedId) ??
        (showMenuButton
            ? VooAppBarLeading(showMenuButton: true, config: config)
            : null);

    final effectiveCenterTitle = centerTitle ?? config?.centerAppBarTitle ?? false;

    final effectiveActions = actions ?? config?.appBarActionsBuilder?.call(effectiveSelectedId);

    final effectiveBackgroundColor =
        backgroundColor ??
        config?.navigationBackgroundColor ??
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
          automaticallyImplyLeading: effectiveLeading != null,
          actions: effectiveActions?.isNotEmpty == true
              ? [...effectiveActions!, SizedBox(width: context.vooSpacing.md)]
              : null,
          centerTitle: effectiveCenterTitle,
          backgroundColor: Colors.transparent,
          foregroundColor: effectiveForegroundColor,
          elevation: 0,
          toolbarHeight:
              (toolbarHeight ?? kToolbarHeight) + context.vooSpacing.sm,
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
}
