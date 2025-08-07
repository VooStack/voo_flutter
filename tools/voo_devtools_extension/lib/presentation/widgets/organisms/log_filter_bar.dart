import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/log_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/dropdown_field.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/level_filters_widget.dart';

class LogFilterBar extends StatefulWidget {
  const LogFilterBar({super.key});

  @override
  State<LogFilterBar> createState() => _LogFilterBarState();
}

class _LogFilterBarState extends State<LogFilterBar> {
  final _searchController = TextEditingController();
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<LogBloc>().state;
    _searchController.text = state.searchQuery;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<LogBloc>().add(SearchQueryChanged(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search logs... (use /pattern/ for regex)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  icon: Icon(_showAdvancedFilters ? Icons.filter_list_off : Icons.filter_list),
                  label: Text(_showAdvancedFilters ? 'Hide Filters' : 'Show Filters'),
                  onPressed: () {
                    setState(() {
                      _showAdvancedFilters = !_showAdvancedFilters;
                    });
                  },
                ),
              ],
            ),
            if (_showAdvancedFilters) ...[
              const SizedBox(height: 12),
              LevelFiltersWidget(
                selectedLevels: state.selectedLevels ?? [],
                onLevelToggled: (level) {
                  final selectedLevels = state.selectedLevels ?? [];
                  final newLevels = List<LogLevel>.from(selectedLevels);
                  if (selectedLevels.contains(level)) {
                    newLevels.remove(level);
                  } else {
                    newLevels.add(level);
                  }
                  context.read<LogBloc>().add(FilterLogsChanged(levels: newLevels.isEmpty ? null : newLevels, category: state.selectedCategory));
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownField(
                      label: 'Category',
                      value: state.selectedCategory,
                      items: state.categories,
                      onChanged: (value) {
                        context.read<LogBloc>().add(FilterLogsChanged(levels: state.selectedLevels, category: value));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
