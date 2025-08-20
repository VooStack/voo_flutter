import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/log_entry_tile.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/empty_logs_placeholder.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/error_placeholder.dart';

class LogsList extends StatelessWidget {
  final List<LogEntryModel> logs;
  final String? selectedLogId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final Function(LogEntryModel) onLogTap;

  const LogsList({
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
      return ErrorPlaceholder(error: error!);
    }

    if (logs.isEmpty) {
      return const EmptyLogsPlaceholder();
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