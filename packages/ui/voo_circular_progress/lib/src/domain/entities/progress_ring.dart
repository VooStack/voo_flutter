import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single progress ring in the circular progress indicator.
///
/// Each ring displays progress as a ratio of [current] to [goal] values.
/// The ring is rendered with the specified [color] and [strokeWidth].
class ProgressRing extends Equatable {
  /// Creates a progress ring with current and goal values.
  ///
  /// The [current] value represents the current progress value.
  /// The [goal] value represents the target or maximum value.
  /// The [color] defines the color of the ring.
  /// The [strokeWidth] defines the thickness of the ring.
  /// The [backgroundColor] is optional and defines the background ring color.
  /// The [startAngle] defines where the ring starts (in radians, default is -π/2 for top).
  const ProgressRing({
    required this.current,
    required this.goal,
    required this.color,
    this.strokeWidth = 12.0,
    this.backgroundColor,
    this.startAngle = -1.5707963267948966, // -π/2
    this.capStyle = StrokeCap.round,
  }) : assert(current >= 0, 'Current value must be non-negative'),
       assert(goal > 0, 'Goal value must be positive'),
       assert(strokeWidth > 0, 'Stroke width must be positive');

  /// The current progress value.
  final double current;

  /// The goal or target value.
  final double goal;

  /// The color of the progress ring.
  final Color color;

  /// The width of the ring stroke.
  final double strokeWidth;

  /// The background color of the ring (optional).
  /// If not provided, a semi-transparent version of [color] will be used.
  final Color? backgroundColor;

  /// The starting angle of the ring in radians.
  /// Default is -π/2 (top of the circle).
  final double startAngle;

  /// The style of the stroke cap.
  /// Default is [StrokeCap.round] for smooth rounded ends.
  final StrokeCap capStyle;

  /// Returns the progress percentage (0.0 to 1.0).
  double get progress {
    if (goal == 0) return 0.0;
    return (current / goal).clamp(0.0, 1.0);
  }

  /// Returns the percentage as a whole number (0 to 100).
  int get percentageInt => (progress * 100).round();

  /// Returns whether the goal has been reached or exceeded.
  bool get isGoalReached => current >= goal;

  /// Creates a copy of this ring with optional new values.
  ProgressRing copyWith({
    double? current,
    double? goal,
    Color? color,
    double? strokeWidth,
    Color? backgroundColor,
    double? startAngle,
    StrokeCap? capStyle,
  }) =>
      ProgressRing(
        current: current ?? this.current,
        goal: goal ?? this.goal,
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        startAngle: startAngle ?? this.startAngle,
        capStyle: capStyle ?? this.capStyle,
      );

  @override
  List<Object?> get props => [
        current,
        goal,
        color,
        strokeWidth,
        backgroundColor,
        startAngle,
        capStyle,
      ];
}
