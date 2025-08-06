import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/log_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/log_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/logs_list.dart';

class LogsTab extends StatefulWidget {
  const LogsTab({super.key});

  @override
  State<LogsTab> createState() => _LogsTabState();
}

class _LogsTabState extends State<LogsTab> with AutomaticKeepAliveClientMixin {
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

    return BlocConsumer<LogBloc, LogState>(
      listener: (context, state) {
        if (state.autoScroll && _scrollController.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            }
          });
        }

        if (_showDetails && state.selectedLog == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
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
                  if (_showDetails && state.selectedLog != null)
                    SizedBox(
                      width: 400,
                      child: LogDetailsPanel(log: state.selectedLog!, onClose: () => setState(() => _showDetails = false)),
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
