import 'package:flutter/material.dart';
import '../foundations/design_system.dart';

/// Material 3 radio button
class VooRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color? activeColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool toggleable;
  final MouseCursor? mouseCursor;
  final bool isError;
  
  const VooRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
    this.toggleable = false,
    this.mouseCursor,
    this.isError = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: isError ? colorScheme.error : activeColor,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor != null 
        ? WidgetStateProperty.all(overlayColor) 
        : null,
      splashRadius: splashRadius,
      focusNode: focusNode,
      autofocus: autofocus,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
    );
  }
}

/// Material 3 radio list tile
class VooRadioListTile<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool toggleable;
  final Color? activeColor;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final bool enabled;
  final ListTileControlAffinity controlAffinity;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool? enableFeedback;
  final bool selected;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;
  final bool isError;
  
  const VooRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.activeColor,
    this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense,
    this.enabled = true,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.selected = false,
    this.hoverColor,
    this.mouseCursor,
    this.isError = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      toggleable: toggleable,
      activeColor: isError ? colorScheme.error : activeColor,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      isThreeLine: isThreeLine,
      dense: dense,
      enabled: enabled,
      controlAffinity: controlAffinity,
      autofocus: autofocus,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(
        horizontal: design.spacingMd,
      ),
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.radiusMd),
      ),
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

/// Radio button group for single selection
class VooRadioGroup<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
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
  final bool toggleable;
  
  const VooRadioGroup({
    super.key,
    required this.items,
    this.value,
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
    this.toggleable = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;
    
    Widget content;
    
    if (direction == Axis.vertical) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => _buildRadioTile(item, context)).toList(),
      );
    } else {
      content = Wrap(
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runSpacing: runSpacing,
        children: items.map((item) => _buildRadioChip(item, context)).toList(),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: design.spacingSm),
        ],
        Container(
          padding: contentPadding,
          decoration: hasError ? BoxDecoration(
            border: Border.all(color: colorScheme.error),
            borderRadius: BorderRadius.circular(design.radiusMd),
          ) : null,
          child: content,
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: design.spacingXs),
          Text(
            errorText ?? helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildRadioTile(T item, BuildContext context) {
    final isItemDisabled = isDisabled?.call(item) ?? false;
    
    return VooRadioListTile<T>(
      value: item,
      groupValue: value,
      onChanged: enabled && !isItemDisabled ? onChanged : null,
      toggleable: toggleable,
      title: Text(labelBuilder(item)),
      subtitle: subtitleBuilder != null 
        ? (subtitleBuilder!(item) != null ? Text(subtitleBuilder!(item)!) : null)
        : null,
      secondary: leadingBuilder?.call(item),
      enabled: enabled && !isItemDisabled,
      isError: errorText != null,
    );
  }
  
  Widget _buildRadioChip(T item, BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == item;
    final isItemDisabled = isDisabled?.call(item) ?? false;
    
    return ChoiceChip(
      label: Text(labelBuilder(item)),
      selected: isSelected,
      onSelected: enabled && !isItemDisabled ? (selected) {
        if (selected) {
          onChanged?.call(item);
        } else if (toggleable) {
          onChanged?.call(null);
        }
      } : null,
      avatar: leadingBuilder?.call(item),
      backgroundColor: errorText != null 
        ? colorScheme.errorContainer 
        : null,
      selectedColor: errorText != null
        ? colorScheme.error.withValues(alpha: 0.2)
        : null,
      padding: EdgeInsets.symmetric(
        horizontal: design.spacingSm,
        vertical: design.spacingXs,
      ),
    );
  }
}

/// Individual radio button with label (atomic component)
class VooLabeledRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
  final bool toggleable;
  final bool isError;
  final EdgeInsetsGeometry? padding;
  
  const VooLabeledRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.toggleable = false,
    this.isError = false,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return InkWell(
      onTap: enabled ? () {
        if (value == groupValue && toggleable) {
          onChanged?.call(null);
        } else {
          onChanged?.call(value);
        }
      } : null,
      borderRadius: BorderRadius.circular(design.radiusMd),
      child: Padding(
        padding: padding ?? EdgeInsets.all(design.spacingSm),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: design.spacingMd),
            ],
            VooRadio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              toggleable: toggleable,
              isError: isError,
            ),
            SizedBox(width: design.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: enabled ? null : Theme.of(context).disabledColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: design.spacingXs),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: enabled 
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).disabledColor,
                      ),
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

/// Radio button card for enhanced visual selection
class VooRadioCard<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  
  const VooRadioCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.selectedColor,
    this.unselectedColor,
    this.elevation,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;
    
    return Card(
      elevation: elevation ?? (isSelected ? 4 : 1),
      color: isSelected 
        ? (selectedColor ?? colorScheme.primaryContainer)
        : unselectedColor,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(value) : null,
        borderRadius: BorderRadius.circular(design.radiusMd),
        child: Padding(
          padding: padding ?? EdgeInsets.all(design.spacingMd),
          child: Row(
            children: [
              VooRadio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: enabled ? onChanged : null,
              ),
              SizedBox(width: design.spacingMd),
              if (leading != null) ...[
                leading!,
                SizedBox(width: design.spacingMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: isSelected 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      ),
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: design.spacingXs),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isSelected
                            ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                            : colorScheme.onSurfaceVariant,
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: design.spacingMd),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}