import 'package:flutter/material.dart';
import '../foundations/design_system.dart';

class VooDropdown<T> extends StatefulWidget {
  final T? value;
  final List<VooDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final IconData? prefixIcon;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final double? menuMaxHeight;
  final bool isExpanded;
  final Widget? disabledHint;
  final int elevation;
  final TextStyle? style;
  final Widget? underline;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const VooDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.prefixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.menuMaxHeight,
    this.isExpanded = true,
    this.disabledHint,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
  });

  @override
  State<VooDropdown<T>> createState() => _VooDropdownState<T>();
}

class _VooDropdownState<T> extends State<VooDropdown<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final hasError = widget.error != null && widget.error!.isNotEmpty;

    // Determine border color based on state
    Color borderColor;
    if (!widget.enabled) {
      borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
    } else if (hasError) {
      borderColor = theme.colorScheme.error;
    } else if (_isFocused) {
      borderColor = theme.colorScheme.primary;
    } else {
      borderColor = theme.colorScheme.outline;
    }

    return AnimatedContainer(
      duration: design.animationDurationFast,
      curve: design.animationCurve,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError
                    ? theme.colorScheme.error
                    : _isFocused
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                fontWeight: _isFocused ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            SizedBox(height: design.spacingXs),
          ],
          Container(
            height: design.inputHeight,
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: design.spacingLg,
                ),
            decoration: BoxDecoration(
              // No background color to match TextFormField styling
              borderRadius: BorderRadius.circular(design.radiusMd),
              border: Border.all(
                color: borderColor,
                width: _isFocused ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    size: design.iconSizeMd,
                    color: _isFocused ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: design.spacingMd),
                ],
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: widget.value,
                      items: widget.items
                          .map(
                            (item) => DropdownMenuItem<T>(
                              value: item.value,
                              enabled: item.enabled,
                              alignment: widget.alignment,
                              child: Row(
                                children: [
                                  if (item.icon != null) ...[
                                    Icon(
                                      item.icon,
                                      size: design.iconSizeMd,
                                      color: item.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                                    ),
                                    SizedBox(width: design.spacingSm),
                                  ],
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.label,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: item.enabled ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                                          ),
                                        ),
                                        if (item.subtitle != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            item.subtitle!,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: widget.enabled ? widget.onChanged : null,
                      hint: widget.hint != null
                          ? Text(
                              widget.hint!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                            )
                          : null,
                      disabledHint: widget.disabledHint,
                      focusNode: _focusNode,
                      autofocus: widget.autofocus,
                      menuMaxHeight: widget.menuMaxHeight,
                      isExpanded: widget.isExpanded,
                      elevation: widget.elevation,
                      style: widget.style ?? theme.textTheme.bodyMedium,
                      icon: widget.icon ??
                          Icon(
                            Icons.arrow_drop_down,
                            color: widget.enabled
                                ? (widget.iconEnabledColor ?? theme.colorScheme.onSurfaceVariant)
                                : (widget.iconDisabledColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.38)),
                          ),
                      iconSize: widget.iconSize,
                      isDense: widget.isDense,
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(design.radiusMd),
                      dropdownColor: theme.colorScheme.surface,
                      focusColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.helper != null || widget.error != null) ...[
            SizedBox(height: design.spacingXs),
            Text(
              widget.error ?? widget.helper ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class VooDropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;

  const VooDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.enabled = true,
  });
}
