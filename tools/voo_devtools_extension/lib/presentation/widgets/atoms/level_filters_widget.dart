import 'package:flutter/material.dart';
import 'package:voo_logging_devtools_extension/core/models/log_level.dart';
import 'package:voo_logging_devtools_extension/presentation/widgets/atoms/log_level_chip.dart';

class LevelFiltersWidget extends StatelessWidget {
  final List<LogLevel> selectedLevels;
  final void Function(LogLevel level) onLevelToggled;

  const LevelFiltersWidget({super.key, required this.selectedLevels, required this.onLevelToggled});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: LogLevel.values.map((level) {
      final isSelected = selectedLevels.contains(level);

      return LogLevelChip(level: level, selected: isSelected, onTap: () => onLevelToggled(level));
    }).toList(),
  );
}
