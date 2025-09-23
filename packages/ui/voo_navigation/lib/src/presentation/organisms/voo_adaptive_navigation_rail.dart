import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

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
    _animationController = AnimationController(duration: widget.config.animationDuration, vsync: this);

    _hoverController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

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

    final effectiveWidth = widget.width ?? (widget.extended ? (widget.config.extendedNavigationRailWidth ?? 256) : (widget.config.navigationRailWidth ?? 88));

    // Use a subtle surface color variation for better visual distinction
    final effectiveBackgroundColor =
        widget.backgroundColor ??
        widget.config.navigationBackgroundColor ??
        (theme.brightness == Brightness.light ? theme.colorScheme.surface.withValues(alpha: 0.95) : theme.colorScheme.surfaceContainerLow);

    return AnimatedContainer(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      width: effectiveWidth,
      margin: EdgeInsets.all(widget.config.navigationRailMargin),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          boxShadow: [
            BoxShadow(color: theme.shadowColor.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(2, 0)),
            BoxShadow(color: theme.shadowColor.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(4, 0)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.vooRadius.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(context.vooRadius.lg), bottomRight: Radius.circular(context.vooRadius.lg)),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1), width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // Custom header or default header
                    if (widget.extended) widget.config.drawerHeader ?? _buildDefaultHeader(context),

                    // Navigation items
                    Expanded(
                      child: ListView(
                        controller: widget.config.drawerScrollController,
                        padding: EdgeInsets.symmetric(
                          vertical: context.vooSpacing.sm,
                          horizontal: widget.extended ? context.vooSpacing.sm + context.vooSpacing.xs : context.vooSpacing.sm,
                        ),
                        physics: const ClampingScrollPhysics(),
                        children: _buildNavigationItems(context),
                      ),
                    ),

                    // Leading widget for FAB or other actions
                    if (widget.config.floatingActionButton != null && widget.config.showFloatingActionButton)
                      Padding(padding: EdgeInsets.all(context.vooSpacing.md), child: widget.config.floatingActionButton),

                    // Custom footer if provided
                    if (widget.config.drawerFooter != null) widget.config.drawerFooter!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    final theme = Theme.of(context);

    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Container(
      padding: EdgeInsets.fromLTRB(spacing.md, spacing.lg, spacing.md, spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(radius.md)),
            child: Icon(Icons.dashboard, color: theme.colorScheme.primary, size: 20),
          ),
          SizedBox(height: spacing.sm),
          Text(
            (widget.config.appBarTitle != null && widget.config.appBarTitle is Text) ? ((widget.config.appBarTitle! as Text).data ?? 'Navigation') : 'Navigation',
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ],
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
        widgets.add(SizedBox(height: context.vooSpacing.xs));
      }
    }

    return widgets;
  }

  Widget _buildSectionHeader(VooNavigationItem item, ThemeData theme) => Theme(
    data: theme.copyWith(
      dividerColor: Colors.transparent,
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: theme.colorScheme.onSurfaceVariant,
        collapsedIconColor: theme.colorScheme.onSurfaceVariant,
        textColor: theme.colorScheme.onSurface,
        collapsedTextColor: theme.colorScheme.onSurfaceVariant,
      ),
    ),
    child: ExpansionTile(
      title: Text(
        item.label,
        style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
      ),
      leading: Icon(item.isExpanded ? item.selectedIcon ?? item.icon : item.icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
      initiallyExpanded: item.isExpanded,
      children: item.children?.map((child) => _buildNavigationItem(child, theme, indent: true)).toList() ?? [],
    ),
  );

  Widget _buildNavigationItem(VooNavigationItem item, ThemeData theme, {bool indent = false}) {
    final isSelected = item.id == widget.selectedId;
    final isHovered = _hoveredItems[item.id] ?? false;
    final isDark = theme.brightness == Brightness.dark;

    _itemAnimationControllers[item.id] ??= AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    if (isSelected) {
      _itemAnimationControllers[item.id]!.forward();
    } else {
      _itemAnimationControllers[item.id]!.reverse();
    }

    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.extended ? 0 : spacing.xs, vertical: spacing.xxs),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredItems[item.id] = true),
        onExit: (_) => setState(() => _hoveredItems[item.id] = false),
        cursor: item.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: InkWell(
          onTap: item.isEnabled ? () => widget.onNavigationItemSelected(item.id) : null,
          borderRadius: BorderRadius.circular(widget.extended ? radius.lg : radius.full),
          child: AnimatedScale(
            scale: isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.extended ? 48 : 56,
              padding: EdgeInsets.symmetric(horizontal: widget.extended ? spacing.md : spacing.xs, vertical: widget.extended ? spacing.sm : spacing.xs),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.extended ? radius.md + spacing.xxs : radius.full),
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.12),
                          theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !isSelected ? (isHovered ? theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.08 : 0.04) : Colors.transparent) : null,
                boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))] : null,
              ),
              child: widget.extended
                  ? Row(
                      children: [
                        // Icon with badge
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected ? item.effectiveSelectedIcon : item.icon,
                            key: ValueKey(isSelected),
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: spacing.sm + spacing.xs),
                        Expanded(
                          child: Text(
                            item.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Badge
                        if (item.hasBadge) ...[SizedBox(width: spacing.sm), _buildModernBadge(item, isSelected)],
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  isSelected ? item.effectiveSelectedIcon : item.icon,
                                  key: ValueKey(isSelected),
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                  size: 24,
                                ),
                              ),
                              if (item.hasBadge) Positioned(top: -4, right: -8, child: _buildModernBadge(item, isSelected)),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernBadge(VooNavigationItem item, bool isSelected) {
    final theme = Theme.of(context);

    String badgeText;
    if (item.badgeCount != null) {
      badgeText = item.badgeCount! > 99 ? '99+' : item.badgeCount.toString();
    } else if (item.badgeText != null) {
      badgeText = item.badgeText!;
    } else if (item.showDot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: item.badgeColor ?? Colors.red, shape: BoxShape.circle),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.extended ? context.vooSpacing.sm : context.vooSpacing.sm - context.vooSpacing.xxs, vertical: context.vooSpacing.xxs),
      decoration: BoxDecoration(color: item.badgeColor ?? theme.colorScheme.error, borderRadius: BorderRadius.circular(context.vooRadius.lg)),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: widget.extended ? 11 : 10),
      ),
    );
  }
}
