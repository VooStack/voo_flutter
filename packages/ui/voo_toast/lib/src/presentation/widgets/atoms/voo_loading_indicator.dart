import 'package:flutter/material.dart';

class VooLoadingIndicator extends StatelessWidget {
  const VooLoadingIndicator({
    super.key,
    this.color,
    this.size = 20.0,
    this.strokeWidth = 2.0,
  });

  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
