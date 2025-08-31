import 'package:flutter/material.dart';
import 'package:voo_motion/src/animations/fade_animation.dart';
import 'package:voo_motion/src/animations/scale_animation.dart';
import 'package:voo_motion/src/animations/slide_animation.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Animation type for staggered list items
enum StaggerAnimationType {
  fadeIn,
  slideLeft,
  slideRight,
  slideTop,
  slideBottom,
  scale,
}

/// A list widget with staggered animations for its children
class VooStaggerList extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final VooAnimationConfig config;
  final StaggerAnimationType animationType;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  
  const VooStaggerList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.config = const VooAnimationConfig(),
    this.animationType = StaggerAnimationType.fadeIn,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });
  
  @override
  State<VooStaggerList> createState() => _VooStaggerListState();
}

class _VooStaggerListState extends State<VooStaggerList> {
  @override
  Widget build(BuildContext context) {
    final animatedChildren = <Widget>[];
    
    for (int i = 0; i < widget.children.length; i++) {
      final delay = widget.staggerDelay * i;
      final config = widget.config.copyWith(
        delay: widget.config.delay + delay,
      );
      
      Widget animatedChild;
      
      switch (widget.animationType) {
        case StaggerAnimationType.fadeIn:
          animatedChild = VooFadeAnimation(
            config: config,
            child: widget.children[i],
          );
          break;
        case StaggerAnimationType.slideLeft:
          animatedChild = VooSlideAnimation(
            config: config,
            child: widget.children[i],
          );
          break;
        case StaggerAnimationType.slideRight:
          animatedChild = VooSlideAnimation(
            config: config,
            fromOffset: const Offset(1, 0),
            child: widget.children[i],
          );
          break;
        case StaggerAnimationType.slideTop:
          animatedChild = VooSlideAnimation(
            config: config,
            fromOffset: const Offset(0, -1),
            child: widget.children[i],
          );
          break;
        case StaggerAnimationType.slideBottom:
          animatedChild = VooSlideAnimation(
            config: config,
            fromOffset: const Offset(0, 1),
            child: widget.children[i],
          );
          break;
        case StaggerAnimationType.scale:
          animatedChild = VooScaleAnimation(
            config: config,
            child: widget.children[i],
          );
          break;
      }
      
      animatedChildren.add(animatedChild);
    }
    
    if (widget.direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        children: animatedChildren,
      );
    } else {
      return Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        children: animatedChildren,
      );
    }
  }
}