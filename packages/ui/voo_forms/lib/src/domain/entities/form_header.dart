import 'package:flutter/material.dart';

/// Represents a header that can be used to categorize and organize form sections
class VooFormHeader {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;
  final HeaderStyle style;
  final HeaderAlignment alignment;
  final bool showDivider;
  final double? dividerHeight;
  final Color? dividerColor;
  final Map<String, dynamic>? metadata;

  const VooFormHeader({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.leading,
    this.trailing,
    this.color,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.decoration,
    this.style = HeaderStyle.normal,
    this.alignment = HeaderAlignment.left,
    this.showDivider = false,
    this.dividerHeight,
    this.dividerColor,
    this.metadata,
  });

  /// Create a copy with updated values
  VooFormHeader copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    IconData? icon,
    Widget? leading,
    Widget? trailing,
    Color? color,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    BoxDecoration? decoration,
    HeaderStyle? style,
    HeaderAlignment? alignment,
    bool? showDivider,
    double? dividerHeight,
    Color? dividerColor,
    Map<String, dynamic>? metadata,
  }) =>
      VooFormHeader(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        leading: leading ?? this.leading,
        trailing: trailing ?? this.trailing,
        color: color ?? this.color,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        borderRadius: borderRadius ?? this.borderRadius,
        decoration: decoration ?? this.decoration,
        style: style ?? this.style,
        alignment: alignment ?? this.alignment,
        showDivider: showDivider ?? this.showDivider,
        dividerHeight: dividerHeight ?? this.dividerHeight,
        dividerColor: dividerColor ?? this.dividerColor,
        metadata: metadata ?? this.metadata,
      );

  /// Convert to map
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'style': style.toString(),
        'alignment': alignment.toString(),
        'showDivider': showDivider,
        'dividerHeight': dividerHeight,
        'metadata': metadata,
      };
}

/// Style variations for form headers
enum HeaderStyle {
  /// Normal text style
  normal,
  
  /// Large prominent header
  large,
  
  /// Small subtle header
  small,
  
  /// Card-style header with background
  card,
  
  /// Banner-style header
  banner,
  
  /// Chip-style compact header
  chip,
  
  /// Gradient background header
  gradient,
}

/// Alignment options for header content
enum HeaderAlignment {
  /// Left aligned (default)
  left,
  
  /// Center aligned
  center,
  
  /// Right aligned
  right,
  
  /// Space between elements
  spaceBetween,
  
  /// Space around elements
  spaceAround,
}