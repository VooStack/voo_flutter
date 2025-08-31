import 'package:flutter/material.dart';

/// An atomic pagination button component
class PaginationButtonAtom extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Callback when pressed
  final VoidCallback? onPressed;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Icon size
  final double iconSize;
  
  const PaginationButtonAtom({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) => IconButton(
      icon: Icon(icon, size: iconSize),
      onPressed: onPressed,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
}