import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_list.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/heat_map_visualization.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  bool _showDetails = false;
  bool _showHeatMap = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return BlocConsumer<AnalyticsBloc, AnalyticsState>(
      listener: (context, state) {
        if (_showDetails && state.selectedEvent == null) {
          setState(() => _showDetails = false);
        }
      },
      builder: (context, state) => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(child: const AnalyticsFilterBar()),
                const SizedBox(width: 8),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Events'), icon: Icon(Icons.list)),
                    ButtonSegment(value: true, label: Text('Heat Map'), icon: Icon(Icons.grid_on)),
                  ],
                  selected: {_showHeatMap},
                  onSelectionChanged: (value) {
                    setState(() => _showHeatMap = value.first);
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: theme.colorScheme.surface,
              child: _showHeatMap
                  ? _buildHeatMapView(state)
                  : Row(
                      children: [
                        Expanded(
                          child: AnalyticsList(
                            events: state.filteredEvents,
                            selectedEventId: state.selectedEvent?.id,
                            scrollController: _scrollController,
                            isLoading: state.isLoading,
                            error: state.error,
                            onEventTap: (event) {
                              context.read<AnalyticsBloc>().add(SelectAnalyticsEvent(event));
                              if (!_showDetails) {
                                setState(() => _showDetails = true);
                              }
                            },
                          ),
                        ),
                        if (_showDetails && state.selectedEvent != null)
                          SizedBox(
                            width: 400,
                            child: AnalyticsDetailsPanel(event: state.selectedEvent!, onClose: () => setState(() => _showDetails = false)),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMapView(AnalyticsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}', style: Theme.of(context).textTheme.bodyLarge));
    }

    final heatMapPoints = _extractHeatMapPoints(state.filteredEvents);

    if (heatMapPoints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No touch events recorded', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Touch events will appear here as they are tracked',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: HeatMapVisualization(points: heatMapPoints, screenName: _getCurrentScreen(state.filteredEvents), showGrid: true, gridSize: 20),
    );
  }

  List<HeatMapPoint> _extractHeatMapPoints(List<dynamic> events) {
    final points = <HeatMapPoint>[];

    for (final event in events) {
      if (event is Map<String, dynamic>) {
        final metadata = event['metadata'] as Map<String, dynamic>?;
        if (metadata != null && metadata['type'] == 'touch_event') {
          final x = metadata['x'] as double?;
          final y = metadata['y'] as double?;
          if (x != null && y != null) {
            points.add(
              HeatMapPoint(
                x: x / 1000,
                y: y / 1000,
                intensity: 0.5,
                screenName: metadata['screen'] as String?,
                timestamp: DateTime.tryParse(event['timestamp'] ?? '') ?? DateTime.now(),
              ),
            );
          }
        }
      }
    }

    return points;
  }

  String? _getCurrentScreen(List<dynamic> events) {
    if (events.isEmpty) return null;

    for (final event in events) {
      if (event is Map<String, dynamic>) {
        final metadata = event['metadata'] as Map<String, dynamic>?;
        if (metadata != null && metadata['screen'] != null) {
          return metadata['screen'] as String;
        }
      }
    }

    return null;
  }
}
