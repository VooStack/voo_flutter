import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';

/// A row of action buttons for overlay dialogs.
class OverlayActionBar extends StatelessWidget {
  /// The list of actions to display.
  final List<VooOverlayAction> actions;

  /// The overlay style preset.
  final VooOverlayStyle style;

  /// Padding around the action bar.
  final EdgeInsets? padding;

  /// Spacing between action buttons.
  final double? spacing;

  /// Whether to expand buttons to fill available width.
  final bool expandButtons;

  /// Alignment of the actions.
  final MainAxisAlignment alignment;

  const OverlayActionBar({
    super.key,
    required this.actions,
    this.style = VooOverlayStyle.material,
    this.padding,
    this.spacing,
    this.expandButtons = false,
    this.alignment = MainAxisAlignment.end,
  });

  EdgeInsets _getPadding() {
    if (padding != null) return padding!;
    switch (style) {
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.paper:
        return const EdgeInsets.fromLTRB(16, 8, 16, 16);
      case VooOverlayStyle.material:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.custom:
        return const EdgeInsets.fromLTRB(24, 8, 24, 24);
      case VooOverlayStyle.glass:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.frosted:
        return const EdgeInsets.fromLTRB(20, 12, 20, 20);
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.neon:
        return const EdgeInsets.fromLTRB(20, 12, 20, 20);
      case VooOverlayStyle.fluent:
        return const EdgeInsets.fromLTRB(16, 12, 16, 16);
      case VooOverlayStyle.brutalist:
        return const EdgeInsets.fromLTRB(20, 16, 20, 20);
      case VooOverlayStyle.retro:
        return const EdgeInsets.fromLTRB(20, 12, 20, 16);
    }
  }

  double _getSpacing() {
    if (spacing != null) return spacing!;
    switch (style) {
      case VooOverlayStyle.cupertino:
      case VooOverlayStyle.material:
      case VooOverlayStyle.minimal:
      case VooOverlayStyle.outlined:
      case VooOverlayStyle.elevated:
      case VooOverlayStyle.soft:
      case VooOverlayStyle.neumorphic:
      case VooOverlayStyle.fluent:
      case VooOverlayStyle.paper:
      case VooOverlayStyle.custom:
        return 8.0;
      case VooOverlayStyle.glass:
      case VooOverlayStyle.dark:
      case VooOverlayStyle.gradient:
      case VooOverlayStyle.frosted:
        return 12.0;
      case VooOverlayStyle.brutalist:
      case VooOverlayStyle.neon:
        return 16.0;
      case VooOverlayStyle.retro:
        return 10.0;
    }
  }

  Widget _buildButton(
    BuildContext context,
    VooOverlayAction action,
  ) {
    final theme = Theme.of(context);

    VoidCallback? onPressed;
    if (action.onPressed != null || action.autoPop) {
      onPressed = () {
        action.onPressed?.call();
        if (action.autoPop) {
          Navigator.of(context).pop();
        }
      };
    }

    ButtonStyle? buttonStyle = action.style;

    if (action.isDestructive && buttonStyle == null) {
      switch (style) {
        case VooOverlayStyle.material:
        case VooOverlayStyle.elevated:
        case VooOverlayStyle.soft:
        case VooOverlayStyle.outlined:
        case VooOverlayStyle.minimal:
        case VooOverlayStyle.neumorphic:
        case VooOverlayStyle.fluent:
        case VooOverlayStyle.paper:
        case VooOverlayStyle.custom:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          );
        case VooOverlayStyle.cupertino:
        case VooOverlayStyle.frosted:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red,
          );
        case VooOverlayStyle.glass:
        case VooOverlayStyle.dark:
        case VooOverlayStyle.gradient:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red.shade300,
          );
        case VooOverlayStyle.brutalist:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red,
          );
        case VooOverlayStyle.retro:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: const Color(0xFFB22222),
          );
        case VooOverlayStyle.neon:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red.shade400,
          );
      }
    }

    Widget buttonChild;
    if (action.icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 18),
          const SizedBox(width: 8),
          Text(action.label),
        ],
      );
    } else {
      buttonChild = Text(action.label);
    }

    Widget button;
    if (action.isPrimary) {
      switch (style) {
        case VooOverlayStyle.cupertino:
        case VooOverlayStyle.material:
        case VooOverlayStyle.minimal:
        case VooOverlayStyle.outlined:
        case VooOverlayStyle.elevated:
        case VooOverlayStyle.soft:
        case VooOverlayStyle.neumorphic:
        case VooOverlayStyle.fluent:
        case VooOverlayStyle.paper:
        case VooOverlayStyle.frosted:
        case VooOverlayStyle.custom:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
        case VooOverlayStyle.glass:
        case VooOverlayStyle.dark:
        case VooOverlayStyle.gradient:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.brutalist:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor:
                      theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                  foregroundColor:
                      theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                  shape: const RoundedRectangleBorder(),
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.retro:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: const Color(0xFFFFF8E7),
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.neon:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
            child: buttonChild,
          );
      }
    } else {
      switch (style) {
        case VooOverlayStyle.glass:
        case VooOverlayStyle.dark:
        case VooOverlayStyle.gradient:
        case VooOverlayStyle.frosted:
          button = OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle ??
                OutlinedButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.9),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.outlined:
        case VooOverlayStyle.brutalist:
          button = OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle ??
                OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.outline,
                    width: style == VooOverlayStyle.brutalist ? 2 : 1,
                  ),
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.neon:
          button = OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle ??
                OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                  ),
                ),
            child: buttonChild,
          );
        case VooOverlayStyle.cupertino:
        case VooOverlayStyle.material:
        case VooOverlayStyle.minimal:
        case VooOverlayStyle.elevated:
        case VooOverlayStyle.soft:
        case VooOverlayStyle.neumorphic:
        case VooOverlayStyle.fluent:
        case VooOverlayStyle.retro:
        case VooOverlayStyle.paper:
        case VooOverlayStyle.custom:
          button = TextButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
      }
    }

    return button;
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final buttonSpacing = _getSpacing();

    final List<Widget> buttonWidgets = [];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) {
        buttonWidgets.add(SizedBox(width: buttonSpacing));
      }

      final button = _buildButton(context, actions[i]);
      if (expandButtons) {
        buttonWidgets.add(Expanded(child: button));
      } else {
        buttonWidgets.add(button);
      }
    }

    return Padding(
      padding: _getPadding(),
      child: Row(
        mainAxisAlignment: expandButtons ? MainAxisAlignment.center : alignment,
        children: buttonWidgets,
      ),
    );
  }
}
