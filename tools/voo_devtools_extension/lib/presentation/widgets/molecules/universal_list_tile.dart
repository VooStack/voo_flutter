import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/presentation/theme/app_theme.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/modern_list_tile.dart';

/// Universal list tile that can display any type of data with consistent styling
class UniversalListTile extends StatelessWidget {
  final String id;
  final String title;
  final String? subtitle;
  final String? category;
  final DateTime timestamp;
  final Widget? leadingBadge;
  final List<Widget> trailingBadges;
  final Map<String, String> metadata;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;
  final IconData? icon;
  final bool showTimestamp;

  const UniversalListTile({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    this.category,
    required this.timestamp,
    this.leadingBadge,
    this.trailingBadges = const [],
    this.metadata = const {},
    this.isSelected = false,
    required this.onTap,
    this.accentColor,
    this.icon,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ModernListTile(
      isSelected: isSelected,
      selectedColor: accentColor,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      leading: leadingBadge ?? (icon != null 
        ? Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (accentColor ?? theme.colorScheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(
              icon,
              size: 18,
              color: accentColor ?? theme.colorScheme.primary,
            ),
          )
        : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...trailingBadges.map((badge) => Padding(
                padding: const EdgeInsets.only(left: AppTheme.spacingSm),
                child: badge,
              )),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTheme.getSubtitleStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      subtitle: showTimestamp ? _buildMetadataRow(context) : null,
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[];
    
    // Add timestamp
    items.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule,
          size: 11,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 3),
        Text(
          _formatTime(timestamp),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
      ],
    ));
    
    // Add category if present
    if (category != null) {
      items.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.label_outline,
            size: 11,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 3),
          Text(
            category!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ));
    }
    
    // Add first metadata item if exists
    if (metadata.isNotEmpty) {
      final firstEntry = metadata.entries.first;
      items.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${firstEntry.key}: ${firstEntry.value}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ));
    }
    
    return Row(
      children: items.map((item) {
        final index = items.indexOf(item);
        if (index == 0) return item;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3,
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            item,
          ],
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}