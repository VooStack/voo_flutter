import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/atoms/overlay_handle.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// An iOS-style action sheet with a list of action options.
///
/// This overlay displays a list of tappable action items, typically used
/// for presenting multiple options to the user.
class VooActionSheet extends StatelessWidget {
  /// The title text displayed at the top.
  final Widget? title;

  /// Optional message displayed below the title.
  final Widget? message;

  /// List of actions to display.
  final List<VooOverlayAction> actions;

  /// Optional cancel action (displayed separately at bottom).
  final VooOverlayAction? cancelAction;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Behavior configuration.
  final VooOverlayBehavior behavior;

  const VooActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.cancelAction,
    this.style = VooOverlayStyle.cupertino,
    this.behavior = VooOverlayBehavior.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final decoration = overlayStyle.getDecoration(context, VooOverlayType.actionSheet);
    final blurSigma = overlayStyle.getBlurSigma();
    final theme = Theme.of(context);

    Widget sheet = Container(
      margin: const EdgeInsets.all(8),
      decoration: decoration,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (behavior.showDragHandle) OverlayHandle(style: style),

            // Header section
            if (title != null || message != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant) ?? const TextStyle(),
                        textAlign: TextAlign.center,
                        child: title!,
                      ),
                    if (message != null) ...[
                      const SizedBox(height: 4),
                      DefaultTextStyle(
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant) ?? const TextStyle(),
                        textAlign: TextAlign.center,
                        child: message!,
                      ),
                    ],
                  ],
                ),
              ),

            // Divider after header
            if (title != null || message != null) Divider(height: 1, color: theme.dividerColor),

            // Action items
            ...actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              final isLast = index == actions.length - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionItem(action: action, style: style),
                  if (!isLast) Divider(height: 1, color: theme.dividerColor),
                ],
              );
            }),
          ],
        ),
      ),
    );

    // Cancel button (separate from main sheet)
    Widget? cancelButton;
    if (cancelAction != null) {
      cancelButton = Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: decoration,
        child: _ActionItem(action: cancelAction!, style: style, isBold: true),
      );
    }

    if (blurSigma > 0) {
      sheet = ClipRRect(
        borderRadius: overlayStyle.getBorderRadius(context, VooOverlayType.actionSheet),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: sheet,
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [sheet, if (cancelButton != null) cancelButton]);
  }
}

class _ActionItem extends StatelessWidget {
  final VooOverlayAction action;
  final VooOverlayStyle style;
  final bool isBold;

  const _ActionItem({required this.action, required this.style, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color textColor;
    if (action.isDestructive) {
      textColor = theme.colorScheme.error;
    } else if (action.isPrimary) {
      textColor = theme.colorScheme.primary;
    } else {
      textColor = theme.colorScheme.onSurface;
    }

    return InkWell(
      onTap: () {
        action.onPressed?.call();
        if (action.autoPop) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (action.icon != null) ...[Icon(action.icon, color: textColor, size: 20), const SizedBox(width: 8)],
            Text(
              action.label,
              style: theme.textTheme.bodyLarge?.copyWith(color: textColor, fontWeight: isBold ? FontWeight.w600 : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
