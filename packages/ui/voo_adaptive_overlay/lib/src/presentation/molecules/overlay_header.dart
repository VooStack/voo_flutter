import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/presentation/atoms/overlay_close_button.dart';

/// Header widget for overlays containing a title and optional close button.
class OverlayHeader extends StatelessWidget {
  /// The title text or widget.
  final Widget? title;

  /// Whether to show the close button.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Custom title text style.
  final TextStyle? titleStyle;

  /// Padding for the header.
  final EdgeInsets? padding;

  /// Leading widget (shown before title).
  final Widget? leading;

  /// Trailing widgets (shown after close button).
  final List<Widget>? trailing;

  /// Whether to center the title.
  final bool centerTitle;

  const OverlayHeader({
    super.key,
    this.title,
    this.showCloseButton = true,
    this.onClose,
    this.style = VooOverlayStyle.material,
    this.titleStyle,
    this.padding,
    this.leading,
    this.trailing,
    this.centerTitle = false,
  });

  EdgeInsets _getPadding() {
    if (padding != null) return padding!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return const EdgeInsets.fromLTRB(16, 12, 8, 12);
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.custom:
        return const EdgeInsets.fromLTRB(24, 16, 8, 8);
      case VooOverlayStyle.glass:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.frosted:
        return const EdgeInsets.fromLTRB(20, 16, 12, 12);
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.paper:
        return const EdgeInsets.fromLTRB(16, 12, 8, 8);
      case VooOverlayStyle.brutalist:
        return const EdgeInsets.fromLTRB(20, 20, 12, 12);
      case VooOverlayStyle.retro:
      case VooOverlayStyle.neon:
        return const EdgeInsets.fromLTRB(20, 14, 10, 10);
    }
  }

  TextStyle _getTitleStyle(BuildContext context) {
    if (titleStyle != null) return titleStyle!;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.custom:
        return theme.textTheme.headlineSmall ?? const TextStyle(fontSize: 24);
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.frosted:
        return theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
      case VooOverlayStyle.glass:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
        return theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ) ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.paper:
        return theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ) ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
      case VooOverlayStyle.brutalist:
        return theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: isDark ? Colors.white : Colors.black,
            ) ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w900);
      case VooOverlayStyle.retro:
        return theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFFFF8E7) : const Color(0xFF3D2B1F),
            ) ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
      case VooOverlayStyle.neon:
        return theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ) ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null;
    final hasContent = hasTitle || showCloseButton || leading != null || trailing != null;

    if (!hasContent) return const SizedBox.shrink();

    Widget? titleWidget;
    if (title != null) {
      titleWidget = title is Text
          ? DefaultTextStyle(
              style: _getTitleStyle(context),
              child: title!,
            )
          : title;
    }

    final List<Widget> actions = [];

    if (showCloseButton) {
      actions.add(
        OverlayCloseButton(
          onPressed: onClose,
          style: style,
        ),
      );
    }

    if (trailing != null) {
      actions.addAll(trailing!);
    }

    return Padding(
      padding: _getPadding(),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          if (centerTitle && titleWidget != null)
            Expanded(
              child: Center(child: titleWidget),
            )
          else if (titleWidget != null)
            Expanded(child: titleWidget)
          else
            const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
