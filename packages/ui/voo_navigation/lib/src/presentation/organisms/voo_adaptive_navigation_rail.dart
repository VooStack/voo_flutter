import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// Adaptive navigation rail for tablet and desktop layouts with Material 3 design
/// Features smooth animations, hover effects, and beautiful visual transitions
class VooAdaptiveNavigationRail extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Whether to show extended rail with labels
  final bool extended;

  /// Custom width for the rail
  final double? width;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom elevation
  final double? elevation;

  const VooAdaptiveNavigationRail({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.extended = false,
    this.width,
    this.backgroundColor,
    this.elevation,
  });

  @override
  State<VooAdaptiveNavigationRail> createState() => _VooAdaptiveNavigationRailState();
}

class _VooAdaptiveNavigationRailState extends State<VooAdaptiveNavigationRail> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  final Map<String, bool> _hoveredItems = {};
  final Map<String, AnimationController> _itemAnimationControllers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    if (widget.extended) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VooAdaptiveNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended) {
      if (widget.extended) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    for (final controller in _itemAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveWidth = widget.width ?? (widget.extended ? (widget.config.extendedNavigationRailWidth ?? 256) : (widget.config.navigationRailWidth ?? 88));

    final effectiveBackgroundColor =
        widget.backgroundColor ?? widget.config.navigationBackgroundColor ?? theme.navigationRailTheme.backgroundColor ?? colorScheme.surface;

    final effectiveElevation = widget.elevation ?? widget.config.elevation ?? theme.navigationRailTheme.elevation ?? 0;

    return AnimatedContainer(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      width: effectiveWidth,
      child: Material(
        color: effectiveBackgroundColor,
        elevation: effectiveElevation,
        shadowColor: theme.colorScheme.shadow.withAlpha(25),
        surfaceTintColor: theme.colorScheme.surfaceTint,
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(16),
        ),
        child: Column(
          children: [
            // Custom header if provided
            if (widget.config.drawerHeader != null) widget.config.drawerHeader!,

            // Navigation items
            Expanded(
              child: ListView(
                controller: widget.config.drawerScrollController,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: widget.extended ? 0 : 8,
                ),
                physics: const ClampingScrollPhysics(),
                children: _buildNavigationItems(context),
              ),
            ),

            // Leading widget for FAB or other actions
            if (widget.config.floatingActionButton != null && widget.config.showFloatingActionButton)
              Padding(
                padding: const EdgeInsets.all(16),
                child: widget.config.floatingActionButton,
              ),

            // Custom footer if provided
            if (widget.config.drawerFooter != null) widget.config.drawerFooter!,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    final theme = Theme.of(context);
    final visibleItems = widget.config.visibleItems;
    final widgets = <Widget>[];

    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];

      // Handle section headers
      if (item.hasChildren && widget.config.groupItemsBySections) {
        widgets.add(_buildSectionHeader(item, theme));
        if (item.isExpanded && item.children != null) {
          for (final child in item.children!) {
            widgets.add(_buildNavigationItem(child, theme, indent: true));
          }
        }
      } else {
        widgets.add(_buildNavigationItem(item, theme));
      }

      // Add spacing between items
      if (i < visibleItems.length - 1) {
        widgets.add(const SizedBox(height: 4));
      }
    }

    return widgets;
  }

  Widget _buildSectionHeader(VooNavigationItem item, ThemeData theme) => ExpansionTile(
        title: AnimatedDefaultTextStyle(
          duration: widget.config.animationDuration,
          style: widget.extended ? (item.labelStyle ?? theme.textTheme.titleSmall!) : const TextStyle(fontSize: 0),
          child: Text(item.label),
        ),
        leading: Icon(
          item.isExpanded ? item.selectedIcon ?? item.icon : item.icon,
          color: item.iconColor ?? theme.colorScheme.onSurfaceVariant,
        ),
        initiallyExpanded: item.isExpanded,
        children: item.children
                ?.map(
                  (child) => _buildNavigationItem(child, theme, indent: true),
                )
                .toList() ??
            [],
      );

  Widget _buildNavigationItem(
    VooNavigationItem item,
    ThemeData theme, {
    bool indent = false,
  }) {
    final isSelected = item.id == widget.selectedId;
    final colorScheme = theme.colorScheme;
    final isHovered = _hoveredItems[item.id] ?? false;

    final selectedColor = widget.config.selectedItemColor ?? theme.navigationRailTheme.selectedIconTheme?.color ?? colorScheme.primary;

    final unselectedColor = widget.config.unselectedItemColor ?? theme.navigationRailTheme.unselectedIconTheme?.color ?? colorScheme.onSurfaceVariant;

    _itemAnimationControllers[item.id] ??= AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (isSelected) {
      _itemAnimationControllers[item.id]!.forward();
    } else {
      _itemAnimationControllers[item.id]!.reverse();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.extended ? 12 : 4,
        vertical: 4,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredItems[item.id] = true),
        onExit: (_) => setState(() => _hoveredItems[item.id] = false),
        cursor: item.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: InkWell(
          onTap: item.isEnabled ? () => widget.onNavigationItemSelected(item.id) : null,
          borderRadius: BorderRadius.circular(widget.extended ? 16 : 28),
          splashColor: selectedColor.withAlpha(25),
          highlightColor: selectedColor.withAlpha(15),
          hoverColor: selectedColor.withAlpha(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.extended ? 56 : 64,
            padding: EdgeInsets.symmetric(
              horizontal: widget.extended ? 16 : 4,
              vertical: widget.extended ? 8 : 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.extended ? 16 : 28),
              color: isSelected
                  ? selectedColor.withAlpha(25)
                  : isHovered
                      ? colorScheme.surfaceContainerHighest.withAlpha(51)
                      : null,
            ),
            child: widget.extended
                ? Row(
                    children: [
                      // Icon with badge
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: item.leadingWidget ??
                                  Icon(
                                    isSelected ? item.effectiveSelectedIcon : item.icon,
                                    key: ValueKey('${item.id}_icon_$isSelected'),
                                    color: isSelected ? (item.selectedIconColor ?? selectedColor) : (item.iconColor ?? unselectedColor),
                                    size: 24,
                                  ),
                            ),
                            if (item.hasBadge || item.trailingWidget != null)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: item.trailingWidget ?? _buildBadge(item, theme),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: widget.config.animationDuration,
                          style: isSelected
                              ? (item.selectedLabelStyle ??
                                  theme.textTheme.bodyMedium!.copyWith(
                                    color: selectedColor,
                                    fontWeight: FontWeight.w600,
                                  ))
                              : (item.labelStyle ??
                                  theme.textTheme.bodyMedium!.copyWith(
                                    color: unselectedColor,
                                  )),
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: item.leadingWidget ??
                              Icon(
                                isSelected ? item.effectiveSelectedIcon : item.icon,
                                key: ValueKey('${item.id}_icon_$isSelected'),
                                color: isSelected ? (item.selectedIconColor ?? selectedColor) : (item.iconColor ?? unselectedColor),
                                size: 28,
                              ),
                        ),
                        if (item.hasBadge || item.trailingWidget != null)
                          Positioned(
                            top: -4,
                            right: -8,
                            child: item.trailingWidget ?? _buildBadge(item, theme),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(VooNavigationItem item, ThemeData theme) {
    if (item.showDot) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: item.badgeColor ?? theme.colorScheme.error,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.surface,
          ),
        ),
      );
    }

    final badgeText = item.badgeText ?? (item.badgeCount != null ? item.badgeCount.toString() : '');

    if (badgeText.isEmpty) return const SizedBox.shrink();

    // Compact badge for navigation rail
    if (!widget.extended) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: item.badgeColor ?? theme.colorScheme.error,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.surface,
          ),
        ),
        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
        child: Center(
          child: Text(
            badgeText.length > 2 ? '99+' : badgeText,
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onError,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Regular badge for extended rail
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: item.badgeColor ?? theme.colorScheme.error,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 1.5,
        ),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Center(
        child: Text(
          badgeText,
          style: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
