import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_animated_badge.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_line_indicator.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_themed_indicator.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed navigation item widget
///
/// Renders a navigation item with the appropriate visual style based on theme:
/// - Handles selection state and animations
/// - Displays icon, label, and badge
/// - Supports hover states (for desktop)
/// - Applies theme-specific indicators
///
/// ```dart
/// VooThemedNavItem(
///   theme: config.effectiveTheme,
///   item: navigationItem,
///   isSelected: isCurrentItem,
///   onTap: () => handleSelect(item.id),
/// )
/// ```
class VooThemedNavItem extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation item data
  final VooNavigationItem item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Whether to show the label
  final bool showLabel;

  /// Custom selected color (overrides theme)
  final Color? selectedColor;

  /// Custom unselected color (overrides theme)
  final Color? unselectedColor;

  /// Whether to enable haptic feedback on tap
  final bool enableHapticFeedback;

  /// Orientation of the item (vertical for rail, horizontal for bottom nav)
  final Axis orientation;

  /// Line indicator position (for minimal theme)
  final VooLineIndicatorPosition lineIndicatorPosition;

  const VooThemedNavItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.showLabel = true,
    this.selectedColor,
    this.unselectedColor,
    this.enableHapticFeedback = true,
    this.orientation = Axis.vertical,
    this.lineIndicatorPosition = VooLineIndicatorPosition.bottom,
  });

  @override
  State<VooThemedNavItem> createState() => _VooThemedNavItemState();
}

class _VooThemedNavItemState extends State<VooThemedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void didUpdateWidget(VooThemedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _playBounce();
    }
  }

  void _playBounce() {
    _bounceController.forward(from: 0);
  }

  void _handleTap() {
    if (!widget.item.isEnabled) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.vooSpacing;

    final selectedColor =
        widget.selectedColor ?? widget.theme.resolveIndicatorColor(context);
    final unselectedColor =
        widget.unselectedColor ?? colorScheme.onSurfaceVariant;

    final effectiveColor = widget.isSelected ? selectedColor : unselectedColor;

    // Build the icon with badge
    Widget iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedSwitcher(
          duration: widget.theme.animationDuration,
          switchInCurve: widget.theme.animationCurve,
          switchOutCurve: Curves.easeIn,
          child: Icon(
            widget.isSelected
                ? widget.item.effectiveSelectedIcon
                : widget.item.icon,
            key: ValueKey(widget.isSelected),
            color: effectiveColor,
            size: 24,
          ),
        ),
        if (widget.item.hasBadge)
          Positioned(
            top: -6,
            right: -10,
            child: VooAnimatedBadge(
              item: widget.item,
              isSelected: widget.isSelected,
            ),
          ),
      ],
    );

    // Build the content based on orientation
    Widget content;
    if (widget.orientation == Axis.vertical) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          if (widget.showLabel) ...[
            SizedBox(height: spacing.xxs),
            AnimatedDefaultTextStyle(
              duration: widget.theme.animationDuration,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: effectiveColor,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
              child: Text(
                widget.item.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (widget.showLabel) ...[
            SizedBox(width: spacing.sm),
            AnimatedDefaultTextStyle(
              duration: widget.theme.animationDuration,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: effectiveColor,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
              child: Text(
                widget.item.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      );
    }

    // Wrap with themed indicator
    content = VooThemedIndicator(
      theme: widget.theme,
      isSelected: widget.isSelected,
      linePosition: widget.lineIndicatorPosition,
      child: content,
    );

    // Apply scale animation on selection
    content = AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        final scale = widget.isSelected
            ? 1.0 + (_bounceAnimation.value - 1.0) * 0.1
            : (_isPressed ? 0.95 : 1.0);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: content,
    );

    // Apply hover effect for desktop
    content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        duration: widget.theme.animationDuration,
        opacity: widget.item.isEnabled
            ? (_isHovered ? 0.9 : 1.0)
            : 0.5,
        child: content,
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.item.isEnabled ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        child: content,
      ),
    );
  }
}

/// A themed rail navigation item with edge indicator
///
/// Specialized for vertical rail navigation with optional edge bar
class VooThemedRailItem extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation item data
  final VooNavigationItem item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Whether to show the label
  final bool showLabel;

  /// Whether to show the edge indicator
  final bool showEdgeIndicator;

  /// Custom selected color
  final Color? selectedColor;

  /// Width of the rail item
  final double width;

  const VooThemedRailItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.showLabel = false,
    this.showEdgeIndicator = true,
    this.selectedColor,
    this.width = 72,
  });

  @override
  State<VooThemedRailItem> createState() => _VooThemedRailItemState();
}

class _VooThemedRailItemState extends State<VooThemedRailItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.vooSpacing;

    final selectedColor =
        widget.selectedColor ?? widget.theme.resolveIndicatorColor(context);
    final unselectedColor = colorScheme.onSurfaceVariant;
    final effectiveColor = widget.isSelected ? selectedColor : unselectedColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.isEnabled ? widget.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: widget.width,
          child: Row(
            children: [
              // Edge indicator
              if (widget.showEdgeIndicator)
                VooEdgeBarIndicator(
                  theme: widget.theme,
                  isSelected: widget.isSelected,
                  color: selectedColor,
                ),

              // Item content
              Expanded(
                child: AnimatedContainer(
                  duration: widget.theme.animationDuration,
                  curve: widget.theme.animationCurve,
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.sm,
                    horizontal: spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered && !widget.isSelected
                        ? colorScheme.onSurface.withValues(alpha: 0.04)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      widget.theme.indicatorBorderRadius,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            widget.isSelected
                                ? widget.item.effectiveSelectedIcon
                                : widget.item.icon,
                            color: effectiveColor,
                            size: 24,
                          ),
                          if (widget.item.hasBadge)
                            Positioned(
                              top: -4,
                              right: -8,
                              child: VooAnimatedBadge(
                                item: widget.item,
                                isSelected: widget.isSelected,
                              ),
                            ),
                        ],
                      ),

                      // Label
                      if (widget.showLabel) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          widget.item.label,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: effectiveColor,
                                    fontWeight: widget.isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A themed drawer navigation item
///
/// Specialized for horizontal drawer navigation with full labels
class VooThemedDrawerItem extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation item data
  final VooNavigationItem item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Custom selected color
  final Color? selectedColor;

  /// Whether this is a child item (indented)
  final bool isChild;

  const VooThemedDrawerItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.selectedColor,
    this.isChild = false,
  });

  @override
  State<VooThemedDrawerItem> createState() => _VooThemedDrawerItemState();
}

class _VooThemedDrawerItemState extends State<VooThemedDrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.vooSpacing;

    final selectedColor =
        widget.selectedColor ?? widget.theme.resolveIndicatorColor(context);
    final unselectedColor = colorScheme.onSurfaceVariant;
    final effectiveColor = widget.isSelected ? selectedColor : unselectedColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.isEnabled ? widget.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: widget.theme.animationDuration,
          curve: widget.theme.animationCurve,
          margin: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xxs,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ).copyWith(
            left: widget.isChild ? spacing.xl : spacing.md,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? selectedColor.withValues(alpha: 0.12)
                : _isHovered
                    ? colorScheme.onSurface.withValues(alpha: 0.04)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.theme.indicatorBorderRadius),
          ),
          child: Row(
            children: [
              // Edge indicator for selected
              if (widget.isSelected &&
                  widget.theme.preset != VooNavigationPreset.minimalModern)
                Container(
                  width: 3,
                  height: 24,
                  margin: EdgeInsets.only(right: spacing.sm),
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),

              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    widget.isSelected
                        ? widget.item.effectiveSelectedIcon
                        : widget.item.icon,
                    color: effectiveColor,
                    size: 24,
                  ),
                  if (widget.item.hasBadge)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: VooAnimatedBadge(
                        item: widget.item,
                        isSelected: widget.isSelected,
                      ),
                    ),
                ],
              ),

              SizedBox(width: spacing.md),

              // Label
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: effectiveColor,
                        fontWeight:
                            widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Trailing badge count
              if (widget.item.badgeCount != null && widget.item.badgeCount! > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xs,
                    vertical: spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.item.badgeCount! > 99
                        ? '99+'
                        : widget.item.badgeCount.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
