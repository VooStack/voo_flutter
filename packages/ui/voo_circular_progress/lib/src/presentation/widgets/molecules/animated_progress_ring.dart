import 'package:flutter/material.dart';
import 'package:voo_circular_progress/src/domain/entities/circular_progress_config.dart';
import 'package:voo_circular_progress/src/domain/entities/progress_ring.dart';
import 'package:voo_circular_progress/src/presentation/widgets/atoms/atoms.dart';

/// An animated wrapper for a single progress ring.
///
/// This widget manages the animation state for a single ring and renders
/// it using [CircularRingPainter]. The animation is triggered when the
/// progress value changes.
class AnimatedProgressRing extends StatefulWidget {
  /// Creates an animated progress ring.
  ///
  /// The [ring] defines the appearance and progress of the ring.
  /// The [config] defines the animation settings.
  /// The [ringRadius] defines the radius of this ring from the center.
  const AnimatedProgressRing({
    required this.ring,
    required this.config,
    required this.ringRadius,
    super.key,
  });

  /// The progress ring configuration.
  final ProgressRing ring;

  /// The circular progress configuration for animations.
  final CircularProgressConfig config;

  /// The radius of this ring from the center.
  final double ringRadius;

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.config.animationCurve,
    );

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation if progress changes
    if (oldWidget.ring.progress != widget.ring.progress) {
      _controller
        ..duration = widget.config.animationDuration
        ..reset()
        ..forward();
    }

    // Update animation curve if it changed
    if (oldWidget.config.animationCurve != widget.config.animationCurve) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.config.animationCurve,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => CustomPaint(
          painter: CircularRingPainter(
            ring: widget.ring,
            animationProgress: _animation.value,
            ringRadius: widget.ringRadius,
          ),
        ),
      );
}
