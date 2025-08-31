import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_config.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';

/// Widget that renders the submit section of a form
class SubmitSectionWidget extends StatelessWidget {
  final VooFormController controller;
  final VooFormConfig config;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onSuccess;
  final void Function(dynamic)? onError;
  final String submitButtonText;
  final Widget? submitButtonIcon;
  final EdgeInsetsGeometry? padding;

  const SubmitSectionWidget({
    super.key,
    required this.controller,
    required this.config,
    this.onSubmit,
    this.onSuccess,
    this.onError,
    this.submitButtonText = 'Submit',
    this.submitButtonIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget submitButton = ElevatedButton.icon(
      onPressed: controller.isSubmitting || onSubmit == null
          ? null
          : () async {
              await controller.submit(
                onSubmit: onSubmit!,
                onSuccess: onSuccess,
                onError: onError,
              );
            },
      icon: submitButtonIcon ?? const SizedBox.shrink(),
      label: controller.isSubmitting
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(submitButtonText),
      style: config.submitButtonStyle ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
          ),
    );

    final Widget resetButton = TextButton(
      onPressed: controller.isSubmitting
          ? null
          : () {
              controller.clearErrors();
              controller.reset();
            },
      child: const Text('Reset'),
    );

    Widget buttonRow;
    switch (config.submitButtonPosition) {
      case ButtonPosition.bottomLeft:
        buttonRow = Row(
          children: [submitButton, const SizedBox(width: 8), resetButton],
        );
        break;
      case ButtonPosition.bottomCenter:
        buttonRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [resetButton, const SizedBox(width: 8), submitButton],
        );
        break;
      case ButtonPosition.bottomRight:
      default:
        buttonRow = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [resetButton, const SizedBox(width: 8), submitButton],
        );
        break;
    }

    final effectivePadding =
        padding ?? config.padding ?? const EdgeInsets.all(16.0);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(child: buttonRow),
    );
  }
}