import 'package:flutter/material.dart';

/// Custom curves for VooMotion animations
class VooMotionCurve {
  /// Smooth ease in and out
  static const Curve smooth = Curves.easeInOut;
  
  /// Sharp ease in and out
  static const Curve sharp = Curves.fastOutSlowIn;
  
  /// Spring effect
  static const Curve spring = Curves.elasticOut;
  
  /// Bounce effect
  static const Curve bounce = Curves.bounceOut;
  
  /// Linear animation
  static const Curve linear = Curves.linear;
  
  /// Fast start, slow end
  static const Curve decelerate = Curves.decelerate;
  
  /// Slow start, fast end
  static const Curve accelerate = Curves.easeIn;
  
  /// Back ease in
  static const Curve anticipate = Curves.elasticIn;
  
  /// Overshoot then settle
  static const Curve overshoot = Curves.elasticInOut;
  
  /// Custom spring curve with configurable tension
  static Curve springCurve({double tension = 1.0}) {
    return ElasticOutCurve(tension);
  }
  
  /// Custom bounce curve with configurable bounces
  static Curve bounceCurve({int bounces = 3}) {
    return _CustomBounceCurve(bounces);
  }
}

/// Custom bounce curve implementation
class _CustomBounceCurve extends Curve {
  final int bounces;
  
  const _CustomBounceCurve(this.bounces);
  
  @override
  double transformInternal(double t) {
    if (t == 1.0) return 1.0;
    
    double amplitude = 1.0;
    double period = 1.0 / (bounces + 1);
    
    if (t < period) {
      return amplitude * t / period;
    }
    
    for (int i = 1; i <= bounces; i++) {
      amplitude *= 0.4;
      if (t < period * (i + 1)) {
        final double localT = (t - period * i) / period;
        return 1.0 - amplitude * (1.0 - localT);
      }
    }
    
    return 1.0;
  }
}