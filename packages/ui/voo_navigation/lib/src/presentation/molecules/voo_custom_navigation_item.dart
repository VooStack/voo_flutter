import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/atoms/voo_modern_icon.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Custom navigation item widget for bottom navigation
class VooCustomNavigationItem extends StatelessWidget {
  /// Navigation item data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Index of this item
  final int index;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Scale animation for the icon
  final Animation<double> scaleAnimation;

  /// Rotation animation for the icon
  final Animation<double> rotationAnimation;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show selected labels only
  final bool showSelectedLabels;

  /// Whether to enable feedback
  final bool enableFeedback;

  /// Callback when item is selected
  final VoidCallback? onTap;

  const VooCustomNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.index,
    required this.config,
    required this.scaleAnimation,
    required this.rotationAnimation,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = config.selectedItemColor ?? theme.colorScheme.primary;

    return InkWell(
      onTap: item.isEnabled
          ? () {
              if (enableFeedback) {
                HapticFeedback.lightImpact();
              }
              onTap?.call();
            }
          : null,
      borderRadius: BorderRadius.circular(context.vooRadius.lg),
      child: AnimatedContainer(
        duration: config.animationDuration,
        padding: EdgeInsets.symmetric(
          vertical: context.vooSpacing.xs,
          horizontal: context.vooSpacing.sm + context.vooSpacing.xxs,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: context.vooSpacing.xs - context.vooSpacing.xxs,
          vertical: context.vooSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.vooRadius.md + context.vooSpacing.xxs,
          ),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedBuilder(
              animation: Listenable.merge([scaleAnimation, rotationAnimation]),
              builder: (context, child) => Transform.scale(
                scale: scaleAnimation.value,
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: VooModernIcon(
                    item: item,
                    isSelected: isSelected,
                    primaryColor: primaryColor,
                  ),
                ),
              ),
            ),

            // Animated label
            if (showLabels && (!showSelectedLabels || isSelected))
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.white.withValues(alpha: 0.85),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 11,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: context.vooSpacing.xxs),
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}