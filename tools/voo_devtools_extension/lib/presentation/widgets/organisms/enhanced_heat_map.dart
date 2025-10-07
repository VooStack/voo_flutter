import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/presentation/theme/app_theme.dart';

/// Enhanced heat map point with additional metadata
class HeatMapPoint {
  final double x;
  final double y;
  final double intensity;
  final String? screenName;
  final DateTime timestamp;
  final String? touchType;
  final Map<String, dynamic>? metadata;

  HeatMapPoint({
    required this.x,
    required this.y,
    this.intensity = 0.7,
    this.screenName,
    required this.timestamp,
    this.touchType,
    this.metadata,
  });
}

/// Route data with touch points and screenshot
class RouteData {
  final String routeName;
  final List<HeatMapPoint> touchPoints;
  final Uint8List? screenshot;
  final Size screenSize;
  final DateTime firstSeen;
  final DateTime lastSeen;

  RouteData({
    required this.routeName,
    required this.touchPoints,
    this.screenshot,
    this.screenSize = const Size(400, 800),
    required this.firstSeen,
    required this.lastSeen,
  });

  int get touchCount => touchPoints.length;

  Map<String, int> get touchTypeBreakdown {
    final breakdown = <String, int>{};
    for (final point in touchPoints) {
      final type = point.touchType ?? 'tap';
      breakdown[type] = (breakdown[type] ?? 0) + 1;
    }
    return breakdown;
  }
}

/// Modern, enhanced heat map visualization
class EnhancedHeatMap extends StatefulWidget {
  final Map<String, RouteData> routeDataMap;
  final double height;
  final bool showControls;
  final bool animated;

  const EnhancedHeatMap({
    super.key,
    required this.routeDataMap,
    this.height = 600,
    this.showControls = true,
    this.animated = true,
  });

  @override
  State<EnhancedHeatMap> createState() => _EnhancedHeatMapState();
}

class _EnhancedHeatMapState extends State<EnhancedHeatMap>
    with TickerProviderStateMixin {
  String? _selectedRoute;
  double _heatIntensity = 1.0;
  double _blurRadius = 25.0;
  bool _showGrid = false;
  bool _showPoints = true;
  bool _showStats = true;
  HeatMapPoint? _hoveredPoint;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.routeDataMap.isNotEmpty) {
      _selectedRoute = widget.routeDataMap.keys.first;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.routeDataMap.isEmpty) {
      return _buildEmptyState(theme);
    }

    final selectedData = _selectedRoute != null
        ? widget.routeDataMap[_selectedRoute]
        : null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Column(
        children: [
          if (widget.showControls) _buildControlPanel(theme),
          Expanded(
            child: selectedData != null
                ? _buildHeatMapView(selectedData, theme)
                : _buildEmptyState(theme),
          ),
          if (_showStats && selectedData != null)
            _buildStatsPanel(selectedData, theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                radius: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.touch_app_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Touch Data Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Navigate through your app to track touch interactions',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First row: Screen selector and sliders
          SizedBox(
            height: 40,
            child: Row(
              children: [
                // Route selector
                Text(
                  'Select Screen',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Container(
                  width: 250,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRoute,
                      isExpanded: true,
                      isDense: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      items: widget.routeDataMap.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Row(
                            children: [
                              Icon(
                                Icons.mobile_screen_share,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${entry.value.touchCount}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRoute = value;
                          if (widget.animated) {
                            _animationController
                              ..reset()
                              ..forward();
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingXl),

                // Heat intensity slider
                Text('Heat Intensity', style: theme.textTheme.labelMedium),
                const SizedBox(width: AppTheme.spacingSm),
                SizedBox(
                  width: 150,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                    ),
                    child: Slider(
                      value: _heatIntensity,
                      min: 0.1,
                      max: 2.0,
                      onChanged: (value) {
                        setState(() => _heatIntensity = value);
                      },
                    ),
                  ),
                ),
                Text(
                  '${(_heatIntensity * 100).round()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingXl),

                // Blur radius slider
                Text('Blur Radius', style: theme.textTheme.labelMedium),
                const SizedBox(width: AppTheme.spacingSm),
                SizedBox(
                  width: 150,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                    ),
                    child: Slider(
                      value: _blurRadius,
                      min: 5,
                      max: 50,
                      onChanged: (value) {
                        setState(() => _blurRadius = value);
                      },
                    ),
                  ),
                ),
                Text(
                  '${_blurRadius.round()}px',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Second row: Toggle controls
          SizedBox(
            height: 32,
            child: Row(
              children: [
                _buildToggleChip(
                  theme,
                  'Show Grid',
                  Icons.grid_on,
                  _showGrid,
                  (value) => setState(() => _showGrid = value),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                _buildToggleChip(
                  theme,
                  'Show Points',
                  Icons.scatter_plot,
                  _showPoints,
                  (value) => setState(() => _showPoints = value),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                _buildToggleChip(
                  theme,
                  'Show Stats',
                  Icons.analytics,
                  _showStats,
                  (value) => setState(() => _showStats = value),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    if (widget.animated) {
                      _animationController
                        ..reset()
                        ..forward();
                    }
                  },
                  tooltip: 'Refresh animation',
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(
    ThemeData theme,
    String label,
    IconData icon,
    bool selected,
    ValueChanged<bool> onChanged,
  ) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 4), Text(label)],
      ),
      selected: selected,
      onSelected: onChanged,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }

  Widget _buildHeatMapView(RouteData data, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),

            // Screenshot if available
            if (data.screenshot != null)
              Opacity(
                opacity: 0.3,
                child: Image.memory(data.screenshot!, fit: BoxFit.contain),
              ),

            // Heat map visualization
            MouseRegion(
              onHover: (event) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(event.position);
                _findHoveredPoint(localPosition, data);
              },
              onExit: (_) {
                setState(() => _hoveredPoint = null);
              },
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomPaint(
                  painter: EnhancedHeatMapPainter(
                    points: data.touchPoints,
                    intensity: _heatIntensity,
                    blurRadius: _blurRadius,
                    showGrid: _showGrid,
                    showPoints: _showPoints,
                    theme: theme,
                    hoveredPoint: _hoveredPoint,
                  ),
                ),
              ),
            ),

            // Hover tooltip
            if (_hoveredPoint != null)
              Positioned(
                left: _hoveredPoint!.x * MediaQuery.of(context).size.width,
                top: _hoveredPoint!.y * widget.height - 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Touch at (${(_hoveredPoint!.x * 100).toStringAsFixed(1)}%, ${(_hoveredPoint!.y * 100).toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: theme.colorScheme.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsPanel(RouteData data, ThemeData theme) {
    final breakdown = data.touchTypeBreakdown;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            Icons.touch_app,
            'Total Touches',
            data.touchCount.toString(),
            theme.colorScheme.primary,
          ),
          _buildStatItem(
            theme,
            Icons.access_time,
            'First Seen',
            _formatTime(data.firstSeen),
            theme.colorScheme.secondary,
          ),
          _buildStatItem(
            theme,
            Icons.update,
            'Last Seen',
            _formatTime(data.lastSeen),
            Colors.orange,
          ),
          ...breakdown.entries
              .take(3)
              .map(
                (entry) => _buildStatItem(
                  theme,
                  _getIconForTouchType(entry.key),
                  entry.key,
                  entry.value.toString(),
                  Colors.indigo,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _findHoveredPoint(Offset position, RouteData data) {
    // Implementation to find the nearest point to hover position
    // This is simplified - you'd need to adjust based on actual render box
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  IconData _getIconForTouchType(String type) {
    switch (type.toLowerCase()) {
      case 'tap':
        return Icons.touch_app;
      case 'swipe':
        return Icons.swipe;
      case 'long_press':
        return Icons.timer;
      case 'drag':
        return Icons.drag_indicator;
      default:
        return Icons.touch_app;
    }
  }
}

/// Enhanced heat map painter with smooth gradients
class EnhancedHeatMapPainter extends CustomPainter {
  final List<HeatMapPoint> points;
  final double intensity;
  final double blurRadius;
  final bool showGrid;
  final bool showPoints;
  final ThemeData theme;
  final HeatMapPoint? hoveredPoint;

  EnhancedHeatMapPainter({
    required this.points,
    required this.intensity,
    required this.blurRadius,
    required this.showGrid,
    required this.showPoints,
    required this.theme,
    this.hoveredPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    if (points.isNotEmpty) {
      _drawHeatMap(canvas, size);

      if (showPoints) {
        _drawPoints(canvas, size);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 20.0;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawHeatMap(Canvas canvas, Size size) {
    // Create aggregated heat data
    final heatData = _aggregateHeatData(size);

    // Draw heat gradients
    for (final entry in heatData.entries) {
      final point = entry.key;
      final intensity = entry.value * this.intensity;

      // Create gradient paint
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(point.dx * size.width, point.dy * size.height),
          blurRadius * 2,
          [
            _getHeatColor(intensity),
            _getHeatColor(intensity * 0.5).withValues(alpha: 0.5),
            _getHeatColor(intensity * 0.2).withValues(alpha: 0.2),
            Colors.transparent,
          ],
          [0.0, 0.3, 0.6, 1.0],
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

      canvas.drawCircle(
        Offset(point.dx * size.width, point.dy * size.height),
        blurRadius * 2,
        paint,
      );
    }
  }

  void _drawPoints(Canvas canvas, Size size) {
    for (final point in points) {
      final isHovered = hoveredPoint == point;

      // Outer glow
      if (isHovered) {
        final glowPaint = Paint()
          ..color = theme.colorScheme.primary.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

        canvas.drawCircle(
          Offset(point.x * size.width, point.y * size.height),
          8,
          glowPaint,
        );
      }

      // Point
      final pointPaint = Paint()
        ..color = isHovered
            ? theme.colorScheme.primary
            : _getHeatColor(point.intensity).withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(point.x * size.width, point.y * size.height),
        isHovered ? 5 : 3,
        pointPaint,
      );

      // Point border
      final borderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(
        Offset(point.x * size.width, point.y * size.height),
        isHovered ? 5 : 3,
        borderPaint,
      );
    }
  }

  Map<Offset, double> _aggregateHeatData(Size size) {
    final aggregated = <Offset, double>{};
    const cellSize = 15.0;

    for (final point in points) {
      final cellX =
          (point.x * size.width / cellSize).floor() * cellSize / size.width;
      final cellY =
          (point.y * size.height / cellSize).floor() * cellSize / size.height;
      final cellKey = Offset(cellX, cellY);

      aggregated[cellKey] = math.min(
        1.0,
        (aggregated[cellKey] ?? 0) + point.intensity / points.length,
      );
    }

    return aggregated;
  }

  Color _getHeatColor(double intensity) {
    intensity = intensity.clamp(0.0, 1.0);

    // Beautiful gradient from cool to hot colors
    const colors = [
      Color(0xFF1E3A8A), // Deep blue
      Color(0xFF3B82F6), // Blue
      Color(0xFF06B6D4), // Cyan
      Color(0xFF10B981), // Emerald
      Color(0xFFF59E0B), // Amber
      Color(0xFFEF4444), // Red
      Color(0xFF991B1B), // Dark red
    ];

    final index = (intensity * (colors.length - 1)).floor();
    final remainder = (intensity * (colors.length - 1)) - index;

    if (index >= colors.length - 1) {
      return colors.last;
    }

    return Color.lerp(colors[index], colors[index + 1], remainder)!;
  }

  @override
  bool shouldRepaint(covariant EnhancedHeatMapPainter oldDelegate) {
    return points != oldDelegate.points ||
        intensity != oldDelegate.intensity ||
        blurRadius != oldDelegate.blurRadius ||
        showGrid != oldDelegate.showGrid ||
        showPoints != oldDelegate.showPoints ||
        hoveredPoint != oldDelegate.hoveredPoint;
  }
}
