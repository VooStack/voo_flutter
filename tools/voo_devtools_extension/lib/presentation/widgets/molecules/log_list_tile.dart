import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/log_entry_model.dart';
import 'package:voo_devtools_extension/core/models/log_level.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/log_level_chip.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/category_chip.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/universal_list_tile.dart';

/// Log entry tile using the universal list tile component
class LogListTile extends StatelessWidget {
  final LogEntryModel log;
  final bool isSelected;
  final VoidCallback onTap;

  const LogListTile({
    super.key,
    required this.log,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final levelColor = Color(log.level.color);

    return UniversalListTile(
      id: log.id,
      title: log.message,
      subtitle: log.tag,
      category: log.category,
      timestamp: log.timestamp,
      leadingBadge: LogLevelChip(level: log.level),
      trailingBadges: [
        if (log.category != null)
          CategoryChip(category: log.category!, compact: true),
      ],
      metadata: {
        if (log.metadata?.isNotEmpty == true)
          'metadata': '${log.metadata!.length} items',
        if (log.error != null) 'error': 'Has error',
      },
      isSelected: isSelected,
      onTap: onTap,
      accentColor: levelColor,
      icon: _getLogIcon(log.level),
    );
  }

  IconData _getLogIcon(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Icons.chat_bubble_outline;
      case LogLevel.debug:
        return Icons.bug_report_outlined;
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warning:
        return Icons.warning_amber_outlined;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.fatal:
        return Icons.dangerous_outlined;
      case LogLevel.network:
        return Icons.wifi_outlined;
      case LogLevel.navigation:
        return Icons.navigation_outlined;
    }
  }
}
