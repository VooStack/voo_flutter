import 'package:flutter/material.dart';
import '../foundations/design_system.dart';

/// Material 3 segmented button segment
class VooButtonSegment<T> {
  final T value;
  final Widget label;
  final Widget? icon;
  final String? tooltip;
  final bool enabled;
  
  const VooButtonSegment({
    required this.value,
    required this.label,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });
}

/// Material 3 segmented button for single selection
class VooSegmentedButton<T> extends StatelessWidget {
  final List<VooButtonSegment<T>> segments;
  final T? selected;
  final ValueChanged<T>? onSelectionChanged;
  final bool showSelectedIcon;
  final Widget? selectedIcon;
  final ButtonStyle? style;
  final bool enabled;
  
  const VooSegmentedButton({
    super.key,
    required this.segments,
    this.selected,
    this.onSelectionChanged,
    this.showSelectedIcon = true,
    this.selectedIcon,
    this.style,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return SegmentedButton<T>(
      segments: segments.map((segment) => ButtonSegment<T>(
        value: segment.value,
        label: segment.label,
        icon: segment.icon,
        tooltip: segment.tooltip,
        enabled: segment.enabled && enabled,
      )).toList(),
      selected: selected != null ? {selected as T} : {},
      onSelectionChanged: enabled && onSelectionChanged != null
        ? (Set<T> selection) {
            if (selection.isNotEmpty) {
              onSelectionChanged!(selection.first);
            }
          }
        : null,
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
      style: style ?? SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.radiusMd),
        ),
      ),
    );
  }
}

/// Material 3 multi-select segmented button
class VooMultiSegmentedButton<T> extends StatelessWidget {
  final List<VooButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final bool showSelectedIcon;
  final Widget? selectedIcon;
  final ButtonStyle? style;
  final bool enabled;
  final bool emptySelectionAllowed;
  
  const VooMultiSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.showSelectedIcon = true,
    this.selectedIcon,
    this.style,
    this.enabled = true,
    this.emptySelectionAllowed = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return SegmentedButton<T>(
      segments: segments.map((segment) => ButtonSegment<T>(
        value: segment.value,
        label: segment.label,
        icon: segment.icon,
        tooltip: segment.tooltip,
        enabled: segment.enabled && enabled,
      )).toList(),
      selected: selected,
      onSelectionChanged: enabled && onSelectionChanged != null
        ? onSelectionChanged
        : null,
      multiSelectionEnabled: true,
      emptySelectionAllowed: emptySelectionAllowed,
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
      style: style ?? SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.radiusMd),
        ),
      ),
    );
  }
}

/// Labeled segmented button with helper text
class VooLabeledSegmentedButton<T> extends StatelessWidget {
  final List<VooButtonSegment<T>> segments;
  final T? selected;
  final ValueChanged<T>? onSelectionChanged;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool showSelectedIcon;
  
  const VooLabeledSegmentedButton({
    super.key,
    required this.segments,
    this.selected,
    this.onSelectionChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.showSelectedIcon = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = errorText != null;
    
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
        VooSegmentedButton<T>(
          segments: segments,
          selected: selected,
          onSelectionChanged: enabled ? onSelectionChanged : null,
          enabled: enabled,
          showSelectedIcon: showSelectedIcon,
          style: hasError ? SegmentedButton.styleFrom(
            side: BorderSide(color: colorScheme.error),
          ) : null,
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
}

/// Icon segmented button for toolbar-like selections
class VooIconSegmentedButton<T> extends StatelessWidget {
  final List<VooIconSegment<T>> segments;
  final T? selected;
  final ValueChanged<T>? onSelectionChanged;
  final double? iconSize;
  final bool enabled;
  final Color? selectedColor;
  final Color? unselectedColor;
  
  const VooIconSegmentedButton({
    super.key,
    required this.segments,
    this.selected,
    this.onSelectionChanged,
    this.iconSize,
    this.enabled = true,
    this.selectedColor,
    this.unselectedColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SegmentedButton<T>(
      segments: segments.map((segment) => ButtonSegment<T>(
        value: segment.value,
        icon: Icon(
          segment.icon,
          size: iconSize ?? 20,
        ),
        label: segment.showLabel ? Text(segment.label) : const SizedBox.shrink(),
        tooltip: segment.tooltip ?? segment.label,
        enabled: segment.enabled && enabled,
      )).toList(),
      selected: selected != null ? {selected as T} : {},
      onSelectionChanged: enabled && onSelectionChanged != null
        ? (Set<T> selection) {
            if (selection.isNotEmpty) {
              onSelectionChanged!(selection.first);
            }
          }
        : null,
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: selectedColor ?? colorScheme.primaryContainer,
        selectedForegroundColor: selectedColor != null 
          ? colorScheme.onPrimaryContainer
          : null,
        backgroundColor: unselectedColor,
      ),
    );
  }
}

/// Icon segment for icon segmented button
class VooIconSegment<T> {
  final T value;
  final IconData icon;
  final String label;
  final String? tooltip;
  final bool enabled;
  final bool showLabel;
  
  const VooIconSegment({
    required this.value,
    required this.icon,
    required this.label,
    this.tooltip,
    this.enabled = true,
    this.showLabel = false,
  });
}

/// Custom styled segmented button
class VooCustomSegmentedButton<T> extends StatelessWidget {
  final List<VooCustomSegment<T>> segments;
  final T? selected;
  final ValueChanged<T>? onSelectionChanged;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final BoxDecoration? decoration;
  final bool enabled;
  
  const VooCustomSegmentedButton({
    super.key,
    required this.segments,
    this.selected,
    this.onSelectionChanged,
    this.padding,
    this.spacing,
    this.decoration,
    this.enabled = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: padding ?? EdgeInsets.all(design.spacingXs),
      decoration: decoration ?? BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(design.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < segments.length; i++) ...[
            if (i > 0 && spacing != null) SizedBox(width: spacing),
            _buildSegment(segments[i], context),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSegment(VooCustomSegment<T> segment, BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = segment.value == selected;
    
    return Flexible(
      fit: segment.flex != null ? FlexFit.tight : FlexFit.loose,
      flex: segment.flex ?? 1,
      child: Material(
        color: isSelected 
          ? (segment.selectedColor ?? colorScheme.primaryContainer)
          : (segment.unselectedColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(design.radiusSm),
        child: InkWell(
          onTap: enabled && segment.enabled && onSelectionChanged != null
            ? () => onSelectionChanged!(segment.value)
            : null,
          borderRadius: BorderRadius.circular(design.radiusSm),
          child: Padding(
            padding: segment.padding ?? EdgeInsets.symmetric(
              horizontal: design.spacingMd,
              vertical: design.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (segment.leading != null) ...[
                  segment.leading!,
                  SizedBox(width: design.spacingSm),
                ],
                segment.child,
                if (segment.trailing != null) ...[
                  SizedBox(width: design.spacingSm),
                  segment.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom segment for custom segmented button
class VooCustomSegment<T> {
  final T value;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final Color? selectedColor;
  final Color? unselectedColor;
  final EdgeInsetsGeometry? padding;
  final int? flex;
  
  const VooCustomSegment({
    required this.value,
    required this.child,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.selectedColor,
    this.unselectedColor,
    this.padding,
    this.flex,
  });
}

/// View switcher using segmented button
class VooViewSwitcher<T> extends StatelessWidget {
  final List<VooViewSegment<T>> views;
  final T selected;
  final ValueChanged<T> onViewChanged;
  final bool showIcons;
  final Widget? leading;
  final Widget? trailing;
  
  const VooViewSwitcher({
    super.key,
    required this.views,
    required this.selected,
    required this.onViewChanged,
    this.showIcons = true,
    this.leading,
    this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: design.spacingMd),
        ],
        Expanded(
          child: VooSegmentedButton<T>(
            segments: views.map((view) => VooButtonSegment<T>(
              value: view.value,
              label: Text(view.label),
              icon: showIcons && view.icon != null ? Icon(view.icon) : null,
              tooltip: view.tooltip,
              enabled: view.enabled,
            )).toList(),
            selected: selected,
            onSelectionChanged: onViewChanged,
                ),
        ),
        if (trailing != null) ...[
          SizedBox(width: design.spacingMd),
          trailing!,
        ],
      ],
    );
  }
}

/// View segment for view switcher
class VooViewSegment<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;
  
  const VooViewSegment({
    required this.value,
    required this.label,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });
}