import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/network_request_tile.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/network_filter_bar.dart';

class NetworkTab extends StatefulWidget {
  const NetworkTab({super.key});

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> {
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
                  Expanded(child: _buildNetworkList(state)),
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

  Widget _buildNetworkList(NetworkState state) {
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
            Text('Error loading network logs', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(state.error!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    }

    final logs = state.filteredNetworkLogs;

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No network requests',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Network requests will appear here when logged',
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

        return NetworkRequestTile(
          log: log,
          selected: isSelected,
          onTap: () {
            context.read<NetworkBloc>().add(SelectNetworkLog(log));
            if (!_showDetails) {
              setState(() => _showDetails = true);
            }
          },
        );
      },
    );
  }
}