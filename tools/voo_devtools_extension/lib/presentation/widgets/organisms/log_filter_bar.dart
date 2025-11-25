import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/date_range_filter.dart';
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
            // Date range filter
            DateRangeFilter(
              selectedRange: state.dateRange,
              onRangeChanged: (range) {
                context.read<LogBloc>().add(DateRangeChanged(range));
              },
            ),
            const SizedBox(width: 8),
            // Favorites filter toggle
            _FavoritesFilterButton(
              showFavoritesOnly: state.showFavoritesOnly,
              favoriteCount: state.favoriteCount,
              onToggle: () {
                context.read<LogBloc>().add(ToggleShowFavoritesOnly());
              },
            ),
            const SizedBox(width: 8),
            // Clear all filters button (only show if filters are active)
            if (state.hasActiveFilters)
              TextButton.icon(
                icon: const Icon(Icons.filter_alt_off, size: 18),
                label: const Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    _searchQuery = null;
                    _selectedLevel = null;
                  });
                  context.read<LogBloc>().add(ClearAllFilters());
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
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

/// A button to toggle showing only favorites
class _FavoritesFilterButton extends StatelessWidget {
  final bool showFavoritesOnly;
  final int favoriteCount;
  final VoidCallback onToggle;

  const _FavoritesFilterButton({
    required this.showFavoritesOnly,
    required this.favoriteCount,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = showFavoritesOnly;
    final hasItems = favoriteCount > 0;

    return Tooltip(
      message: isActive
          ? 'Show all logs'
          : hasItems
              ? 'Show only favorites ($favoriteCount)'
              : 'No favorites yet',
      child: InkWell(
        onTap: hasItems || isActive ? onToggle : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.amber.withValues(alpha: 0.2)
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? Colors.amber.withValues(alpha: 0.5)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.star : Icons.star_outline,
                size: 16,
                color: isActive
                    ? Colors.amber
                    : hasItems
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              if (favoriteCount > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '$favoriteCount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive
                        ? Colors.amber
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
