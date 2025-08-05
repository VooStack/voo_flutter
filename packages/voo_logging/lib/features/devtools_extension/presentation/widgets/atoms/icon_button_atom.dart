import 'package:flutter/material.dart';

/// Atomic icon button with consistent styling
class IconButtonAtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;

  const IconButtonAtom({super.key, required this.icon, this.onPressed, this.tooltip, this.color, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color ?? theme.iconTheme.color,
      constraints: BoxConstraints(minWidth: size + 16, minHeight: size + 16),
      padding: const EdgeInsets.all(8),
      splashRadius: size,
    );
  }
}
