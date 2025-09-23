import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Ripple animation that creates expanding circles
class VooRippleAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color rippleColor;
  final int rippleCount;
  final double minRadius;
  final double maxRadius;
  final Duration rippleDelay;

  const VooRippleAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(),
    this.rippleColor = Colors.blue,
    this.rippleCount = 3,
    this.minRadius = 30,
    this.maxRadius = 150,
    this.rippleDelay = const Duration(milliseconds: 300),
  });

  @override
  State<VooRippleAnimation> createState() => _VooRippleAnimationState();
}

class _VooRippleAnimationState extends State<VooRippleAnimation> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _radiusAnimations = [];
  final List<Animation<double>> _opacityAnimations = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.rippleCount; i++) {
      final controller = AnimationController(duration: widget.config.duration, vsync: this);

      final radiusAnimation = Tween<double>(
        begin: widget.minRadius,
        end: widget.maxRadius,
      ).animate(CurvedAnimation(parent: controller, curve: widget.config.curve));

      final opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _radiusAnimations.add(radiusAnimation);
      _opacityAnimations.add(opacityAnimation);
    }

    if (widget.config.autoPlay) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    widget.config.onStart?.call();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.config.delay + (widget.rippleDelay * i), () {
        if (mounted) {
          if (widget.config.repeat) {
            _controllers[i].repeat();
          } else {
            _controllers[i].forward().then((_) {
              if (i == _controllers.length - 1) {
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
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ripples = <Widget>[];

    for (int i = 0; i < _controllers.length; i++) {
      ripples.add(
        AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) => Center(
            child: Container(
              width: _radiusAnimations[i].value * 2,
              height: _radiusAnimations[i].value * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: widget.rippleColor.withValues(alpha: _opacityAnimations[i].value), width: 2),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(alignment: Alignment.center, children: [...ripples, widget.child]);
  }
}
