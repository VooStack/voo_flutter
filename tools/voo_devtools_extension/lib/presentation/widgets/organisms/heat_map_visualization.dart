import 'package:flutter/material.dart';
import 'dart:math' as math;

class HeatMapPoint {
  final double x;
  final double y;
  final double intensity;
  final String? screenName;
  final DateTime timestamp;

  HeatMapPoint({required this.x, required this.y, required this.intensity, this.screenName, required this.timestamp});
}

class HeatMapVisualization extends StatefulWidget {
  final List<HeatMapPoint> points;
  final double width;
  final double height;
  final bool showGrid;
  final int gridSize;
  final String? screenName;

  const HeatMapVisualization({super.key, required this.points, this.width = double.infinity, this.height = 600, this.showGrid = true, this.gridSize = 20, this.screenName});

  @override
  State<HeatMapVisualization> createState() => _HeatMapVisualizationState();
}

class _HeatMapVisualizationState extends State<HeatMapVisualization> {
  Offset? _hoveredPosition;
  HeatMapPoint? _nearestPoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.screenName != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text('Heat Map: ${widget.screenName}', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Text('${widget.points.length} touch points', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = widget.height == double.infinity ? constraints.maxHeight : widget.height;

                return MouseRegion(
                  onHover: (event) {
                    setState(() {
                      _hoveredPosition = event.localPosition;
                      _nearestPoint = _findNearestPoint(event.localPosition, width, height);
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hoveredPosition = null;
                      _nearestPoint = null;
                    });
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(width, height),
                        painter: HeatMapPainter(points: widget.points, showGrid: widget.showGrid, gridSize: widget.gridSize, theme: theme),
                      ),
                      if (_hoveredPosition != null)
                        Positioned(
                          left: _hoveredPosition!.dx + 10,
                          top: _hoveredPosition!.dy - 30,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: theme.colorScheme.inverseSurface, borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              _nearestPoint != null
                                  ? 'Intensity: ${(_nearestPoint!.intensity * 100).toStringAsFixed(0)}%'
                                  : '(${_hoveredPosition!.dx.toStringAsFixed(0)}, ${_hoveredPosition!.dy.toStringAsFixed(0)})',
                              style: TextStyle(color: theme.colorScheme.onInverseSurface, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                _buildLegendItem(theme, 'Low', Colors.blue.withValues(alpha: 0.3)),
                const SizedBox(width: 24),
                _buildLegendItem(theme, 'Medium', Colors.green.withValues(alpha: 0.5)),
                const SizedBox(width: 24),
                _buildLegendItem(theme, 'High', Colors.orange.withValues(alpha: 0.7)),
                const SizedBox(width: 24),
                _buildLegendItem(theme, 'Very High', Colors.red.withValues(alpha: 0.9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  HeatMapPoint? _findNearestPoint(Offset position, double width, double height) {
    if (widget.points.isEmpty) return null;

    HeatMapPoint? nearest;
    double minDistance = double.infinity;

    for (final point in widget.points) {
      final scaledX = point.x * width;
      final scaledY = point.y * height;
      final distance = (position - Offset(scaledX, scaledY)).distance;

      if (distance < minDistance && distance < 20) {
        minDistance = distance;
        nearest = point;
      }
    }

    return nearest;
  }
}

class HeatMapPainter extends CustomPainter {
  final List<HeatMapPoint> points;
  final bool showGrid;
  final int gridSize;
  final ThemeData theme;

  HeatMapPainter({required this.points, required this.showGrid, required this.gridSize, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    if (points.isNotEmpty) {
      _drawHeatMap(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.dividerColor.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= size.width; i += gridSize) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }

    for (int i = 0; i <= size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  void _drawHeatMap(Canvas canvas, Size size) {
    final aggregatedPoints = _aggregatePoints(size);

    for (final entry in aggregatedPoints.entries) {
      final point = entry.key;
      final intensity = entry.value;

      final paint = Paint()
        ..color = _getHeatColor(intensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + intensity * 20);

      final radius = 10 + intensity * 30;
      canvas.drawCircle(Offset(point.dx * size.width, point.dy * size.height), radius, paint);
    }

    for (final point in points) {
      final paint = Paint()
        ..color = _getHeatColor(point.intensity).withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(point.x * size.width, point.y * size.height), 3, paint);
    }
  }

  Map<Offset, double> _aggregatePoints(Size size) {
    final aggregated = <Offset, double>{};
    final cellSize = gridSize.toDouble();

    for (final point in points) {
      final cellX = (point.x * size.width / cellSize).floor() * cellSize / size.width;
      final cellY = (point.y * size.height / cellSize).floor() * cellSize / size.height;
      final cellKey = Offset(cellX, cellY);

      aggregated[cellKey] = (aggregated[cellKey] ?? 0) + point.intensity;
    }

    final maxIntensity = aggregated.values.fold(0.0, math.max);
    if (maxIntensity > 0) {
      aggregated.updateAll((key, value) => value / maxIntensity);
    }

    return aggregated;
  }

  Color _getHeatColor(double intensity) {
    intensity = intensity.clamp(0.0, 1.0);

    if (intensity < 0.25) {
      return Color.lerp(Colors.blue.withValues(alpha: 0.3), Colors.green.withValues(alpha: 0.5), intensity * 4)!;
    } else if (intensity < 0.5) {
      return Color.lerp(Colors.green.withValues(alpha: 0.5), Colors.yellow.withValues(alpha: 0.7), (intensity - 0.25) * 4)!;
    } else if (intensity < 0.75) {
      return Color.lerp(Colors.yellow.withValues(alpha: 0.7), Colors.orange.withValues(alpha: 0.8), (intensity - 0.5) * 4)!;
    } else {
      return Color.lerp(Colors.orange.withValues(alpha: 0.8), Colors.red.withValues(alpha: 0.9), (intensity - 0.75) * 4)!;
    }
  }

  @override
  bool shouldRepaint(covariant HeatMapPainter oldDelegate) {
    return points != oldDelegate.points || showGrid != oldDelegate.showGrid || gridSize != oldDelegate.gridSize;
  }
}
