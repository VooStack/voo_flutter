import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Wave animation widget that creates a wave effect
class VooWaveAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double waveHeight;
  final double waveCount;
  final WaveType waveType;
  final Axis direction;
  
  const VooWaveAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.waveHeight = 20.0,
    this.waveCount = 1.0,
    this.waveType = WaveType.sin,
    this.direction = Axis.vertical,
  });
  
  @override
  State<VooWaveAnimation> createState() => _VooWaveAnimationState();
}

enum WaveType {
  sin,
  cos,
  sawtooth,
  square,
  triangle,
}

class _VooWaveAnimationState extends State<VooWaveAnimation>
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
      begin: 0.0,
      end: 2 * math.pi * widget.waveCount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
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
  
  double _calculateWaveValue(double t) {
    switch (widget.waveType) {
      case WaveType.sin:
        return math.sin(t) * widget.waveHeight;
      case WaveType.cos:
        return math.cos(t) * widget.waveHeight;
      case WaveType.sawtooth:
        final normalized = (t % (2 * math.pi)) / (2 * math.pi);
        return (2 * normalized - 1) * widget.waveHeight;
      case WaveType.square:
        return (math.sin(t) >= 0 ? 1 : -1) * widget.waveHeight;
      case WaveType.triangle:
        final normalized = (t % (2 * math.pi)) / (2 * math.pi);
        return (normalized < 0.5 
          ? 4 * normalized - 1 
          : 3 - 4 * normalized) * widget.waveHeight;
    }
  }
  
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final waveValue = _calculateWaveValue(_animation.value);
        final offset = widget.direction == Axis.vertical
            ? Offset(waveValue, 0)
            : Offset(0, waveValue);
        
        return Transform.translate(
          offset: offset,
          child: widget.child,
        );
      },
    );
}