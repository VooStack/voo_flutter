import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/drawer_child_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Expandable section widget for drawer navigation with children
class VooDrawerExpandableSection extends StatelessWidget {
  /// The navigation item with children
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Callback to set hover state
  final void Function(String itemId, bool isHovered) onHoverChanged;

  /// Expansion animation controller
  final AnimationController? expansionController;

  /// Expansion animation
  final Animation<double>? expansionAnimation;

  const VooDrawerExpandableSection({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.onHoverChanged,
    this.expansionController,
    this.expansionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpanded = expansionController?.value == 1.0;
    final isHovered = hoveredItems[item.id] == true;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(item.id, true),
          onExit: (_) => onHoverChanged(item.id, false),
          child: InkWell(
            onTap: () => onItemTap(item),
            borderRadius: BorderRadius.circular(context.vooRadius.lg),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(bottom: context.vooSpacing.xs),
              padding: EdgeInsets.symmetric(
                horizontal: context.vooSpacing.md,
                vertical: context.vooSpacing.sm + context.vooSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(context.vooRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? item.selectedIcon ?? item.icon
                        : item.icon,
                    color: Colors.white,
                    size: context.vooSize.checkboxSize,
                  ),
                  SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.25 : 0,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: context.vooSize.checkboxSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Animated expansion for children
        if (expansionController != null && expansionAnimation != null)
          SizeTransition(
            sizeFactor: expansionAnimation!,
            child: Column(
              children: item.children!.map((child) =>
                VooDrawerChildNavigationItem(
                  item: child,
                  config: config,
                  selectedId: selectedId,
                  onItemTap: onItemTap,
                  isHovered: hoveredItems[child.id] == true,
                  onHoverChanged: (isHovered) => onHoverChanged(child.id, isHovered),
                ),
              ).toList(),
            ),
          ),
      ],
    );
  }
}