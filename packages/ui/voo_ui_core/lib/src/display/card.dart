import 'package:flutter/material.dart';
import 'package:voo_ui_core/src/foundations/design_system.dart';

class VooCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final ShapeBorder? shape;
  final BorderSide? borderSide;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Clip? clipBehavior;
  final bool semanticContainer;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final MouseCursor? mouseCursor;
  final bool selected;
  final Color? selectedColor;
  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final BorderRadius? borderRadius;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enableFeedback;

  const VooCard({
    super.key,
    required this.child,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderSide,
    this.borderOnForeground = true,
    this.margin,
    this.padding,
    this.clipBehavior,
    this.semanticContainer = true,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onHover,
    this.onFocusChange,
    this.mouseCursor,
    this.selected = false,
    this.selectedColor,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.borderRadius,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    final effectiveElevation = elevation ?? (selected ? 4.0 : 1.0);

    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(design.radiusLg);

    final effectiveShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
          side: borderSide ?? (selected ? BorderSide(color: selectedColor ?? theme.colorScheme.primary, width: 2) : BorderSide.none),
        );

    final effectiveColor = color ?? (selected ? (selectedColor ?? theme.colorScheme.primary).withValues(alpha: 0.08) : theme.colorScheme.surface);

    final effectivePadding = padding ?? EdgeInsets.all(design.spacingLg);

    final effectiveMargin = margin ?? EdgeInsets.all(design.spacingSm);

    final card = Card(
      color: effectiveColor,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: effectiveElevation,
      shape: effectiveShape,
      borderOnForeground: borderOnForeground,
      margin: effectiveMargin,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      semanticContainer: semanticContainer,
      child: onTap != null || onLongPress != null || onDoubleTap != null
          ? InkWell(
              onTap: enabled ? onTap : null,
              onLongPress: enabled ? onLongPress : null,
              onDoubleTap: enabled ? onDoubleTap : null,
              onHover: onHover,
              onFocusChange: onFocusChange,
              mouseCursor: mouseCursor,
              focusNode: focusNode,
              autofocus: autofocus,
              enableFeedback: enableFeedback,
              splashColor: splashColor,
              highlightColor: highlightColor,
              splashFactory: splashFactory,
              borderRadius: effectiveBorderRadius,
              child: Padding(padding: effectivePadding, child: child),
            )
          : Padding(padding: effectivePadding, child: child),
    );

    return card;
  }
}

/// A card optimized for displaying content with a header
class VooContentCard extends StatelessWidget {
  final Widget? header;
  final Widget content;
  final Widget? footer;
  final List<Widget>? actions;
  final Color? color;
  final Color? headerColor;
  final Color? footerColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? footerPadding;
  final double? elevation;
  final ShapeBorder? shape;
  final BorderSide? borderSide;
  final VoidCallback? onTap;
  final bool selected;
  final Color? selectedColor;
  final bool dividerBetweenHeaderAndContent;
  final bool dividerBetweenContentAndFooter;
  final MainAxisAlignment actionsAlignment;
  final double actionsSpacing;

  const VooContentCard({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.actions,
    this.color,
    this.headerColor,
    this.footerColor,
    this.margin,
    this.headerPadding,
    this.contentPadding,
    this.footerPadding,
    this.elevation,
    this.shape,
    this.borderSide,
    this.onTap,
    this.selected = false,
    this.selectedColor,
    this.dividerBetweenHeaderAndContent = false,
    this.dividerBetweenContentAndFooter = false,
    this.actionsAlignment = MainAxisAlignment.end,
    this.actionsSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;

    final effectiveHeaderPadding = headerPadding ?? EdgeInsets.all(design.spacingLg);

    final effectiveContentPadding = contentPadding ?? EdgeInsets.all(design.spacingLg);

    final effectiveFooterPadding = footerPadding ?? EdgeInsets.all(design.spacingLg);

    return VooCard(
      color: color,
      elevation: elevation,
      shape: shape,
      borderSide: borderSide,
      margin: margin,
      padding: EdgeInsets.zero,
      onTap: onTap,
      selected: selected,
      selectedColor: selectedColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            Container(color: headerColor, padding: effectiveHeaderPadding, child: header),
            if (dividerBetweenHeaderAndContent) const Divider(height: 1, thickness: 1),
          ],
          Padding(padding: effectiveContentPadding, child: content),
          if (footer != null || actions != null) ...[
            if (dividerBetweenContentAndFooter) const Divider(height: 1, thickness: 1),
            Container(
              color: footerColor,
              padding: effectiveFooterPadding,
              child:
                  footer ??
                  Row(
                    mainAxisAlignment: actionsAlignment,
                    children: [
                      for (int i = 0; i < actions!.length; i++) ...[actions![i], if (i < actions!.length - 1) SizedBox(width: actionsSpacing)],
                    ],
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
