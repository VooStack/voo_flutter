import 'package:flutter/material.dart';
import 'package:voo_ui/src/foundations/design_system.dart';

/// Material 3 circular progress indicator
class VooCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double strokeWidth;
  final double strokeAlign;
  final StrokeCap? strokeCap;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double size;
  
  const VooCircularProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.strokeWidth = 4.0,
    this.strokeAlign = CircularProgressIndicator.strokeAlignCenter,
    this.strokeCap,
    this.semanticsLabel,
    this.semanticsValue,
    this.size = 40.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        color: color,
        strokeWidth: strokeWidth,
        strokeAlign: strokeAlign,
        strokeCap: strokeCap,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

/// Material 3 linear progress indicator
class VooLinearProgressIndicator extends StatelessWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final double minHeight;
  final BorderRadiusGeometry? borderRadius;
  final String? semanticsLabel;
  final String? semanticsValue;
  
  const VooLinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.minHeight = 4.0,
    this.borderRadius,
    this.semanticsLabel,
    this.semanticsValue,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(design.radiusXs),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        color: color,
        minHeight: minHeight,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

/// Labeled progress indicator with percentage
class VooLabeledProgress extends StatelessWidget {
  final double? value;
  final String? label;
  final bool showPercentage;
  final bool isLinear;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final TextStyle? labelStyle;
  final TextStyle? percentageStyle;
  
  const VooLabeledProgress({
    super.key,
    this.value,
    this.label,
    this.showPercentage = true,
    this.isLinear = true,
    this.color,
    this.backgroundColor,
    this.size,
    this.labelStyle,
    this.percentageStyle,
  });
  
  String get _percentageText {
    if (value == null) return '';
    final percentage = (value! * 100).round();
    return '$percentage%';
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
                ),
              if (showPercentage && value != null)
                Text(
                  _percentageText,
                  style: percentageStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: design.spacingSm),
        ],
        if (isLinear)
          VooLinearProgressIndicator(
            value: value,
            color: color,
            backgroundColor: backgroundColor,
            minHeight: size ?? 8.0,
          )
        else
          Center(
            child: VooCircularProgressIndicator(
              value: value,
              color: color,
              backgroundColor: backgroundColor,
              size: size ?? 40.0,
            ),
          ),
      ],
    );
  }
}

/// Step progress indicator
class VooStepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final double spacing;
  final BorderRadiusGeometry? borderRadius;
  final bool showLabels;
  final List<String>? stepLabels;
  
  const VooStepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.height = 4.0,
    this.spacing = 4.0,
    this.borderRadius,
    this.showLabels = false,
    this.stepLabels,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isCurrent = index == currentStep;
            
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                height: height,
                decoration: BoxDecoration(
                  color: isActive || isCurrent
                    ? (activeColor ?? colorScheme.primary)
                    : (inactiveColor ?? colorScheme.surfaceContainerHighest),
                  borderRadius: borderRadius ?? BorderRadius.circular(design.radiusXs),
                ),
              ),
            );
          }),
        ),
        if (showLabels && stepLabels != null && stepLabels!.length == totalSteps) ...[
          SizedBox(height: design.spacingSm),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              
              return Expanded(
                child: Text(
                  stepLabels![index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// Circular progress with center content
class VooCircularProgressWithContent extends StatelessWidget {
  final double? value;
  final Widget child;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  
  const VooCircularProgressWithContent({
    super.key,
    this.value,
    required this.child,
    this.size = 80.0,
    this.strokeWidth = 4.0,
    this.progressColor,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VooCircularProgressIndicator(
            value: value,
            size: size,
            strokeWidth: strokeWidth,
            color: progressColor,
            backgroundColor: backgroundColor,
          ),
          child,
        ],
      ),
    );
  }
}

/// Skeleton loader for content placeholders
class VooSkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final Widget? child;
  
  const VooSkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.child,
  });
  
  @override
  State<VooSkeletonLoader> createState() => _VooSkeletonLoaderState();
}

class _VooSkeletonLoaderState extends State<VooSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height ?? 20,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(design.radiusSm),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(-1.0 + _animation.value + 0.5, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// List skeleton loader
class VooListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;
  final bool showAvatar;
  final bool showSubtitle;
  final EdgeInsetsGeometry? padding;
  
  const VooListSkeletonLoader({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 72.0,
    this.spacing = 8.0,
    this.showAvatar = true,
    this.showSubtitle = true,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Padding(
      padding: padding ?? EdgeInsets.all(design.spacingMd),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < itemCount - 1 ? spacing : 0),
            child: SizedBox(
              height: itemHeight,
              child: Row(
                children: [
                  if (showAvatar) ...[
                    VooSkeletonLoader(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    SizedBox(width: design.spacingMd),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VooSkeletonLoader(
                          height: 16,
                          width: double.infinity,
                        ),
                        if (showSubtitle) ...[
                          SizedBox(height: design.spacingSm),
                          VooSkeletonLoader(
                            height: 14,
                            width: 200,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Card skeleton loader
class VooCardSkeletonLoader extends StatelessWidget {
  final double? width;
  final double height;
  final bool showImage;
  final bool showTitle;
  final bool showSubtitle;
  final bool showActions;
  final EdgeInsetsGeometry? margin;
  
  const VooCardSkeletonLoader({
    super.key,
    this.width,
    this.height = 200.0,
    this.showImage = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showActions = false,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage)
              VooSkeletonLoader(
                height: height * 0.6,
                width: double.infinity,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(design.radiusMd),
                ),
              ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(design.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: showActions 
                      ? MainAxisAlignment.spaceBetween 
                      : MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showTitle)
                            VooSkeletonLoader(
                              height: 16,
                              width: double.infinity,
                            ),
                          if (showSubtitle) ...[
                            SizedBox(height: design.spacingXs),
                            VooSkeletonLoader(
                              height: 14,
                              width: 150,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showActions) ...[
                      SizedBox(height: design.spacingXs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          VooSkeletonLoader(
                            height: 24,
                            width: 60,
                            borderRadius: BorderRadius.circular(design.radiusSm),
                          ),
                          SizedBox(width: design.spacingXs),
                          VooSkeletonLoader(
                            height: 24,
                            width: 60,
                            borderRadius: BorderRadius.circular(design.radiusSm),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer effect widget
class VooShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool enabled;
  
  const VooShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });
  
  @override
  State<VooShimmer> createState() => _VooShimmerState();
}

class _VooShimmerState extends State<VooShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;
    
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(-1.0 + _animation.value + 1.0, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// Progress ring indicator
class VooProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final StrokeCap strokeCap;
  
  const VooProgressRing({
    super.key,
    required this.value,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.progressColor,
    this.backgroundColor,
    this.child,
    this.strokeCap = StrokeCap.round,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          value: value,
          strokeWidth: strokeWidth,
          progressColor: progressColor ?? colorScheme.primary,
          backgroundColor: backgroundColor ?? colorScheme.surfaceContainerHighest,
          strokeCap: strokeCap,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final StrokeCap strokeCap;
  
  _ProgressRingPainter({
    required this.value,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeCap,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap;
    
    const startAngle = -90 * (3.141592653589793 / 180);
    final sweepAngle = value * 2 * 3.141592653589793;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return value != oldDelegate.value ||
           strokeWidth != oldDelegate.strokeWidth ||
           progressColor != oldDelegate.progressColor ||
           backgroundColor != oldDelegate.backgroundColor ||
           strokeCap != oldDelegate.strokeCap;
  }
}