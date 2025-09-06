import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/field_layout.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_form_field_widget.dart';

/// Section divider for forms - provides visual separation between form sections
/// Implements VooFormFieldWidget so it can be used in VooForm fields list
/// Follows atomic design and KISS principle
class VooFormSectionDivider extends StatelessWidget implements VooFormFieldWidget {
  @override
  final String name;
  
  /// Optional label for the section (displayed as title)
  @override
  final String? label;
  
  /// Optional subtitle for the section
  final String? subtitle;
  
  /// Custom widget to display instead of label/subtitle
  final Widget? customWidget;
  
  /// Height of the divider line
  final double thickness;
  
  /// Color of the divider line
  final Color? color;
  
  /// Indent from the start
  final double indent;
  
  /// Indent from the end
  final double endIndent;
  
  /// Space above the divider
  final double topSpacing;
  
  /// Space below the divider
  final double bottomSpacing;
  
  /// Whether to show the divider line
  final bool showLine;
  
  /// Text style for the label
  final TextStyle? labelStyle;
  
  /// Text style for the subtitle
  final TextStyle? subtitleStyle;
  
  /// Alignment of the label/subtitle
  final CrossAxisAlignment alignment;
  
  /// Layout configuration for the divider
  @override
  final VooFieldLayout layout;
  
  bool get required => false;
  
  dynamic get value => null;
  
  @override
  dynamic get initialValue => null;
  
  const VooFormSectionDivider({
    super.key,
    required this.name,
    this.label,
    this.subtitle,
    this.customWidget,
    this.thickness = 1.0,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.topSpacing = 24.0,
    this.bottomSpacing = 16.0,
    this.showLine = true,
    this.labelStyle,
    this.subtitleStyle,
    this.alignment = CrossAxisAlignment.start,
    this.layout = VooFieldLayout.wide,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(
        top: topSpacing,
        bottom: bottomSpacing,
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // Custom widget takes precedence
          if (customWidget != null)
            customWidget!
          // Otherwise show label/subtitle if provided
          else if (label != null || subtitle != null)
            Column(
              crossAxisAlignment: alignment,
              children: [
                if (label != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      label!,
                      style: labelStyle ?? theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                if (subtitle != null) ...[
                  if (label != null) const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          
          // Show divider line if enabled
          if (showLine) ...[
            if (label != null || subtitle != null || customWidget != null)
              const SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(
                left: indent,
                right: endIndent,
              ),
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (color ?? theme.colorScheme.outlineVariant).withValues(alpha: 0),
                    (color ?? theme.colorScheme.outlineVariant).withValues(alpha: 0.3),
                    (color ?? theme.colorScheme.outlineVariant).withValues(alpha: 0.3),
                    (color ?? theme.colorScheme.outlineVariant).withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.1, 0.9, 1.0],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  VooFormFieldWidget copyWith() => VooFormSectionDivider(
      key: key,
      name: name,
      label: label,
      subtitle: subtitle,
      customWidget: customWidget,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
      topSpacing: topSpacing,
      bottomSpacing: bottomSpacing,
      showLine: showLine,
      labelStyle: labelStyle,
      subtitleStyle: subtitleStyle,
      alignment: alignment,
      layout: layout,
    );
}

/// Convenience constructors for common divider styles
extension VooFormSectionDividerStyles on VooFormSectionDivider {
  /// Creates a simple line divider with no text
  static VooFormSectionDivider line({
    Key? key,
    String name = 'divider',
    double thickness = 1.0,
    Color? color,
    double indent = 0.0,
    double endIndent = 0.0,
    double topSpacing = 12.0,
    double bottomSpacing = 12.0,
    VooFieldLayout layout = VooFieldLayout.wide,
  }) => VooFormSectionDivider(
        key: key,
        name: name,
        thickness: thickness,
        color: color,
        indent: indent,
        endIndent: endIndent,
        topSpacing: topSpacing,
        bottomSpacing: bottomSpacing,
        layout: layout,
      );
  
  /// Creates a section header with label
  static VooFormSectionDivider section({
    Key? key,
    required String name,
    required String label,
    String? subtitle,
    bool showLine = true,
    double topSpacing = 32.0,
    double bottomSpacing = 20.0,
    TextStyle? labelStyle,
    TextStyle? subtitleStyle,
    VooFieldLayout layout = VooFieldLayout.wide,
  }) => VooFormSectionDivider(
        key: key,
        name: name,
        label: label,
        subtitle: subtitle,
        showLine: showLine,
        topSpacing: topSpacing,
        bottomSpacing: bottomSpacing,
        labelStyle: labelStyle,
        subtitleStyle: subtitleStyle,
        layout: layout,
      );
  
  /// Creates a spacer with no visible divider
  static VooFormSectionDivider spacer({
    Key? key,
    String name = 'spacer',
    double height = 24.0,
    VooFieldLayout layout = VooFieldLayout.wide,
  }) => VooFormSectionDivider(
        key: key,
        name: name,
        showLine: false,
        topSpacing: height / 2,
        bottomSpacing: height / 2,
        layout: layout,
      );
}