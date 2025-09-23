import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';

/// Reusable navigation item widget
class VooNavigationItemWidget extends StatelessWidget {
  final VooNavigationItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const VooNavigationItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(isSelected ? item.effectiveSelectedIcon : item.icon),
    title: Text(item.label),
    selected: isSelected,
    onTap: item.isEnabled ? onTap : null,
  );
}
