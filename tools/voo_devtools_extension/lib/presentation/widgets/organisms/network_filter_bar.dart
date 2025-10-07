import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_bloc.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_event.dart';
import 'package:voo_devtools_extension/presentation/blocs/network_state.dart';
import 'package:voo_devtools_extension/presentation/widgets/organisms/universal_filter_bar.dart';

class NetworkFilterBar extends StatefulWidget {
  const NetworkFilterBar({super.key});

  @override
  State<NetworkFilterBar> createState() => _NetworkFilterBarState();
}

class _NetworkFilterBarState extends State<NetworkFilterBar> {
  String? _searchQuery;
  String? _selectedMethod;
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return Column(
          children: [
            UniversalFilterBar(
              searchHint: 'Search by URL...',
              searchQuery: _searchQuery,
              onSearchChanged: (value) {
                setState(() => _searchQuery = value);
                _onFilterChanged();
              },
              filterOptions: const [
                FilterOption(
                  label: 'GET',
                  value: 'GET',
                  icon: Icons.download,
                  color: Colors.green,
                ),
                FilterOption(
                  label: 'POST',
                  value: 'POST',
                  icon: Icons.upload,
                  color: Colors.blue,
                ),
                FilterOption(
                  label: 'PUT',
                  value: 'PUT',
                  icon: Icons.edit,
                  color: Colors.orange,
                ),
                FilterOption(
                  label: 'DELETE',
                  value: 'DELETE',
                  icon: Icons.delete,
                  color: Colors.red,
                ),
                FilterOption(label: '2xx', value: '2xx', color: Colors.green),
                FilterOption(label: '3xx', value: '3xx', color: Colors.blue),
                FilterOption(label: '4xx', value: '4xx', color: Colors.orange),
                FilterOption(label: '5xx', value: '5xx', color: Colors.red),
              ],
              selectedFilter: _selectedMethod ?? _selectedStatus,
              onFilterChanged: (value) {
                setState(() {
                  // Check if it's a method or status
                  if (['GET', 'POST', 'PUT', 'DELETE'].contains(value)) {
                    _selectedMethod = value;
                    _selectedStatus = null;
                  } else if (['2xx', '3xx', '4xx', '5xx'].contains(value)) {
                    _selectedStatus = value;
                    _selectedMethod = null;
                  } else {
                    _selectedMethod = null;
                    _selectedStatus = null;
                  }
                });
                _onFilterChanged();
              },
              additionalActions: [
                // Clear network logs button
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Clear Logs'),
                  onPressed: () {
                    context.read<NetworkBloc>().add(ClearNetworkLogs());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              onClear: null, // Don't show the universal clear button
            ),
          ],
        );
      },
    );
  }

  void _onFilterChanged() {
    context.read<NetworkBloc>().add(
      FilterNetworkLogs(
        method: _selectedMethod,
        statusFilter: _selectedStatus,
        searchQuery: _searchQuery,
      ),
    );
  }
}
