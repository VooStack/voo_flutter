import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Shake animation widget that creates a shaking effect
class VooShakeAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double intensity;
  final int numberOfShakes;
  
  const VooShakeAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.intensity = 10,
    this.numberOfShakes = 5,
  });
  
  @override
  State<VooShakeAnimation> createState() => _VooShakeAnimationState();
}

class _VooShakeAnimationState extends State<VooShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    
    // Create custom shake curve
    final curve = _ShakeCustomCurve(widget.numberOfShakes);
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.intensity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ),);
    
    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          _controller.forward().then((_) {
            widget.config.onComplete?.call();
            if (widget.config.repeat) {
              _controller.repeat();
            }
          });
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
      builder: (context, child) => Transform.translate(
          offset: Offset(_animation.value, 0),
          child: widget.child,
        ),
    );
}

/// Custom shake curve that creates oscillating motion
class _ShakeCustomCurve extends Curve {
  final int numberOfShakes;
  
  const _ShakeCustomCurve(this.numberOfShakes);
  
  @override
  double transformInternal(double t) {
    // Create oscillating pattern that decays over time
    final double decay = 1.0 - t;
    final double oscillation = math.sin(t * math.pi * 2 * numberOfShakes);
    return oscillation * decay;
  }
}