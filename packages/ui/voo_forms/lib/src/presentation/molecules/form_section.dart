import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_field.dart';
import 'package:voo_forms/src/domain/entities/form_section.dart';
import 'package:voo_forms/src/presentation/atoms/voo_form_header.dart';
import 'package:voo_forms/src/presentation/controllers/voo_form_controller.dart';
import 'package:voo_forms/src/presentation/molecules/form_field_builder.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

class FormSectionWidget extends StatefulWidget {
  final VooFormSection section;
  final List<VooFormField> fields;
  final VooFormController controller;
  final bool showErrors;
  final EdgeInsetsGeometry? padding;

  const FormSectionWidget({
    super.key,
    required this.section,
    required this.fields,
    required this.controller,
    this.showErrors = true,
    this.padding,
  });

  @override
  State<FormSectionWidget> createState() => _FormSectionWidgetState();
}

class _FormSectionWidgetState extends State<FormSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.section.collapsed;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (!_isCollapsed) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
      if (_isCollapsed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = VooResponsive.maybeOf(context);

    // Calculate responsive columns
    final columns = widget.section.columns ??
        (responsive?.device(
          phone: 1,
          tablet: 2,
          desktop: 3,
          defaultValue: 1,
        ) ?? 1);

    // Build section header
    Widget? header;
    if (widget.section.header != null) {
      header = FormHeaderWidget(
        header: widget.section.header!,
        onTap: widget.section.collapsible ? _toggleCollapse : null,
      );
    } else if (widget.section.title != null || widget.section.icon != null) {
      header = InkWell(
        onTap: widget.section.collapsible ? _toggleCollapse : null,
        borderRadius: BorderRadius.circular(design.radiusMd),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: design.spacingMd,
            horizontal: design.spacingLg,
          ),
          child: Row(
            children: [
              if (widget.section.icon != null) ...[
                Icon(
                  widget.section.icon,
                  size: design.iconSizeLg,
                  color: widget.section.color ?? theme.colorScheme.primary,
                ),
                SizedBox(width: design.spacingMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.section.title != null)
                      Text(
                        widget.section.title!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.section.color,
                        ),
                      ),
                    if (widget.section.subtitle != null) ...[
                      SizedBox(height: design.spacingXs),
                      Text(
                        widget.section.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.section.collapsible)
                AnimatedRotation(
                  turns: _isCollapsed ? 0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: design.iconSizeLg,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Build section description
    Widget? description;
    if (widget.section.description != null && !_isCollapsed) {
      description = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacingLg,
          vertical: design.spacingSm,
        ),
        child: Text(
          widget.section.description!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    // Build fields content
    Widget content;
    if ((columns) > 1 && !(responsive?.isPhone ?? false)) {
      // Grid layout for multiple columns
      content = LayoutBuilder(
        builder: (context, constraints) {
          final columnsCount = columns;
          final itemWidth = (constraints.maxWidth -
                  (columnsCount - 1) * design.spacingMd) /
              columnsCount;
          
          return Wrap(
            spacing: design.spacingMd,
            runSpacing: design.spacingMd,
            children: widget.fields.map((field) {
              return SizedBox(
                width: field.gridColumns != null
                    ? (itemWidth * field.gridColumns! +
                        design.spacingMd * (field.gridColumns! - 1))
                    : itemWidth,
                child: VooFormFieldBuilder(
                  field: field,
                  controller: widget.controller,
                  showError: widget.showErrors,
                ),
              );
            }).toList(),
          );
        },
      );
    } else {
      // Single column layout
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.fields
            .map((field) => Padding(
                  padding: EdgeInsets.only(bottom: design.spacingMd),
                  child: VooFormFieldBuilder(
                    field: field,
                    controller: widget.controller,
                    showError: widget.showErrors,
                  ),
                ),)
            .toList(),
      );
    }

    // Wrap content in animation if collapsible
    if (widget.section.collapsible) {
      content = SizeTransition(
        sizeFactor: _expandAnimation,
        child: Padding(
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: design.spacingLg,
                vertical: design.spacingMd,
              ),
          child: content,
        ),
      );
    } else {
      content = Padding(
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: design.spacingLg,
              vertical: design.spacingMd,
            ),
        child: content,
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.radiusLg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header,
          if (description != null) description,
          content,
        ],
      ),
    );
  }
}