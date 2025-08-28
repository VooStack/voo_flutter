import 'package:flutter/material.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// A Material 3 compliant divider for form sections
/// Follows Material Design 3 guidelines for dividers
class VooFormSectionDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final DividerStyle style;

  const VooFormSectionDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.margin,
    this.style = DividerStyle.full,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = VooResponsive.maybeOf(context);
    
    // Material 3 divider specifications
    final defaultThickness = 1.0;
    final defaultHeight = responsive?.device(
      phone: design.spacingMd * 2,
      tablet: design.spacingLg * 2,
      desktop: design.spacingXl * 2,
      defaultValue: design.spacingLg * 2,
    ) ?? design.spacingLg * 2;
    
    // Calculate indentation based on style
    double calculateIndent() {
      switch (style) {
        case DividerStyle.full:
          return 0;
        case DividerStyle.inset:
          return responsive?.device(
            phone: design.spacingMd,
            tablet: design.spacingLg,
            desktop: design.spacingXl,
            defaultValue: design.spacingLg,
          ) ?? design.spacingLg;
        case DividerStyle.middle:
          return responsive?.device(
            phone: design.spacingLg * 2,
            tablet: design.spacingXl * 2,
            desktop: design.spacingXl * 3,
            defaultValue: design.spacingXl * 2,
          ) ?? design.spacingXl * 2;
      }
    }
    
    final dividerIndent = indent ?? calculateIndent();
    final dividerEndIndent = endIndent ?? (style == DividerStyle.middle ? dividerIndent : 0);
    
    // Material 3 color - use outline variant
    final dividerColor = color ?? theme.colorScheme.outlineVariant;
    
    Widget divider = Divider(
      height: height ?? defaultHeight,
      thickness: thickness ?? defaultThickness,
      indent: dividerIndent,
      endIndent: dividerEndIndent,
      color: dividerColor,
    );
    
    if (margin != null) {
      divider = Padding(
        padding: margin!,
        child: divider,
      );
    }
    
    return divider;
  }
  
  /// Creates a full-width divider
  factory VooFormSectionDivider.full({
    double? height,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return VooFormSectionDivider(
      height: height,
      thickness: thickness,
      color: color,
      margin: margin,
      style: DividerStyle.full,
    );
  }
  
  /// Creates an inset divider (Material 3 standard)
  factory VooFormSectionDivider.inset({
    double? height,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return VooFormSectionDivider(
      height: height,
      thickness: thickness,
      color: color,
      margin: margin,
      style: DividerStyle.inset,
    );
  }
  
  /// Creates a middle divider (centered with equal indents)
  factory VooFormSectionDivider.middle({
    double? height,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return VooFormSectionDivider(
      height: height,
      thickness: thickness,
      color: color,
      margin: margin,
      style: DividerStyle.middle,
    );
  }
}

/// Divider style options
enum DividerStyle {
  /// Full width divider
  full,
  
  /// Inset divider (Material 3 standard)
  inset,
  
  /// Middle divider with equal indents
  middle,
}

/// A Material 3 compliant text divider for form sections
/// Shows text in the middle of the divider (e.g., "OR", "AND")
class VooFormSectionTextDivider extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double? thickness;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? textPadding;
  final TextAlign textAlign;
  final Widget? icon;
  final double? spacing;
  final DividerTextStyle style;

  const VooFormSectionTextDivider({
    super.key,
    required this.text,
    this.textStyle,
    this.thickness,
    this.color,
    this.margin,
    this.textPadding,
    this.textAlign = TextAlign.center,
    this.icon,
    this.spacing,
    this.style = DividerTextStyle.outlined,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);
    final responsive = VooResponsive.maybeOf(context);
    
    // Material 3 specifications
    final dividerColor = color ?? theme.colorScheme.outlineVariant;
    final dividerThickness = thickness ?? 1.0;
    
    // Text styling following Material 3
    final defaultTextStyle = textStyle ?? theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );
    
    // Calculate spacing
    final horizontalSpacing = spacing ?? responsive?.device(
      phone: design.spacingMd,
      tablet: design.spacingLg,
      desktop: design.spacingLg,
      defaultValue: design.spacingMd,
    ) ?? design.spacingMd;
    
    // Build text widget with optional icon
    Widget textWidget = Text(
      text,
      style: defaultTextStyle,
      textAlign: textAlign,
    );
    
    if (icon != null) {
      textWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: design.spacingSm),
          textWidget,
        ],
      );
    }
    
    // Apply text padding
    if (textPadding != null) {
      textWidget = Padding(
        padding: textPadding!,
        child: textWidget,
      );
    }
    
    // Apply style-specific decoration
    switch (style) {
      case DividerTextStyle.plain:
        // No additional decoration
        break;
        
      case DividerTextStyle.outlined:
        textWidget = Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacingMd,
            vertical: design.spacingSm,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: dividerColor,
              width: dividerThickness,
            ),
            borderRadius: BorderRadius.circular(design.radiusFull),
            color: theme.colorScheme.surface,
          ),
          child: textWidget,
        );
        break;
        
      case DividerTextStyle.chip:
        textWidget = Chip(
          label: textWidget,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          side: BorderSide.none,
          labelStyle: defaultTextStyle,
          padding: EdgeInsets.symmetric(
            horizontal: design.spacingMd,
          ),
        );
        break;
        
      case DividerTextStyle.filled:
        textWidget = Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacingMd,
            vertical: design.spacingSm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(design.radiusFull),
          ),
          child: textWidget,
        );
        break;
    }
    
    // Build the complete divider with text
    Widget divider = Row(
      children: [
        Expanded(
          child: Container(
            height: dividerThickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
          child: textWidget,
        ),
        Expanded(
          child: Container(
            height: dividerThickness,
            color: dividerColor,
          ),
        ),
      ],
    );
    
    // Apply margin
    if (margin != null) {
      divider = Padding(
        padding: margin!,
        child: divider,
      );
    }
    
    return divider;
  }
  
  /// Creates a simple "OR" divider
  factory VooFormSectionTextDivider.or({
    TextStyle? textStyle,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
    DividerTextStyle style = DividerTextStyle.outlined,
  }) {
    return VooFormSectionTextDivider(
      text: 'OR',
      textStyle: textStyle,
      thickness: thickness,
      color: color,
      margin: margin,
      style: style,
    );
  }
  
  /// Creates a simple "AND" divider
  factory VooFormSectionTextDivider.and({
    TextStyle? textStyle,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
    DividerTextStyle style = DividerTextStyle.outlined,
  }) {
    return VooFormSectionTextDivider(
      text: 'AND',
      textStyle: textStyle,
      thickness: thickness,
      color: color,
      margin: margin,
      style: style,
    );
  }
  
  /// Creates a custom text divider with an icon
  factory VooFormSectionTextDivider.withIcon({
    required String text,
    required Widget icon,
    TextStyle? textStyle,
    double? thickness,
    Color? color,
    EdgeInsetsGeometry? margin,
    DividerTextStyle style = DividerTextStyle.outlined,
  }) {
    return VooFormSectionTextDivider(
      text: text,
      icon: icon,
      textStyle: textStyle,
      thickness: thickness,
      color: color,
      margin: margin,
      style: style,
    );
  }
}

/// Style options for text dividers
enum DividerTextStyle {
  /// Plain text without decoration
  plain,
  
  /// Text with outline border (default)
  outlined,
  
  /// Text as a chip
  chip,
  
  /// Text with filled background
  filled,
}