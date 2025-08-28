import 'package:flutter/material.dart';

/// Enhanced hero animation widget with additional features
class VooHeroAnimation extends StatelessWidget {
  final String tag;
  final Widget child;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool transitionOnUserGestures;
  
  const VooHeroAnimation({
    super.key,
    required this.tag,
    required this.child,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: child,
    );
  }
  
  /// Create a material-style hero animation
  static Widget material({
    required String tag,
    required Widget child,
  }) {
    return Hero(
      tag: tag,
      createRectTween: (begin, end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
  
  /// Create a radial hero animation
  static Widget radial({
    required String tag,
    required Widget child,
    double maxRadius = 200,
  }) {
    return Hero(
      tag: tag,
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      child: ClipOval(
        child: child,
      ),
    );
  }
}