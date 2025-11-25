import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/enhanced_empty_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/log_entry_tile.dart';

class LogsList extends StatelessWidget {
  final List<LogEntryModel> logs;
  final String? selectedLogId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onRetry;
  final Function(LogEntryModel) onLogTap;

  const LogsList({
    super.key,
    required this.logs,
    this.selectedLogId,
    required this.scrollController,
    required this.isLoading,
    this.error,
    this.hasActiveFilters = false,
    this.onClearFilters,
    this.onRetry,
    required this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const EnhancedEmptyState(type: EmptyStateType.connecting);
    }

    if (error != null) {
      return EnhancedEmptyState.error(
        message: error,
        onRetry: onRetry,
      );
    }

    if (logs.isEmpty) {
      if (hasActiveFilters) {
        return EnhancedEmptyState.filteredEmpty(
          title: 'No Matching Logs',
          message: 'No logs match your current filters. Try adjusting your search criteria.',
          onClearFilters: onClearFilters,
        );
      }
      return EnhancedEmptyState.noData(
        title: 'No Logs Yet',
        message: 'Logs will appear here in real-time as your app generates them.',
        icon: Icons.article_outlined,
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isSelected = selectedLogId == log.id;

        return LogEntryTile(
          log: log,
          selected: isSelected,
          onTap: () => onLogTap(log),
        );
      },
    );
  }
}
