import 'package:flutter/material.dart';

/// Material 3 compliant form button variants
enum VooFormButtonVariant {
  filled,
  filledTonal,
  outlined,
  text,
  elevated,
}

/// Material 3 compliant form button sizes
enum VooFormButtonSize {
  small,
  medium,
  large,
}

/// Material 3 compliant form button with consistent design
class VooFormButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final VooFormButtonVariant variant;
  final VooFormButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  
  const VooFormButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = VooFormButtonVariant.filled,
    this.size = VooFormButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.color,
    this.textColor,
    this.borderRadius,
    this.padding,
  });
  
  /// Submit button factory
  factory VooFormButton.submit({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Submit',
    bool isLoading = false,
    bool isFullWidth = true,
  }) =>
      VooFormButton(
        key: key,
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
        icon: Icons.check,
      );
  
  /// Cancel button factory
  factory VooFormButton.cancel({
    Key? key,
    required VoidCallback onPressed,
    String label = 'Cancel',
    bool isFullWidth = false,
  }) =>
      VooFormButton(
        key: key,
        label: label,
        onPressed: onPressed,
        variant: VooFormButtonVariant.text,
        isFullWidth: isFullWidth,
      );
  
  /// Secondary action button factory
  factory VooFormButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
  }) =>
      VooFormButton(
        key: key,
        label: label,
        onPressed: onPressed,
        variant: VooFormButtonVariant.filledTonal,
        icon: icon,
        isFullWidth: isFullWidth,
      );
  
  /// Danger/Destructive button factory
  factory VooFormButton.danger({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
  }) =>
      VooFormButton(
        key: key,
        label: label,
        onPressed: onPressed,
        color: Colors.red,
        icon: icon ?? Icons.warning,
        isFullWidth: isFullWidth,
      );
  
  EdgeInsetsGeometry _getPadding() {
    if (padding != null) return padding!;
    
    switch (size) {
      case VooFormButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case VooFormButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case VooFormButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
  
  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (size) {
      case VooFormButtonSize.small:
        return theme.textTheme.labelSmall!;
      case VooFormButtonSize.medium:
        return theme.textTheme.labelLarge!;
      case VooFormButtonSize.large:
        return theme.textTheme.titleMedium!;
    }
  }
  
  Widget _buildButtonContent(BuildContext context) {
    final textStyle = _getTextStyle(context).copyWith(color: textColor);
    
    if (isLoading) {
      return SizedBox(
        height: textStyle.fontSize! * 1.5,
        width: textStyle.fontSize! * 1.5,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: textStyle.fontSize! * 1.2),
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    }
    
    return Text(label, style: textStyle);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? 12;
    
    Widget button;
    
    switch (variant) {
      case VooFormButtonVariant.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color ?? theme.colorScheme.primary,
            foregroundColor: textColor ?? theme.colorScheme.onPrimary,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;
        
      case VooFormButtonVariant.filledTonal:
        button = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color ?? theme.colorScheme.secondaryContainer,
            foregroundColor: textColor ?? theme.colorScheme.onSecondaryContainer,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;
        
      case VooFormButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: _getPadding(),
            side: BorderSide(
              color: color ?? theme.colorScheme.outline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;
        
      case VooFormButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;
        
      case VooFormButtonVariant.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? theme.colorScheme.surface,
            foregroundColor: textColor ?? theme.colorScheme.primary,
            padding: _getPadding(),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        );
        break;
    }
    
    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }
}

/// Material 3 compliant form action buttons row
class VooFormActions extends StatelessWidget {
  final List<VooFormButton> buttons;
  final MainAxisAlignment alignment;
  final double spacing;
  final bool isVertical;
  final bool reverseOrder;
  
  const VooFormActions({
    super.key,
    required this.buttons,
    this.alignment = MainAxisAlignment.end,
    this.spacing = 8.0,
    this.isVertical = false,
    this.reverseOrder = false,
  });
  
  /// Standard submit/cancel actions
  factory VooFormActions.submitCancel({
    Key? key,
    required VoidCallback? onSubmit,
    required VoidCallback onCancel,
    String submitLabel = 'Submit',
    String cancelLabel = 'Cancel',
    bool isSubmitLoading = false,
    bool reverseOrder = false,
  }) =>
      VooFormActions(
        key: key,
        buttons: [
          VooFormButton.cancel(
            label: cancelLabel,
            onPressed: onCancel,
          ),
          VooFormButton.submit(
            label: submitLabel,
            onPressed: onSubmit,
            isLoading: isSubmitLoading,
          ),
        ],
        reverseOrder: reverseOrder,
      );
  
  @override
  Widget build(BuildContext context) {
    final orderedButtons = reverseOrder ? buttons.reversed.toList() : buttons;
    
    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < orderedButtons.length; i++) ...[
            orderedButtons[i],
            if (i < orderedButtons.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    }
    
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (int i = 0; i < orderedButtons.length; i++) ...[
          if (orderedButtons[i].isFullWidth)
            Expanded(child: orderedButtons[i])
          else
            orderedButtons[i],
          if (i < orderedButtons.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}