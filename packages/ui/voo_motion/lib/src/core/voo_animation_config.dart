import 'package:flutter/material.dart';

/// Configuration for VooMotion animations
class VooAnimationConfig {
  /// Duration of the animation
  final Duration duration;
  
  /// Delay before the animation starts
  final Duration delay;
  
  /// Animation curve
  final Curve curve;
  
  /// Whether the animation should repeat
  final bool repeat;
  
  /// Whether the animation should reverse
  final bool reverse;
  
  /// Number of times to repeat (-1 for infinite)
  final int repeatCount;
  
  /// Callback when animation starts
  final VoidCallback? onStart;
  
  /// Callback when animation completes
  final VoidCallback? onComplete;
  
  /// Whether to auto-play the animation
  final bool autoPlay;
  
  const VooAnimationConfig({
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.reverse = false,
    this.repeatCount = 1,
    this.onStart,
    this.onComplete,
    this.autoPlay = true,
  });
  
  /// Create a copy with modified values
  VooAnimationConfig copyWith({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    bool? repeat,
    bool? reverse,
    int? repeatCount,
    VoidCallback? onStart,
    VoidCallback? onComplete,
    bool? autoPlay,
  }) {
    return VooAnimationConfig(
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      repeat: repeat ?? this.repeat,
      reverse: reverse ?? this.reverse,
      repeatCount: repeatCount ?? this.repeatCount,
      onStart: onStart ?? this.onStart,
      onComplete: onComplete ?? this.onComplete,
      autoPlay: autoPlay ?? this.autoPlay,
    );
  }
  
  /// Quick config for fast animations
  static const VooAnimationConfig fast = VooAnimationConfig(
    duration: Duration(milliseconds: 300),
  );
  
  /// Quick config for slow animations
  static const VooAnimationConfig slow = VooAnimationConfig(
    duration: Duration(milliseconds: 800),
  );
  
  /// Quick config for spring animations
  static const VooAnimationConfig spring = VooAnimationConfig(
    curve: Curves.elasticOut,
    duration: Duration(milliseconds: 800),
  );
  
  /// Quick config for bounce animations
  static const VooAnimationConfig bounce = VooAnimationConfig(
    curve: Curves.bounceOut,
    duration: Duration(milliseconds: 600),
  );
}