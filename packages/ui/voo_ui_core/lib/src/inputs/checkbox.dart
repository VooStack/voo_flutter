import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/design_system.dart';

/// Material 3 checkbox with enhanced features
class VooCheckbox extends StatelessWidget {
  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final String? semanticLabel;
  final bool isError;
  final MouseCursor? mouseCursor;
  final double? splashRadius;

  const VooCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.semanticLabel,
    this.isError = false,
    this.mouseCursor,
    this.splashRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Checkbox(
      value: value,
      tristate: tristate,
      onChanged: onChanged,
      activeColor: isError ? colorScheme.error : activeColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: side ?? (isError ? BorderSide(color: colorScheme.error, width: 2) : null),
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      splashRadius: splashRadius,
    );
  }
}

/// Material 3 checkbox list tile
class VooCheckboxListTile extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final bool enabled;
  final bool tristate;
  final ListTileControlAffinity controlAffinity;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool? enableFeedback;
  final String? semanticLabel;
  final bool selected;
  final bool isError;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;

  const VooCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense,
    this.enabled = true,
    this.tristate = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.semanticLabel,
    this.selected = false,
    this.isError = false,
    this.hoverColor,
    this.mouseCursor,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;

    return CheckboxListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: isError ? colorScheme.error : activeColor,
      checkColor: checkColor,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: enabled,
      tristate: tristate,
      controlAffinity: controlAffinity,
      autofocus: autofocus,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: design.spacingMd),
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(design.radiusMd)),
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      selected: selected,
      hoverColor: hoverColor,
      mouseCursor: mouseCursor,
    );
  }
}

/// Checkbox group for multiple selections
class VooCheckboxGroup<T> extends StatelessWidget {
  final List<T> items;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final String Function(T) labelBuilder;
  final String? Function(T)? subtitleBuilder;
  final Widget? Function(T)? leadingBuilder;
  final bool Function(T)? isDisabled;
  final String? label;
  final String? helperText;
  final String? errorText;
  final EdgeInsetsGeometry? contentPadding;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final bool enabled;

  const VooCheckboxGroup({
    super.key,
    required this.items,
    required this.values,
    this.onChanged,
    required this.labelBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.isDisabled,
    this.label,
    this.helperText,
    this.errorText,
    this.contentPadding,
    this.direction = Axis.vertical,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;

    Widget content;

    if (direction == Axis.vertical) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: items.map((item) => _buildCheckboxTile(item, context)).toList());
    } else {
      content = Wrap(
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runSpacing: runSpacing,
        children: items.map((item) => _buildCheckboxChip(item, context)).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant)),
          SizedBox(height: design.spacingSm),
        ],
        Container(
          padding: contentPadding,
          decoration: hasError
              ? BoxDecoration(
                  border: Border.all(color: colorScheme.error),
                  borderRadius: BorderRadius.circular(design.radiusMd),
                )
              : null,
          child: content,
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            errorText ?? helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxTile(T item, BuildContext context) {
    final isSelected = values.contains(item);
    final isItemDisabled = isDisabled?.call(item) ?? false;

    return VooCheckboxListTile(
      value: isSelected,
      onChanged: enabled && !isItemDisabled
          ? (value) {
              if (value == true) {
                onChanged?.call([...values, item]);
              } else {
                onChanged?.call(values.where((v) => v != item).toList());
              }
            }
          : null,
      title: Text(labelBuilder(item)),
      subtitle: subtitleBuilder != null ? Text(subtitleBuilder!(item) ?? '') : null,
      secondary: leadingBuilder?.call(item),
      enabled: enabled && !isItemDisabled,
      isError: errorText != null,
    );
  }

  Widget _buildCheckboxChip(T item, BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = values.contains(item);
    final isItemDisabled = isDisabled?.call(item) ?? false;

    return FilterChip(
      label: Text(labelBuilder(item)),
      selected: isSelected,
      onSelected: enabled && !isItemDisabled
          ? (value) {
              if (value) {
                onChanged?.call([...values, item]);
              } else {
                onChanged?.call(values.where((v) => v != item).toList());
              }
            }
          : null,
      avatar: leadingBuilder?.call(item),
      backgroundColor: errorText != null ? colorScheme.errorContainer : null,
      selectedColor: errorText != null ? colorScheme.error.withValues(alpha: 0.2) : null,
      padding: EdgeInsets.symmetric(horizontal: design.spacingSm, vertical: design.spacingXs),
    );
  }
}

/// Individual checkbox with label (atomic component)
class VooLabeledCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
  final bool tristate;
  final bool isError;
  final EdgeInsetsGeometry? padding;

  const VooLabeledCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.tristate = false,
    this.isError = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return InkWell(
      onTap: enabled
          ? () {
              if (tristate) {
                if (value == null) {
                  onChanged?.call(false);
                } else if (value == false) {
                  onChanged?.call(true);
                } else {
                  onChanged?.call(null);
                }
              } else {
                onChanged?.call(!(value ?? false));
              }
            }
          : null,
      borderRadius: BorderRadius.circular(design.radiusMd),
      child: Padding(
        padding: padding ?? EdgeInsets.all(design.spacingSm),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: design.spacingMd)],
            VooCheckbox(value: value, onChanged: enabled ? onChanged : null, tristate: tristate, isError: isError),
            SizedBox(width: design.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: enabled ? null : Theme.of(context).disabledColor)),
                  if (subtitle != null) ...[
                    SizedBox(height: design.spacingXs),
                    Text(
                      subtitle!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: enabled ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).disabledColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
