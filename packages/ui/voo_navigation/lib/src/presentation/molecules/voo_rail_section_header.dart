import 'package:flutter/material.dart';
import 'package:voo_navigation/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Section header with expansion tile for navigation rail
class VooRailSectionHeader extends StatelessWidget {
  /// Navigation item representing the section
  final VooNavigationItem item;

  /// Child widgets for the expanded section
  final List<Widget> children;

  const VooRailSectionHeader({
    super.key,
    required this.item,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: theme.colorScheme.onSurfaceVariant,
          collapsedIconColor: theme.colorScheme.onSurfaceVariant,
          textColor: theme.colorScheme.onSurface,
          collapsedTextColor: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          item.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(
          item.isExpanded ? item.selectedIcon ?? item.icon : item.icon,
          color: theme.colorScheme.onSurfaceVariant,
          size: context.vooSize.checkboxSize,
        ),
        initiallyExpanded: item.isExpanded,
        children: children,
      ),
    );
  }
}
