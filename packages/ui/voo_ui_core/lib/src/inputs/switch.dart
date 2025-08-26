import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../foundations/design_system.dart';

/// Material 3 switch component
class VooSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageProvider? inactiveThumbImage;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final DragStartBehavior dragStartBehavior;
  final Widget? thumbIcon;
  final bool isError;
  
  const VooSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.dragStartBehavior = DragStartBehavior.start,
    this.thumbIcon,
    this.isError = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: isError ? colorScheme.error : activeColor,
      activeTrackColor: isError 
        ? colorScheme.error.withValues(alpha: 0.5)
        : activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      activeThumbImage: activeThumbImage,
      inactiveThumbImage: inactiveThumbImage,
      materialTapTargetSize: materialTapTargetSize,
      thumbIcon: thumbIcon != null && thumbIcon is Icon
        ? WidgetStateProperty.all(thumbIcon as Icon)
        : null,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor != null
        ? WidgetStateProperty.all(overlayColor)
        : null,
      splashRadius: splashRadius,
      focusNode: focusNode,
      autofocus: autofocus,
      mouseCursor: mouseCursor,
      dragStartBehavior: dragStartBehavior,
    );
  }
}

/// Material 3 switch list tile
class VooSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageProvider? inactiveThumbImage;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final bool autofocus;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool? enableFeedback;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;
  final bool isError;
  
  const VooSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.enabled = true,
    this.autofocus = false,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
    this.hoverColor,
    this.mouseCursor,
    this.isError = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: isError ? colorScheme.error : activeColor,
      activeTrackColor: isError 
        ? colorScheme.error.withValues(alpha: 0.5)
        : activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      activeThumbImage: activeThumbImage,
      inactiveThumbImage: inactiveThumbImage,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(
        horizontal: design.spacingMd,
      ),
      autofocus: autofocus,
      selected: selected,
      controlAffinity: controlAffinity,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.radiusMd),
      ),
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
      focusNode: focusNode,
      enableFeedback: enableFeedback,
      hoverColor: hoverColor,
      mouseCursor: mouseCursor,
    );
  }
}

/// Labeled switch (atomic component)
class VooLabeledSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
  final bool isError;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;
  
  const VooLabeledSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.isError = false,
    this.padding,
    this.alignment = MainAxisAlignment.spaceBetween,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: BorderRadius.circular(design.radiusMd),
      child: Padding(
        padding: padding ?? EdgeInsets.all(design.spacingSm),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: design.spacingMd),
            ],
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
            SizedBox(width: design.spacingMd),
            VooSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              isError: isError,
            ),
          ],
        ),
      ),
    );
  }
}

/// Switch settings group
class VooSwitchGroup extends StatelessWidget {
  final Map<String, bool> switches;
  final ValueChanged<Map<String, bool>>? onChanged;
  final Map<String, String> labels;
  final Map<String, String>? subtitles;
  final Map<String, Widget>? icons;
  final Set<String>? disabledSwitches;
  final String? groupLabel;
  final String? helperText;
  final String? errorText;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final bool showDividers;
  
  const VooSwitchGroup({
    super.key,
    required this.switches,
    this.onChanged,
    required this.labels,
    this.subtitles,
    this.icons,
    this.disabledSwitches,
    this.groupLabel,
    this.helperText,
    this.errorText,
    this.contentPadding,
    this.enabled = true,
    this.showDividers = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;
    
    final switchKeys = switches.keys.toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groupLabel != null) ...[
          Text(
            groupLabel!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: hasError ? colorScheme.error : null,
            ),
          ),
          SizedBox(height: design.spacingMd),
        ],
        Container(
          padding: contentPadding,
          decoration: hasError ? BoxDecoration(
            border: Border.all(color: colorScheme.error),
            borderRadius: BorderRadius.circular(design.radiusMd),
          ) : null,
          child: Column(
            children: [
              for (int i = 0; i < switchKeys.length; i++) ...[
                _buildSwitchTile(switchKeys[i], context),
                if (showDividers && i < switchKeys.length - 1)
                  const Divider(),
              ],
            ],
          ),
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
  
  Widget _buildSwitchTile(String key, BuildContext context) {
    final isDisabled = disabledSwitches?.contains(key) ?? false;
    
    return VooSwitchListTile(
      value: switches[key] ?? false,
      onChanged: enabled && !isDisabled ? (value) {
        onChanged?.call({...switches, key: value});
      } : null,
      title: Text(labels[key] ?? key),
      subtitle: subtitles?[key] != null ? Text(subtitles![key]!) : null,
      secondary: icons?[key],
      enabled: enabled && !isDisabled,
      isError: errorText != null,
    );
  }
}

/// Switch card for feature toggles
class VooSwitchCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  
  const VooSwitchCard({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.elevation,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: elevation ?? (value ? 4 : 1),
      color: value 
        ? (activeColor ?? colorScheme.primaryContainer)
        : inactiveColor,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(!value) : null,
        borderRadius: BorderRadius.circular(design.radiusMd),
        child: Padding(
          padding: padding ?? EdgeInsets.all(design.spacingMd),
          child: Row(
            children: [
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
                        color: value 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      ),
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: design.spacingXs),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: value
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
              ] else ...[
                SizedBox(width: design.spacingMd),
                VooSwitch(
                  value: value,
                  onChanged: enabled ? onChanged : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Adaptive switch that changes style based on platform
class VooAdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;
  
  const VooAdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeTrackColor: activeColor,
      inactiveTrackColor: inactiveColor,
    );
  }
}