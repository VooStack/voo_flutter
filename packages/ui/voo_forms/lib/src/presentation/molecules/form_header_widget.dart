import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';

/// Widget that displays the form header with title and description
class FormHeaderWidget extends StatelessWidget {
  final VooForm form;
  final VooFormConfig config;
  final EdgeInsetsGeometry? padding;

  const FormHeaderWidget({
    super.key,
    required this.form,
    required this.config,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding =
        padding ?? config.padding ?? const EdgeInsets.all(16.0);

    return Padding(
      padding: effectivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (form.title != null)
            Text(
              form.title!,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (form.description != null) ...[
            const SizedBox(height: 8.0),
            Text(
              form.description!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}