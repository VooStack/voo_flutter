import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/performance_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_filter_bar.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

class PerformanceFilterBar extends StatefulWidget {
  const PerformanceFilterBar({super.key});

  @override
  State<PerformanceFilterBar> createState() => _PerformanceFilterBarState();
}

class _PerformanceFilterBarState extends State<PerformanceFilterBar> {
  String? _searchQuery;
  bool _showSlowOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) => UniversalFilterBar(
        searchHint: 'Search operations...',
        searchQuery: _searchQuery,
        onSearchChanged: (value) {
          setState(() => _searchQuery = value);
          _onFilterChanged();
        },
        filterOptions: const [
          FilterOption(
            label: 'Slow (>1s)',
            value: 'slow',
            icon: Icons.speed,
            color: Colors.orange,
          ),
          FilterOption(
            label: 'Network',
            value: 'network',
            icon: Icons.wifi,
            color: Colors.blue,
          ),
          FilterOption(
            label: 'Custom',
            value: 'custom',
            icon: Icons.timer,
            color: Colors.green,
          ),
        ],
        selectedFilter: _showSlowOnly ? 'slow' : null,
        onFilterChanged: (value) {
          setState(() => _showSlowOnly = value == 'slow');
          _onFilterChanged();
        },
        additionalActions: [
          // Clear performance logs button
          TextButton.icon(
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Clear Logs'),
            onPressed: () => _clearLogs(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        onClear: null, // Don't show the universal clear button
      ),
    );
  }

  void _onFilterChanged() {
    context.read<PerformanceBloc>().add(
      FilterPerformanceLogs(
        operationType: null,
        showSlowOnly: _showSlowOnly,
        searchQuery: _searchQuery,
      ),
    );
  }

  Future<void> _clearLogs(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text('Clear Performance Logs'),
        content: const Text(
          'Are you sure you want to clear all performance logs?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<PerformanceBloc>().add(ClearPerformanceLogs());
    }
  }
}
