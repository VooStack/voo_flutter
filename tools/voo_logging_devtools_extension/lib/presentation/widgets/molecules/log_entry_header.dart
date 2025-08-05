import 'package:flutter/material.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/category_badge.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/log_level_chip.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/timestamp_text.dart';
import 'package:voo_logging/features/logging/domain/entities/log_entry.dart';

/// Molecule widget that combines log entry metadata
class LogEntryHeader extends StatelessWidget {
  final LogEntry log;
  final bool showTimestamp;
  final bool showCategory;
  final bool showTag;
  final VoidCallback? onLevelTap;

  const LogEntryHeader({super.key, required this.log, this.showTimestamp = true, this.showCategory = true, this.showTag = true, this.onLevelTap});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      LogLevelChip(level: log.level, onTap: onLevelTap),
      if (showTimestamp) ...[const SizedBox(width: 8), TimestampText(timestamp: log.timestamp)],
      if (showCategory && log.category != null) ...[const SizedBox(width: 8), CategoryBadge(category: log.category!)],
      if (showTag && log.tag != null) ...[const SizedBox(width: 8), CategoryBadge(category: log.tag!, color: Theme.of(context).colorScheme.secondary)],
    ],
  );
}
