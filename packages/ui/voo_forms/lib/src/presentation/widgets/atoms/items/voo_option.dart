import 'package:flutter/material.dart';

/// A standardized option widget for dropdowns and multi-selects
/// Provides a consistent design system for list options
class VooOption extends StatelessWidget {
  /// The main text to display
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Whether this option is currently selected
  final bool isSelected;

  /// Leading widget (icon, image, etc.)
  final Widget? leading;

  /// Trailing widget (icon, badge, etc.)
  final Widget? trailing;

  /// Whether to show a checkbox for multi-select scenarios
  final bool showCheckbox;

  /// Whether to show a radio button for single-select scenarios
  final bool showRadio;

  /// Whether to show a checkmark icon when selected
  final bool showCheckmark;

  /// Custom background color when selected
  final Color? selectedColor;

  /// Custom text style for the title
  final TextStyle? titleStyle;

  /// Custom text style for the subtitle
  final TextStyle? subtitleStyle;

  /// Padding for the option content
  final EdgeInsetsGeometry? padding;

  /// Whether this option is enabled
  final bool enabled;

  /// Callback when the option is tapped
  final VoidCallback? onTap;

  /// Custom height for the option
  final double? height;

  /// Whether to use dense layout
  final bool dense;

  const VooOption({
    super.key,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    this.leading,
    this.trailing,
    this.showCheckbox = false,
    this.showRadio = false,
    this.showCheckmark = true,
    this.selectedColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.enabled = true,
    this.onTap,
    this.height,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine effective colors
    final effectiveSelectedColor = selectedColor ?? colorScheme.primaryContainer.withValues(alpha: 0.3);
    final effectiveTitleColor = !enabled
        ? colorScheme.onSurface.withValues(alpha: 0.38)
        : isSelected
        ? colorScheme.primary
        : colorScheme.onSurface;
    final effectiveSubtitleColor = !enabled ? colorScheme.onSurface.withValues(alpha: 0.38) : colorScheme.onSurfaceVariant;

    // Build title widget
    final Widget titleWidget = Text(
      title,
      style: (titleStyle ?? theme.textTheme.bodyMedium)?.copyWith(color: effectiveTitleColor, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
      maxLines: subtitle != null ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );

    // Build subtitle widget if provided
    Widget? subtitleWidget;
    if (subtitle != null) {
      subtitleWidget = Text(
        subtitle!,
        style: (subtitleStyle ?? theme.textTheme.bodySmall)?.copyWith(color: effectiveSubtitleColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Build leading widget
    Widget? effectiveLeading = leading;
    if (showCheckbox) {
      effectiveLeading = Checkbox(value: isSelected, onChanged: enabled ? (_) => onTap?.call() : null, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
    } else if (showRadio) {
      effectiveLeading = Radio<bool>(
        value: true,
        groupValue: isSelected,
        onChanged: enabled ? (_) => onTap?.call() : null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }

    // Build trailing widget
    Widget? effectiveTrailing = trailing;
    if (effectiveTrailing == null && showCheckmark && isSelected) {
      effectiveTrailing = Icon(Icons.check, size: 20, color: colorScheme.primary);
    }

    // Build content
    Widget content = Row(
      children: [
        if (effectiveLeading != null) ...[effectiveLeading, SizedBox(width: dense ? 8 : 12)],
        Expanded(
          child: subtitle != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [titleWidget, const SizedBox(height: 2), subtitleWidget!],
                )
              : titleWidget,
        ),
        if (effectiveTrailing != null) ...[SizedBox(width: dense ? 8 : 12), effectiveTrailing],
      ],
    );

    // Apply padding
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: dense ? 12 : 16, vertical: dense ? 8 : 12);

    content = Padding(padding: effectivePadding, child: content);

    // Apply height constraint if provided
    if (height != null) {
      content = SizedBox(height: height, child: content);
    }

    // Wrap in container with background color
    return Container(
      color: isSelected ? effectiveSelectedColor : null,
      child: InkWell(onTap: enabled ? onTap : null, child: content),
    );
  }
}

/// Simplified option for basic use cases
class VooSimpleOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCheckbox;

  const VooSimpleOption({super.key, required this.text, this.isSelected = false, this.onTap, this.showCheckbox = false});

  @override
  Widget build(BuildContext context) => VooOption(title: text, isSelected: isSelected, onTap: onTap, showCheckbox: showCheckbox, dense: true);
}
