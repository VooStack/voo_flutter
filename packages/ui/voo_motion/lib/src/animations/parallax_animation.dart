import 'package:flutter/material.dart';

/// Parallax animation widget that creates depth effect with scroll
class VooParallaxAnimation extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final double parallaxFactor;
  final Axis scrollDirection;
  final bool reversed;
  final Alignment alignment;
  
  const VooParallaxAnimation({
    super.key,
    required this.child,
    this.scrollController,
    this.parallaxFactor = 0.5,
    this.scrollDirection = Axis.vertical,
    this.reversed = false,
    this.alignment = Alignment.center,
  });
  
  @override
  State<VooParallaxAnimation> createState() => _VooParallaxAnimationState();
}

class _VooParallaxAnimationState extends State<VooParallaxAnimation> {
  ScrollController? _scrollController;
  double _scrollOffset = 0;
  
  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? _findScrollController();
    _scrollController?.addListener(_onScroll);
  }
  
  ScrollController? _findScrollController() {
    // Try to find a scroll controller in the widget tree
    ScrollController? controller;
    context.visitAncestorElements((element) {
      if (element.widget is ScrollView) {
        final scrollView = element.widget as ScrollView;
        controller = scrollView.controller;
        return false;
      }
      return true;
    });
    return controller;
  }
  
  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollOffset = _scrollController?.offset ?? 0;
      });
    }
  }
  
  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final parallaxOffset = _scrollOffset * widget.parallaxFactor * (widget.reversed ? -1 : 1);
    final offset = widget.scrollDirection == Axis.vertical
        ? Offset(0, parallaxOffset)
        : Offset(parallaxOffset, 0);
    
    return Transform.translate(
      offset: offset,
      child: widget.child,
    );
  }
}

/// Parallax container with multiple layers
class VooParallaxContainer extends StatelessWidget {
  final List<ParallaxLayer> layers;
  final ScrollController? scrollController;
  final double height;
  final double width;
  
  const VooParallaxContainer({
    super.key,
    required this.layers,
    this.scrollController,
    this.height = 200,
    this.width = double.infinity,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: layers.map((layer) {
          return VooParallaxAnimation(
            scrollController: scrollController,
            parallaxFactor: layer.parallaxFactor,
            alignment: layer.alignment,
            child: layer.child,
          );
        }).toList(),
      ),
    );
  }
}

class ParallaxLayer {
  final Widget child;
  final double parallaxFactor;
  final Alignment alignment;
  
  const ParallaxLayer({
    required this.child,
    this.parallaxFactor = 0.5,
    this.alignment = Alignment.center,
  });
}