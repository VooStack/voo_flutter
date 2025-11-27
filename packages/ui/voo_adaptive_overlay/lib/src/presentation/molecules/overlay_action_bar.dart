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
        return const EdgeInsets.fromLTRB(16, 8, 16, 16);
      case VooOverlayStyle.material:
        return const EdgeInsets.fromLTRB(24, 8, 24, 24);
      case VooOverlayStyle.glass:
        return const EdgeInsets.fromLTRB(20, 12, 20, 20);
      case VooOverlayStyle.minimal:
        return const EdgeInsets.fromLTRB(16, 8, 16, 16);
      case VooOverlayStyle.custom:
        return const EdgeInsets.fromLTRB(24, 8, 24, 24);
    }
  }

  double _getSpacing() {
    if (spacing != null) return spacing!;
    switch (style) {
      case VooOverlayStyle.cupertino:
        return 8.0;
      case VooOverlayStyle.material:
        return 8.0;
      case VooOverlayStyle.glass:
        return 12.0;
      case VooOverlayStyle.minimal:
        return 8.0;
      case VooOverlayStyle.custom:
        return 8.0;
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
          buttonStyle = TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          );
          break;
        case VooOverlayStyle.cupertino:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red,
          );
          break;
        case VooOverlayStyle.glass:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: Colors.red.shade300,
          );
          break;
        default:
          buttonStyle = TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
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
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
          break;
        case VooOverlayStyle.glass:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle ??
                FilledButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                ),
            child: buttonChild,
          );
          break;
        case VooOverlayStyle.material:
        case VooOverlayStyle.minimal:
        case VooOverlayStyle.custom:
          button = FilledButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
          break;
      }
    } else {
      switch (style) {
        case VooOverlayStyle.glass:
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
          break;
        case VooOverlayStyle.cupertino:
        case VooOverlayStyle.material:
        case VooOverlayStyle.minimal:
        case VooOverlayStyle.custom:
          button = TextButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: buttonChild,
          );
          break;
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
