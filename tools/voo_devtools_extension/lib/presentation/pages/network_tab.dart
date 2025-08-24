import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';
import 'package:voo_ui/voo_ui.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_list.dart';

class NetworkTab extends StatefulWidget {
  const NetworkTab({super.key});

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab>
    with AutomaticKeepAliveClientMixin {
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

    return BlocConsumer<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (_showDetails && state.selectedRequest == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          // Page header
          VooPageHeader(
            icon: Icons.wifi,
            title: 'Network',
            subtitle: 'Network request monitoring',
            iconColor: Colors.cyan,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<NetworkBloc>().add(LoadNetworkLogs());
                },
                tooltip: 'Refresh',
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
          const NetworkFilterBar(),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: NetworkList(
                      requests: state.filteredNetworkRequests,
                      selectedRequestId: state.selectedRequest?.id,
                      scrollController: _scrollController,
                      isLoading: state.isLoading,
                      error: state.error,
                      onRequestTap: (request) {
                        context.read<NetworkBloc>().add(
                          SelectNetworkRequest(request),
                        );
                        if (!_showDetails) {
                          setState(() => _showDetails = true);
                        }
                      },
                    ),
                  ),
                  if (_showDetails && state.selectedRequest != null) ...[
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
                      child: NetworkDetailsPanel(
                        request: state.selectedRequest!,
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
