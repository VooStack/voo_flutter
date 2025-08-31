import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Bounce animation widget that creates a bouncing effect
class VooBounceAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double bounceHeight;
  final int numberOfBounces;
  
  const VooBounceAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.bounceHeight = 20,
    this.numberOfBounces = 3,
  });
  
  @override
  State<VooBounceAnimation> createState() => _VooBounceAnimationState();
}

class _VooBounceAnimationState extends State<VooBounceAnimation>
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
    
    // Create custom bounce curve
    final curve = _BounceCustomCurve(widget.numberOfBounces);
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.bounceHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: curve,
    ),);
    
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
      builder: (context, child) => Transform.translate(
          offset: Offset(0, -_animation.value),
          child: widget.child,
        ),
    );
}

/// Custom bounce curve that creates multiple bounces
class _BounceCustomCurve extends Curve {
  final int numberOfBounces;
  
  const _BounceCustomCurve(this.numberOfBounces);
  
  @override
  double transformInternal(double t) {
    // Calculate bounce physics
    double value = 0;
    final double period = 1.0 / (numberOfBounces * 2);
    
    for (int i = 0; i < numberOfBounces; i++) {
      final double bounceStart = i * period * 2;
      final double bounceEnd = bounceStart + period * 2;
      
      if (t >= bounceStart && t < bounceEnd) {
        final double localT = (t - bounceStart) / (period * 2);
        final double amplitude = 1.0 - (i / numberOfBounces);
        
        if (localT < 0.5) {
          // Going up
          value = amplitude * (localT * 2);
        } else {
          // Coming down
          value = amplitude * (2 - localT * 2);
        }
        break;
      }
    }
    
    return value;
  }
}