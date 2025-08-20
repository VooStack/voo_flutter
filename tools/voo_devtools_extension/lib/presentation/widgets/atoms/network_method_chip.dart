import 'package:flutter/material.dart';

class NetworkMethodChip extends StatelessWidget {
  final String method;

  const NetworkMethodChip({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final color = _getMethodColor(method);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
