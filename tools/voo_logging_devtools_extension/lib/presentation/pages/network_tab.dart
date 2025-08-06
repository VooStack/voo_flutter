import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_list.dart';

class NetworkTab extends StatefulWidget {
  const NetworkTab({super.key});

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> with AutomaticKeepAliveClientMixin {
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

    return BlocConsumer<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (_showDetails && state.selectedLog == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          const NetworkFilterBar(),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: NetworkList(
                      logs: state.filteredNetworkLogs,
                      selectedLogId: state.selectedLog?.id,
                      scrollController: _scrollController,
                      isLoading: state.isLoading,
                      error: state.error,
                      onLogTap: (log) {
                        context.read<NetworkBloc>().add(SelectNetworkLog(log));
                        if (!_showDetails) {
                          setState(() => _showDetails = true);
                        }
                      },
                    ),
                  ),
                  if (_showDetails && state.selectedLog != null)
                    SizedBox(
                      width: 400,
                      child: NetworkDetailsPanel(
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