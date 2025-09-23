import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/design_system.dart';

enum VooSpacingSize { xs, sm, md, lg, xl, xxl, xxxl, none, custom }

class VooContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final VooSpacingSize paddingSize;
  final EdgeInsetsGeometry? margin;
  final VooSpacingSize marginSize;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final VooSpacingSize borderRadiusSize;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape shape;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool animate;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const VooContainer({
    super.key,
    this.child,
    this.alignment,
    this.padding,
    this.paddingSize = VooSpacingSize.none,
    this.margin,
    this.marginSize = VooSpacingSize.none,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.borderRadius,
    this.borderRadiusSize = VooSpacingSize.none,
    this.border,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.animate = false,
    this.animationDuration,
    this.animationCurve,
  });

  EdgeInsetsGeometry? _getSpacing(VooDesignSystemData design, VooSpacingSize size) {
    switch (size) {
      case VooSpacingSize.xs:
        return EdgeInsets.all(design.spacingXs);
      case VooSpacingSize.sm:
        return EdgeInsets.all(design.spacingSm);
      case VooSpacingSize.md:
        return EdgeInsets.all(design.spacingMd);
      case VooSpacingSize.lg:
        return EdgeInsets.all(design.spacingLg);
      case VooSpacingSize.xl:
        return EdgeInsets.all(design.spacingXl);
      case VooSpacingSize.xxl:
        return EdgeInsets.all(design.spacingXxl);
      case VooSpacingSize.xxxl:
        return EdgeInsets.all(design.spacingXxxl);
      case VooSpacingSize.none:
      case VooSpacingSize.custom:
        return null;
    }
  }

  BorderRadiusGeometry? _getBorderRadius(VooDesignSystemData design, VooSpacingSize size) {
    switch (size) {
      case VooSpacingSize.xs:
        return BorderRadius.circular(design.radiusXs);
      case VooSpacingSize.sm:
        return BorderRadius.circular(design.radiusSm);
      case VooSpacingSize.md:
        return BorderRadius.circular(design.radiusMd);
      case VooSpacingSize.lg:
        return BorderRadius.circular(design.radiusLg);
      case VooSpacingSize.xl:
        return BorderRadius.circular(design.radiusXl);
      case VooSpacingSize.xxl:
        return BorderRadius.circular(design.radiusXxl);
      case VooSpacingSize.xxxl:
        return BorderRadius.circular(design.radiusFull);
      case VooSpacingSize.none:
      case VooSpacingSize.custom:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    // Calculate effective padding
    final effectivePadding = padding ?? _getSpacing(design, paddingSize);

    // Calculate effective margin
    final effectiveMargin = margin ?? _getSpacing(design, marginSize);

    // Calculate effective border radius
    final effectiveBorderRadius = borderRadius ?? _getBorderRadius(design, borderRadiusSize);

    // Build decoration if any style properties are set
    Decoration? effectiveDecoration = decoration;
    if (effectiveDecoration == null &&
        (color != null ||
            effectiveBorderRadius != null ||
            border != null ||
            boxShadow != null ||
            gradient != null ||
            backgroundBlendMode != null ||
            shape != BoxShape.rectangle ||
            elevation != null)) {
      // If elevation is set, use Material for proper shadow
      if (elevation != null && elevation! > 0) {
        return Container(
          margin: effectiveMargin,
          child: Material(
            color: color ?? theme.colorScheme.surface,
            shadowColor: shadowColor ?? theme.shadowColor,
            surfaceTintColor: surfaceTintColor,
            elevation: elevation!,
            borderRadius: effectiveBorderRadius is BorderRadius ? effectiveBorderRadius : null,
            shape: shape == BoxShape.circle ? const CircleBorder() : RoundedRectangleBorder(borderRadius: effectiveBorderRadius ?? BorderRadius.zero),
            clipBehavior: clipBehavior,
            animationDuration: animationDuration ?? design.animationDuration,
            child: Container(
              alignment: alignment,
              padding: effectivePadding,
              width: width,
              height: height,
              constraints: constraints,
              transform: transform,
              transformAlignment: transformAlignment,
              clipBehavior: clipBehavior,
              child: child,
            ),
          ),
        );
      }

      effectiveDecoration = BoxDecoration(
        color: color,
        borderRadius: shape == BoxShape.rectangle ? effectiveBorderRadius : null,
        border: border,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      );
    }

    final container = Container(
      alignment: alignment,
      padding: effectivePadding,
      margin: effectiveMargin,
      width: width,
      height: height,
      constraints: constraints,
      decoration: effectiveDecoration,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );

    // Wrap with AnimatedContainer if animation is enabled
    if (animate) {
      return AnimatedContainer(
        alignment: alignment,
        padding: effectivePadding,
        margin: effectiveMargin,
        width: width,
        height: height,
        constraints: constraints,
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        duration: animationDuration ?? design.animationDuration,
        curve: animationCurve ?? design.animationCurve,
        child: child,
      );
    }

    return container;
  }
}

/// A container with responsive sizing based on the design system
class VooResponsiveContainer extends StatelessWidget {
  final Widget? child;
  final double? maxWidth;
  final double? minWidth;
  final double? maxHeight;
  final double? minHeight;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final VooSpacingSize paddingSize;
  final EdgeInsetsGeometry? margin;
  final VooSpacingSize marginSize;
  final bool centerContent;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final VooSpacingSize borderRadiusSize;

  const VooResponsiveContainer({
    super.key,
    this.child,
    this.maxWidth,
    this.minWidth,
    this.maxHeight,
    this.minHeight,
    this.alignment = Alignment.topCenter,
    this.padding,
    this.paddingSize = VooSpacingSize.md,
    this.margin,
    this.marginSize = VooSpacingSize.none,
    this.centerContent = false,
    this.backgroundColor,
    this.borderRadius,
    this.borderRadiusSize = VooSpacingSize.none,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = VooContainer(
      padding: padding,
      paddingSize: paddingSize,
      margin: margin,
      marginSize: marginSize,
      color: backgroundColor,
      borderRadius: borderRadius,
      borderRadiusSize: borderRadiusSize,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        minWidth: minWidth ?? 0,
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? 0,
      ),
      child: child,
    );

    if (centerContent) {
      content = Center(child: content);
    } else {
      content = Align(alignment: alignment, child: content);
    }

    return content;
  }
}
