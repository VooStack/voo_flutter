import 'package:flutter/material.dart';
import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/core/domain/extensions/log_level_extensions.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/log_level_indicator.dart';

/// Atomic widget for displaying a log level with indicator, name and count
class LogLevelRow extends StatelessWidget {
  final LogLevel level;
  final int count;
  final EdgeInsetsGeometry? padding;

  const LogLevelRow({
    super.key,
    required this.level,
    required this.count,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          LogLevelIndicator(level: level),
          const SizedBox(width: 8),
          Expanded(child: Text(level.displayName)),
          Text(
            count.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}