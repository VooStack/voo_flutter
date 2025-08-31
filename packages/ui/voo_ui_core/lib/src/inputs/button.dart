import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/design_system.dart';

enum VooButtonSize { small, medium, large }

enum VooButtonVariant { elevated, outlined, text, tonal }

class VooButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final Widget child;
  final IconData? icon;
  final VooButtonSize size;
  final VooButtonVariant variant;
  final bool expanded;
  final bool loading;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final Widget? loadingWidget;
  final MainAxisAlignment alignment;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledBackgroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? maximumSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MouseCursor? mouseCursor;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration? animationDuration;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment2;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color? overlayColor;

  const VooButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.icon,
    this.size = VooButtonSize.medium,
    this.variant = VooButtonVariant.elevated,
    this.expanded = false,
    this.loading = false,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.loadingWidget,
    this.alignment = MainAxisAlignment.center,
    this.foregroundColor,
    this.backgroundColor,
    this.disabledForegroundColor,
    this.disabledBackgroundColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment2,
    this.splashFactory,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    // Calculate button height based on size
    double buttonHeight;
    double horizontalPadding;
    double fontSize;
    double iconSize;

    switch (size) {
      case VooButtonSize.small:
        buttonHeight = 32.0;
        horizontalPadding = design.spacingMd;
        fontSize = 13.0;
        iconSize = design.iconSizeSm;
        break;
      case VooButtonSize.medium:
        buttonHeight = design.buttonHeight;
        horizontalPadding = design.spacingLg;
        fontSize = 14.0;
        iconSize = design.iconSizeMd;
        break;
      case VooButtonSize.large:
        buttonHeight = 52.0;
        horizontalPadding = design.spacingXl;
        fontSize = 16.0;
        iconSize = design.iconSizeLg;
        break;
    }

    // Build child widget
    Widget buttonChild;
    if (loading) {
      buttonChild = loadingWidget ??
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == VooButtonVariant.elevated ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
              ),
            ),
          );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          Icon(icon, size: iconSize),
          SizedBox(width: design.spacingSm),
          Flexible(child: child),
        ],
      );
    } else {
      buttonChild = child;
    }

    // Apply text style to child if it's a Text widget
    if (child is Text) {
      buttonChild = DefaultTextStyle(
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        child: buttonChild,
      );
    }

    // Build button style
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding);

    final effectiveMinimumSize = minimumSize ?? Size(expanded ? double.infinity : 0, buttonHeight);

    final effectiveShape = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.radiusMd),
        );

    final effectiveAnimationDuration = animationDuration ?? design.animationDuration;

    // Build the button based on variant
    switch (variant) {
      case VooButtonVariant.elevated:
        return SizedBox(
          width: expanded ? double.infinity : null,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            onLongPress: loading ? null : onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ??
                ElevatedButton.styleFrom(
                  foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
                  backgroundColor: backgroundColor ?? theme.colorScheme.primary,
                  disabledForegroundColor: disabledForegroundColor,
                  disabledBackgroundColor: disabledBackgroundColor,
                  elevation: elevation ?? 2,
                  padding: effectivePadding,
                  minimumSize: effectiveMinimumSize,
                  maximumSize: maximumSize,
                  shape: effectiveShape,
                  visualDensity: visualDensity,
                  tapTargetSize: tapTargetSize,
                  animationDuration: effectiveAnimationDuration,
                  enableFeedback: enableFeedback,
                  alignment: alignment2,
                  splashFactory: splashFactory,
                  overlayColor: overlayColor,
                ),
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            child: buttonChild,
          ),
        );

      case VooButtonVariant.outlined:
        return SizedBox(
          width: expanded ? double.infinity : null,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            onLongPress: loading ? null : onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ??
                OutlinedButton.styleFrom(
                  foregroundColor: foregroundColor ?? theme.colorScheme.primary,
                  backgroundColor: backgroundColor,
                  disabledForegroundColor: disabledForegroundColor,
                  disabledBackgroundColor: disabledBackgroundColor,
                  padding: effectivePadding,
                  minimumSize: effectiveMinimumSize,
                  maximumSize: maximumSize,
                  side: side ??
                      BorderSide(
                        color: theme.colorScheme.outline,
                      ),
                  shape: effectiveShape,
                  visualDensity: visualDensity,
                  tapTargetSize: tapTargetSize,
                  animationDuration: effectiveAnimationDuration,
                  enableFeedback: enableFeedback,
                  alignment: alignment2,
                  splashFactory: splashFactory,
                  overlayColor: overlayColor,
                ),
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            child: buttonChild,
          ),
        );

      case VooButtonVariant.text:
        return SizedBox(
          width: expanded ? double.infinity : null,
          child: TextButton(
            onPressed: loading ? null : onPressed,
            onLongPress: loading ? null : onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ??
                TextButton.styleFrom(
                  foregroundColor: foregroundColor ?? theme.colorScheme.primary,
                  backgroundColor: backgroundColor,
                  disabledForegroundColor: disabledForegroundColor,
                  disabledBackgroundColor: disabledBackgroundColor,
                  padding: effectivePadding,
                  minimumSize: effectiveMinimumSize,
                  maximumSize: maximumSize,
                  shape: effectiveShape,
                  visualDensity: visualDensity,
                  tapTargetSize: tapTargetSize,
                  animationDuration: effectiveAnimationDuration,
                  enableFeedback: enableFeedback,
                  alignment: alignment2,
                  splashFactory: splashFactory,
                  overlayColor: overlayColor,
                ),
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            child: buttonChild,
          ),
        );

      case VooButtonVariant.tonal:
        return SizedBox(
          width: expanded ? double.infinity : null,
          child: FilledButton.tonal(
            onPressed: loading ? null : onPressed,
            onLongPress: loading ? null : onLongPress,
            onHover: onHover,
            onFocusChange: onFocusChange,
            style: style ??
                FilledButton.styleFrom(
                  foregroundColor: foregroundColor ?? theme.colorScheme.onSecondaryContainer,
                  backgroundColor: backgroundColor ?? theme.colorScheme.secondaryContainer,
                  disabledForegroundColor: disabledForegroundColor,
                  disabledBackgroundColor: disabledBackgroundColor,
                  elevation: elevation ?? 0,
                  padding: effectivePadding,
                  minimumSize: effectiveMinimumSize,
                  maximumSize: maximumSize,
                  shape: effectiveShape,
                  enabledMouseCursor: mouseCursor,
                  visualDensity: visualDensity,
                  tapTargetSize: tapTargetSize,
                  animationDuration: effectiveAnimationDuration,
                  enableFeedback: enableFeedback,
                  alignment: alignment2,
                  splashFactory: splashFactory,
                  overlayColor: overlayColor,
                ),
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            statesController: statesController,
            child: buttonChild,
          ),
        );
    }
  }
}

/// Icon button with Voo design system integration
class VooIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? color;
  final Color? disabledColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? splashColor;
  final double? splashRadius;
  final String? tooltip;
  final bool selected;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final BoxConstraints? constraints;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enableFeedback;
  final ButtonStyle? style;
  final bool? isSelected;
  final Widget? selectedIcon;
  final VisualDensity? visualDensity;
  final MouseCursor? mouseCursor;

  const VooIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.color,
    this.disabledColor,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.tooltip,
    this.selected = false,
    this.selectedColor,
    this.padding,
    this.alignment = Alignment.center,
    this.constraints,
    this.autofocus = false,
    this.focusNode,
    this.enableFeedback = true,
    this.style,
    this.isSelected,
    this.selectedIcon,
    this.visualDensity,
    this.mouseCursor,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    final effectiveIconSize = iconSize ?? design.iconSizeLg;
    final effectivePadding = padding ?? EdgeInsets.all(design.spacingSm);

    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: effectiveIconSize,
      color: color,
      disabledColor: disabledColor,
      hoverColor: hoverColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashRadius: splashRadius,
      padding: effectivePadding,
      alignment: alignment,
      constraints: constraints,
      autofocus: autofocus,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      style: style,
      isSelected: isSelected ?? selected,
      selectedIcon: selectedIcon ?? Icon(icon),
      visualDensity: visualDensity,
      mouseCursor: mouseCursor,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }
}
