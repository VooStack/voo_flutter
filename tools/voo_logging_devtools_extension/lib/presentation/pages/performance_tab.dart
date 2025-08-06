import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/performance_metric_tile.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/performance_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/performance_filter_bar.dart';

class PerformanceTab extends StatefulWidget {
  const PerformanceTab({super.key});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> {
  final _scrollController = ScrollController();
  bool _showDetails = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PerformanceBloc, PerformanceState>(
      listener: (context, state) {
        if (_showDetails && state.selectedLog == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          const PerformanceFilterBar(),
          if (state.averageDurations.isNotEmpty)
            _buildAveragesCard(theme, state),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(child: _buildPerformanceList(state)),
                  if (_showDetails && state.selectedLog != null)
                    SizedBox(
                      width: 400,
                      child: PerformanceDetailsPanel(
                        log: state.selectedLog!,
                        onClose: () => setState(() => _showDetails = false),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAveragesCard(ThemeData theme, PerformanceState state) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Average Durations', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: state.averageDurations.entries.map((entry) {
              final avgMs = entry.value.round();
              final color = _getDurationColor(avgMs);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.key}: ${avgMs}ms',
                    style: theme.textTheme.bodySmall?.copyWith(color: color),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceList(PerformanceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading performance logs', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(state.error!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    final logs = state.filteredPerformanceLogs;

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.speed, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No performance metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Performance metrics will appear here when tracked',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isSelected = state.selectedLog?.id == log.id;

        return PerformanceMetricTile(
          log: log,
          selected: isSelected,
          onTap: () {
            context.read<PerformanceBloc>().add(SelectPerformanceLog(log));
            if (!_showDetails) {
              setState(() => _showDetails = true);
            }
          },
        );
      },
    );
  }

  Color _getDurationColor(int ms) {
    if (ms < 100) {
      return Colors.green;
    } else if (ms < 500) {
      return Colors.lightGreen;
    } else if (ms < 1000) {
      return Colors.orange;
    } else if (ms < 3000) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }
}