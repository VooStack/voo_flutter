import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Rotation animation widget for spin transitions
class VooRotationAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double fromAngle;
  final double toAngle;
  final Alignment alignment;

  const VooRotationAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.fromAngle = 0,
    this.toAngle = 6.28319, // 2 * pi
    this.alignment = Alignment.center,
  });

  @override
  State<VooRotationAnimation> createState() => _VooRotationAnimationState();
}

class _VooRotationAnimationState extends State<VooRotationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.config.duration, vsync: this);

    _animation = Tween<double>(begin: widget.fromAngle, end: widget.toAngle).animate(CurvedAnimation(parent: _controller, curve: widget.config.curve));

    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          if (widget.config.repeat) {
            _controller.repeat();
          } else {
            _controller.forward().then((_) {
              widget.config.onComplete?.call();
            });
          }
        }
      });
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
    builder: (context, child) => Transform.rotate(angle: _animation.value, alignment: widget.alignment, child: widget.child),
  );
}
