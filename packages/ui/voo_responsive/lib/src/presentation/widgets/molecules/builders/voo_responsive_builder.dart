import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/screen_info.dart';

class VooResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenInfo screenInfo) builder;

  const VooResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenInfo = ScreenInfo.fromContext(context);
        return builder(context, screenInfo);
      },
    );
  }
}
