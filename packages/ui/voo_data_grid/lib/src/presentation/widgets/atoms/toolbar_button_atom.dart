import 'package:flutter/material.dart';

/// An atomic toolbar button component
class ToolbarButtonAtom extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Callback when pressed
  final VoidCallback? onPressed;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Whether the button is in active/selected state
  final bool isActive;
  
  /// Optional badge count to display
  final int? badgeCount;
  
  /// Icon color
  final Color? iconColor;
  
  /// Active icon color
  final Color? activeColor;
  
  const ToolbarButtonAtom({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isActive = false,
    this.badgeCount,
    this.iconColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = isActive 
        ? (activeColor ?? theme.colorScheme.primary)
        : iconColor;
    
    Widget button = IconButton(
      icon: Icon(icon, color: effectiveColor),
      onPressed: onPressed,
      tooltip: tooltip,
    );
    
    if (badgeCount != null && badgeCount! > 0) {
      button = Stack(
        children: [
          button,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    return button;
  }
}