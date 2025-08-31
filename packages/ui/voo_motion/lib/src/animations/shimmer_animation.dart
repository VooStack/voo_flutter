import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Shimmer animation widget that creates a shimmer/skeleton loading effect
class VooShimmerAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color baseColor;
  final Color highlightColor;
  final double shimmerWidth;
  final ShimmerDirection direction;
  final double angle;
  
  const VooShimmerAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.shimmerWidth = 0.5,
    this.direction = ShimmerDirection.leftToRight,
    this.angle = 0.0,
  });
  
  @override
  State<VooShimmerAnimation> createState() => _VooShimmerAnimationState();
}

enum ShimmerDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  diagonal,
}

class _VooShimmerAnimationState extends State<VooShimmerAnimation>
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
      begin: -1.0,
      end: 2.0,
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
  
  Offset _getBeginOffset() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return const Offset(-1.0, 0.0);
      case ShimmerDirection.rightToLeft:
        return const Offset(1.0, 0.0);
      case ShimmerDirection.topToBottom:
        return const Offset(0.0, -1.0);
      case ShimmerDirection.bottomToTop:
        return const Offset(0.0, 1.0);
      case ShimmerDirection.diagonal:
        return const Offset(-1.0, -1.0);
    }
  }
  
  Offset _getEndOffset() {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return const Offset(1.0, 0.0);
      case ShimmerDirection.rightToLeft:
        return const Offset(-1.0, 0.0);
      case ShimmerDirection.topToBottom:
        return const Offset(0.0, 1.0);
      case ShimmerDirection.bottomToTop:
        return const Offset(0.0, -1.0);
      case ShimmerDirection.diagonal:
        return const Offset(1.0, 1.0);
    }
  }
  
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
              begin: Alignment(_getBeginOffset().dx, _getBeginOffset().dy),
              end: Alignment(_getEndOffset().dx, _getEndOffset().dy),
              transform: _SlideGradientTransform(
                slidePercent: _animation.value,
              ),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ).createShader(bounds),
          child: widget.child,
        ),
    );
}

class _SlideGradientTransform extends GradientTransform {
  final double slidePercent;
  
  const _SlideGradientTransform({
    required this.slidePercent,
  });
  
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) => Matrix4.translationValues(
      bounds.width * slidePercent,
      0.0,
      0.0,
    );
}