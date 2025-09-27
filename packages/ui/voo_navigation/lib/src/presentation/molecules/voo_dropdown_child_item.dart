import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';
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
      borderRadius: context.vooRadius.button,
      child: Container(
        padding:
            childrenPadding ??
            EdgeInsets.only(
              left: context.vooSpacing.xxl * 2,
              right: context.vooSpacing.md,
              top: context.vooSpacing.sm,
              bottom: context.vooSpacing.sm,
            ),
        decoration: isSelected && config.indicatorShape == null
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: config.selectedItemColor ?? colorScheme.primary,
                    width: context.vooSize.borderThick,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            // Icon
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              size: context.vooSize.checkboxSize,
              color: isSelected
                  ? (item.selectedIconColor ??
                        config.selectedItemColor ??
                        colorScheme.primary)
                  : (item.iconColor ??
                        config.unselectedItemColor ??
                        colorScheme.onSurfaceVariant),
            ),

            SizedBox(width: context.vooSpacing.sm + context.vooSpacing.xs),

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
              SizedBox(width: context.vooSpacing.sm),
              VooNavigationBadge(
                item: item,
                config: config,
                size: context.vooSize.iconXSmall,
                animate: config.enableAnimations,
              ),
            ],

            // Trailing widget if present
            if (item.trailingWidget != null) ...[
              SizedBox(width: context.vooSpacing.sm),
              item.trailingWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
