import 'package:flutter/material.dart';

class VooListEmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? icon;
  final Widget? action;

  const VooListEmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            if (message != null) ...[
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}