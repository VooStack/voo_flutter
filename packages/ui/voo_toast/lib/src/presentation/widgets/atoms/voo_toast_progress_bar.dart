import 'package:flutter/material.dart';

class VooToastProgressBar extends StatelessWidget {
  const VooToastProgressBar({
    super.key,
    required this.duration,
    this.height = 3.0,
    this.color,
    this.backgroundColor,
  });

  final Duration duration;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      ),
      child: TweenAnimationBuilder<double>(
        duration: duration,
        tween: Tween<double>(begin: 1.0, end: 0.0),
        builder: (context, value, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: color ?? theme.colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}