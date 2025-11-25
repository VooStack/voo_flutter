import 'package:flutter/material.dart';

/// Animated glow indicator for selected navigation items
/// Creates a subtle pulsing glow effect behind selected items
class VooGlowIndicator extends StatefulWidget {
  /// Whether the indicator is active
  final bool isActive;

  /// The primary color for the glow
  final Color color;

  /// Width of the indicator
  final double width;

  /// Height of the indicator
  final double height;

  /// Border radius
  final double borderRadius;

  /// Whether to animate the glow
  final bool animate;

  /// Child widget to display on top of the glow
  final Widget? child;

  const VooGlowIndicator({
    super.key,
    required this.isActive,
    required this.color,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = 12,
    this.animate = true,
    this.child,
  });

  @override
  State<VooGlowIndicator> createState() => _VooGlowIndicatorState();
}

class _VooGlowIndicatorState extends State<VooGlowIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive && widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VooGlowIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && widget.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child ?? const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: widget.animate ? _glowAnimation.value * 0.3 : 0.15,
                ),
                blurRadius: 16,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: widget.color.withValues(
                  alpha: widget.animate ? _glowAnimation.value * 0.15 : 0.08,
                ),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Left edge accent bar indicator for selected items
class VooEdgeIndicator extends StatelessWidget {
  /// Whether the indicator is visible
  final bool isActive;

  /// The color of the indicator
  final Color color;

  /// Height of the indicator (usually matches item height)
  final double height;

  /// Width of the indicator bar
  final double width;

  /// Border radius
  final BorderRadius? borderRadius;

  const VooEdgeIndicator({
    super.key,
    required this.isActive,
    required this.color,
    this.height = 32,
    this.width = 3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: width,
      height: isActive ? height : 0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ??
            BorderRadius.only(
              topRight: Radius.circular(width),
              bottomRight: Radius.circular(width),
            ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ]
            : null,
      ),
    );
  }
}
