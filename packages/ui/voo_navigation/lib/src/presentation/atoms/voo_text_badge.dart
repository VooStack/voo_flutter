import 'package:flutter/material.dart';

/// Text badge widget for navigation items
class VooTextBadge extends StatelessWidget {
  /// Badge text to display
  final String text;

  /// Badge color
  final Color badgeColor;

  /// Text color
  final Color textColor;

  /// Badge size
  final double size;

  /// Text style
  final TextStyle? textStyle;

  /// Whether to animate the badge
  final bool animate;

  /// Animation duration
  final Duration animationDuration;

  const VooTextBadge({
    super.key,
    required this.text,
    required this.badgeColor,
    required this.textColor,
    required this.size,
    this.textStyle,
    required this.animate,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final badge = Container(
      padding: EdgeInsets.symmetric(
        horizontal: text.length == 1 ? 6 : 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha((0.3 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      child: Center(
        child: Text(
          text,
          style:
              textStyle ??
              theme.textTheme.labelSmall!.copyWith(
                color: textColor,
                fontSize: size * 0.55,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    if (!animate) {
      return badge;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: animationDuration,
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: badge,
    );
  }
}
