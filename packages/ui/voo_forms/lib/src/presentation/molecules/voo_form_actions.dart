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
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: design.spacingLg,
        vertical: design.spacingMd,
      ),
      decoration: elevated 
          ? BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          if (showCancel && onCancel != null) ...[
            AnimatedScale(
              scale: controller.isSubmitting ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: OutlinedButton(
                onPressed: controller.isSubmitting ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  cancelLabel,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: design.spacingMd),
          ],
          AnimatedScale(
            scale: controller.isSubmitting ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  colors: controller.isSubmitting
                      ? [
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                          theme.colorScheme.primary.withValues(alpha: 0.5),
                        ]
                      : [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.9),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: controller.isSubmitting ? 4 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: controller.isSubmitting ? null : onSubmit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 14.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isSubmitting) ...[
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          controller.isSubmitting ? 'Processing...' : submitLabel,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}