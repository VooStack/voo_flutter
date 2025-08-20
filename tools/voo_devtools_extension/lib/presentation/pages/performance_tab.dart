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
  double _detailsPanelWidth = 400.0;
  final double _minDetailsPanelWidth = 300.0;
  final double _maxDetailsPanelWidth = 600.0;

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
                  if (_showDetails && state.selectedLog != null) ...[
                    // Resizable divider
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _detailsPanelWidth = (_detailsPanelWidth - details.delta.dx).clamp(
                              _minDetailsPanelWidth,
                              _maxDetailsPanelWidth,
                            );
                          });
                        },
                        child: Container(
                          width: 4,
                          color: Colors.transparent,
                          child: Center(
                            child: Container(
                              width: 1,
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Details panel
                    SizedBox(
                      width: _detailsPanelWidth,
                      child: PerformanceDetailsPanel(
                        log: state.selectedLog!,
                        onClose: () => setState(() => _showDetails = false),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}