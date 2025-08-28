import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Scale animation widget for size transitions
class VooScaleAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double fromScale;
  final double toScale;
  final Alignment alignment;
  
  const VooScaleAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.fromScale = 0.0,
    this.toScale = 1.0,
    this.alignment = Alignment.center,
  });
  
  @override
  State<VooScaleAnimation> createState() => _VooScaleAnimationState();
}

class _VooScaleAnimationState extends State<VooScaleAnimation>
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
      begin: widget.fromScale,
      end: widget.toScale,
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
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}