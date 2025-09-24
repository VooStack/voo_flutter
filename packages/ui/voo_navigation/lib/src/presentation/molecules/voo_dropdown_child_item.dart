import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation/src/presentation/molecules/voo_navigation_badge.dart';

/// Dropdown child item widget
class VooDropdownChildItem extends StatelessWidget {
  /// Navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether this item is selected
  final bool isSelected;

  /// Callback when item is selected
  final VoidCallback? onTap;

  /// Padding for child items
  final EdgeInsetsGeometry? childrenPadding;

  const VooDropdownChildItem({
    super.key,
    required this.item,
    required this.config,
    required this.isSelected,
    this.onTap,
    this.childrenPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: item.isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            childrenPadding ??
            const EdgeInsets.only(left: 48, right: 16, top: 8, bottom: 8),
        decoration: isSelected && config.indicatorShape == null
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: config.selectedItemColor ?? colorScheme.primary,
                    width: 3,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            // Icon
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              size: 20,
              color: isSelected
                  ? (item.selectedIconColor ??
                        config.selectedItemColor ??
                        colorScheme.primary)
                  : (item.iconColor ??
                        config.unselectedItemColor ??
                        colorScheme.onSurfaceVariant),
            ),

            const SizedBox(width: 12),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: isSelected
                    ? (item.selectedLabelStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            color:
                                config.selectedItemColor ?? colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ))
                    : (item.labelStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            color:
                                config.unselectedItemColor ??
                                colorScheme.onSurfaceVariant,
                          )),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Badge if present
            if (item.hasBadge) ...[
              const SizedBox(width: 8),
              VooNavigationBadge(
                item: item,
                config: config,
                size: 14,
                animate: config.enableAnimations,
              ),
            ],

            // Trailing widget if present
            if (item.trailingWidget != null) ...[
              const SizedBox(width: 8),
              item.trailingWidget!,
            ],
          ],
        ),
      ),
    );
  }
}