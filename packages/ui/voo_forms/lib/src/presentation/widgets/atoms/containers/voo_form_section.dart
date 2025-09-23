import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// A container widget for organizing form fields into logical sections
/// Provides visual grouping with optional title, description, and styling
class VooFormSection extends StatefulWidget implements VooFormFieldWidget {
  /// Section title displayed at the top
  final String? title;

  /// Optional custom title widget
  final Widget? titleWidget;

  /// Optional description text below the title
  final String? description;

  /// Child widgets (typically form fields) in this section
  final List<Widget> children;

  /// Whether this section can be collapsed
  final bool isCollapsible;

  /// Initial expanded state (only applies if isCollapsible is true)
  final bool initiallyExpanded;

  /// Padding inside the section
  final EdgeInsetsGeometry? padding;

  /// Margin around the section
  final EdgeInsetsGeometry? margin;

  /// Background color for the section
  final Color? backgroundColor;

  /// Border decoration for the section
  final BoxBorder? border;

  /// Border radius for the section
  final BorderRadius? borderRadius;

  /// Elevation for the section (creates shadow)
  final double elevation;

  /// Whether to show a divider after the title
  final bool showTitleDivider;

  /// Spacing between child widgets
  final double childrenSpacing;

  /// Cross axis alignment for children
  final CrossAxisAlignment crossAxisAlignment;

  /// Optional leading widget (e.g., icon) for the title
  final Widget? leading;

  /// Optional trailing widget for the title (overrides collapse icon if collapsible)
  final Widget? trailing;

  /// Callback when section is expanded/collapsed
  final ValueChanged<bool>? onExpansionChanged;

  // VooFormFieldWidget interface implementation
  @override
  String get name => 'section_${title?.replaceAll(' ', '_').toLowerCase() ?? 'unnamed'}';

  @override
  String? get label => title;

  @override
  dynamic get initialValue => null;

  @override
  VooFieldLayout get layout => VooFieldLayout.standard;

  const VooFormSection({
    super.key,
    this.title,
    this.titleWidget,
    this.description,
    required this.children,
    this.isCollapsible = false,
    this.initiallyExpanded = true,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.elevation = 0,
    this.showTitleDivider = true,
    this.childrenSpacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.leading,
    this.trailing,
    this.onExpansionChanged,
  }) : assert(title != null || titleWidget != null || !isCollapsible, 'A title is required when section is collapsible');

  @override
  State<VooFormSection> createState() => _VooFormSectionState();

  @override
  VooFormFieldWidget copyWith() => VooFormSection(
    key: key,
    title: title,
    titleWidget: titleWidget,
    description: description,
    isCollapsible: isCollapsible,
    initiallyExpanded: initiallyExpanded,
    padding: padding,
    margin: margin,
    backgroundColor: backgroundColor,
    border: border,
    borderRadius: borderRadius,
    elevation: elevation,
    showTitleDivider: showTitleDivider,
    childrenSpacing: childrenSpacing,
    crossAxisAlignment: crossAxisAlignment,
    leading: leading,
    trailing: trailing,
    onExpansionChanged: onExpansionChanged,
    children: children,
  );
}

class _VooFormSectionState extends State<VooFormSection> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.titleWidget == null && widget.title == null) {
      return const SizedBox.shrink();
    }

    final Widget titleContent =
        widget.titleWidget ??
        Text(
          widget.title!,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
        );

    // Build the title row with optional leading/trailing widgets
    Widget titleRow = Row(
      children: [
        if (widget.leading != null) ...[widget.leading!, const SizedBox(width: 12)],
        Expanded(child: titleContent),
        if (widget.isCollapsible && widget.trailing == null)
          RotationTransition(
            turns: _rotationAnimation,
            child: Icon(Icons.expand_more, color: theme.colorScheme.onSurfaceVariant),
          )
        else if (widget.trailing != null)
          widget.trailing!,
      ],
    );

    // Make title clickable if collapsible
    if (widget.isCollapsible) {
      titleRow = InkWell(
        onTap: _toggleExpansion,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: titleRow),
      );
    }

    return titleRow;
  }

  Widget _buildDescription(BuildContext context) {
    if (widget.description == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(widget.description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }

  Widget _buildChildren() {
    if (widget.children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        for (int i = 0; i < widget.children.length; i++) ...[widget.children[i], if (i < widget.children.length - 1) SizedBox(height: widget.childrenSpacing)],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine effective values
    final effectivePadding = widget.padding ?? const EdgeInsets.all(16);
    final effectiveMargin = widget.margin ?? const EdgeInsets.symmetric(vertical: 8);
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final effectiveBackgroundColor = widget.backgroundColor ?? (widget.elevation > 0 ? theme.colorScheme.surface : Colors.transparent);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        _buildDescription(context),
        if (widget.showTitleDivider && (widget.title != null || widget.titleWidget != null) && (!widget.isCollapsible || _isExpanded)) ...[
          const SizedBox(height: 12),
          Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
        ] else if (widget.title != null || widget.titleWidget != null)
          const SizedBox(height: 16),

        // Animated expansion for children
        if (widget.isCollapsible) SizeTransition(sizeFactor: _expandAnimation, child: _buildChildren()) else _buildChildren(),
      ],
    );

    // Apply padding
    content = Padding(padding: effectivePadding, child: content);

    // Apply decoration (background, border, etc.)
    if (widget.elevation > 0 || widget.backgroundColor != null || widget.border != null) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
          border: widget.border ?? (widget.elevation == 0 ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)) : null),
          boxShadow: widget.elevation > 0
              ? [BoxShadow(color: theme.shadowColor.withValues(alpha: 0.1), blurRadius: widget.elevation * 2, offset: Offset(0, widget.elevation))]
              : null,
        ),
        child: ClipRRect(borderRadius: effectiveBorderRadius, child: content),
      );
    }

    // Apply margin
    if (effectiveMargin != EdgeInsets.zero) {
      content = Padding(padding: effectiveMargin, child: content);
    }

    return content;
  }
}
