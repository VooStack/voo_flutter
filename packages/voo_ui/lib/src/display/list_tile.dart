import 'package:flutter/material.dart';
import 'package:voo_ui/src/foundations/spacing.dart';

class VooListTile extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final Color? selectedColor;
  final BorderRadius? borderRadius;

  const VooListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.selectedColor,
    this.borderRadius,
  });

  @override
  State<VooListTile> createState() => _VooListTileState();
}

class _VooListTileState extends State<VooListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = widget.isSelected
        ? (widget.selectedColor ?? theme.colorScheme.primaryContainer)
            .withValues(alpha: isDark ? 0.3 : 0.2)
        : _isHovered
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : Colors.transparent;

    final borderColor = widget.isSelected
        ? (widget.selectedColor ?? theme.colorScheme.primary)
            .withValues(alpha: 0.5)
        : _isHovered
            ? theme.colorScheme.outline.withValues(alpha: 0.3)
            : theme.colorScheme.outline.withValues(alpha: 0.1);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(
          horizontal: VooSpacing.sm,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(VooSpacing.radiusMd),
          border: Border.all(
            color: borderColor,
            width: widget.isSelected ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            borderRadius: widget.borderRadius ??
                BorderRadius.circular(VooSpacing.radiusMd),
            highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
            splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: VooSpacing.md,
                    vertical: 10,
                  ),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: VooSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultTextStyle(
                          style:
                              theme.textTheme.bodyMedium ?? const TextStyle(),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
                          DefaultTextStyle(
                            style: (theme.textTheme.bodySmall ??
                                    const TextStyle())
                                .copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: VooSpacing.md),
                    widget.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}