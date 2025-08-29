import 'package:flutter/material.dart';
import 'package:voo_forms/src/domain/entities/form_header.dart';
import 'package:voo_ui_core/voo_ui_core.dart';

/// Widget that renders a form header
class FormHeaderWidget extends StatelessWidget {
  final VooFormHeader header;
  final VoidCallback? onTap;

  const FormHeaderWidget({
    super.key,
    required this.header,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.vooDesign;
    final theme = Theme.of(context);

    Widget content = _buildContent(context, design, theme);

    if (header.decoration != null) {
      content = Container(
        padding: header.padding,
        margin: header.margin,
        decoration: header.decoration,
        child: content,
      );
    } else {
      content = Container(
        padding: header.padding ??
            EdgeInsets.symmetric(
              horizontal: design.spacingLg,
              vertical: design.spacingMd,
            ),
        margin: header.margin,
        decoration: BoxDecoration(
          color: header.backgroundColor ?? _getBackgroundColor(context, theme),
          borderRadius: header.borderRadius ??
              BorderRadius.circular(
                header.style == HeaderStyle.card ? design.radiusLg : 0,
              ),
        ),
        child: content,
      );
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: header.borderRadius ??
            BorderRadius.circular(
              header.style == HeaderStyle.card ? design.radiusLg : 0,
            ),
        child: content,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        content,
        if (header.showDivider)
          Divider(
            height: header.dividerHeight ?? 1.0,
            color: header.dividerColor ?? theme.colorScheme.outlineVariant,
          ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    VooDesignSystemData design,
    ThemeData theme,
  ) {
    final mainAxisAlignment = _getMainAxisAlignment();

    final titleStyle = _getTitleStyle(theme);
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: header.color?.withValues(alpha: 0.8) ??
          theme.colorScheme.onSurfaceVariant,
    );
    final descriptionStyle = theme.textTheme.bodySmall?.copyWith(
      color: header.color?.withValues(alpha: 0.6) ??
          theme.colorScheme.onSurfaceVariant,
    );

    Widget titleWidget = Text(
      header.title,
      style: titleStyle,
      textAlign: _getTextAlign(),
    );

    if (header.style == HeaderStyle.chip) {
      return Wrap(
        alignment: _getWrapAlignment(),
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: design.spacingSm,
        children: [
          if (header.leading != null) header.leading!,
          if (header.icon != null && header.leading == null)
            Icon(
              header.icon,
              size: design.iconSizeMd,
              color: header.color ?? theme.colorScheme.primary,
            ),
          Chip(
            label: titleWidget,
            backgroundColor:
                header.backgroundColor ?? theme.colorScheme.primaryContainer,
            labelStyle: titleStyle,
          ),
          if (header.trailing != null) header.trailing!,
        ],
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (header.leading != null) ...[
          header.leading!,
          SizedBox(width: design.spacingMd),
        ] else if (header.icon != null) ...[
          Icon(
            header.icon,
            size: _getIconSize(design),
            color: header.color ?? theme.colorScheme.primary,
          ),
          SizedBox(width: design.spacingMd),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: _getCrossAxisAlignment(),
            children: [
              titleWidget,
              if (header.subtitle != null) ...[
                SizedBox(height: design.spacingXs),
                Text(
                  header.subtitle!,
                  style: subtitleStyle,
                  textAlign: _getTextAlign(),
                ),
              ],
              if (header.description != null) ...[
                SizedBox(height: design.spacingSm),
                Text(
                  header.description!,
                  style: descriptionStyle,
                  textAlign: _getTextAlign(),
                ),
              ],
            ],
          ),
        ),
        if (header.trailing != null) ...[
          SizedBox(width: design.spacingMd),
          header.trailing!,
        ],
      ],
    );
  }

  TextStyle _getTitleStyle(ThemeData theme) {
    final baseStyle = switch (header.style) {
      HeaderStyle.large => theme.textTheme.headlineMedium,
      HeaderStyle.small => theme.textTheme.titleSmall,
      HeaderStyle.banner => theme.textTheme.headlineSmall,
      HeaderStyle.chip => theme.textTheme.labelLarge,
      HeaderStyle.gradient => theme.textTheme.titleLarge,
      _ => theme.textTheme.titleMedium,
    };

    return baseStyle?.copyWith(
          color: header.color ??
              (header.style == HeaderStyle.gradient
                  ? Colors.white
                  : theme.colorScheme.onSurface),
          fontWeight: header.style == HeaderStyle.large ||
                  header.style == HeaderStyle.banner
              ? FontWeight.bold
              : FontWeight.w600,
        ) ??
        const TextStyle();
  }

  double _getIconSize(VooDesignSystemData design) {
    return switch (header.style) {
      HeaderStyle.large => design.iconSizeXl,
      HeaderStyle.small => design.iconSizeSm,
      HeaderStyle.chip => design.iconSizeSm,
      _ => design.iconSizeLg,
    };
  }

  Color? _getBackgroundColor(BuildContext context, ThemeData theme) {
    return switch (header.style) {
      HeaderStyle.card => theme.colorScheme.surfaceContainerHighest,
      HeaderStyle.banner => theme.colorScheme.primaryContainer,
      HeaderStyle.gradient => null,
      _ => Colors.transparent,
    };
  }

  MainAxisAlignment _getMainAxisAlignment() {
    return switch (header.alignment) {
      HeaderAlignment.center => MainAxisAlignment.center,
      HeaderAlignment.right => MainAxisAlignment.end,
      HeaderAlignment.spaceBetween => MainAxisAlignment.spaceBetween,
      HeaderAlignment.spaceAround => MainAxisAlignment.spaceAround,
      _ => MainAxisAlignment.start,
    };
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    return switch (header.alignment) {
      HeaderAlignment.center => CrossAxisAlignment.center,
      HeaderAlignment.right => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
  }

  WrapAlignment _getWrapAlignment() {
    return switch (header.alignment) {
      HeaderAlignment.center => WrapAlignment.center,
      HeaderAlignment.right => WrapAlignment.end,
      HeaderAlignment.spaceBetween => WrapAlignment.spaceBetween,
      HeaderAlignment.spaceAround => WrapAlignment.spaceAround,
      _ => WrapAlignment.start,
    };
  }

  TextAlign _getTextAlign() {
    return switch (header.alignment) {
      HeaderAlignment.center => TextAlign.center,
      HeaderAlignment.right => TextAlign.end,
      _ => TextAlign.start,
    };
  }
}
