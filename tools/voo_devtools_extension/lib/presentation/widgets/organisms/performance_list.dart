import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/enhanced_empty_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/performance_list_tile.dart';

class PerformanceList extends StatelessWidget {
  final List<LogEntryModel> logs;
  final String? selectedLogId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onRetry;
  final Function(LogEntryModel) onLogTap;

  const PerformanceList({
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
        message: 'Error loading performance logs: $error',
        onRetry: onRetry,
      );
    }

    if (logs.isEmpty) {
      if (hasActiveFilters) {
        return EnhancedEmptyState.filteredEmpty(
          title: 'No Matching Metrics',
          message: 'No performance metrics match your current filters.',
          onClearFilters: onClearFilters,
        );
      }
      return EnhancedEmptyState.noData(
        title: 'No Performance Metrics',
        message: 'Performance metrics will appear here as operations are tracked.',
        icon: Icons.speed_outlined,
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isSelected = selectedLogId == log.id;

        return PerformanceListTile(
          log: log,
          isSelected: isSelected,
          onTap: () => onLogTap(log),
        );
      },
    );
  }
}
