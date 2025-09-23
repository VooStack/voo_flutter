import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Drop animation widget that makes child appear to drop from above
class VooDropAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double fromHeight;

  const VooDropAnimation({super.key, required this.child, this.config = const VooAnimationConfig(), this.fromHeight = 50});

  @override
  State<VooDropAnimation> createState() => _VooDropAnimationState();
}

class _VooDropAnimationState extends State<VooDropAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.config.duration, vsync: this);

    _translateAnimation = Tween<double>(begin: -widget.fromHeight, end: 0).animate(CurvedAnimation(parent: _controller, curve: widget.config.curve));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          _controller.forward().then((_) {
            widget.config.onComplete?.call();
          });
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
    builder: (context, child) => Transform.translate(
      offset: Offset(0, _translateAnimation.value),
      child: Opacity(opacity: _opacityAnimation.value, child: widget.child),
    ),
  );
}
