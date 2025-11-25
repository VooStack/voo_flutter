import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Animated badge widget with pulse effect for new notifications
class VooAnimatedBadge extends StatefulWidget {
  /// Navigation item containing badge data
  final VooNavigationItem item;

  /// Whether the parent item is selected
  final bool isSelected;

  /// Custom badge color
  final Color? badgeColor;

  /// Whether to show pulse animation
  final bool enablePulse;

  const VooAnimatedBadge({
    super.key,
    required this.item,
    required this.isSelected,
    this.badgeColor,
    this.enablePulse = true,
  });

  @override
  State<VooAnimatedBadge> createState() => _VooAnimatedBadgeState();
}

class _VooAnimatedBadgeState extends State<VooAnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  int? _previousCount;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_pulseController);

    _previousCount = widget.item.badgeCount;
  }

  @override
  void didUpdateWidget(VooAnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger pulse when badge count increases
    final currentCount = widget.item.badgeCount ?? 0;
    final previousCount = _previousCount ?? 0;

    if (currentCount > previousCount && widget.enablePulse) {
      _pulseController.forward(from: 0);
    }

    _previousCount = widget.item.badgeCount;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    final badgeColor =
        widget.badgeColor ?? widget.item.badgeColor ?? theme.colorScheme.error;

    // Handle dot badge
    if (widget.item.showDot) {
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              if (widget.enablePulse && _pulseController.isAnimating)
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badgeColor.withValues(
                        alpha: (1.0 - _pulseController.value) * 0.4,
                      ),
                    ),
                  ),
                ),
              // Main dot
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Get badge text
    String badgeText;
    if (widget.item.badgeCount != null) {
      badgeText =
          widget.item.badgeCount! > 99 ? '99+' : widget.item.badgeCount.toString();
    } else if (widget.item.badgeText != null) {
      badgeText = widget.item.badgeText!;
    } else {
      return const SizedBox.shrink();
    }

    // Build text badge with animation
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring for text badge
            if (widget.enablePulse && _pulseController.isAnimating)
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(
                      alpha: (1.0 - _pulseController.value) * 0.3,
                    ),
                    borderRadius: BorderRadius.circular(radius.lg),
                  ),
                  constraints: const BoxConstraints(minWidth: 20),
                  child: Opacity(
                    opacity: 0,
                    child: Text(
                      badgeText,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            // Main badge
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm - spacing.xxs,
                  vertical: spacing.xxs / 2,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(radius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  badgeText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
