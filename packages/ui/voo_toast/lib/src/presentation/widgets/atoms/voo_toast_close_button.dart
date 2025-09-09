import 'package:flutter/material.dart';

class VooToastCloseButton extends StatelessWidget {
  const VooToastCloseButton({
    super.key,
    required this.onPressed,
    this.size = 20.0,
    this.color,
  });

  final VoidCallback onPressed;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.close,
        size: size,
        color: color ?? theme.colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        width: size + 8,
        height: size + 8,
      ),
    );
  }
}