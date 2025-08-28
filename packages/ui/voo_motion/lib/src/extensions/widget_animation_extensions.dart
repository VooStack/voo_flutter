import 'package:flutter/material.dart';
import 'package:voo_motion/src/animations/drop_animation.dart';
import 'package:voo_motion/src/animations/fade_animation.dart';
import 'package:voo_motion/src/animations/slide_animation.dart';
import 'package:voo_motion/src/animations/scale_animation.dart';
import 'package:voo_motion/src/animations/rotation_animation.dart';
import 'package:voo_motion/src/animations/bounce_animation.dart';
import 'package:voo_motion/src/animations/shake_animation.dart';
import 'package:voo_motion/src/animations/flip_animation.dart';
import 'package:voo_motion/src/animations/blur_animation.dart';
import 'package:voo_motion/src/animations/glow_animation.dart';
import 'package:voo_motion/src/animations/pulse_animation.dart';
import 'package:voo_motion/src/animations/shimmer_animation.dart';
import 'package:voo_motion/src/animations/wave_animation.dart';
import 'package:voo_motion/src/animations/ripple_animation.dart';
import 'package:voo_motion/src/animations/parallax_animation.dart';
import 'package:voo_motion/src/animations/hover_animation.dart';
import 'package:voo_motion/src/animations/hover_color_animation.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Extension methods to easily apply animations to any widget
extension VooMotionExtensions on Widget {
  /// Drop in animation - widget drops from above with a bounce
  Widget dropIn({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? fromHeight,
    VoidCallback? onStart,
    VoidCallback? onComplete,
    bool repeat = false,
    bool reverse = false,
    int repeatCount = 1,
    bool autoPlay = true,
  }) {
    return VooDropAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 600),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.bounceOut,
        onStart: onStart,
        onComplete: onComplete,
        repeat: repeat,
        reverse: reverse,
        repeatCount: repeatCount,
        autoPlay: autoPlay,
      ),
      fromHeight: fromHeight ?? 50,
      child: this,
    );
  }
  
  /// Fade in animation
  Widget fadeIn({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? from,
    double? to,
    VoidCallback? onStart,
    VoidCallback? onComplete,
    bool repeat = false,
    bool reverse = false,
    int repeatCount = 1,
    bool autoPlay = true,
  }) {
    return VooFadeAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeIn,
        onStart: onStart,
        onComplete: onComplete,
        repeat: repeat,
        reverse: reverse,
        repeatCount: repeatCount,
        autoPlay: autoPlay,
      ),
      fromOpacity: from ?? 0.0,
      toOpacity: to ?? 1.0,
      child: this,
    );
  }
  
  /// Fade out animation
  Widget fadeOut({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? to,
    VoidCallback? onComplete,
  }) {
    return VooFadeAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOut,
        onComplete: onComplete,
      ),
      fromOpacity: 1.0,
      toOpacity: to ?? 0.0,
      child: this,
    );
  }
  
  /// Slide in from left
  Widget slideInLeft({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? offset,
    VoidCallback? onComplete,
  }) {
    return VooSlideAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOutCubic,
        onComplete: onComplete,
      ),
      fromOffset: Offset(-(offset ?? 1.0), 0),
      toOffset: Offset.zero,
      child: this,
    );
  }
  
  /// Slide in from right
  Widget slideInRight({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? offset,
    VoidCallback? onComplete,
  }) {
    return VooSlideAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOutCubic,
        onComplete: onComplete,
      ),
      fromOffset: Offset(offset ?? 1.0, 0),
      toOffset: Offset.zero,
      child: this,
    );
  }
  
  /// Slide in from top
  Widget slideInTop({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? offset,
    VoidCallback? onComplete,
  }) {
    return VooSlideAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOutCubic,
        onComplete: onComplete,
      ),
      fromOffset: Offset(0, -(offset ?? 1.0)),
      toOffset: Offset.zero,
      child: this,
    );
  }
  
  /// Slide in from bottom
  Widget slideInBottom({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? offset,
    VoidCallback? onComplete,
  }) {
    return VooSlideAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOutCubic,
        onComplete: onComplete,
      ),
      fromOffset: Offset(0, offset ?? 1.0),
      toOffset: Offset.zero,
      child: this,
    );
  }
  
  /// Scale in animation
  Widget scaleIn({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? from,
    double? to,
    VoidCallback? onComplete,
  }) {
    return VooScaleAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.elasticOut,
        onComplete: onComplete,
      ),
      fromScale: from ?? 0.0,
      toScale: to ?? 1.0,
      child: this,
    );
  }
  
  /// Scale out animation
  Widget scaleOut({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? from,
    double? to,
    VoidCallback? onComplete,
  }) {
    return VooScaleAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInBack,
        onComplete: onComplete,
      ),
      fromScale: from ?? 1.0,
      toScale: to ?? 0.0,
      child: this,
    );
  }
  
  /// Rotate animation
  Widget rotate({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? from,
    double? to,
    bool repeat = false,
    VoidCallback? onComplete,
  }) {
    return VooRotationAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 1000),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.linear,
        repeat: repeat,
        onComplete: onComplete,
      ),
      fromAngle: from ?? 0.0,
      toAngle: to ?? 6.28319, // 2 * pi
      child: this,
    );
  }
  
  /// Bounce animation
  Widget bounce({
    Duration? duration,
    Duration? delay,
    double? height,
    int? bounces,
    bool repeat = false,
    VoidCallback? onComplete,
  }) {
    return VooBounceAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 1000),
        delay: delay ?? Duration.zero,
        repeat: repeat,
        onComplete: onComplete,
      ),
      bounceHeight: height ?? 20,
      numberOfBounces: bounces ?? 3,
      child: this,
    );
  }
  
  /// Shake animation
  Widget shake({
    Duration? duration,
    Duration? delay,
    double? intensity,
    int? shakes,
    VoidCallback? onComplete,
  }) {
    return VooShakeAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        onComplete: onComplete,
      ),
      intensity: intensity ?? 10,
      numberOfShakes: shakes ?? 5,
      child: this,
    );
  }
  
  /// Flip animation (horizontal)
  Widget flipX({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return VooFlipAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 600),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
      ),
      direction: FlipDirection.horizontal,
      child: this,
    );
  }
  
  /// Flip animation (vertical)
  Widget flipY({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return VooFlipAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 600),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
      ),
      direction: FlipDirection.vertical,
      child: this,
    );
  }
  
  /// Chain multiple animations together
  Widget animate(List<Widget Function(Widget)> animations) {
    Widget result = this;
    for (final animation in animations) {
      result = animation(result);
    }
    return result;
  }
  
  /// Blur animation
  Widget blur({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? fromBlur,
    double? toBlur,
    double? blurX,
    double? blurY,
    VoidCallback? onComplete,
    bool repeat = false,
    bool reverse = false,
    bool autoPlay = true,
  }) {
    return VooBlurAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
        repeat: repeat,
        reverse: reverse,
        autoPlay: autoPlay,
      ),
      fromBlur: fromBlur ?? 10.0,
      toBlur: toBlur ?? 0.0,
      blurX: blurX ?? 0.0,
      blurY: blurY ?? 0.0,
      child: this,
    );
  }
  
  /// Glow animation
  Widget glow({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    Color? glowColor,
    double? minRadius,
    double? maxRadius,
    double? intensity,
    VoidCallback? onComplete,
    bool repeat = false,
    bool reverse = false,
    bool autoPlay = true,
  }) {
    return VooGlowAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 1000),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
        repeat: repeat,
        reverse: reverse,
        autoPlay: autoPlay,
      ),
      glowColor: glowColor ?? Colors.blue,
      minGlowRadius: minRadius ?? 0.0,
      maxGlowRadius: maxRadius ?? 20.0,
      glowIntensity: intensity ?? 0.8,
      child: this,
    );
  }
  
  /// Pulse animation
  Widget pulse({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? minScale,
    double? maxScale,
    Color? pulseColor,
    double? pulseOpacity,
    bool showPulseEffect = false,
    VoidCallback? onComplete,
    bool repeat = true,
    bool autoPlay = true,
  }) {
    return VooPulseAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 1000),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
        repeat: repeat,
        autoPlay: autoPlay,
      ),
      minScale: minScale ?? 0.95,
      maxScale: maxScale ?? 1.05,
      pulseColor: pulseColor,
      pulseOpacity: pulseOpacity ?? 0.3,
      showPulseEffect: showPulseEffect,
      child: this,
    );
  }
  
  /// Shimmer loading animation
  Widget shimmer({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    Color? baseColor,
    Color? highlightColor,
    double? shimmerWidth,
    ShimmerDirection? direction,
    VoidCallback? onComplete,
    bool repeat = true,
    bool autoPlay = true,
  }) {
    return VooShimmerAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 1500),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.linear,
        onComplete: onComplete,
        repeat: repeat,
        autoPlay: autoPlay,
      ),
      baseColor: baseColor ?? const Color(0xFFE0E0E0),
      highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
      shimmerWidth: shimmerWidth ?? 0.5,
      direction: direction ?? ShimmerDirection.leftToRight,
      child: this,
    );
  }
  
  /// Wave animation
  Widget wave({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? waveHeight,
    double? waveCount,
    WaveType? waveType,
    Axis? direction,
    VoidCallback? onComplete,
    bool repeat = true,
    bool autoPlay = true,
  }) {
    return VooWaveAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 2000),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeInOut,
        onComplete: onComplete,
        repeat: repeat,
        autoPlay: autoPlay,
      ),
      waveHeight: waveHeight ?? 20.0,
      waveCount: waveCount ?? 1.0,
      waveType: waveType ?? WaveType.sin,
      direction: direction ?? Axis.vertical,
      child: this,
    );
  }
  
  /// Ripple animation
  Widget ripple({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    Color? rippleColor,
    int? rippleCount,
    double? minRadius,
    double? maxRadius,
    Duration? rippleDelay,
    VoidCallback? onComplete,
    bool repeat = true,
    bool autoPlay = true,
  }) {
    return VooRippleAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 2000),
        delay: delay ?? Duration.zero,
        curve: curve ?? Curves.easeOut,
        onComplete: onComplete,
        repeat: repeat,
        autoPlay: autoPlay,
      ),
      rippleColor: rippleColor ?? Colors.blue,
      rippleCount: rippleCount ?? 3,
      minRadius: minRadius ?? 30,
      maxRadius: maxRadius ?? 150,
      rippleDelay: rippleDelay ?? const Duration(milliseconds: 300),
      child: this,
    );
  }
  
  /// Parallax animation for scroll effects
  Widget parallax({
    ScrollController? scrollController,
    double? parallaxFactor,
    Axis? scrollDirection,
    bool reversed = false,
    Alignment? alignment,
  }) {
    return VooParallaxAnimation(
      scrollController: scrollController,
      parallaxFactor: parallaxFactor ?? 0.5,
      scrollDirection: scrollDirection ?? Axis.vertical,
      reversed: reversed,
      alignment: alignment ?? Alignment.center,
      child: this,
    );
  }
  
  /// Hover grow animation
  Widget hoverGrow({
    double? growScale,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverGrowAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeOutCubic,
      ),
      growScale: growScale ?? 1.05,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover lift animation
  Widget hoverLift({
    double? liftHeight,
    double? shadowBlur,
    Color? shadowColor,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverLiftAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeOutCubic,
      ),
      liftHeight: liftHeight ?? 5.0,
      shadowBlur: shadowBlur ?? 20.0,
      shadowColor: shadowColor ?? Colors.black26,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover glow animation
  Widget hoverGlow({
    Color? glowColor,
    double? glowRadius,
    double? glowIntensity,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverGlowAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 300),
        curve: curve ?? Curves.easeInOut,
      ),
      glowColor: glowColor ?? Colors.blue,
      glowRadius: glowRadius ?? 20.0,
      glowIntensity: glowIntensity ?? 0.8,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover tilt animation
  Widget hoverTilt({
    double? tiltAngle,
    bool? enableDepth,
    double? depthFactor,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverTiltAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeOutCubic,
      ),
      tiltAngle: tiltAngle ?? 0.05,
      enableDepth: enableDepth ?? true,
      depthFactor: depthFactor ?? 1.0,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover shine animation
  Widget hoverShine({
    Color? shineColor,
    double? shineWidth,
    double? shineAngle,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverShineAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 600),
        curve: curve ?? Curves.easeInOut,
      ),
      shineColor: shineColor ?? Colors.white24,
      shineWidth: shineWidth ?? 0.3,
      shineAngle: shineAngle ?? 45,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover rotate animation
  Widget hoverRotate({
    double? rotationAngle,
    Axis? rotationAxis,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverRotateAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 300),
        curve: curve ?? Curves.easeInOut,
      ),
      rotationAngle: rotationAngle ?? 0.1,
      rotationAxis: rotationAxis ?? Axis.vertical,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover color animation
  Widget hoverColor({
    required Color hoverColor,
    Color? fromColor,
    bool? applyToContainer,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverColorAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeInOut,
      ),
      fromColor: fromColor,
      hoverColor: hoverColor,
      applyToContainer: applyToContainer ?? true,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover blur animation
  Widget hoverBlur({
    double? blurAmount,
    bool? blurBackground,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverBlurAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 300),
        curve: curve ?? Curves.easeInOut,
      ),
      blurAmount: blurAmount ?? 5.0,
      blurBackground: blurBackground ?? true,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover underline animation
  Widget hoverUnderline({
    Color? underlineColor,
    double? thickness,
    double? offset,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverUnderlineAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeInOut,
      ),
      underlineColor: underlineColor ?? Colors.blue,
      underlineThickness: thickness ?? 2.0,
      underlineOffset: offset ?? 2.0,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Hover border animation
  Widget hoverBorder({
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    Duration? duration,
    Curve? curve,
    VoidCallback? onHover,
    VoidCallback? onExit,
  }) {
    return VooHoverBorderAnimation(
      config: VooAnimationConfig(
        duration: duration ?? const Duration(milliseconds: 200),
        curve: curve ?? Curves.easeInOut,
      ),
      borderColor: borderColor ?? Colors.blue,
      borderWidth: borderWidth ?? 2.0,
      borderRadius: borderRadius,
      onHover: onHover,
      onExit: onExit,
      child: this,
    );
  }
  
  /// Apply animation with custom configuration
  Widget withAnimation({
    required Widget Function(Widget child, VooAnimationConfig config) builder,
    VooAnimationConfig config = const VooAnimationConfig(),
  }) {
    return builder(this, config);
  }
}