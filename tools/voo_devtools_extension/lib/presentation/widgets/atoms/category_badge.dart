import 'package:flutter/material.dart';

class CategoryBadge extends StatelessWidget {
  final String category;
  final Color? color;
  final TextStyle? textStyle;

  const CategoryBadge({
    super.key,
    required this.category,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = color ?? theme.colorScheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: bgColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        category,
        style:
            textStyle ??
            theme.textTheme.labelSmall?.copyWith(
              color: bgColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
