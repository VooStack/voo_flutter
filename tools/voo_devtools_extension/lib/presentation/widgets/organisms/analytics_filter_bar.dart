import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/universal_filter_bar.dart';

class AnalyticsFilterBar extends StatelessWidget {
  const AnalyticsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return UniversalFilterBar(
          searchHint: 'Search analytics events...',
          searchQuery: state.searchQuery,
          onSearchChanged: (value) {
            context.read<AnalyticsBloc>().add(
              SearchAnalyticsEvents(value ?? ''),
            );
          },
          showFilters:
              false, // Disable filters for now since state doesn't support it
          filterOptions: const [],
          selectedFilter: null,
          onFilterChanged: (value) {
            // Not implemented yet
          },
          additionalActions: [
            // Clear analytics events button
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear Events'),
              onPressed: () {
                context.read<AnalyticsBloc>().add(ClearAnalyticsEvents());
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          onClear: null, // Don't show the universal clear button
        );
      },
    );
  }
}
