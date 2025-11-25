import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_animated_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern floating bottom navigation bar with pill indicator and smooth animations
class VooFloatingBottomNavigation extends StatefulWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Custom height for the navigation bar
  final double? height;

  /// Whether to show labels
  final bool showLabels;

  /// Horizontal margin from screen edges
  final double? horizontalMargin;

  /// Bottom margin from screen edge
  final double? bottomMargin;

  /// Custom background color
  final Color? backgroundColor;

  /// Border radius for the floating bar
  final double? borderRadius;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  const VooFloatingBottomNavigation({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.height,
    this.showLabels = true,
    this.horizontalMargin,
    this.bottomMargin,
    this.backgroundColor,
    this.borderRadius,
    this.enableHapticFeedback = true,
  });

  @override
  State<VooFloatingBottomNavigation> createState() =>
      _VooFloatingBottomNavigationState();
}

class _VooFloatingBottomNavigationState
    extends State<VooFloatingBottomNavigation> with TickerProviderStateMixin {
  late AnimationController _indicatorController;
  late AnimationController _selectionController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _indicatorAnimation = CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(VooFloatingBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      _animateSelection();
    }
  }

  void _animateSelection() {
    _indicatorController.forward(from: 0);
    _selectionController.forward(from: 0);
  }

  int _getSelectedIndex() {
    final items = widget.config.mobilePriorityItems;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == widget.selectedId) {
        return i;
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.config.mobilePriorityItems;
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = _getSelectedIndex();
    final effectiveHeight = widget.height ?? 72.0;
    // Use explicit fallbacks when voo_tokens aren't configured
    final effectiveMargin = widget.horizontalMargin ?? (spacing.md > 0 ? spacing.md : 16.0);
    final effectiveBottomMargin = widget.bottomMargin ?? (spacing.lg > 0 ? spacing.lg : 24.0);
    final effectiveBorderRadius = widget.borderRadius ?? (radius.xxl > 0 ? radius.xxl : 28.0);

    final isDark = theme.brightness == Brightness.dark;
    final effectiveBackgroundColor = widget.backgroundColor ??
        (isDark
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.surface);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        effectiveMargin,
        0,
        effectiveMargin,
        effectiveBottomMargin,
      ),
      child: Container(
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: isDark ? 0.3 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: isDark ? 0.15 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Stack(
            children: [
              // Sliding pill indicator
              AnimatedBuilder(
                animation: _indicatorAnimation,
                builder: (context, child) {
                  return _SlidingPillIndicator(
                    itemCount: items.length,
                    selectedIndex: selectedIndex,
                    animation: _indicatorAnimation,
                    primaryColor: widget.config.selectedItemColor ??
                        theme.colorScheme.primary,
                  );
                },
              ),

              // Navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == selectedIndex;

                  return Expanded(
                    child: _FloatingNavItem(
                      item: item,
                      isSelected: isSelected,
                      showLabel: widget.showLabels,
                      primaryColor: widget.config.selectedItemColor ??
                          theme.colorScheme.primary,
                      onTap: () {
                        if (widget.enableHapticFeedback) {
                          HapticFeedback.lightImpact();
                        }
                        widget.onNavigationItemSelected(item.id);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sliding pill indicator that moves between items
class _SlidingPillIndicator extends StatelessWidget {
  final int itemCount;
  final int selectedIndex;
  final Animation<double> animation;
  final Color primaryColor;

  const _SlidingPillIndicator({
    required this.itemCount,
    required this.selectedIndex,
    required this.animation,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / itemCount;
        final pillWidth = itemWidth * 0.65;
        final pillHeight = 4.0;
        final leftPosition =
            (itemWidth * selectedIndex) + (itemWidth - pillWidth) / 2;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          left: leftPosition,
          top: 8,
          child: Container(
            width: pillWidth,
            height: pillHeight,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(pillHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Individual floating navigation item
class _FloatingNavItem extends StatefulWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final bool showLabel;
  final Color primaryColor;
  final VoidCallback onTap;

  const _FloatingNavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_FloatingNavItem> createState() => _FloatingNavItemState();
}

class _FloatingNavItemState extends State<_FloatingNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
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
  void didUpdateWidget(_FloatingNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _playBounce();
    }
  }

  void _playBounce() {
    _bounceController.forward(from: 0);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.item.isEnabled ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          final scale = widget.isSelected
              ? 1.0 + (_bounceAnimation.value - 1.0) * 0.15
              : (_isPressed ? 0.92 : 1.0);

          return Transform.scale(
            scale: scale,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with optional badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        child: Icon(
                          widget.isSelected
                              ? widget.item.effectiveSelectedIcon
                              : widget.item.icon,
                          key: ValueKey(widget.isSelected),
                          color: widget.isSelected
                              ? widget.primaryColor
                              : theme.colorScheme.onSurfaceVariant,
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
                  ),

                  // Label
                  if (widget.showLabel) ...[
                    SizedBox(height: spacing.xxs),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: widget.isSelected
                            ? widget.primaryColor
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 11,
                      ),
                      child: Text(
                        widget.item.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
