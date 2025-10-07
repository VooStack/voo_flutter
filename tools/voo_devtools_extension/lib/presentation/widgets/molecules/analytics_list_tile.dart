import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/universal_list_tile.dart';

/// Analytics event tile using the universal list tile component
class AnalyticsListTile extends StatelessWidget {
  final LogEntryModel event;
  final bool isSelected;
  final VoidCallback onTap;

  const AnalyticsListTile({
    super.key,
    required this.event,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = event.metadata ?? {};
    final eventType = metadata['type'] as String?;
    final eventName = metadata['eventName'] as String? ?? event.message;

    // Determine event type and styling
    final (icon, color) = _getEventTypeInfo(eventType);

    // Build subtitle based on event type
    String? subtitle;
    if (eventType == 'touch_event') {
      final x = metadata['x'];
      final y = metadata['y'];
      final screen = metadata['screen'] ?? metadata['screenName'];
      subtitle = 'Touch at ($x, $y) on $screen';
    } else if (eventType == 'route_screenshot') {
      final route = metadata['route'];
      subtitle = 'Screenshot captured for route: $route';
    } else if (eventType == 'analytics_event') {
      subtitle = 'Event: $eventName';
    } else {
      subtitle = event.tag;
    }

    return UniversalListTile(
      id: event.id,
      title: event.message,
      subtitle: subtitle,
      category: event.category ?? 'Analytics',
      timestamp: event.timestamp,
      leadingBadge: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      trailingBadges: [
        if (eventType != null) _buildEventTypeBadge(context, eventType),
      ],
      metadata: {if (metadata.isNotEmpty) 'data': '${metadata.length} fields'},
      isSelected: isSelected,
      onTap: onTap,
      accentColor: color,
      showTimestamp: true,
    );
  }

  (IconData, Color) _getEventTypeInfo(String? type) {
    switch (type) {
      case 'touch_event':
        return (Icons.touch_app_outlined, Colors.blue);
      case 'route_screenshot':
        return (Icons.camera_alt_outlined, Colors.purple);
      case 'analytics_event':
        return (Icons.analytics_outlined, Colors.indigo);
      case 'user_property':
        return (Icons.person_outline, Colors.green);
      case 'screen_view':
        return (Icons.pageview_outlined, Colors.orange);
      default:
        return (Icons.insights_outlined, Colors.grey);
    }
  }

  Widget _buildEventTypeBadge(BuildContext context, String type) {
    final theme = Theme.of(context);
    final displayName = _getEventTypeDisplayName(type);
    final (_, color) = _getEventTypeInfo(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        displayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  String _getEventTypeDisplayName(String type) {
    switch (type) {
      case 'touch_event':
        return 'Touch';
      case 'route_screenshot':
        return 'Screenshot';
      case 'analytics_event':
        return 'Event';
      case 'user_property':
        return 'User';
      case 'screen_view':
        return 'Screen';
      default:
        return type;
    }
  }
}
