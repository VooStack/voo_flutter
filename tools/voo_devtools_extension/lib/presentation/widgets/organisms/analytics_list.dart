import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_ui/voo_ui.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/error_placeholder.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/molecules/analytics_list_tile.dart';

class AnalyticsList extends StatelessWidget {
  final List<LogEntryModel> events;
  final String? selectedEventId;
  final ScrollController scrollController;
  final bool isLoading;
  final String? error;
  final Function(LogEntryModel) onEventTap;

  const AnalyticsList({
    super.key,
    required this.events,
    this.selectedEventId,
    required this.scrollController,
    required this.isLoading,
    this.error,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return ErrorPlaceholder(error: error!);
    }

    if (events.isEmpty) {
      return const VooEmptyState(
        icon: Icons.analytics_outlined,
        title: 'No Analytics Events',
        message: 'Analytics events will appear here as they are tracked',
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
