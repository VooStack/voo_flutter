import 'package:flutter/material.dart';
import 'package:voo_motion/src/core/voo_animation_config.dart';

/// Typewriter animation for text that appears character by character
class VooTypewriterAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VooAnimationConfig config;
  final bool showCursor;
  final String cursor;
  final Duration cursorBlinkDuration;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const VooTypewriterAnimation({
    super.key,
    required this.text,
    this.style,
    this.config = const VooAnimationConfig(),
    this.showCursor = true,
    this.cursor = '|',
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<VooTypewriterAnimation> createState() => _VooTypewriterAnimationState();
}

class _VooTypewriterAnimationState extends State<VooTypewriterAnimation> with TickerProviderStateMixin {
  late AnimationController _typeController;
  late AnimationController _cursorController;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();

    final textLength = widget.text.length;
    final duration = widget.config.duration;

    _typeController = AnimationController(duration: duration, vsync: this);

    _cursorController = AnimationController(duration: widget.cursorBlinkDuration, vsync: this);

    _characterCount = StepTween(begin: 0, end: textLength).animate(CurvedAnimation(parent: _typeController, curve: widget.config.curve));

    if (widget.config.autoPlay) {
      Future.delayed(widget.config.delay, () {
        if (mounted) {
          widget.config.onStart?.call();
          _typeController.forward().then((_) {
            widget.config.onComplete?.call();
            if (widget.showCursor) {
              _cursorController.repeat(reverse: true);
            }
            if (widget.config.repeat) {
              _handleRepeat();
            }
          });
        }
      });
    }
  }

  void _handleRepeat() {
    if (!mounted) return;

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _typeController.reset();
        _typeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _typeController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _characterCount,
    builder: (context, child) {
      final text = widget.text.substring(0, _characterCount.value);

      if (widget.showCursor) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: widget.style, textAlign: widget.textAlign, maxLines: widget.maxLines, overflow: widget.overflow),
            AnimatedBuilder(
              animation: _cursorController,
              builder: (context, _) => Opacity(
                opacity: _cursorController.value,
                child: Text(widget.cursor, style: widget.style),
              ),
            ),
          ],
        );
      }

      return Text(text, style: widget.style, textAlign: widget.textAlign, maxLines: widget.maxLines, overflow: widget.overflow);
    },
  );
}
