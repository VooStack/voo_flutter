import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_details_panel.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/log_level_chip.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/category_chip.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

class LogDetailsPanel extends StatelessWidget {
  final LogEntryModel log;
  final VoidCallback? onClose;

  const LogDetailsPanel({super.key, required this.log, this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = log.metadata ?? {};
    final levelColor = Color(log.level.color);

    // Build sections
    final sections = <DetailSection>[];

    // Log Information section
    sections.add(
      DetailSection(
        title: 'Log Information',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LogLevelChip(level: log.level),
                const SizedBox(width: AppTheme.spacingSm),
                if (log.category != null)
                  CategoryChip(category: log.category!, compact: false),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            UniversalDetailsPanel.buildKeyValueRow(
              'Timestamp',
              log.timestamp.toIso8601String(),
            ),
            UniversalDetailsPanel.buildKeyValueRow(
              'Level',
              log.level.displayName,
            ),
            if (log.category != null)
              UniversalDetailsPanel.buildKeyValueRow('Category', log.category!),
            if (log.tag != null)
              UniversalDetailsPanel.buildKeyValueRow('Tag', log.tag!),
          ],
        ),
      ),
    );

    // Message section
    sections.add(
      DetailSection(
        title: 'Message',
        content: SelectableText(log.message, style: theme.textTheme.bodyMedium),
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
    if (log.error != null) {
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
              log.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      );
    }

    // Stack trace section
    if (log.stackTrace != null) {
      sections.add(
        DetailSection(
          title: 'Stack Trace',
          content: UniversalDetailsPanel.buildCodeBlock(
            context,
            log.stackTrace!,
          ),
          collapsible: true,
          initiallyExpanded: false,
        ),
      );
    }

    return UniversalDetailsPanel(
      title: _getTitle(log),
      headerBadges: [
        LogLevelChip(level: log.level),
        if (log.category != null)
          CategoryChip(category: log.category!, compact: true),
      ],
      sections: sections,
      onClose: onClose ?? () {},
      accentColor: levelColor,
    );
  }

  String _getTitle(LogEntryModel log) {
    if (log.category != null) {
      return '${log.level.displayName} - ${log.category}';
    }
    return log.level.displayName;
  }
}
