import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// The position of the popup relative to its anchor.
enum VooPopupPosition {
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

/// A small popup overlay positioned near an anchor point.
///
/// Great for contextual menus, tooltips, or quick actions.
class VooPopup extends StatelessWidget {
  /// The content to display in the popup.
  final Widget? content;

  /// Optional list of actions.
  final List<VooOverlayAction>? actions;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Position relative to anchor.
  final VooPopupPosition position;

  /// The anchor rect to position around.
  final Rect? anchorRect;

  /// Maximum width of the popup.
  final double maxWidth;

  /// Maximum height of the popup.
  final double maxHeight;

  /// Whether to show an arrow pointing to the anchor.
  final bool showArrow;

  /// Custom background color.
  final Color? backgroundColor;

  /// Offset from the anchor position.
  final Offset offset;

  const VooPopup({
    super.key,
    this.content,
    this.actions,
    this.style = VooOverlayStyle.material,
    this.position = VooPopupPosition.auto,
    this.anchorRect,
    this.maxWidth = 280,
    this.maxHeight = 400,
    this.showArrow = true,
    this.backgroundColor,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final decoration =
        overlayStyle.getDecoration(context, VooOverlayType.popup);
    final blurSigma = overlayStyle.getBlurSigma();
    final theme = Theme.of(context);
    final textColor = overlayStyle.getTextColor(context);

    Widget popup = Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      decoration: decoration.copyWith(
        color: backgroundColor ?? decoration.color,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (content != null)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: DefaultTextStyle.merge(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                    child: content!,
                  ),
                ),
              ),
            if (actions != null && actions!.isNotEmpty) ...[
              const Divider(height: 1),
              _buildActionsList(context, textColor),
            ],
          ],
        ),
      ),
    );

    if (blurSigma > 0) {
      popup = ClipRRect(
        borderRadius:
            overlayStyle.getBorderRadius(context, VooOverlayType.popup),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: popup,
        ),
      );
    }

    if (anchorRect != null) {
      return _PositionedPopup(
        anchorRect: anchorRect!,
        position: position,
        offset: offset,
        showArrow: showArrow,
        arrowColor: backgroundColor ?? decoration.color ?? theme.cardColor,
        child: popup,
      );
    }

    return Center(child: popup);
  }

  Widget _buildActionsList(BuildContext context, Color? textColor) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions!.map((action) {
        Color actionColor;
        if (action.isDestructive) {
          actionColor = theme.colorScheme.error;
        } else if (action.isPrimary) {
          actionColor = theme.colorScheme.primary;
        } else {
          actionColor = textColor ?? theme.colorScheme.onSurface;
        }

        return InkWell(
          onTap: () {
            action.onPressed?.call();
            if (action.autoPop) {
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (action.icon != null) ...[
                  Icon(action.icon, size: 18, color: actionColor),
                  const SizedBox(width: 10),
                ],
                Text(
                  action.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: actionColor,
                    fontWeight:
                        action.isPrimary ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PositionedPopup extends StatefulWidget {
  final Rect anchorRect;
  final VooPopupPosition position;
  final Offset offset;
  final bool showArrow;
  final Color arrowColor;
  final Widget child;

  const _PositionedPopup({
    required this.anchorRect,
    required this.position,
    required this.offset,
    required this.showArrow,
    required this.arrowColor,
    required this.child,
  });

  @override
  State<_PositionedPopup> createState() => _PositionedPopupState();
}

class _PositionedPopupState extends State<_PositionedPopup> {
  final GlobalKey _popupKey = GlobalKey();
  Size? _popupSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measurePopup());
  }

  void _measurePopup() {
    final renderBox =
        _popupKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _popupSize = renderBox.size;
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

    // Build the popup content with arrow
    Widget popupContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showArrow && actualPosition == VooPopupPosition.below)
          _buildArrow(actualPosition, null),
        KeyedSubtree(
          key: _popupKey,
          child: widget.child,
        ),
        if (widget.showArrow && actualPosition == VooPopupPosition.above)
          _buildArrow(actualPosition, null),
      ],
    );

    // If we haven't measured yet, position off-screen to measure
    if (_popupSize == null) {
      return Stack(
        children: [
          Positioned(
            left: -9999,
            top: -9999,
            child: popupContent,
          ),
        ],
      );
    }

    // Calculate clamped position
    final popupWidth = _popupSize!.width;
    final popupHeight = _popupSize!.height;
    final safeLeft = padding.left + edgePadding;
    final safeRight = screenSize.width - padding.right - edgePadding;
    final safeTop = padding.top + edgePadding;
    final safeBottom = screenSize.height - padding.bottom - edgePadding;

    double left;
    double top;
    double arrowOffset = 0;

    switch (actualPosition) {
      case VooPopupPosition.above:
        // Center horizontally on anchor, then clamp
        left = widget.anchorRect.center.dx - popupWidth / 2 + widget.offset.dx;
        top = widget.anchorRect.top -
            popupHeight -
            spacing -
            (widget.showArrow ? 8 : 0) +
            widget.offset.dy;

        // Clamp horizontal position
        final clampedLeft = left.clamp(safeLeft, safeRight - popupWidth);
        arrowOffset = left - clampedLeft;
        left = clampedLeft;

      case VooPopupPosition.below:
        // Center horizontally on anchor, then clamp
        left = widget.anchorRect.center.dx - popupWidth / 2 + widget.offset.dx;
        top = widget.anchorRect.bottom +
            spacing +
            (widget.showArrow ? 8 : 0) +
            widget.offset.dy;

        // Clamp horizontal position
        final clampedLeft = left.clamp(safeLeft, safeRight - popupWidth);
        arrowOffset = left - clampedLeft;
        left = clampedLeft;

      case VooPopupPosition.left:
        left = widget.anchorRect.left -
            popupWidth -
            spacing -
            (widget.showArrow ? 8 : 0) +
            widget.offset.dx;
        top =
            widget.anchorRect.center.dy - popupHeight / 2 + widget.offset.dy;

        // Clamp vertical position
        top = top.clamp(safeTop, safeBottom - popupHeight);

      case VooPopupPosition.right:
        left = widget.anchorRect.right +
            spacing +
            (widget.showArrow ? 8 : 0) +
            widget.offset.dx;
        top =
            widget.anchorRect.center.dy - popupHeight / 2 + widget.offset.dy;

        // Clamp vertical position
        top = top.clamp(safeTop, safeBottom - popupHeight);

      case VooPopupPosition.auto:
        // Should not reach here after calculation
        left = widget.anchorRect.center.dx - popupWidth / 2;
        top = widget.anchorRect.bottom + spacing;
    }

    // Rebuild popup content with arrow offset
    popupContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showArrow && actualPosition == VooPopupPosition.below)
          _buildArrow(actualPosition, arrowOffset),
        widget.child,
        if (widget.showArrow && actualPosition == VooPopupPosition.above)
          _buildArrow(actualPosition, arrowOffset),
      ],
    );

    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          child: popupContent,
        ),
      ],
    );
  }

  VooPopupPosition _calculatePosition(Size screenSize) {
    if (widget.position != VooPopupPosition.auto) return widget.position;

    final spaceAbove = widget.anchorRect.top;
    final spaceBelow = screenSize.height - widget.anchorRect.bottom;
    final spaceLeft = widget.anchorRect.left;
    final spaceRight = screenSize.width - widget.anchorRect.right;

    // Prefer below, then above, then right, then left
    if (spaceBelow >= 200) return VooPopupPosition.below;
    if (spaceAbove >= 200) return VooPopupPosition.above;
    if (spaceRight >= 200) return VooPopupPosition.right;
    if (spaceLeft >= 200) return VooPopupPosition.left;

    return VooPopupPosition.below;
  }

  Widget _buildArrow(VooPopupPosition pos, double? horizontalOffset) {
    Widget arrow = CustomPaint(
      size: const Size(16, 8),
      painter: _ArrowPainter(
        color: widget.arrowColor,
        isPointingUp: pos == VooPopupPosition.below,
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

class _ArrowPainter extends CustomPainter {
  final Color color;
  final bool isPointingUp;

  _ArrowPainter({required this.color, required this.isPointingUp});

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
