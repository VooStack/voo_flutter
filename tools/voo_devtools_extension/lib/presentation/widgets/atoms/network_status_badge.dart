import 'package:flutter/material.dart';

class NetworkStatusBadge extends StatelessWidget {
  final int statusCode;

  const NetworkStatusBadge({super.key, required this.statusCode});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(statusCode);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        statusCode.toString(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(int code) {
    if (code >= 200 && code < 300) {
      return Colors.green;
    } else if (code >= 300 && code < 400) {
      return Colors.orange;
    } else if (code >= 400 && code < 500) {
      return Colors.red;
    } else if (code >= 500) {
      return Colors.red.shade900;
    }
    return Colors.grey;
  }
}