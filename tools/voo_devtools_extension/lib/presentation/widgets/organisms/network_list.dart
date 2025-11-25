import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/enhanced_empty_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/network_request_tile.dart';

class NetworkList extends StatelessWidget {
  // Support both old and new interfaces
  final List<LogEntryModel>? logs;
  final List<NetworkRequestModel>? requests;
  final String? selectedLogId;
  final String? selectedRequestId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onRetry;
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
    this.hasActiveFilters = false,
    this.onClearFilters,
    this.onRetry,
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
      return const EnhancedEmptyState(type: EmptyStateType.connecting);
    }

    if (error != null) {
      return EnhancedEmptyState.error(
        message: 'Error loading network data: $error',
        onRetry: onRetry,
      );
    }

    // Handle new request-based interface
    if (requests != null && onRequestTap != null) {
      if (requests!.isEmpty) {
        if (hasActiveFilters) {
          return EnhancedEmptyState.filteredEmpty(
            title: 'No Matching Requests',
            message: 'No network requests match your current filters.',
            onClearFilters: onClearFilters,
          );
        }
        return EnhancedEmptyState.noData(
          title: 'No Network Requests',
          message: 'Network requests will appear here as your app makes HTTP calls.',
          icon: Icons.wifi_outlined,
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
        if (hasActiveFilters) {
          return EnhancedEmptyState.filteredEmpty(
            title: 'No Matching Requests',
            message: 'No network requests match your current filters.',
            onClearFilters: onClearFilters,
          );
        }
        return EnhancedEmptyState.noData(
          title: 'No Network Requests',
          message: 'Network requests will appear here as your app makes HTTP calls.',
          icon: Icons.wifi_outlined,
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

    return EnhancedEmptyState.noData(
      title: 'No Network Requests',
      message: 'Network requests will appear here as your app makes HTTP calls.',
      icon: Icons.wifi_outlined,
    );
  }
}
