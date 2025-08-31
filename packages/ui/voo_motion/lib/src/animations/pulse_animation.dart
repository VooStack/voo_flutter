import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Pulse animation widget that creates a pulsing effect
class VooPulseAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double minScale;
  final double maxScale;
  final Color? pulseColor;
  final double pulseOpacity;
  final bool showPulseEffect;
  
  const VooPulseAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.pulseColor,
    this.pulseOpacity = 0.3,
    this.showPulseEffect = false,
  });
  
  @override
  State<VooPulseAnimation> createState() => _VooPulseAnimationState();
}

class _VooPulseAnimationState extends State<VooPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    ),);
    
    _opacityAnimation = Tween<double>(
      begin: widget.pulseOpacity,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ),);
    
    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          if (widget.config.repeat || widget.config.repeatCount > 1) {
            _controller.repeat(reverse: true);
          } else {
            _controller.forward().then((_) {
              if (mounted) {
                _controller.reverse().then((_) {
                  widget.config.onComplete?.call();
                });
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
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulseWidget = Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
        
        if (widget.showPulseEffect) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse effect layer
              Transform.scale(
                scale: 1.0 + (_scaleAnimation.value - widget.minScale) * 2,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.pulseColor ?? Theme.of(context).primaryColor,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
              // Main widget
              pulseWidget,
            ],
          );
        }
        
        return pulseWidget;
      },
    );
}