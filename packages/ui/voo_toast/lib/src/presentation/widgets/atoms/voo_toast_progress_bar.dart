import 'package:flutter/material.dart';

class VooToastProgressBar extends StatefulWidget {
  const VooToastProgressBar({
    super.key,
    required this.duration,
    this.height = 3.0,
    this.color,
    this.backgroundColor,
  });

  final Duration duration;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  @override
  State<VooToastProgressBar> createState() => _VooToastProgressBarState();
}

class _VooToastProgressBarState extends State<VooToastProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = widget.color ?? theme.colorScheme.primary;
    
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? 
            progressColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: TweenAnimationBuilder<double>(
        duration: widget.duration,
        tween: Tween<double>(begin: 1.0, end: 0.0),
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(widget.height / 2),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          progressColor.withValues(alpha: 0.8),
                          progressColor,
                          progressColor.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            transform: GradientTranslation(_shimmerAnimation.value),
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.srcOver,
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GradientTranslation extends GradientTransform {
  const GradientTranslation(this.translate);
  
  final double translate;
  
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * translate, 0, 0);
  }
}