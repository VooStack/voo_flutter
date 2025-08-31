import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Base hover animation widget
class VooHoverAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Widget Function(BuildContext context, bool isHovered, Widget child) builder;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  final MouseCursor? cursor;
  
  const VooHoverAnimation({
    super.key,
    required this.child,
    required this.builder,
    this.config = const VooAnimationConfig(),
    this.onHover,
    this.onExit,
    this.cursor,
  });
  
  @override
  State<VooHoverAnimation> createState() => _VooHoverAnimationState();
}

class _VooHoverAnimationState extends State<VooHoverAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
      reverseCurve: widget.config.curve.flipped,
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleHoverChange(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });
    
    if (hovering) {
      widget.onHover?.call();
      _controller.forward();
    } else {
      widget.onExit?.call();
      _controller.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: widget.cursor ?? MouseCursor.defer,
      onEnter: (_) => _handleHoverChange(true),
      onExit: (_) => _handleHoverChange(false),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => widget.builder(context, _isHovered, widget.child),
      ),
    );
}

/// Hover grow animation - scales up on hover
class VooHoverGrowAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double growScale;
  final Alignment alignment;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverGrowAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    ),
    this.growScale = 1.05,
    this.alignment = Alignment.center,
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
            begin: 1.0,
            end: isHovered ? growScale : 1.0,
          ),
          builder: (context, scale, child) => Transform.scale(
              scale: scale,
              alignment: alignment,
              child: child,
            ),
          child: child,
        ),
      child: child,
    );
}

/// Hover lift animation - elevates with shadow on hover
class VooHoverLiftAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double liftHeight;
  final double shadowBlur;
  final Color shadowColor;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverLiftAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    ),
    this.liftHeight = 5.0,
    this.shadowBlur = 20.0,
    this.shadowColor = Colors.black26,
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
          builder: (context, value, child) => Transform.translate(
              offset: Offset(0, -liftHeight * value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withValues(alpha: shadowColor.a * value),
                      blurRadius: shadowBlur * value,
                      offset: Offset(0, liftHeight * 2 * value),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          child: child,
        ),
      child: child,
    );
}

/// Hover glow animation - adds glow effect on hover
class VooHoverGlowAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color glowColor;
  final double glowRadius;
  final double glowIntensity;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverGlowAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 300),
    ),
    this.glowColor = Colors.blue,
    this.glowRadius = 20.0,
    this.glowIntensity = 0.8,
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
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: glowIntensity * value),
                    blurRadius: glowRadius * value,
                    spreadRadius: (glowRadius / 2) * value,
                  ),
                ],
              ),
              child: child,
            ),
          child: child,
        ),
      child: child,
    );
}

/// Hover tilt animation - 3D perspective tilt effect on hover
class VooHoverTiltAnimation extends StatefulWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double tiltAngle;
  final bool enableDepth;
  final double depthFactor;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverTiltAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    ),
    this.tiltAngle = 0.05,
    this.enableDepth = true,
    this.depthFactor = 1.0,
    this.onHover,
    this.onExit,
  });
  
  @override
  State<VooHoverTiltAnimation> createState() => _VooHoverTiltAnimationState();
}

class _VooHoverTiltAnimationState extends State<VooHoverTiltAnimation> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;
  
  void _updateTilt(Offset localPosition, Size size) {
    if (!_isHovered) return;
    
    setState(() {
      // Calculate rotation based on mouse position
      _rotateY = (localPosition.dx - size.width / 2) / size.width * widget.tiltAngle;
      _rotateX = -(localPosition.dy - size.height / 2) / size.height * widget.tiltAngle;
    });
  }
  
  void _resetTilt() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
      _isHovered = false;
    });
  }
  
  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() => _isHovered = true);
        widget.onHover?.call();
      },
      onExit: (event) {
        _resetTilt();
        widget.onExit?.call();
      },
      onHover: (event) {
        final RenderBox box = context.findRenderObject()! as RenderBox;
        final localPosition = box.globalToLocal(event.position);
        _updateTilt(localPosition, box.size);
      },
      child: TweenAnimationBuilder<double>(
        duration: widget.config.duration,
        curve: widget.config.curve,
        tween: Tween<double>(
          begin: 0.0,
          end: _isHovered ? 1.0 : 0.0,
        ),
        builder: (context, value, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, widget.enableDepth ? 0.001 * widget.depthFactor : 0)
              ..rotateX(_rotateX * value)
              ..rotateY(_rotateY * value),
            child: child,
          ),
        child: widget.child,
      ),
    );
}

/// Hover shine animation - adds a shine/shimmer effect on hover
class VooHoverShineAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final Color shineColor;
  final double shineWidth;
  final double shineAngle;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverShineAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 600),
    ),
    this.shineColor = Colors.white24,
    this.shineWidth = 0.3,
    this.shineAngle = 45,
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
            begin: -1.0,
            end: isHovered ? 2.0 : -1.0,
          ),
          builder: (context, value, child) => ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  stops: [
                    value - shineWidth,
                    value,
                    value + shineWidth,
                  ].map((e) => e.clamp(0.0, 1.0)).toList(),
                  colors: [
                    Colors.transparent,
                    shineColor,
                    Colors.transparent,
                  ],
                  transform: GradientRotation(shineAngle * 3.14159 / 180),
                ).createShader(bounds),
              blendMode: BlendMode.srcOver,
              child: child,
            ),
          child: child,
        ),
      child: child,
    );
}

/// Hover rotate animation - rotates on hover
class VooHoverRotateAnimation extends StatelessWidget {
  final Widget child;
  final VooAnimationConfig config;
  final double rotationAngle;
  final Axis rotationAxis;
  final VoidCallback? onHover;
  final VoidCallback? onExit;
  
  const VooHoverRotateAnimation({
    super.key,
    required this.child,
    this.config = const VooAnimationConfig(
      duration: Duration(milliseconds: 300),
    ),
    this.rotationAngle = 0.1,
    this.rotationAxis = Axis.vertical,
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
            end: isHovered ? rotationAngle : 0.0,
          ),
          builder: (context, angle, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotate(
                  rotationAxis == Axis.horizontal 
                    ? vector_math.Vector3(1, 0, 0) 
                    : vector_math.Vector3(0, 1, 0),
                  angle,
                ),
              child: child,
            ),
          child: child,
        ),
      child: child,
    );
}