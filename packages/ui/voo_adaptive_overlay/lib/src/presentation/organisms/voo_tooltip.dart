import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// The position of the tooltip relative to its anchor.
enum VooTooltipPosition {
  /// Above the anchor.
  above,

  /// Below the anchor.
  below,

  /// To the left of the anchor.
  left,

  /// To the right of the anchor.
  right,

  /// Auto-determine based on available space.
  auto,
}

/// An informational tooltip positioned near an anchor element.
///
/// Used for hints, explanatory text, and contextual help.
class VooTooltip extends StatelessWidget {
  /// The message to display.
  final String message;

  /// Optional rich content widget.
  final Widget? content;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Position relative to anchor.
  final VooTooltipPosition position;

  /// The anchor rect to position around.
  final Rect? anchorRect;

  /// Maximum width of the tooltip.
  final double maxWidth;

  /// Whether to show an arrow pointing to the anchor.
  final bool showArrow;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom text color.
  final Color? textColor;

  /// Offset from the anchor position.
  final Offset offset;

  const VooTooltip({
    super.key,
    required this.message,
    this.content,
    this.style = VooOverlayStyle.material,
    this.position = VooTooltipPosition.auto,
    this.anchorRect,
    this.maxWidth = 240,
    this.showArrow = true,
    this.backgroundColor,
    this.textColor,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final borderRadius =
        overlayStyle.getBorderRadius(context, VooOverlayType.tooltip);
    final blurSigma = overlayStyle.getBlurSigma();
    final theme = Theme.of(context);

    final bgColor = backgroundColor ??
        overlayStyle.getBackgroundColor(context, VooOverlayType.tooltip);
    final fgColor =
        textColor ?? overlayStyle.getTextColor(context) ?? theme.colorScheme.onSurface;

    Widget tooltip = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        boxShadow: overlayStyle.getBoxShadow(context),
        border: overlayStyle.getBorder(context),
      ),
      child: content ??
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: fgColor,
            ),
            textAlign: TextAlign.center,
          ),
    );

    if (blurSigma > 0) {
      tooltip = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: tooltip,
        ),
      );
    }

    if (anchorRect != null) {
      return _PositionedTooltip(
        anchorRect: anchorRect!,
        position: position,
        offset: offset,
        showArrow: showArrow,
        arrowColor: bgColor,
        child: tooltip,
      );
    }

    return Center(child: tooltip);
  }
}

class _PositionedTooltip extends StatefulWidget {
  final Rect anchorRect;
  final VooTooltipPosition position;
  final Offset offset;
  final bool showArrow;
  final Color arrowColor;
  final Widget child;

  const _PositionedTooltip({
    required this.anchorRect,
    required this.position,
    required this.offset,
    required this.showArrow,
    required this.arrowColor,
    required this.child,
  });

  @override
  State<_PositionedTooltip> createState() => _PositionedTooltipState();
}

class _PositionedTooltipState extends State<_PositionedTooltip> {
  final GlobalKey _tooltipKey = GlobalKey();
  Size? _tooltipSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTooltip());
  }

  void _measureTooltip() {
    final renderBox =
        _tooltipKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _tooltipSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;
    const edgePadding = 8.0;
    const spacing = 4.0;

    // Calculate best position
    final actualPosition = _calculatePosition(screenSize);

    // Build the tooltip content with arrow
    Widget tooltipContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showArrow && actualPosition == VooTooltipPosition.below)
          _buildArrow(actualPosition, null),
        KeyedSubtree(
          key: _tooltipKey,
          child: widget.child,
        ),
        if (widget.showArrow && actualPosition == VooTooltipPosition.above)
          _buildArrow(actualPosition, null),
      ],
    );

    // If we haven't measured yet, position off-screen to measure
    if (_tooltipSize == null) {
      return Stack(
        children: [
          Positioned(
            left: -9999,
            top: -9999,
            child: tooltipContent,
          ),
        ],
      );
    }

    // Calculate clamped position
    final tooltipWidth = _tooltipSize!.width;
    final tooltipHeight = _tooltipSize!.height;
    final safeLeft = padding.left + edgePadding;
    final safeRight = screenSize.width - padding.right - edgePadding;
    final safeTop = padding.top + edgePadding;
    final safeBottom = screenSize.height - padding.bottom - edgePadding;

    double left;
    double top;
    double arrowOffset = 0;

    switch (actualPosition) {
      case VooTooltipPosition.above:
        // Center horizontally on anchor, then clamp
        left =
            widget.anchorRect.center.dx - tooltipWidth / 2 + widget.offset.dx;
        top = widget.anchorRect.top -
            tooltipHeight -
            spacing -
            (widget.showArrow ? 6 : 0) +
            widget.offset.dy;

        // Clamp horizontal position
        final clampedLeft = left.clamp(safeLeft, safeRight - tooltipWidth);
        arrowOffset = left - clampedLeft;
        left = clampedLeft;

      case VooTooltipPosition.below:
        // Center horizontally on anchor, then clamp
        left =
            widget.anchorRect.center.dx - tooltipWidth / 2 + widget.offset.dx;
        top = widget.anchorRect.bottom +
            spacing +
            (widget.showArrow ? 6 : 0) +
            widget.offset.dy;

        // Clamp horizontal position
        final clampedLeft = left.clamp(safeLeft, safeRight - tooltipWidth);
        arrowOffset = left - clampedLeft;
        left = clampedLeft;

      case VooTooltipPosition.left:
        left = widget.anchorRect.left -
            tooltipWidth -
            spacing -
            (widget.showArrow ? 6 : 0) +
            widget.offset.dx;
        top = widget.anchorRect.center.dy -
            tooltipHeight / 2 +
            widget.offset.dy;

        // Clamp vertical position
        top = top.clamp(safeTop, safeBottom - tooltipHeight);

      case VooTooltipPosition.right:
        left = widget.anchorRect.right +
            spacing +
            (widget.showArrow ? 6 : 0) +
            widget.offset.dx;
        top = widget.anchorRect.center.dy -
            tooltipHeight / 2 +
            widget.offset.dy;

        // Clamp vertical position
        top = top.clamp(safeTop, safeBottom - tooltipHeight);

      case VooTooltipPosition.auto:
        // Should not reach here after calculation
        left = widget.anchorRect.center.dx - tooltipWidth / 2;
        top = widget.anchorRect.bottom + spacing;
    }

    // Rebuild tooltip content with arrow offset
    tooltipContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showArrow && actualPosition == VooTooltipPosition.below)
          _buildArrow(actualPosition, arrowOffset),
        widget.child,
        if (widget.showArrow && actualPosition == VooTooltipPosition.above)
          _buildArrow(actualPosition, arrowOffset),
      ],
    );

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          child: tooltipContent,
        ),
      ],
    );
  }

  VooTooltipPosition _calculatePosition(Size screenSize) {
    if (widget.position != VooTooltipPosition.auto) return widget.position;

    final spaceAbove = widget.anchorRect.top;
    final spaceBelow = screenSize.height - widget.anchorRect.bottom;
    final spaceLeft = widget.anchorRect.left;
    final spaceRight = screenSize.width - widget.anchorRect.right;

    // Prefer above, then below, then right, then left
    if (spaceAbove >= 60) return VooTooltipPosition.above;
    if (spaceBelow >= 60) return VooTooltipPosition.below;
    if (spaceRight >= 150) return VooTooltipPosition.right;
    if (spaceLeft >= 150) return VooTooltipPosition.left;

    return VooTooltipPosition.above;
  }

  Widget _buildArrow(VooTooltipPosition pos, double? horizontalOffset) {
    Widget arrow = CustomPaint(
      size: const Size(12, 6),
      painter: _TooltipArrowPainter(
        color: widget.arrowColor,
        isPointingUp: pos == VooTooltipPosition.below,
      ),
    );

    if (horizontalOffset != null && horizontalOffset != 0) {
      arrow = Transform.translate(
        offset: Offset(horizontalOffset, 0),
        child: arrow,
      );
    }

    return arrow;
  }
}

class _TooltipArrowPainter extends CustomPainter {
  final Color color;
  final bool isPointingUp;

  _TooltipArrowPainter({required this.color, required this.isPointingUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isPointingUp) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
