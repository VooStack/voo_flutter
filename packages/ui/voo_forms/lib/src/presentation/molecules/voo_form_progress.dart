import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';

/// Progress indicator molecule for forms
/// Shows completion status based on required fields
class VooFormProgress extends StatelessWidget {
  final VooForm form;
  final VooFormController controller;
  final bool showProgress;
  final Color? completedColor;
  final Color? progressColor;
  final double height;

  const VooFormProgress({
    super.key,
    required this.form,
    required this.controller,
    this.showProgress = true,
    this.completedColor,
    this.progressColor,
    this.height = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!showProgress) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final progress = _calculateProgress();
    final isCompleted = progress >= 1.0;

    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          isCompleted 
            ? (completedColor ?? theme.colorScheme.tertiary)
            : (progressColor ?? theme.colorScheme.primary),
        ),
      ),
    );
  }

  double _calculateProgress() {
    final requiredFields = form.fields.where((f) => f.required).toList();
    if (requiredFields.isEmpty) return 1.0;

    int filledCount = 0;
    for (final field in requiredFields) {
      final value = controller.getValue(field.id);
      if (value != null &&
          !(value is String && value.isEmpty) &&
          !(value is List && value.isEmpty)) {
        filledCount++;
      }
    }

    return filledCount / requiredFields.length;
  }
}