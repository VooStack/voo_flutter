import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/enums/button_type.dart';

/// Atomic form button widget that provides consistent button styling
/// Follows atomic design and KISS principle
class VooFormButton extends StatelessWidget {
  /// Button text
  final String text;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Whether button is enabled
  final bool enabled;
  
  /// Button type (filled, outlined, text)
  final ButtonType type;
  
  /// Whether to show loading indicator
  final bool showLoading;
  
  const VooFormButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.type = ButtonType.filled,
    this.showLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = enabled && !showLoading ? onPressed : null;
    
    final Widget child = showLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.filled
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Text(text);

    return switch (type) {
      ButtonType.filled => FilledButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      ButtonType.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      ButtonType.text => TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };
  }
}