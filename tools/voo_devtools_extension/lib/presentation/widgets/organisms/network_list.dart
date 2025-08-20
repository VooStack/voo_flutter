import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_logging_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/network_request_tile.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/empty_state_widget.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/error_placeholder.dart';

class NetworkList extends StatelessWidget {
  // Support both old and new interfaces
  final List<LogEntryModel>? logs;
  final List<NetworkRequestModel>? requests;
  final String? selectedLogId;
  final String? selectedRequestId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final Function(LogEntryModel)? onLogTap;
  final Function(NetworkRequestModel)? onRequestTap;

  const NetworkList({
    super.key,
    this.logs,
    this.requests,
    this.selectedLogId,
    this.selectedRequestId,
    required this.scrollController,
    required this.isLoading,
    this.error,
    this.onLogTap,
    this.onRequestTap,
  }) : assert(
         (logs != null && onLogTap != null) ||
             (requests != null && onRequestTap != null),
         'Either logs/onLogTap or requests/onRequestTap must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return ErrorPlaceholder(error: 'Error loading network data\n$error');
    }

    // Handle new request-based interface
    if (requests != null && onRequestTap != null) {
      if (requests!.isEmpty) {
        return const EmptyStateWidget(
          icon: Icons.wifi_off_outlined,
          title: 'No Network Requests',
          message: 'Network requests will appear here when made',
        );
      }

      return Container(
        color: theme.colorScheme.surface,
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: requests!.length,
          itemBuilder: (context, index) {
            final request = requests![index];
            final isSelected = selectedRequestId == request.id;

            return NetworkRequestTile(
              request: request,
              selected: isSelected,
              onTap: () => onRequestTap!(request),
            );
          },
        ),
      );
    }

    // Handle legacy log-based interface
    if (logs != null && onLogTap != null) {
      if (logs!.isEmpty) {
        return const EmptyStateWidget(
          icon: Icons.wifi_off_outlined,
          title: 'No Network Requests',
          message: 'Network requests will appear here when made',
        );
      }

      return ListView.builder(
        controller: scrollController,
        itemCount: logs!.length,
        itemBuilder: (context, index) {
          final log = logs![index];
          final isSelected = selectedLogId == log.id;

          // Convert log to request for the tile
          final request = NetworkRequestModel.fromLogEntry(log);

          return NetworkRequestTile(
            request: request,
            selected: isSelected,
            onTap: () => onLogTap!(log),
          );
        },
      );
    }

    return const EmptyStateWidget(
      icon: Icons.wifi_off_outlined,
      title: 'No Network Requests',
      message: 'Network requests will appear here when made',
    );
  }
}
