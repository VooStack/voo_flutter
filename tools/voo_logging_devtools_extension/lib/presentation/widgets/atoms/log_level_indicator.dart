import 'package:flutter/material.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/core/domain/value_objects/log_level_color.dart';

/// Atomic widget for displaying a log level color indicator
class LogLevelIndicator extends StatelessWidget {
  final LogLevel level;
  final double size;

  const LogLevelIndicator({
    super.key,
    required this.level,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    final levelColor = LogLevelColor.forLevel(level);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          levelColor.red,
          levelColor.green,
          levelColor.blue,
          levelColor.opacity,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}