import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  final String error;

  const ErrorPlaceholder({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error loading logs', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
