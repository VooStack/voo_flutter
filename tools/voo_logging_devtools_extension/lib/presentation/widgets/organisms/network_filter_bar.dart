import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/network_state.dart';

class NetworkFilterBar extends StatefulWidget {
  const NetworkFilterBar({super.key});

  @override
  State<NetworkFilterBar> createState() => _NetworkFilterBarState();
}

class _NetworkFilterBarState extends State<NetworkFilterBar> {
  final _searchController = TextEditingController();
  String? _selectedMethod;
  String? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NetworkBloc, NetworkState>(
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
                  hintText: 'Search by URL...',
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
            
            // Method filter
            SizedBox(
              width: 120,
              child: DropdownButtonFormField<String>(
                value: _selectedMethod,
                decoration: InputDecoration(
                  labelText: 'Method',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'GET', child: Text('GET')),
                  DropdownMenuItem(value: 'POST', child: Text('POST')),
                  DropdownMenuItem(value: 'PUT', child: Text('PUT')),
                  DropdownMenuItem(value: 'DELETE', child: Text('DELETE')),
                  DropdownMenuItem(value: 'PATCH', child: Text('PATCH')),
                ],
                onChanged: (value) {
                  setState(() => _selectedMethod = value);
                  _onFilterChanged();
                },
              ),
            ),
            const SizedBox(width: 12),
            
            // Status filter
            SizedBox(
              width: 120,
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'success', child: Text('Success')),
                  DropdownMenuItem(value: 'error', child: Text('Error')),
                  DropdownMenuItem(value: 'redirect', child: Text('Redirect')),
                ],
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  _onFilterChanged();
                },
              ),
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
              tooltip: 'Clear network logs',
            ),
          ],
        ),
      ),
    );
  }

  void _onFilterChanged() {
    context.read<NetworkBloc>().add(FilterNetworkLogs(
      method: _selectedMethod,
      statusFilter: _selectedStatus,
      searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
    ));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedMethod = null;
      _selectedStatus = null;
    });
    _onFilterChanged();
  }

  Future<void> _clearLogs(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Network Logs'),
        content: const Text('Are you sure you want to clear all network logs?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Clear')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NetworkBloc>().add(ClearNetworkLogs());
    }
  }
}