import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Glow animation widget that creates a glowing effect
class VooGlowAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color glowColor;
  final double minGlowRadius;
  final double maxGlowRadius;
  final double glowIntensity;
  final BlendMode blendMode;
  
  const VooGlowAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.glowColor = Colors.blue,
    this.minGlowRadius = 0.0,
    this.maxGlowRadius = 20.0,
    this.glowIntensity = 0.8,
    this.blendMode = BlendMode.screen,
  });
  
  @override
  State<VooGlowAnimation> createState() => _VooGlowAnimationState();
}

class _VooGlowAnimationState extends State<VooGlowAnimation>
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
      begin: widget.minGlowRadius,
      end: widget.maxGlowRadius,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    ));
    
    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          if (widget.config.repeat) {
            _controller.repeat(reverse: true);
          } else {
            _controller.forward().then((_) {
              if (widget.config.reverse && mounted) {
                _controller.reverse().then((_) {
                  widget.config.onComplete?.call();
                });
              } else {
                widget.config.onComplete?.call();
              }
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: widget.glowIntensity),
                blurRadius: _animation.value,
                spreadRadius: _animation.value / 2,
                blurStyle: BlurStyle.normal,
              ),
              BoxShadow(
                color: widget.glowColor.withValues(alpha: widget.glowIntensity * 0.5),
                blurRadius: _animation.value * 1.5,
                spreadRadius: _animation.value * 0.75,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}