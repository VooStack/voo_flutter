import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_ui/src/foundations/design_system.dart';

class VooAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;
  final double? preferredHeight;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double? expandedHeight;
  final double? collapsedHeight;
  final NotificationListenerCallback<ScrollNotification>? notificationPredicate;

  const VooAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.preferredHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.expandedHeight,
    this.collapsedHeight,
    this.notificationPredicate,
  });

  @override
  Size get preferredSize {
    const design = VooDesignSystemData.defaultSystem;
    final double height = preferredHeight ?? toolbarHeight ?? design.appBarHeight;
    return Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    // Build actions with proper spacing
    List<Widget>? spacedActions;
    if (actions != null && actions!.isNotEmpty) {
      spacedActions = [];
      for (int i = 0; i < actions!.length; i++) {
        spacedActions.add(actions![i]);
        if (i < actions!.length - 1) {
          spacedActions.add(SizedBox(width: design.spacingXs));
        }
      }
      // Add end padding
      spacedActions.add(SizedBox(width: design.spacingSm));
    }

    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title != null
          ? DefaultTextStyle(
              style: titleTextStyle ?? theme.textTheme.titleLarge ?? const TextStyle(),
              child: title!,
            )
          : null,
      actions: spacedActions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation ?? 0,
      scrolledUnderElevation: scrolledUnderElevation ?? 3,
      shadowColor: shadowColor ?? theme.shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      iconTheme: iconTheme ??
          IconThemeData(
            color: theme.colorScheme.onSurface,
            size: design.iconSizeLg,
          ),
      actionsIconTheme: actionsIconTheme ??
          IconThemeData(
            color: theme.colorScheme.onSurfaceVariant,
            size: design.iconSizeLg,
          ),
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? design.spacingLg,
      toolbarHeight: toolbarHeight ?? design.appBarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a VooAppBar suitable for use in a SliverAppBar
  static SliverAppBar sliver({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    double? scrolledUnderElevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    bool forceElevated = false,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool primary = true,
    bool? centerTitle,
    bool excludeHeaderSemantics = false,
    double? titleSpacing,
    double? collapsedHeight,
    double? expandedHeight,
    bool floating = false,
    bool pinned = false,
    bool snap = false,
    bool stretch = false,
    double stretchTriggerOffset = 100.0,
    AsyncCallback? onStretchTrigger,
    ShapeBorder? shape,
    double? toolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool forceMaterialTransparency = false,
    Clip? clipBehavior,
  }) =>
      SliverAppBar(
        key: key,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: title,
        actions: actions,
        flexibleSpace: flexibleSpace,
        bottom: bottom,
        elevation: elevation,
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        forceElevated: forceElevated,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconTheme: iconTheme,
        actionsIconTheme: actionsIconTheme,
        primary: primary,
        centerTitle: centerTitle,
        excludeHeaderSemantics: excludeHeaderSemantics,
        titleSpacing: titleSpacing,
        collapsedHeight: collapsedHeight,
        expandedHeight: expandedHeight,
        floating: floating,
        pinned: pinned,
        snap: snap,
        stretch: stretch,
        stretchTriggerOffset: stretchTriggerOffset,
        onStretchTrigger: onStretchTrigger,
        shape: shape,
        toolbarHeight: toolbarHeight ?? VooDesignSystemData.defaultSystem.appBarHeight,
        leadingWidth: leadingWidth,
        toolbarTextStyle: toolbarTextStyle,
        titleTextStyle: titleTextStyle,
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: forceMaterialTransparency,
        clipBehavior: clipBehavior,
      );
}
