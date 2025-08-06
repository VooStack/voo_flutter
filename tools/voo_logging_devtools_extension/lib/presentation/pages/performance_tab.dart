import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/performance_averages_card.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/performance_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/performance_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/performance_list.dart';

class PerformanceTab extends StatefulWidget {
  const PerformanceTab({super.key});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  bool _showDetails = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            PerformanceAveragesCard(averageDurations: state.averageDurations),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: PerformanceList(
                      logs: state.filteredPerformanceLogs,
                      selectedLogId: state.selectedLog?.id,
                      scrollController: _scrollController,
                      isLoading: state.isLoading,
                      error: state.error,
                      onLogTap: (log) {
                        context.read<PerformanceBloc>().add(SelectPerformanceLog(log));
                        if (!_showDetails) {
                          setState(() => _showDetails = true);
                        }
                      },
                    ),
                  ),
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
}