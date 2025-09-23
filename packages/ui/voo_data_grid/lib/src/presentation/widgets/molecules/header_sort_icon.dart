import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';

/// Sort icon widget for header cells
class HeaderSortIcon extends StatelessWidget {
  final VooSortDirection direction;
  final VooDataGridTheme theme;

  const HeaderSortIcon({super.key, required this.direction, required this.theme});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color? color;

    switch (direction) {
      case VooSortDirection.ascending:
        icon = Icons.arrow_upward;
        color = theme.headerTextColor;
        break;
      case VooSortDirection.descending:
        icon = Icons.arrow_downward;
        color = theme.headerTextColor;
        break;
      case VooSortDirection.none:
        icon = Icons.unfold_more;
        color = theme.headerTextColor.withValues(alpha: 0.3);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
