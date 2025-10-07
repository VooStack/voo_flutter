import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/log_details_panel.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/log_filter_bar.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/logs_list.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> with AutomaticKeepAliveClientMixin {
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

    return BlocConsumer<LogBloc, LogState>(
      listener: (context, state) {
        if (state.autoScroll && _scrollController.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }

        if (_showDetails && state.selectedLog == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          // Page header
          VooPageHeader(
            icon: Icons.list_alt,
            title: 'Logging',
            subtitle: 'Application logs and debugging',
            iconColor: Colors.blue,
            actions: [
              IconButton(
                icon: Icon(state.autoScroll ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  context.read<LogBloc>().add(ToggleAutoScroll());
                },
                tooltip: state.autoScroll
                    ? 'Pause auto-scroll'
                    : 'Resume auto-scroll',
              ),
              IconButton(
                icon: const Icon(Icons.download_outlined),
                onPressed: () {
                  // Export functionality
                },
                tooltip: 'Export',
              ),
            ],
          ),
          // Filter bar
          const LogFilterBar(),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: LogsList(
                      logs: state.filteredLogs,
                      selectedLogId: state.selectedLog?.id,
                      scrollController: _scrollController,
                      isLoading: state.isLoading,
                      error: state.error,
                      onLogTap: (log) {
                        context.read<LogBloc>().add(SelectLog(log));
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
                            _detailsPanelWidth =
                                (_detailsPanelWidth - details.delta.dx).clamp(
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
                      child: LogDetailsPanel(
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
