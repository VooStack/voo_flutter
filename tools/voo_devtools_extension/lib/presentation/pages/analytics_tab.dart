import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_bloc.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_event.dart';
import 'package:voo_logging_devtools_extension/presentation/blocs/analytics_state.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/page_header.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_filter_bar.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_list.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/analytics_details_panel.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/enhanced_heat_map.dart';
import 'package:voo_logging_devtools_extension/presentation/theme/app_theme.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  bool _showDetails = false;
  bool _showHeatMap = false;
  double _detailsPanelWidth = 400.0;
  final double _minDetailsPanelWidth = 300.0;
  final double _maxDetailsPanelWidth = 600.0;

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
          // Page header
          PageHeader(
            icon: Icons.analytics_outlined,
            title: 'Analytics',
            subtitle: 'User interaction tracking',
            iconColor: Colors.indigo,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<AnalyticsBloc>().add(LoadAnalyticsEvents());
                },
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.download_outlined),
                onPressed: () {
                  // Export functionality
                },
                tooltip: 'Export',
              ),
            ],
          ),
          // Filter bar with view toggle
          Container(
            decoration: BoxDecoration(color: theme.colorScheme.surface),
            child: Column(
              children: [
                const AnalyticsFilterBar(),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLg,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View:',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: false,
                            label: Text('Events'),
                            icon: Icon(Icons.list, size: 18),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text('Heat Map'),
                            icon: Icon(Icons.grid_on, size: 18),
                          ),
                        ],
                        selected: {_showHeatMap},
                        onSelectionChanged: (value) {
                          setState(() => _showHeatMap = value.first);
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                ),
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
                              context.read<AnalyticsBloc>().add(
                                SelectAnalyticsEvent(event),
                              );
                              if (!_showDetails) {
                                setState(() => _showDetails = true);
                              }
                            },
                          ),
                        ),
                        if (_showDetails && state.selectedEvent != null) ...[
                          // Resizable divider
                          MouseRegion(
                            cursor: SystemMouseCursors.resizeColumn,
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  _detailsPanelWidth =
                                      (_detailsPanelWidth - details.delta.dx)
                                          .clamp(
                                            _minDetailsPanelWidth,
                                            _maxDetailsPanelWidth,
                                          );
                                });
                              },
                              child: Container(
                                width: 4,
                                color: Colors.transparent,
                                child: Center(
                                  child: Container(
                                    width: 1,
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Details panel
                          SizedBox(
                            width: _detailsPanelWidth,
                            child: AnalyticsDetailsPanel(
                              event: state.selectedEvent!,
                              onClose: () =>
                                  setState(() => _showDetails = false),
                            ),
                          ),
                        ],
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
      return Center(
        child: Text(
          'Error: ${state.error}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final routeDataMap = _extractRouteData(state.filteredEvents);

    return EnhancedHeatMap(
      routeDataMap: routeDataMap,
      height: 600,
      showControls: true,
      animated: true,
    );
  }

  Map<String, RouteData> _extractRouteData(List<dynamic> events) {
    final routeDataMap = <String, RouteData>{};
    final routeScreenshots = <String, Uint8List>{};
    final routeSizes = <String, Size>{};

    // First pass: collect screenshots and route metadata
    for (final event in events) {
      final metadata = event.metadata as Map<String, dynamic>?;
      if (metadata != null && metadata['type'] == 'route_screenshot') {
        final route = metadata['route'] as String? ?? '/';
        final screenshotData = metadata['screenshot'] as String?;
        final width = metadata['width'] as int?;
        final height = metadata['height'] as int?;

        if (screenshotData != null &&
            screenshotData.startsWith('data:image/png;base64,')) {
          try {
            final base64String = screenshotData.substring(
              'data:image/png;base64,'.length,
            );
            final bytes = base64Decode(base64String);
            routeScreenshots[route] = bytes;
            if (width != null && height != null) {
              routeSizes[route] = Size(width.toDouble(), height.toDouble());
            }
          } catch (e) {
            // Ignore decode errors
          }
        }
      }
    }

    // Second pass: collect touch events by route
    for (final event in events) {
      final metadata = event.metadata as Map<String, dynamic>?;
      if (metadata != null && metadata['type'] == 'touch_event') {
        final route = metadata['screen'] as String? ?? '/';
        final x = (metadata['x'] is num) ? metadata['x'].toDouble() : null;
        final y = (metadata['y'] is num) ? metadata['y'].toDouble() : null;

        if (x != null && y != null) {
          // Get or create route data
          final existingData = routeDataMap[route];
          final screenSize = routeSizes[route] ?? const Size(400, 800);

          final point = HeatMapPoint(
            x: x / screenSize.width,
            y: y / screenSize.height,
            intensity: 0.7,
            screenName: route,
            timestamp: event.timestamp ?? DateTime.now(),
          );

          if (existingData != null) {
            existingData.touchPoints.add(point);
          } else {
            routeDataMap[route] = RouteData(
              routeName: route,
              touchPoints: [point],
              screenshot: routeScreenshots[route],
              screenSize: screenSize,
              firstSeen: event.timestamp ?? DateTime.now(),
              lastSeen: event.timestamp ?? DateTime.now(),
            );
          }
        }
      }
    }

    return routeDataMap;
  }
}
