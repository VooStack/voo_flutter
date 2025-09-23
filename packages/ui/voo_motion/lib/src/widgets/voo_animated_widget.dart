import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// A general purpose animated widget wrapper
class VooAnimatedWidget extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Widget Function(BuildContext context, Animation<double> animation, Widget child) builder;

  const VooAnimatedWidget({super.key, required this.child, required this.builder, this.config = const VooAnimationConfig()});

  @override
  State<VooAnimatedWidget> createState() => _VooAnimatedWidgetState();
}

class _VooAnimatedWidgetState extends State<VooAnimatedWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.config.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: widget.config.curve);

    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          if (widget.config.repeat) {
            if (widget.config.reverse) {
              _controller.repeat(reverse: true);
            } else {
              _controller.repeat();
            }
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

  void play() {
    _controller.forward();
  }

  void reverse() {
    _controller.reverse();
  }

  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _animation, builder: (context, child) => widget.builder(context, _animation, widget.child));
}
