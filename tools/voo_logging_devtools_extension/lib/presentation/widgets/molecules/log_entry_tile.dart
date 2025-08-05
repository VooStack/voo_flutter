import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_logging/core/domain/extensions/log_level_extensions.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/log_level_chip.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class LogEntryTile extends StatelessWidget {
  final LogEntryModel log;
  final bool selected;
  final VoidCallback? onTap;

  const LogEntryTile({super.key, required this.log, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
          border: Border(bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LogLevelChip(level: log.level),
                const SizedBox(width: 8),
                Text(_formatTimestamp(log.timestamp), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                if (log.category != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: theme.colorScheme.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text(log.category!, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
                  ),
                ],
                if (log.tag != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: theme.colorScheme.tertiary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text(log.tag!, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () => _copyToClipboard(context),
                  tooltip: 'Copy log entry',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(log.message, style: theme.textTheme.bodyMedium, maxLines: selected ? null : 2, overflow: selected ? null : TextOverflow.ellipsis),
            if (log.error != null) ...[
              const SizedBox(height: 4),
              Text(
                'Error: ${log.error}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                maxLines: selected ? null : 1,
                overflow: selected ? null : TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final logDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (logDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}:'
          '${timestamp.second.toString().padLeft(2, '0')}.'
          '${timestamp.millisecond.toString().padLeft(3, '0')}';
    } else {
      return '${timestamp.month}/${timestamp.day} '
          '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}:'
          '${timestamp.second.toString().padLeft(2, '0')}';
    }
  }

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('Timestamp: ${log.timestamp.toIso8601String()}');
    buffer.writeln('Level: ${log.level.displayName}');
    if (log.category != null) buffer.writeln('Category: ${log.category}');
    if (log.tag != null) buffer.writeln('Tag: ${log.tag}');
    buffer.writeln('Message: ${log.message}');
    if (log.error != null) buffer.writeln('Error: ${log.error}');
    if (log.stackTrace != null) {
      buffer.writeln('Stack Trace:');
      buffer.writeln(log.stackTrace);
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log entry copied to clipboard'), duration: Duration(seconds: 2)));
  }
}
