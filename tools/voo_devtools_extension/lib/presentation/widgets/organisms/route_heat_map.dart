import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/organisms/heat_map_visualization.dart';

class RouteHeatMap extends StatefulWidget {
  final Map<String, RouteData> routeDataMap;

  const RouteHeatMap({super.key, required this.routeDataMap});

  @override
  State<RouteHeatMap> createState() => _RouteHeatMapState();
}

class _RouteHeatMapState extends State<RouteHeatMap> {
  String? _selectedRoute;

  @override
  void initState() {
    super.initState();
    if (widget.routeDataMap.isNotEmpty) {
      _selectedRoute = widget.routeDataMap.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.routeDataMap.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No routes tracked yet', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Navigate through your app to see heat maps for each screen', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    final selectedData = _selectedRoute != null ? widget.routeDataMap[_selectedRoute] : null;

    return Column(
      children: [
        // Route selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              Icon(Icons.route, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text('Select Route:', style: theme.textTheme.bodyLarge),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedRoute,
                  isExpanded: true,
                  items: widget.routeDataMap.keys.map((route) {
                    final data = widget.routeDataMap[route]!;
                    return DropdownMenuItem(
                      value: route,
                      child: Row(
                        children: [
                          Text(route),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                            child: Text('${data.touchPoints.length} touches', style: theme.textTheme.labelSmall),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoute = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              if (selectedData != null && selectedData.screenshot != null)
                Chip(avatar: const Icon(Icons.image, size: 16), label: const Text('Has Screenshot'), backgroundColor: theme.colorScheme.secondaryContainer),
            ],
          ),
        ),
        // Heat map visualization
        Expanded(child: selectedData != null ? _buildRouteHeatMap(selectedData) : const Center(child: Text('Select a route to view its heat map'))),
      ],
    );
  }

  Widget _buildRouteHeatMap(RouteData data) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: data.screenshot != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                // Screenshot background
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(data.screenshot!, fit: BoxFit.contain),
                  ),
                ),
                // Heat map overlay
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: HeatMapVisualization(points: data.touchPoints, screenName: _selectedRoute, showGrid: false, gridSize: 20),
                ),
              ],
            )
          : HeatMapVisualization(points: data.touchPoints, screenName: _selectedRoute, showGrid: true, gridSize: 20),
    );
  }
}

class RouteData {
  final String routeName;
  final List<HeatMapPoint> touchPoints;
  final Uint8List? screenshot;
  final Size? screenSize;
  final DateTime firstSeen;
  final DateTime lastSeen;

  RouteData({required this.routeName, required this.touchPoints, this.screenshot, this.screenSize, required this.firstSeen, required this.lastSeen});
}
