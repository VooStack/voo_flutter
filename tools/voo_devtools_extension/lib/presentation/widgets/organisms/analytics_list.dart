import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/analytics_list_tile.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/enhanced_empty_state.dart';

class AnalyticsList extends StatelessWidget {
  final List<LogEntryModel> events;
  final String? selectedEventId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onRetry;
  final Function(LogEntryModel) onEventTap;

  const AnalyticsList({
    super.key,
    required this.events,
    this.selectedEventId,
    required this.scrollController,
    required this.isLoading,
    this.error,
    this.hasActiveFilters = false,
    this.onClearFilters,
    this.onRetry,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const EnhancedEmptyState(type: EmptyStateType.connecting);
    }

    if (error != null) {
      return EnhancedEmptyState.error(
        message: error,
        onRetry: onRetry,
      );
    }

    if (events.isEmpty) {
      if (hasActiveFilters) {
        return EnhancedEmptyState.filteredEmpty(
          title: 'No Matching Events',
          message: 'No analytics events match your current filters.',
          onClearFilters: onClearFilters,
        );
      }
      return EnhancedEmptyState.noData(
        title: 'No Analytics Events',
        message: 'Analytics events will appear here as user interactions are tracked.',
        icon: Icons.analytics_outlined,
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isSelected = event.id == selectedEventId;

        return AnalyticsListTile(
          event: event,
          isSelected: isSelected,
          onTap: () => onEventTap(event),
        );
      },
    );
  }
}
