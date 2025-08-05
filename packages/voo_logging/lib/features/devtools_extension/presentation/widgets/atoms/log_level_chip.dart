import 'package:flutter/material.dart';

import 'package:voo_logging/core/domain/enums/log_level.dart';
import 'package:voo_logging/core/domain/extensions/log_level_extensions.dart';

class LogLevelChip extends StatelessWidget {
  final LogLevel level;
  final bool selected;
  final VoidCallback? onTap;

  const LogLevelChip({super.key, required this.level, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(
      level.displayName,
      style: TextStyle(color: selected ? Colors.white : _getColor(level), fontSize: 12, fontWeight: FontWeight.w500),
    ),
    selected: selected,
    onSelected: onTap != null ? (_) => onTap!() : null,
    backgroundColor: _getColor(level).withValues(alpha: 0.1),
    selectedColor: _getColor(level),
    side: BorderSide(color: _getColor(level).withValues(alpha: selected ? 1 : 0.3)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  Color _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Colors.grey;
      case LogLevel.debug:
        return Colors.blue;
      case LogLevel.info:
        return Colors.green;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.fatal:
        return Colors.purple;
    }
  }
}
