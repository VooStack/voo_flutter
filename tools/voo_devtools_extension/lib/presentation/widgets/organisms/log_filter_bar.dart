import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_filter_bar.dart';

class LogFilterBar extends StatefulWidget {
  const LogFilterBar({super.key});

  @override
  State<LogFilterBar> createState() => _LogFilterBarState();
}

class _LogFilterBarState extends State<LogFilterBar> {
  String? _searchQuery;
  LogLevel? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) {
        return UniversalFilterBar(
          searchHint: 'Search logs... (use /pattern/ for regex)',
          searchQuery: _searchQuery ?? state.searchQuery,
          onSearchChanged: (value) {
            setState(() => _searchQuery = value);
            context.read<LogBloc>().add(SearchQueryChanged(value ?? ''));
          },
          filterOptions: [
            FilterOption(
              label: 'Verbose',
              value: 'verbose',
              color: Color(LogLevel.verbose.color),
            ),
            FilterOption(
              label: 'Debug',
              value: 'debug',
              color: Color(LogLevel.debug.color),
            ),
            FilterOption(
              label: 'Info',
              value: 'info',
              color: Color(LogLevel.info.color),
            ),
            FilterOption(
              label: 'Warning',
              value: 'warning',
              color: Color(LogLevel.warning.color),
            ),
            FilterOption(
              label: 'Error',
              value: 'error',
              color: Color(LogLevel.error.color),
            ),
            FilterOption(
              label: 'Fatal',
              value: 'fatal',
              color: Color(LogLevel.fatal.color),
            ),
          ],
          selectedFilter: _selectedLevel?.name,
          onFilterChanged: (value) {
            setState(() {
              if (value != null) {
                _selectedLevel = LogLevel.values.firstWhere(
                  (level) => level.name == value,
                  orElse: () => LogLevel.info,
                );
              } else {
                _selectedLevel = null;
              }
            });

            // Update filter
            final levels = _selectedLevel != null
                ? [_selectedLevel!]
                : LogLevel.values;
            context.read<LogBloc>().add(FilterLogsChanged(levels: levels));
          },
          additionalActions: [
            // Clear logs button
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear Logs'),
              onPressed: () {
                context.read<LogBloc>().add(ClearLogs());
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
