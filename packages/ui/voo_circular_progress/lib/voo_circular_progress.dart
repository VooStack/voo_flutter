/// A highly customizable multi-ring circular progress indicator widget.
///
/// This library provides a beautiful, animated circular progress indicator
/// similar to fitness tracking apps like Google Fit. Features include:
///
/// - Multiple concentric progress rings
/// - Smooth animations with customizable duration and curves
/// - Highly customizable appearance (colors, stroke widths, etc.)
/// - Efficient rendering using CustomPainter
/// - Flexible center widget support
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
///   centerWidget: Column(
///     mainAxisAlignment: MainAxisAlignment.center,
///     children: [
///       Text('23', style: TextStyle(fontSize: 48)),
///       Text('7,762', style: TextStyle(fontSize: 24)),
///     ],
///   ),
/// )
/// ```
library voo_circular_progress;

// Domain entities
export 'src/domain/entities/circular_progress_config.dart';
export 'src/domain/entities/progress_ring.dart';

// Presentation widgets
export 'src/presentation/widgets/organisms/organisms.dart';
