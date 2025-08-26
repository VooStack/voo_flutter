import 'package:flutter/material.dart';
import '../foundations/design_system.dart';

/// Material 3 chip variants
enum VooChipVariant {
  /// Assist chip - helps users refine content or initiate actions
  assist,

  /// Filter chip - allows users to filter content
  filter,

  /// Input chip - represents user input or selection
  input,

  /// Suggestion chip - provides suggestions to users
  suggestion,
}

/// Material 3 chip component
class VooChip extends StatelessWidget {
  final Widget label;
  final Widget? avatar;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;
  final VoidCallback? onPressed;
  final bool selected;
  final VooChipVariant variant;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? deleteIconColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final double? pressElevation;
  final bool enabled;
  final String? tooltip;
  final TextStyle? labelStyle;
  final IconThemeData? iconTheme;

  const VooChip({
    super.key,
    required this.label,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.onPressed,
    this.selected = false,
    this.variant = VooChipVariant.assist,
    this.backgroundColor,
    this.selectedColor,
    this.deleteIconColor,
    this.side,
    this.shape,
    this.padding,
    this.materialTapTargetSize,
    this.elevation,
    this.pressElevation,
    this.enabled = true,
    this.tooltip,
    this.labelStyle,
    this.iconTheme,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    Widget chip;

    switch (variant) {
      case VooChipVariant.filter:
        chip = FilterChip(
          label: label,
          avatar: avatar,
          selected: selected,
          onSelected: enabled && onPressed != null ? (_) => onPressed!() : null,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          side: side,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(design.radiusSm),
              ),
          padding: padding,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          pressElevation: pressElevation,
          labelStyle: labelStyle,
          iconTheme: iconTheme,
        );
        break;

      case VooChipVariant.input:
        chip = InputChip(
          label: label,
          avatar: avatar,
          deleteIcon: deleteIcon,
          onDeleted: enabled ? onDeleted : null,
          onPressed: enabled ? onPressed : null,
          selected: selected,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          deleteIconColor: deleteIconColor,
          side: side,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(design.radiusSm),
              ),
          padding: padding,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          pressElevation: pressElevation,
          labelStyle: labelStyle,
          iconTheme: iconTheme,
        );
        break;

      case VooChipVariant.suggestion:
        chip = ActionChip(
          label: label,
          avatar: avatar,
          onPressed: enabled ? onPressed : null,
          backgroundColor: backgroundColor,
          side: side,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(design.radiusSm),
              ),
          padding: padding,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          pressElevation: pressElevation,
          labelStyle: labelStyle,
          iconTheme: iconTheme,
        );
        break;

      case VooChipVariant.assist:
        chip = ActionChip(
          label: label,
          avatar: avatar,
          onPressed: enabled ? onPressed : null,
          backgroundColor: backgroundColor,
          side: side,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(design.radiusSm),
              ),
          padding: padding,
          materialTapTargetSize: materialTapTargetSize,
          elevation: elevation,
          pressElevation: pressElevation,
          labelStyle: labelStyle,
          iconTheme: iconTheme,
        );
        break;
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: chip,
      );
    }

    return chip;
  }
}

/// Choice chip for single selection
class VooChoiceChip<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onSelected;
  final Widget label;
  final Widget? avatar;
  final Color? backgroundColor;
  final Color? selectedColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final String? tooltip;

  const VooChoiceChip({
    super.key,
    required this.value,
    required this.groupValue,
    this.onSelected,
    required this.label,
    this.avatar,
    this.backgroundColor,
    this.selectedColor,
    this.side,
    this.shape,
    this.padding,
    this.enabled = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final isSelected = value == groupValue;

    final chip = ChoiceChip(
      label: label,
      avatar: avatar,
      selected: isSelected,
      onSelected: enabled && onSelected != null ? (selected) => onSelected!(selected ? value : null) : null,
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      side: side,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(design.radiusSm),
          ),
      padding: padding,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: chip,
      );
    }

    return chip;
  }
}

/// Chip group for managing multiple chips
class VooChipGroup<T> extends StatelessWidget {
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>>? onSelectionChanged;
  final String Function(T) labelBuilder;
  final Widget? Function(T)? avatarBuilder;
  final bool Function(T)? isDisabled;
  final VooChipVariant variant;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final bool singleSelection;
  final bool allowEmpty;

  const VooChipGroup({
    super.key,
    required this.items,
    required this.selectedItems,
    this.onSelectionChanged,
    required this.labelBuilder,
    this.avatarBuilder,
    this.isDisabled,
    this.variant = VooChipVariant.filter,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.singleSelection = false,
    this.allowEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        final isItemDisabled = isDisabled?.call(item) ?? false;

        return VooChip(
          label: Text(labelBuilder(item)),
          avatar: avatarBuilder?.call(item),
          selected: isSelected,
          variant: variant,
          enabled: !isItemDisabled,
          onPressed: onSelectionChanged != null
              ? () {
                  List<T> newSelection;

                  if (singleSelection) {
                    newSelection = isSelected && allowEmpty ? [] : [item];
                  } else {
                    if (isSelected) {
                      newSelection = selectedItems.where((i) => i != item).toList();
                    } else {
                      newSelection = [...selectedItems, item];
                    }
                  }

                  if (newSelection.isNotEmpty || allowEmpty) {
                    onSelectionChanged!(newSelection);
                  }
                }
              : null,
        );
      }).toList(),
    );
  }
}

/// Deletable chip list
class VooDeletableChipList<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T>? onDeleted;
  final String Function(T) labelBuilder;
  final Widget? Function(T)? avatarBuilder;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final Color? backgroundColor;
  final BorderSide? side;

  const VooDeletableChipList({
    super.key,
    required this.items,
    this.onDeleted,
    required this.labelBuilder,
    this.avatarBuilder,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.backgroundColor,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((item) {
        return VooChip(
          label: Text(labelBuilder(item)),
          avatar: avatarBuilder?.call(item),
          variant: VooChipVariant.input,
          backgroundColor: backgroundColor,
          side: side,
          onDeleted: onDeleted != null ? () => onDeleted!(item) : null,
        );
      }).toList(),
    );
  }
}

/// Icon chip with label
class VooIconChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? labelColor;
  final BorderSide? side;
  final EdgeInsetsGeometry? padding;
  final bool enabled;

  const VooIconChip({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.labelColor,
    this.side,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    return ActionChip(
      avatar: Icon(icon, size: 18, color: iconColor),
      label: Text(
        label,
        style: TextStyle(color: labelColor),
      ),
      onPressed: enabled ? onPressed : null,
      backgroundColor: backgroundColor,
      side: side,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: design.spacingSm,
            vertical: 0,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.radiusSm),
      ),
    );
  }
}

/// Status chip for displaying states
class VooStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool outlined;
  final double? size;

  const VooStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.outlined = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor = brightness == Brightness.light ? Colors.black : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacingSm,
        vertical: design.spacingXs,
      ),
      decoration: BoxDecoration(
        color: outlined ? null : color.withValues(alpha: 0.2),
        border: outlined ? Border.all(color: color) : null,
        borderRadius: BorderRadius.circular(design.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: size ?? 14,
              color: outlined ? color : textColor,
            ),
            SizedBox(width: design.spacingXs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: outlined ? color : textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Tag chip for categorization
class VooTagChip extends StatelessWidget {
  final String tag;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final double? size;

  const VooTagChip({
    super.key,
    required this.tag,
    this.color,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final colorScheme = Theme.of(context).colorScheme;
    final chipColor = color ?? colorScheme.primary;

    return Material(
      color: selected ? chipColor.withValues(alpha: 0.2) : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? chipColor : colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(design.radiusSm),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radiusSm),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacingSm,
            vertical: design.spacingXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#$tag',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: size,
                      color: selected ? chipColor : null,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
              if (onDeleted != null) ...[
                SizedBox(width: design.spacingXs),
                InkWell(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: size ?? 14,
                    color: selected ? chipColor : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
