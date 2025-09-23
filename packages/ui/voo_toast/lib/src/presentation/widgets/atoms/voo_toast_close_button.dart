import 'package:flutter/material.dart';

class VooToastCloseButton extends StatefulWidget {
  const VooToastCloseButton({super.key, required this.onPressed, this.size = 20.0, this.color});

  final VoidCallback onPressed;
  final double size;
  final Color? color;

  @override
  State<VooToastCloseButton> createState() => _VooToastCloseButtonState();
}

class _VooToastCloseButtonState extends State<VooToastCloseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rotateAnimation = Tween<double>(begin: 0, end: 0.25).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = widget.color ?? theme.colorScheme.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 3.14159,
            child: Container(
              width: widget.size + 12,
              height: widget.size + 12,
              decoration: BoxDecoration(
                color: buttonColor.withValues(alpha: _controller.value * 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: widget.onPressed,
                icon: Icon(Icons.close_rounded, size: widget.size, color: buttonColor),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: widget.size + 12, height: widget.size + 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
