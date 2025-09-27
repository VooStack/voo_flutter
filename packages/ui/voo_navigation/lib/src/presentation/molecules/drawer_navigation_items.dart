import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_expandable_section.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Widget that builds the list of navigation items for the drawer
class VooDrawerNavigationItems extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Map of expansion controllers
  final Map<String, AnimationController> expansionControllers;

  /// Map of expansion animations
  final Map<String, Animation<double>> expansionAnimations;

  /// Callback to set hover state
  final void Function(String itemId, bool isHovered) onHoverChanged;

  const VooDrawerNavigationItems({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.expansionControllers,
    required this.expansionAnimations,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleItems = config.visibleItems;
    final widgets = <Widget>[];

    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];

      // Check if this is a divider
      if (item.isDivider) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.vooSpacing.sm),
            child: Divider(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              height: context.vooSize.borderThin,
            ),
          ),
        );
        continue;
      }

      // Check if this is a section with children
      if (item.hasChildren) {
        widgets.add(
          VooDrawerExpandableSection(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            hoveredItems: hoveredItems,
            onHoverChanged: onHoverChanged,
            expansionController: expansionControllers[item.id],
            expansionAnimation: expansionAnimations[item.id],
          ),
        );
      } else {
        widgets.add(
          VooDrawerNavigationItem(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            isHovered: hoveredItems[item.id] == true,
            onHoverChanged: (isHovered) => onHoverChanged(item.id, isHovered),
          ),
        );
      }
    }

    return Column(children: widgets);
  }
}
