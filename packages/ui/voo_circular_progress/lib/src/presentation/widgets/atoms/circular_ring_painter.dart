import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:voo_circular_progress/src/domain/entities/progress_ring.dart';

/// Custom painter for rendering a circular progress ring efficiently.
///
/// This painter draws a single ring with a background and a progress arc.
/// It uses [CustomPainter] for optimal performance and smooth rendering.
class CircularRingPainter extends CustomPainter {
  /// Creates a circular ring painter.
  ///
  /// The [ring] defines the appearance and progress of the ring.
  /// The [animationProgress] controls the animation state (0.0 to 1.0).
  CircularRingPainter({required this.ring, required this.animationProgress, required this.ringRadius});

  /// The progress ring configuration.
  final ProgressRing ring;

  /// The animation progress value (0.0 to 1.0).
  final double animationProgress;

  /// The radius of this ring from the center.
  final double ringRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: ringRadius);

    // Draw background ring
    _drawBackgroundRing(canvas, rect);

    // Draw progress ring
    _drawProgressRing(canvas, rect);
  }

  /// Draws the background ring (the unfilled portion).
  void _drawBackgroundRing(Canvas canvas, Rect rect) {
    final backgroundPaint = Paint()
      ..color = ring.backgroundColor ?? ring.color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ring.strokeWidth
      ..strokeCap = ring.capStyle;

    canvas.drawCircle(rect.center, ringRadius, backgroundPaint);
  }

  /// Draws the progress ring (the filled portion).
  void _drawProgressRing(Canvas canvas, Rect rect) {
    final progressPaint = Paint()
      ..color = ring.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = ring.strokeWidth
      ..strokeCap = ring.capStyle;

    // Calculate the sweep angle based on progress and animation
    final targetSweepAngle = 2 * math.pi * ring.progress;
    final currentSweepAngle = targetSweepAngle * animationProgress;

    // Only draw if there's progress to show
    if (currentSweepAngle > 0) {
      canvas.drawArc(rect, ring.startAngle, currentSweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(CircularRingPainter oldDelegate) =>
      oldDelegate.ring != ring || oldDelegate.animationProgress != animationProgress || oldDelegate.ringRadius != ringRadius;
}
