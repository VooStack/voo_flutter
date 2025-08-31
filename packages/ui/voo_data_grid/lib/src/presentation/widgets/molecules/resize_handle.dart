import 'package:flutter/material.dart';

/// Resize handle widget for column resizing
class ResizeHandle extends StatelessWidget {
  /// Callback for resize drag updates
  final void Function(double delta)? onResize;
  
  const ResizeHandle({
    super.key,
    this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        onResize?.call(details.delta.dx);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: Container(
          width: 8,
          height: double.infinity,
          color: Colors.transparent,
          child: const Center(
            child: VerticalDivider(width: 2),
          ),
        ),
      ),
    );
  }
}