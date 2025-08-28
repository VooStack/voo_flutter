import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Slide animation widget for position transitions
class VooSlideAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Offset fromOffset;
  final Offset toOffset;
  
  const VooSlideAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.fromOffset = const Offset(-1, 0),
    this.toOffset = Offset.zero,
  });
  
  @override
  State<VooSlideAnimation> createState() => _VooSlideAnimationState();
}

class _VooSlideAnimationState extends State<VooSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    
    _animation = Tween<Offset>(
      begin: widget.fromOffset,
      end: widget.toOffset,
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}