import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_level.dart';

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
    final levelColor = LogLevelColor.fromLevel(level);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(levelColor.value),
        shape: BoxShape.circle,
      ),
    );
  }
}