import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/performance_list_tile.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/empty_state_widget.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/error_placeholder.dart';

class PerformanceList extends StatelessWidget {
  final List<LogEntryModel> logs;
  final String? selectedLogId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final Function(LogEntryModel) onLogTap;

  const PerformanceList({
    super.key,
    required this.logs,
    this.selectedLogId,
    required this.scrollController,
    required this.isLoading,
    this.error,
    required this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return ErrorPlaceholder(error: 'Error loading performance logs\n$error');
    }

    if (logs.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.speed_outlined,
        title: 'No Performance Metrics',
        message: 'Performance metrics will appear here when tracked',
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
