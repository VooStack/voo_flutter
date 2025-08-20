import 'package:flutter/material.dart';

/// Atomic component for displaying HTTP methods with appropriate colors
class MethodBadge extends StatelessWidget {
  final String method;
  final bool compact;

  const MethodBadge({super.key, required this.method, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getMethodColor(method);

    if (compact) {
      return Container(
        width: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(
            method.length > 4 ? method.substring(0, 4) : method,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        method,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'PATCH':
        return Colors.amber;
      case 'DELETE':
        return Colors.red;
      case 'HEAD':
        return Colors.purple;
      case 'OPTIONS':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
