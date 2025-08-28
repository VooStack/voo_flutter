import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Fade animation widget for opacity transitions
class VooFadeAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double fromOpacity;
  final double toOpacity;
  
  const VooFadeAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.fromOpacity = 0.0,
    this.toOpacity = 1.0,
  });
  
  @override
  State<VooFadeAnimation> createState() => _VooFadeAnimationState();
}

class _VooFadeAnimationState extends State<VooFadeAnimation>
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
      begin: widget.fromOpacity,
      end: widget.toOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    ));
    
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
      _controller.repeat();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}