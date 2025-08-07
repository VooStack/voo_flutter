import 'package:flutter/material.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/features/logging/domain/entities/log_statistics.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/log_level_row.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/stat_item.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/stat_row.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/stat_card.dart';

class LogStatisticsCard extends StatelessWidget {
  final LogStatistics statistics;

  const LogStatisticsCard({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummary(theme),
        const SizedBox(height: 16),
        _buildLevelBreakdown(theme),
        if (statistics.categoryCounts.isNotEmpty) ...[const SizedBox(height: 16), _buildTopCategories(theme)],
        if (statistics.tagCounts.isNotEmpty) ...[const SizedBox(height: 16), _buildTopTags(theme)],
      ],
    );
  }

  Widget _buildSummary(ThemeData theme) {
    final duration = statistics.newestLog != null && statistics.oldestLog != null ? statistics.newestLog!.difference(statistics.oldestLog!) : null;

    return StatCard(
      title: 'Summary',
      children: [
        StatItem(label: 'Total Logs', value: statistics.totalLogs.toString()),
        if (duration != null) StatItem(label: 'Duration', value: _formatDuration(duration)),
        if (statistics.oldestLog != null) StatItem(label: 'First Log', value: _formatDateTime(statistics.oldestLog!)),
        if (statistics.newestLog != null) StatItem(label: 'Last Log', value: _formatDateTime(statistics.newestLog!)),
      ],
    );
  }

  Widget _buildLevelBreakdown(ThemeData theme) => StatCard(
    title: 'Log Levels',
    children: LogLevel.values
        .map((level) {
          final count = statistics.levelCounts[level.name] ?? 0;
          if (count == 0) return null;
          return LogLevelRow(level: level, count: count);
        })
        .where((widget) => widget != null)
        .cast<Widget>()
        .toList(),
  );

  Widget _buildTopCategories(ThemeData theme) {
    final sortedCategories = statistics.categoryCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return StatCard(
      title: 'Top Categories',
      children: sortedCategories.take(5).map((entry) => StatRow(label: entry.key, value: entry.value.toString())).toList(),
    );
  }

  Widget _buildTopTags(ThemeData theme) {
    final sortedTags = statistics.tagCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return StatCard(
      title: 'Top Tags',
      children: sortedTags.take(5).map((entry) => StatRow(label: entry.key, value: entry.value.toString())).toList(),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  String _formatDateTime(DateTime dateTime) =>
      '${dateTime.month}/${dateTime.day} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}
