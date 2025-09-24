import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_dropdown_child_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Dropdown children widget that displays child navigation items
class VooDropdownChildren extends StatelessWidget {
  /// Parent navigation item with children
  final VooNavigationItem parentItem;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String? selectedId;

  /// Callback when a child item is selected
  final void Function(String itemId) onItemSelected;

  /// Whether to show dividers between items
  final bool showDividers;

  /// Padding for child items
  final EdgeInsetsGeometry? childrenPadding;

  const VooDropdownChildren({
    super.key,
    required this.parentItem,
    required this.config,
    required this.selectedId,
    required this.onItemSelected,
    this.showDividers = false,
    this.childrenPadding,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final items = parentItem.children ?? [];

    for (int i = 0; i < items.length; i++) {
      final child = items[i];
      final isSelected = child.id == selectedId;

      if (showDividers && i > 0) {
        children.add(Divider(height: context.vooSize.borderThin, thickness: 0.5, indent: 48));
      }

      children.add(
        VooDropdownChildItem(
          item: child,
          config: config,
          isSelected: isSelected,
          onTap: () => onItemSelected(child.id),
          childrenPadding: childrenPadding,
        ),
      );
    }

    return Column(children: children);
  }
}