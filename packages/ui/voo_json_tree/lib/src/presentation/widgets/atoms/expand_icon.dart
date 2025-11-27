import 'package:flutter/material.dart';

/// An animated expand/collapse icon for tree nodes.
class ExpandIcon extends StatelessWidget {
  /// Creates a new [ExpandIcon].
  const ExpandIcon({
    super.key,
    required this.isExpanded,
    required this.onPressed,
    this.color,
    this.size = 16.0,
    this.duration = const Duration(milliseconds: 200),
  });

  /// Whether the node is currently expanded.
  final bool isExpanded;

  /// Callback when the icon is pressed.
  final VoidCallback onPressed;

  /// The color of the icon.
  final Color? color;

  /// The size of the icon.
  final double size;

  /// The duration of the rotation animation.
  final Duration duration;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: AnimatedRotation(
        turns: isExpanded ? 0.25 : 0.0,
        duration: duration,
        child: Icon(Icons.chevron_right, size: size, color: color ?? Theme.of(context).iconTheme.color),
      ),
    ),
  );
}
