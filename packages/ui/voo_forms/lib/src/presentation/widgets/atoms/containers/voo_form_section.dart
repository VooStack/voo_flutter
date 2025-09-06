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
  
  /// Whether to use Material 3 card style
  final bool useCard;
  
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
  
  @override
  VooFormSection copyWith() => VooFormSection(
    title: title,
    titleWidget: titleWidget,
    description: description,
    children: children,
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
    useCard: useCard,
  );
  
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
    this.showTitleDivider = false,
    this.childrenSpacing = 16.0,
    this.useCard = true,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.leading,
    this.trailing,
    this.onExpansionChanged,
  }) : assert(
    title != null || titleWidget != null || !isCollapsible,
    'A title is required when section is collapsible',
  );

  @override
  State<VooFormSection> createState() => _VooFormSectionState();
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),);
    
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

  Widget _buildTitleSection(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.titleWidget == null && widget.title == null) {
      return const SizedBox.shrink();
    }
    
    // Use ListTile with subtle background for header
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: widget.isCollapsible ? _toggleExpansion : null,
          leading: widget.leading,
          title: widget.titleWidget ?? Text(
            widget.title!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: widget.description != null ? Text(
            widget.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ) : null,
          trailing: widget.isCollapsible 
            ? RotationTransition(
                turns: _rotationAnimation,
                child: Icon(
                  Icons.expand_more,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : widget.trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          visualDensity: VisualDensity.comfortable,
        ),
      ),
    );
  }


  Widget _buildChildren() {
    if (widget.children.isEmpty) return const SizedBox.shrink();
    
    // Render children with proper spacing
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.children.length; i++) ...[
          widget.children[i],
          if (i < widget.children.length - 1)
            SizedBox(height: widget.childrenSpacing),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use Material 3 surface colors with proper contrast
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    
    // Build content following Material 3 expansion tile pattern
    Widget sectionContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title section
        if (widget.title != null || widget.titleWidget != null)
          _buildTitleSection(context),
        
        // Content area with animation
        if (widget.isCollapsible)
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _buildChildren(),
            ),
            crossFadeState: _isExpanded 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          )
        else if (widget.children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildChildren(),
          ),
      ],
    );
    
    // Apply Material 3 card styling with proper visual containment
    if (widget.useCard) {
      sectionContent = Card(
        elevation: widget.elevation > 0 ? widget.elevation : 1,
        color: backgroundColor,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: sectionContent,
        ),
      );
    } else {
      // Non-card layout with optional decoration
      if (widget.backgroundColor != null || widget.border != null) {
        sectionContent = Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            border: widget.border,
          ),
          clipBehavior: Clip.antiAlias,
          child: sectionContent,
        );
      } else {
        sectionContent = Padding(
          padding: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
          child: sectionContent,
        );
      }
    }
    
    return sectionContent;
    
  }
}