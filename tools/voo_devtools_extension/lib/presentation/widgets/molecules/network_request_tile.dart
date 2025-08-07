import 'package:flutter/material.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/network_method_chip.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/network_status_badge.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/timestamp_text.dart';

class NetworkRequestTile extends StatelessWidget {
  final LogEntryModel log;
  final bool selected;
  final VoidCallback onTap;

  const NetworkRequestTile({
    super.key,
    required this.log,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = log.metadata ?? {};
    final method = metadata['method'] as String? ?? 'GET';
    final url = metadata['url'] as String? ?? log.message;
    final statusCode = metadata['statusCode'] as int?;
    final duration = metadata['duration'] as int?;
    final responseSize = metadata['contentLength'] as int?;

    return Material(
      color: selected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
              left: BorderSide(
                color: selected ? theme.colorScheme.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              NetworkMethodChip(method: method),
              const SizedBox(width: 12),
              if (statusCode != null) ...[
                NetworkStatusBadge(statusCode: statusCode),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _truncateUrl(url),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        TimestampText(timestamp: log.timestamp),
                        if (duration != null) ...[
                          const SizedBox(width: 16),
                          Text(
                            '${duration}ms',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: duration > 1000 ? Colors.orange : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                        if (responseSize != null && responseSize > 0) ...[
                          const SizedBox(width: 16),
                          Text(
                            _formatBytes(responseSize),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _truncateUrl(String url) {
    if (url.length > 80) {
      return '${url.substring(0, 80)}...';
    }
    return url;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}