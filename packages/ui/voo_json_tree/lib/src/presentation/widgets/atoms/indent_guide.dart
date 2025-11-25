import 'package:flutter/material.dart';

import 'package:voo_json_tree/src/domain/entities/json_tree_theme.dart';

/// A vertical indent guide line for tree visualization.
class IndentGuide extends StatelessWidget {
  /// Creates a new [IndentGuide].
  const IndentGuide({
    super.key,
    required this.depth,
    required this.theme,
    this.height,
  });

  /// The depth level (number of guides to show).
  final int depth;

  /// The theme to use for styling.
  final VooJsonTreeTheme theme;

  /// The height of the guide (null for default).
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (depth <= 0 || !theme.showIndentGuides) {
      return SizedBox(width: depth * theme.indentWidth);
    }

    return SizedBox(
      width: depth * theme.indentWidth,
      height: height,
      child: CustomPaint(
        painter: _IndentGuidePainter(
          depth: depth,
          indentWidth: theme.indentWidth,
          color: theme.indentGuideColor,
        ),
      ),
    );
  }
}

class _IndentGuidePainter extends CustomPainter {
  _IndentGuidePainter({
    required this.depth,
    required this.indentWidth,
    required this.color,
  });

  final int depth;
  final double indentWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (var i = 0; i < depth; i++) {
      final x = (i * indentWidth) + (indentWidth / 2);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_IndentGuidePainter oldDelegate) {
    return depth != oldDelegate.depth ||
        indentWidth != oldDelegate.indentWidth ||
        color != oldDelegate.color;
  }
}
