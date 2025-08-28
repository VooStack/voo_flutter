import 'package:flutter/material.dart';

/// Configuration for form styling and behavior
class VooFormConfig {
  /// Label position relative to field
  final LabelPosition labelPosition;
  
  /// Label style variant
  final LabelStyle labelStyle;
  
  /// Field variant (outlined, filled, underlined)
  final FieldVariant fieldVariant;
  
  /// Field size (small, medium, large)
  final FieldSize fieldSize;
  
  /// Spacing between fields
  final double fieldSpacing;
  
  /// Spacing between sections
  final double sectionSpacing;
  
  /// Max width for form on large screens
  final double? maxFormWidth;
  
  /// Whether to show field icons
  final bool showFieldIcons;
  
  /// Whether to show required indicator
  final bool showRequiredIndicator;
  
  /// Required indicator text or symbol
  final String requiredIndicator;
  
  /// Error display mode
  final ErrorDisplayMode errorDisplayMode;
  
  /// Submit button position
  final ButtonPosition submitButtonPosition;
  
  /// Submit button style
  final ButtonStyle? submitButtonStyle;
  
  /// Form padding
  final EdgeInsetsGeometry? padding;
  
  /// Form margin
  final EdgeInsetsGeometry? margin;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Border decoration
  final BoxDecoration? decoration;
  
  /// Whether form should be centered on large screens
  final bool centerOnLargeScreens;
  
  /// Breakpoint for switching to mobile layout
  final double mobileBreakpoint;
  
  /// Breakpoint for switching to tablet layout
  final double tabletBreakpoint;
  
  /// Number of columns for grid layout on different screen sizes
  final ResponsiveColumns gridColumns;
  
  /// Custom theme overrides
  final ThemeData? themeOverrides;

  const VooFormConfig({
    this.labelPosition = LabelPosition.above,
    this.labelStyle = LabelStyle.normal,
    this.fieldVariant = FieldVariant.outlined,
    this.fieldSize = FieldSize.medium,
    this.fieldSpacing = 16.0,
    this.sectionSpacing = 24.0,
    this.maxFormWidth,
    this.showFieldIcons = true,
    this.showRequiredIndicator = true,
    this.requiredIndicator = '*',
    this.errorDisplayMode = ErrorDisplayMode.below,
    this.submitButtonPosition = ButtonPosition.bottomRight,
    this.submitButtonStyle,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.decoration,
    this.centerOnLargeScreens = true,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 1024.0,
    this.gridColumns = const ResponsiveColumns(),
    this.themeOverrides,
  });

  /// Create a config optimized for mobile
  factory VooFormConfig.mobile() {
    return const VooFormConfig(
      labelPosition: LabelPosition.floating,
      fieldSize: FieldSize.large,
      fieldSpacing: 12.0,
      maxFormWidth: double.infinity,
      centerOnLargeScreens: false,
    );
  }

  /// Create a config optimized for desktop with centered form
  factory VooFormConfig.desktop() {
    return const VooFormConfig(
      labelPosition: LabelPosition.above,
      fieldSize: FieldSize.medium,
      maxFormWidth: 600.0,
      centerOnLargeScreens: true,
      padding: EdgeInsets.all(24.0),
    );
  }

  /// Create a config for compact forms
  factory VooFormConfig.compact() {
    return const VooFormConfig(
      labelPosition: LabelPosition.inline,
      fieldSize: FieldSize.small,
      fieldSpacing: 8.0,
      sectionSpacing: 16.0,
    );
  }

  /// Create a config for material design forms
  factory VooFormConfig.material() {
    return const VooFormConfig(
      labelPosition: LabelPosition.floating,
      fieldVariant: FieldVariant.outlined,
      fieldSize: FieldSize.medium,
    );
  }

  VooFormConfig copyWith({
    LabelPosition? labelPosition,
    LabelStyle? labelStyle,
    FieldVariant? fieldVariant,
    FieldSize? fieldSize,
    double? fieldSpacing,
    double? sectionSpacing,
    double? maxFormWidth,
    bool? showFieldIcons,
    bool? showRequiredIndicator,
    String? requiredIndicator,
    ErrorDisplayMode? errorDisplayMode,
    ButtonPosition? submitButtonPosition,
    ButtonStyle? submitButtonStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    BoxDecoration? decoration,
    bool? centerOnLargeScreens,
    double? mobileBreakpoint,
    double? tabletBreakpoint,
    ResponsiveColumns? gridColumns,
    ThemeData? themeOverrides,
  }) {
    return VooFormConfig(
      labelPosition: labelPosition ?? this.labelPosition,
      labelStyle: labelStyle ?? this.labelStyle,
      fieldVariant: fieldVariant ?? this.fieldVariant,
      fieldSize: fieldSize ?? this.fieldSize,
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      maxFormWidth: maxFormWidth ?? this.maxFormWidth,
      showFieldIcons: showFieldIcons ?? this.showFieldIcons,
      showRequiredIndicator: showRequiredIndicator ?? this.showRequiredIndicator,
      requiredIndicator: requiredIndicator ?? this.requiredIndicator,
      errorDisplayMode: errorDisplayMode ?? this.errorDisplayMode,
      submitButtonPosition: submitButtonPosition ?? this.submitButtonPosition,
      submitButtonStyle: submitButtonStyle ?? this.submitButtonStyle,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      decoration: decoration ?? this.decoration,
      centerOnLargeScreens: centerOnLargeScreens ?? this.centerOnLargeScreens,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      gridColumns: gridColumns ?? this.gridColumns,
      themeOverrides: themeOverrides ?? this.themeOverrides,
    );
  }

  /// Get responsive column count based on screen width
  int getColumnCount(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return gridColumns.mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return gridColumns.tablet;
    } else {
      return gridColumns.desktop;
    }
  }

  /// Get field padding based on size
  EdgeInsetsGeometry getFieldPadding() {
    switch (fieldSize) {
      case FieldSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case FieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case FieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
    }
  }

  /// Get label text style based on configuration
  TextStyle? getLabelStyle(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyMedium;
    
    switch (labelStyle) {
      case LabelStyle.normal:
        return baseStyle;
      case LabelStyle.bold:
        return baseStyle?.copyWith(fontWeight: FontWeight.bold);
      case LabelStyle.uppercase:
        return baseStyle?.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
      case LabelStyle.minimal:
        return baseStyle?.copyWith(
          fontSize: 13.0,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        );
    }
  }
}

/// Label position options
enum LabelPosition {
  above,      // Label above field
  inline,     // Label inside field
  floating,   // Material design floating label
  left,       // Label to the left of field
  hidden,     // No label shown
}

/// Label style variants
enum LabelStyle {
  normal,
  bold,
  uppercase,
  minimal,
}

/// Field appearance variants
enum FieldVariant {
  outlined,
  filled,
  underlined,
  ghost,      // No visible border until focused
}

/// Field size options
enum FieldSize {
  small,
  medium,
  large,
}

/// Error display modes
enum ErrorDisplayMode {
  below,      // Show error below field
  tooltip,    // Show as tooltip on hover/focus
  inline,     // Show inline with field
  none,       // Don't show errors
}

/// Submit button position
enum ButtonPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
  sticky,     // Sticky at bottom of viewport
  inline,     // Inline with last field
}

/// Responsive column configuration
class ResponsiveColumns {
  final int mobile;
  final int tablet;
  final int desktop;

  const ResponsiveColumns({
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
  });
}

/// Field group configuration for grouping related fields
class FieldGroup {
  final String? title;
  final String? description;
  final List<String> fieldIds;
  final int columns;
  final bool collapsible;
  final bool initiallyExpanded;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const FieldGroup({
    this.title,
    this.description,
    required this.fieldIds,
    this.columns = 1,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.decoration,
    this.padding,
    this.margin,
  });
}