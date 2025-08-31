import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_motion/src/animations/hover_animation.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Hover color change animation
class VooHoverColorAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color? fromColor;
  final Color hoverColor;
  final bool applyToContainer;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverColorAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
    ),
    this.fromColor,
    required this.hoverColor,
    this.applyToContainer = true,
    this.onHover,
    this.onExit,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultColor = fromColor ?? Theme.of(context).cardColor;
    
    return VooHoverAnimation(
      config: config,
      onHover: onHover,
      onExit: onExit,
      cursor: SystemMouseCursors.click,
      builder: (context, isHovered, child) => TweenAnimationBuilder<Color?>(
          duration: config.duration,
          curve: config.curve,
          tween: ColorTween(
            begin: defaultColor,
            end: isHovered ? hoverColor : defaultColor,
          ),
          builder: (context, color, child) {
            if (applyToContainer) {
              return Container(
                color: color,
                child: child,
              );
            } else {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  color ?? Colors.transparent,
                  BlendMode.modulate,
                ),
                child: child,
              );
            }
          },
          child: child,
        ),
      child: child,
    );
  }
}

/// Hover blur background animation
class VooHoverBlurAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double blurAmount;
  final bool blurBackground;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverBlurAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 300),
    ),
    this.blurAmount = 5.0,
    this.blurBackground = true,
    this.onHover,
    this.onExit,
  });
  
  @override
  Widget build(BuildContext context) => VooHoverAnimation(
      config: config,
      onHover: onHover,
      onExit: onExit,
      cursor: SystemMouseCursors.click,
      builder: (context, isHovered, child) => TweenAnimationBuilder<double>(
          duration: config.duration,
          curve: config.curve,
          tween: Tween<double>(
            begin: 0.0,
            end: isHovered ? blurAmount : 0.0,
          ),
          builder: (context, blur, child) {
            if (!blurBackground) {
              return Stack(
                children: [
                  if (blur > 0)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blur,
                          sigmaY: blur,
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  child!,
                ],
              );
            } else {
              return ClipRRect(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    if (blur > 0)
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blur,
                          sigmaY: blur,
                        ),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.01),
                        ),
                      ),
                    child!,
                  ],
                ),
              );
            }
          },
          child: child,
        ),
      child: child,
    );
}

/// Hover underline animation for text
class VooHoverUnderlineAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color underlineColor;
  final double underlineThickness;
  final double underlineOffset;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverUnderlineAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
    ),
    this.underlineColor = Colors.blue,
    this.underlineThickness = 2.0,
    this.underlineOffset = 2.0,
    this.onHover,
    this.onExit,
  });
  
  @override
  Widget build(BuildContext context) => VooHoverAnimation(
      config: config,
      onHover: onHover,
      onExit: onExit,
      cursor: SystemMouseCursors.click,
      builder: (context, isHovered, child) => Stack(
          children: [
            child,
            Positioned(
              left: 0,
              right: 0,
              bottom: -underlineOffset,
              child: TweenAnimationBuilder<double>(
                duration: config.duration,
                curve: config.curve,
                tween: Tween<double>(
                  begin: 0.0,
                  end: isHovered ? 1.0 : 0.0,
                ),
                builder: (context, value, _) => Container(
                    height: underlineThickness,
                    color: underlineColor.withValues(alpha: underlineColor.a * value),
                    transform: Matrix4.diagonal3Values(value, 1.0, 1.0),
                    transformAlignment: Alignment.centerLeft,
                  ),
              ),
            ),
          ],
        ),
      child: child,
    );
}

/// Hover border animation
class VooHoverBorderAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverBorderAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
    ),
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
    this.borderRadius,
    this.onHover,
    this.onExit,
  });
  
  @override
  Widget build(BuildContext context) => VooHoverAnimation(
      config: config,
      onHover: onHover,
      onExit: onExit,
      cursor: SystemMouseCursors.click,
      builder: (context, isHovered, child) => TweenAnimationBuilder<double>(
          duration: config.duration,
          curve: config.curve,
          tween: Tween<double>(
            begin: 0.0,
            end: isHovered ? 1.0 : 0.0,
          ),
          builder: (context, value, child) => DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor.withValues(alpha: borderColor.a * value),
                  width: borderWidth * value,
                ),
                borderRadius: borderRadius,
              ),
              child: child,
            ),
          child: child,
        ),
      child: child,
    );
}