import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Direction of the flip animation
enum FlipDirection {
  horizontal,
  vertical,
}

/// Flip animation widget that creates a 3D flip effect
class VooFlipAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final FlipDirection direction;
  
  const VooFlipAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.direction = FlipDirection.horizontal,
  });
  
  @override
  State<VooFlipAnimation> createState() => _VooFlipAnimationState();
}

class _VooFlipAnimationState extends State<VooFlipAnimation>
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
    
    _animation = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    ),);
    
    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          _controller.forward().then((_) {
            widget.config.onComplete?.call();
            if (widget.config.repeat) {
              _handleRepeat();
            }
          });
        }
      });
    }
  }
  
  void _handleRepeat() {
    if (!mounted) return;
    
    if (widget.config.reverse) {
      _controller.repeat(reverse: true);
    } else {
      // For flip, we want full rotations
      _controller.reset();
      _controller.forward();
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
      builder: (context, child) {
        final isShowingFront = _animation.value < math.pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(widget.direction == FlipDirection.vertical 
                ? _animation.value 
                : 0,)
            ..rotateY(widget.direction == FlipDirection.horizontal 
                ? _animation.value 
                : 0,),
          child: isShowingFront
              ? widget.child
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(widget.direction == FlipDirection.vertical 
                        ? math.pi 
                        : 0,)
                    ..rotateY(widget.direction == FlipDirection.horizontal 
                        ? math.pi 
                        : 0,),
                  child: widget.child,
                ),
        );
      },
    );
}