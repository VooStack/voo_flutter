import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// Badge widget for navigation items
class VooNavigationBadge extends StatelessWidget {
  /// The navigation item containing badge data
  final VooNavigationItem item;
  
  /// Navigation configuration for styling
  final VooNavigationConfig config;
  
  /// Custom size for the badge
  final double? size;
  
  /// Whether to animate badge changes
  final bool animate;
  
  const VooNavigationBadge({
    super.key,
    required this.item,
    required this.config,
    this.size,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!item.hasBadge) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);
    
    // Handle dot indicator
    if (item.showDot) {
      return _buildDotBadge(theme);
    }
    
    // Handle text/count badge
    final badgeText = item.badgeText ?? 
        (item.badgeCount != null ? _formatCount(item.badgeCount!) : '');
    
    if (badgeText.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return _buildTextBadge(badgeText, theme);
  }
  
  Widget _buildDotBadge(ThemeData theme) {
    final badgeColor = item.badgeColor ?? theme.colorScheme.error;
    
    final dot = Container(
      width: size ?? 8,
      height: size ?? 8,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha((0.3 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
    
    if (animate && config.enableAnimations) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: config.badgeAnimationDuration,
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
        child: dot,
      );
    }
    
    return dot;
  }
  
  Widget _buildTextBadge(String text, ThemeData theme) {
    final badgeColor = item.badgeColor ?? theme.colorScheme.error;
    final textColor = theme.colorScheme.onError;
    
    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: text.length == 1 ? 6 : 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(size ?? 10),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha((0.3 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        minWidth: size ?? 20,
        minHeight: size ?? 20,
      ),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.labelSmall!.copyWith(
            color: textColor,
            fontSize: (size ?? 20) * 0.55,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    
    if (animate && config.enableAnimations) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: config.badgeAnimationDuration,
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          ),
        child: badge,
      );
    }
    
    return badge;
  }
  
  /// Format count for display (e.g., 99+ for counts over 99)
  String _formatCount(int count) {
    if (count > 999) {
      return '999+';
    } else if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
}