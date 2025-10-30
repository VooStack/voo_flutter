import 'package:flutter/material.dart';
import 'package:voo_circular_progress/src/domain/entities/circular_progress_config.dart';
import 'package:voo_circular_progress/src/domain/entities/progress_ring.dart';
import 'package:voo_circular_progress/src/presentation/widgets/molecules/molecules.dart';

/// A highly customizable multi-ring circular progress indicator.
///
/// This widget displays multiple concentric progress rings with smooth
/// animations, similar to fitness tracking apps like Google Fit.
///
/// Example usage:
/// ```dart
/// VooCircularProgress(
///   rings: [
///     ProgressRing(
///       current: 7762,
///       goal: 10000,
///       color: Colors.cyan,
///       strokeWidth: 12,
///     ),
///     ProgressRing(
///       current: 23,
///       goal: 30,
///       color: Colors.blue,
///       strokeWidth: 12,
///     ),
///   ],
///   size: 200,
///   centerWidget: Text('23'),
/// )
/// ```
class VooCircularProgress extends StatelessWidget {
  /// Creates a circular progress indicator with multiple rings.
  ///
  /// The [rings] parameter defines the progress rings to display, ordered
  /// from outermost to innermost.
  ///
  /// The [size] parameter defines the overall diameter of the indicator.
  ///
  /// The [gapBetweenRings] parameter defines the spacing between rings.
  ///
  /// The [animationDuration] controls how long progress animations take.
  ///
  /// The [animationCurve] defines the easing function for animations.
  ///
  /// The [centerWidget] is an optional widget to display in the center.
  const VooCircularProgress({
    required this.rings,
    this.size = 200.0,
    this.gapBetweenRings = 8.0,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOutCubic,
    this.centerWidget,
    super.key,
  })  : assert(rings.length > 0, 'At least one ring must be provided'),
        assert(size > 0, 'Size must be positive'),
        assert(gapBetweenRings >= 0, 'Gap between rings must be non-negative');

  /// The list of progress rings to display, ordered from outer to inner.
  final List<ProgressRing> rings;

  /// The overall size (diameter) of the circular progress indicator.
  final double size;

  /// The gap between concentric rings.
  final double gapBetweenRings;

  /// The duration for progress animations.
  final Duration animationDuration;

  /// The animation curve for smooth transitions.
  final Curve animationCurve;

  /// Optional widget to display in the center of the rings.
  final Widget? centerWidget;

  /// Creates the configuration from the widget parameters.
  CircularProgressConfig get _config => CircularProgressConfig(
        size: size,
        gapBetweenRings: gapBetweenRings,
        animationDuration: animationDuration,
        animationCurve: animationCurve,
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Render all rings
            ..._buildRings(),
            // Center widget
            if (centerWidget != null) centerWidget!,
          ],
        ),
      );

  /// Builds all the animated rings.
  List<Widget> _buildRings() {
    final widgets = <Widget>[];

    // Calculate the radius for each ring
    // Start from the outermost ring and work inward
    double currentRadius = size / 2;

    for (var i = 0; i < rings.length; i++) {
      final ring = rings[i];

      // Adjust radius to account for stroke width
      final ringRadius = currentRadius - (ring.strokeWidth / 2);

      widgets.add(
        SizedBox(
          width: size,
          height: size,
          child: AnimatedProgressRing(
            ring: ring,
            config: _config,
            ringRadius: ringRadius,
          ),
        ),
      );

      // Move inward for the next ring
      currentRadius -= ring.strokeWidth + gapBetweenRings;

      // Ensure we don't go negative
      if (currentRadius <= 0) break;
    }

    return widgets;
  }
}
