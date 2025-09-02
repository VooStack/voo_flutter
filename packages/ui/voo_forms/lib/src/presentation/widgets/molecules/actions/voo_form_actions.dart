import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/enums/button_type.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/buttons/voo_form_button.dart';

/// Molecule component for form action buttons
/// Provides submit and cancel buttons with customizable appearance
/// Follows KISS principle and atomic design
class VooFormActions extends StatelessWidget {
  /// Callback for submit button
  final VoidCallback? onSubmit;

  /// Callback for cancel button
  final VoidCallback? onCancel;

  /// Text for submit button
  final String submitText;

  /// Text for cancel button
  final String cancelText;

  /// Whether to show submit button
  final bool showSubmit;

  /// Whether to show cancel button
  final bool showCancel;

  /// Main axis alignment for button row
  final MainAxisAlignment alignment;

  /// Spacing between buttons
  final double spacing;

  /// Whether submit button should be enabled
  final bool submitEnabled;

  /// Whether cancel button should be enabled
  final bool cancelEnabled;

  /// Shows loading indicator in submit button
  final bool isLoading;

  /// Submit button type (filled, outlined, text)
  final ButtonType submitButtonType;

  /// Cancel button type (filled, outlined, text)
  final ButtonType cancelButtonType;

  const VooFormActions({
    super.key,
    this.onSubmit,
    this.onCancel,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.showSubmit = true,
    this.showCancel = false,
    this.alignment = MainAxisAlignment.end,
    this.spacing = 8.0,
    this.submitEnabled = true,
    this.cancelEnabled = true,
    this.isLoading = false,
    this.submitButtonType = ButtonType.filled,
    this.cancelButtonType = ButtonType.text,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty if no buttons to show
    if (!showSubmit && !showCancel) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (showCancel)
          VooFormButton(
            text: cancelText,
            onPressed: onCancel,
            enabled: cancelEnabled && !isLoading,
            type: cancelButtonType,
          ),
        if (showCancel && showSubmit) SizedBox(width: spacing),
        if (showSubmit)
          VooFormButton(
            text: submitText,
            onPressed: onSubmit,
            enabled: submitEnabled && !isLoading,
            type: submitButtonType,
            showLoading: isLoading,
          ),
      ],
    );
  }
}