import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/log_export_dialog.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/log_rate_indicator.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/log_statistics_card.dart';

class LoggerToolbar extends StatelessWidget {
  const LoggerToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.logo_dev_sharp,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voo Logger', style: theme.textTheme.headlineSmall),
                Text(
                  '${state.statistics?.totalLogs ?? state.logs.length} logs captured',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            const LogRateIndicator(),
            const SizedBox(width: 16),
            _ToolbarActions(),
          ],
        ),
      ),
    );
  }
}

class _ToolbarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<LogBloc>().state;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            state.autoScroll ? Icons.pause : Icons.play_arrow,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            context.read<LogBloc>().add(ToggleAutoScroll());
          },
          tooltip: state.autoScroll
              ? 'Pause auto-scroll'
              : 'Resume auto-scroll',
        ),
        IconButton(
          icon: const Icon(Icons.clear_all, size: 20),
          onPressed: () => _clearLogs(context),
          tooltip: 'Clear logs',
        ),
        IconButton(
          icon: const Icon(Icons.download, size: 20),
          onPressed: () => _exportLogs(context),
          tooltip: 'Export logs',
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart, size: 20),
          onPressed: () => _showStatistics(context, state),
          tooltip: 'Show statistics',
        ),
        IconButton(
          icon: const Icon(Icons.bug_report, size: 20),
          onPressed: () => _generateTestLog(context),
          tooltip: 'Generate test log',
        ),
      ],
    );
  }

  Future<void> _clearLogs(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Are you sure you want to clear all logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<LogBloc>().add(ClearLogs());
    }
  }

  Future<void> _exportLogs(BuildContext context) async {
    final state = context.read<LogBloc>().state;
    final logsToExport = state.filteredLogs.isNotEmpty
        ? state.filteredLogs
        : state.logs;

    if (logsToExport.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No logs to export'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => LogExportDialog(logs: logsToExport),
    );
  }

  void _showStatistics(BuildContext context, LogState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Statistics'),
        content: state.statistics != null
            ? SizedBox(
                width: 400,
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: LogStatisticsCard(statistics: state.statistics!),
                ),
              )
            : const Text('No statistics available'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _generateTestLog(BuildContext context) {
    context.read<LogBloc>().add(
      LogReceived(
        LogEntryModel(
          id: 'test_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          message: 'Test log generated from UI at ${DateTime.now()}',
          level: LogLevel.info,
          category: 'Test',
          tag: 'UITest',
          metadata: {'source': 'manual_test'},
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test log generated'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
