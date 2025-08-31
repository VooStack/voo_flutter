import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Blur animation widget that animates blur effect
class VooBlurAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double fromBlur;
  final double toBlur;
  final double blurX;
  final double blurY;
  final TileMode tileMode;
  
  const VooBlurAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.fromBlur = 10.0,
    this.toBlur = 0.0,
    this.blurX = 0.0,
    this.blurY = 0.0,
    this.tileMode = TileMode.clamp,
  });
  
  @override
  State<VooBlurAnimation> createState() => _VooBlurAnimationState();
}

class _VooBlurAnimationState extends State<VooBlurAnimation>
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
      begin: widget.fromBlur,
      end: widget.toBlur,
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
      _controller.repeat();
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
        final blur = _animation.value;
        final sigmaX = widget.blurX != 0 ? widget.blurX : blur;
        final sigmaY = widget.blurY != 0 ? widget.blurY : blur;
        
        if (blur == 0 && sigmaX == 0 && sigmaY == 0) {
          return widget.child;
        }
        
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: sigmaX,
            sigmaY: sigmaY,
            tileMode: widget.tileMode,
          ),
          child: widget.child,
        );
      },
    );
}