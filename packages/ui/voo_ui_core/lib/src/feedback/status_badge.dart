import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/colors.dart';

class VooStatusBadge extends StatelessWidget {
  final int statusCode;
  final bool compact;

  const VooStatusBadge({super.key, required this.statusCode, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = VooColors.getHttpStatusColor(statusCode);
    final textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Text(
          statusCode.toString(),
          style: theme.textTheme.labelSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(statusCode), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            statusCode.toString(),
            style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(int code) {
    if (code >= 200 && code < 300) {
      return Icons.check_circle_outline;
    } else if (code >= 300 && code < 400) {
      return Icons.arrow_forward;
    } else if (code >= 400 && code < 500) {
      return Icons.warning_amber_outlined;
    } else if (code >= 500) {
      return Icons.error_outline;
    } else {
      return Icons.help_outline;
    }
  }
}
