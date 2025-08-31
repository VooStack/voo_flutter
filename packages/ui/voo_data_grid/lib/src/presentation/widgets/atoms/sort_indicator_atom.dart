import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// An atomic sort indicator component for column headers
class SortIndicatorAtom extends StatelessWidget {
  /// The current sort direction
  final VooSortDirection direction;
  
  /// Color for the active sort icon
  final Color? activeColor;
  
  /// Color for the inactive sort icon
  final Color? inactiveColor;
  
  /// Size of the icon
  final double iconSize;
  
  const SortIndicatorAtom({
    super.key,
    required this.direction,
    this.activeColor,
    this.inactiveColor,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color? color;
    
    switch (direction) {
      case VooSortDirection.ascending:
        icon = Icons.arrow_upward;
        color = activeColor ?? Theme.of(context).colorScheme.primary;
        break;
      case VooSortDirection.descending:
        icon = Icons.arrow_downward;
        color = activeColor ?? Theme.of(context).colorScheme.primary;
        break;
      case VooSortDirection.none:
        icon = Icons.unfold_more;
        color = inactiveColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);
        break;
    }
    
    return Icon(
      icon,
      size: iconSize,
      color: color,
    );
  }
}