import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Form actions molecule for submit and cancel buttons
class VooFormActions extends StatelessWidget {
  final VooFormController controller;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final String submitLabel;
  final String cancelLabel;
  final bool showCancel;
  final bool elevated;
  final MainAxisAlignment alignment;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext, VooFormController)? customBuilder;

  const VooFormActions({
    super.key,
    required this.controller,
    this.onSubmit,
    this.onCancel,
    this.submitLabel = 'Submit',
    this.cancelLabel = 'Cancel',
    this.showCancel = true,
    this.elevated = true,
    this.alignment = MainAxisAlignment.end,
    this.padding,
    this.customBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null) {
      return customBuilder!(context, controller);
    }

    final design = context.vooDesign;
    final theme = Theme.of(context);
    
    return Container(
      padding: padding ?? EdgeInsets.all(design.spacingMd),
      decoration: elevated 
          ? BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          if (showCancel && onCancel != null) ...[
            VooButton(
              onPressed: onCancel,
              variant: VooButtonVariant.text,
              child: Text(cancelLabel),
            ),
            SizedBox(width: design.spacingMd),
          ],
          VooButton(
            onPressed: controller.isSubmitting ? null : onSubmit,
            child: controller.isSubmitting
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
                : Text(submitLabel),
          ),
        ],
      ),
    );
  }
}