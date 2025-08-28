import 'package:flutter/material.dart';
import 'package:voo_forms/src/presentation/widgets/voo_field_options.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Configuration for form styling and behavior
class VooFormConfig {
  /// Label position relative to field
  final LabelPosition labelPosition;
  
  /// Label style variant
  final LabelStyle labelStyle;
  
  /// Field variant (outlined, filled, underlined)
  final FieldVariant fieldVariant;
  
  /// Field size (small, medium, large)
  final VooSpacingSize fieldSize;
  
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
  
  /// Default field options that apply to all fields
  final VooFieldOptions? defaultFieldOptions;

  const VooFormConfig({
    this.labelPosition = LabelPosition.above,
    this.labelStyle = LabelStyle.normal,
    this.fieldVariant = FieldVariant.outlined,
    this.fieldSize = VooSpacingSize.md,
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
    this.defaultFieldOptions,
  });

  /// Create a config optimized for mobile
  factory VooFormConfig.mobile() {
    return const VooFormConfig(
      labelPosition: LabelPosition.floating,
      fieldSize: VooSpacingSize.lg,
      fieldSpacing: 12.0,
      maxFormWidth: double.infinity,
      centerOnLargeScreens: false,
    );
  }

  /// Create a config optimized for desktop with centered form
  factory VooFormConfig.desktop() {
    return const VooFormConfig(
      labelPosition: LabelPosition.above,
      fieldSize: VooSpacingSize.md,
      maxFormWidth: 600.0,
      centerOnLargeScreens: true,
      padding: EdgeInsets.all(24.0),
    );
  }

  /// Create a config for compact forms
  factory VooFormConfig.compact() {
    return const VooFormConfig(
      labelPosition: LabelPosition.inline,
      fieldSize: VooSpacingSize.sm,
      fieldSpacing: 8.0,
      sectionSpacing: 16.0,
    );
  }

  /// Create a config for material design forms
  factory VooFormConfig.material() {
    return const VooFormConfig(
      labelPosition: LabelPosition.floating,
      fieldVariant: FieldVariant.outlined,
      fieldSize: VooSpacingSize.md,
    );
  }

  VooFormConfig copyWith({
    LabelPosition? labelPosition,
    LabelStyle? labelStyle,
    FieldVariant? fieldVariant,
    VooSpacingSize? fieldSize,
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
      case VooSpacingSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
      case VooSpacingSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case VooSpacingSize.md:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case VooSpacingSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
      case VooSpacingSize.xl:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0);
      case VooSpacingSize.xxl:
        return const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0);
      case VooSpacingSize.xxxl:
        return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 28.0);
      case VooSpacingSize.none:
        return EdgeInsets.zero;
      case VooSpacingSize.custom:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
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
      case LabelStyle.emphasized:
        return baseStyle?.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        );
    }
  }
}

// Enums are now imported from voo_field_options.dart to avoid duplication

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