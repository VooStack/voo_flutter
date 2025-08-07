import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/performance_state.dart';

class PerformanceFilterBar extends StatefulWidget {
  const PerformanceFilterBar({super.key});

  @override
  State<PerformanceFilterBar> createState() => _PerformanceFilterBarState();
}

class _PerformanceFilterBarState extends State<PerformanceFilterBar> {
  final _searchController = TextEditingController();
  String? _selectedOperationType;
  bool _showSlowOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            // Search field
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search operations...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onFilterChanged();
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (_) => _onFilterChanged(),
              ),
            ),
            const SizedBox(width: 12),
            
            // Slow only toggle
            FilterChip(
              label: const Text('Slow Only (>1s)'),
              selected: _showSlowOnly,
              onSelected: (value) {
                setState(() => _showSlowOnly = value);
                _onFilterChanged();
              },
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 12),
            
            // Clear filters button
            IconButton(
              icon: const Icon(Icons.clear_all, size: 20),
              onPressed: _clearFilters,
              tooltip: 'Clear all filters',
            ),
            
            // Clear logs button
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _clearLogs(context),
              tooltip: 'Clear performance logs',
            ),
          ],
        ),
      ),
    );
  }

  void _onFilterChanged() {
    context.read<PerformanceBloc>().add(FilterPerformanceLogs(
      operationType: _selectedOperationType,
      showSlowOnly: _showSlowOnly,
      searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
    ));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedOperationType = null;
      _showSlowOnly = false;
    });
    _onFilterChanged();
  }

  Future<void> _clearLogs(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Performance Logs'),
        content: const Text('Are you sure you want to clear all performance logs?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Clear')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<PerformanceBloc>().add(ClearPerformanceLogs());
    }
  }
}