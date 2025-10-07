import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_details_panel.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/category_chip.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

class AnalyticsDetailsPanel extends StatelessWidget {
  final LogEntryModel event;
  final VoidCallback onClose;

  const AnalyticsDetailsPanel({
    super.key,
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = event.metadata ?? {};
    final eventType = metadata['type'] as String?;

    // Determine event type styling
    final (icon, color) = _getEventTypeInfo(eventType);

    // Build sections
    final sections = <DetailSection>[];

    // Event Information section
    sections.add(
      DetailSection(
        title: 'Event Information',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UniversalDetailsPanel.buildKeyValueRow(
              'Timestamp',
              event.timestamp.toIso8601String(),
            ),
            if (event.category != null)
              UniversalDetailsPanel.buildKeyValueRow(
                'Category',
                event.category!,
              ),
            if (eventType != null)
              UniversalDetailsPanel.buildKeyValueRow(
                'Event Type',
                _getEventTypeDisplayName(eventType),
              ),
            UniversalDetailsPanel.buildKeyValueRow(
              'Level',
              event.level.displayName,
            ),
            if (event.tag != null)
              UniversalDetailsPanel.buildKeyValueRow('Tag', event.tag!),
          ],
        ),
      ),
    );

    // Event-specific details
    if (eventType == 'touch_event') {
      sections.add(
        DetailSection(
          title: 'Touch Event Details',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UniversalDetailsPanel.buildKeyValueRow(
                'Position',
                '(${metadata['x']?.toStringAsFixed(1)}, ${metadata['y']?.toStringAsFixed(1)})',
              ),
              if (metadata['screen'] != null)
                UniversalDetailsPanel.buildKeyValueRow(
                  'Screen',
                  metadata['screen'].toString(),
                ),
              if (metadata['touchType'] != null)
                UniversalDetailsPanel.buildKeyValueRow(
                  'Touch Type',
                  metadata['touchType'].toString(),
                ),
            ],
          ),
        ),
      );
    } else if (eventType == 'route_screenshot') {
      sections.add(
        DetailSection(
          title: 'Screenshot Details',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (metadata['route'] != null)
                UniversalDetailsPanel.buildKeyValueRow(
                  'Route',
                  metadata['route'].toString(),
                ),
              if (metadata['width'] != null && metadata['height'] != null)
                UniversalDetailsPanel.buildKeyValueRow(
                  'Dimensions',
                  '${metadata['width']} × ${metadata['height']}',
                ),
            ],
          ),
        ),
      );
    } else if (eventType == 'analytics_event') {
      sections.add(
        DetailSection(
          title: 'Analytics Event Details',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (metadata['eventName'] != null)
                UniversalDetailsPanel.buildKeyValueRow(
                  'Event Name',
                  metadata['eventName'].toString(),
                ),
              if (metadata['parameters'] != null) ...[
                const SizedBox(height: AppTheme.spacingSm),
                const Text(
                  'Parameters:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                UniversalDetailsPanel.buildCodeBlock(
                  context,
                  UniversalDetailsPanel.formatJson(metadata['parameters']),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Message section
    sections.add(
      DetailSection(
        title: 'Message',
        content: SelectableText(
          event.message,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );

    // Metadata section
    if (metadata.isNotEmpty) {
      sections.add(
        DetailSection(
          title: 'Metadata',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            UniversalDetailsPanel.formatJson(metadata),
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    // Error section
    if (event.error != null) {
      sections.add(
        DetailSection(
          title: 'Error',
          content: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
            ),
            child: SelectableText(
              event.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      );
    }

    // Stack trace section
    if (event.stackTrace != null) {
      sections.add(
        DetailSection(
          title: 'Stack Trace',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            event.stackTrace!,
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    return UniversalDetailsPanel(
      title: _getEventTitle(event, eventType),
      headerBadges: [
        if (eventType != null) _buildEventTypeBadge(context, eventType),
        if (event.category != null)
          CategoryChip(category: event.category!, compact: true),
      ],
      sections: sections,
      onClose: onClose,
      accentColor: color,
    );
  }

  String _getEventTitle(LogEntryModel event, String? eventType) {
    if (eventType == 'touch_event') {
      return 'Touch Event';
    } else if (eventType == 'route_screenshot') {
      return 'Route Screenshot';
    } else if (eventType == 'analytics_event') {
      final eventName = event.metadata?['eventName'] as String?;
      return eventName ?? 'Analytics Event';
    }
    return 'Analytics Event';
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
    final (icon, color) = _getEventTypeInfo(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
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
