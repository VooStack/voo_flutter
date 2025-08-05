import 'package:flutter/material.dart';
import 'package:voo_logging/features/devtools_extension/presentation/widgets/atoms/log_level_chip.dart';
import 'package:voo_logging/features/logging/data/models/log_entry_model.dart';

class LogDetailHeader extends StatelessWidget {
  final LogEntryModel log;
  final VoidCallback onCopyAll;
  final VoidCallback? onClose;

  const LogDetailHeader({
    super.key,
    required this.log,
    required this.onCopyAll,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          LogLevelChip(level: log.level),
          const SizedBox(width: 8),
          Expanded(child: Text('Log Details', style: theme.textTheme.titleMedium)),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: onCopyAll,
            tooltip: 'Copy all details',
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
              tooltip: 'Close details',
            ),
        ],
      ),
    );
  }
}