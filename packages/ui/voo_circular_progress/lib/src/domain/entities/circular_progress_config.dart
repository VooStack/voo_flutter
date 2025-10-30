import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Configuration for the circular progress indicator.
///
/// This class defines the global settings that apply to all rings
/// in the circular progress indicator.
class CircularProgressConfig extends Equatable {
  /// Creates a circular progress configuration.
  ///
  /// The [size] defines the diameter of the entire circular progress indicator.
  /// The [gapBetweenRings] defines the spacing between concentric rings.
  /// The [animationDuration] defines how long animations take to complete.
  /// The [animationCurve] defines the easing curve for animations.
  const CircularProgressConfig({
    this.size = 200.0,
    this.gapBetweenRings = 8.0,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOutCubic,
  }) : assert(size > 0, 'Size must be positive'),
       assert(gapBetweenRings >= 0, 'Gap between rings must be non-negative');

  /// The overall size (diameter) of the circular progress indicator.
  final double size;

  /// The gap between concentric rings.
  final double gapBetweenRings;

  /// The duration for progress animations.
  final Duration animationDuration;

  /// The animation curve for smooth transitions.
  final Curve animationCurve;

  /// Creates a copy of this config with optional new values.
  CircularProgressConfig copyWith({
    double? size,
    double? gapBetweenRings,
    Duration? animationDuration,
    Curve? animationCurve,
  }) =>
      CircularProgressConfig(
        size: size ?? this.size,
        gapBetweenRings: gapBetweenRings ?? this.gapBetweenRings,
        animationDuration: animationDuration ?? this.animationDuration,
        animationCurve: animationCurve ?? this.animationCurve,
      );

  @override
  List<Object?> get props => [
        size,
        gapBetweenRings,
        animationDuration,
        animationCurve,
      ];
}
