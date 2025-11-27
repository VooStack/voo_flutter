import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_action.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';
import 'package:voo_adaptive_overlay/src/presentation/styles/base_overlay_style.dart';

/// The type/severity of an alert dialog.
enum VooAlertType {
  /// Informational alert.
  info,

  /// Success alert.
  success,

  /// Warning alert.
  warning,

  /// Error/critical alert.
  error,

  /// Confirmation alert.
  confirm,
}

/// A system-style alert dialog for critical messages.
///
/// Requires explicit user acknowledgment before dismissal.
class VooAlert extends StatelessWidget {
  /// The title text.
  final String title;

  /// The message content.
  final String message;

  /// Optional rich content widget.
  final Widget? content;

  /// Alert type/severity.
  final VooAlertType type;

  /// Visual style preset.
  final VooOverlayStyle style;

  /// Action buttons.
  final List<VooOverlayAction> actions;

  /// Custom icon.
  final IconData? icon;

  /// Custom icon color.
  final Color? iconColor;

  /// Maximum width of the alert.
  final double maxWidth;

  const VooAlert({
    super.key,
    required this.title,
    required this.message,
    this.content,
    this.type = VooAlertType.info,
    this.style = VooOverlayStyle.material,
    this.actions = const [],
    this.icon,
    this.iconColor,
    this.maxWidth = 340,
  });

  IconData _getIcon() {
    if (icon != null) return icon!;

    switch (type) {
      case VooAlertType.success:
        return Icons.check_circle;
      case VooAlertType.error:
        return Icons.error;
      case VooAlertType.warning:
        return Icons.warning_amber;
      case VooAlertType.info:
        return Icons.info;
      case VooAlertType.confirm:
        return Icons.help;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (iconColor != null) return iconColor!;

    final theme = Theme.of(context);
    switch (type) {
      case VooAlertType.success:
        return Colors.green;
      case VooAlertType.error:
        return theme.colorScheme.error;
      case VooAlertType.warning:
        return Colors.orange;
      case VooAlertType.info:
        return theme.colorScheme.primary;
      case VooAlertType.confirm:
        return theme.colorScheme.primary;
    }
  }

  List<VooOverlayAction> _getDefaultActions() {
    if (actions.isNotEmpty) return actions;

    switch (type) {
      case VooAlertType.confirm:
        return [
          VooOverlayAction.cancel(),
          VooOverlayAction.confirm(),
        ];
      default:
        return [VooOverlayAction.ok()];
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayStyle = BaseOverlayStyle.fromPreset(style);
    final decoration =
        overlayStyle.getDecoration(context, VooOverlayType.alert);
    final blurSigma = overlayStyle.getBlurSigma();
    final theme = Theme.of(context);
    final textColor = overlayStyle.getTextColor(context);

    final alertActions = _getDefaultActions();

    Widget alert = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon and title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getIconColor(context).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(),
                    color: _getIconColor(context),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Message
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: content ??
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor ?? theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildActions(context, alertActions, textColor),
          ),
        ],
      ),
    );

    if (blurSigma > 0) {
      alert = ClipRRect(
        borderRadius:
            overlayStyle.getBorderRadius(context, VooOverlayType.alert),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: alert,
        ),
      );
    }

    return Center(child: alert);
  }

  Widget _buildActions(
    BuildContext context,
    List<VooOverlayAction> alertActions,
    Color? textColor,
  ) {
    final theme = Theme.of(context);

    if (alertActions.length == 1) {
      // Single action - full width button
      final action = alertActions.first;
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            action.onPressed?.call();
            if (action.autoPop) {
              Navigator.of(context).pop();
            }
          },
          style: action.isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                )
              : null,
          child: Text(action.label),
        ),
      );
    }

    if (alertActions.length == 2) {
      // Two actions - side by side
      return Row(
        children: alertActions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          final isLast = index == alertActions.length - 1;

          Widget button;
          if (action.isPrimary || isLast) {
            button = FilledButton(
              onPressed: () {
                action.onPressed?.call();
                if (action.autoPop) {
                  Navigator.of(context).pop(action.isPrimary);
                }
              },
              style: action.isDestructive
                  ? FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                    )
                  : null,
              child: Text(action.label),
            );
          } else {
            button = OutlinedButton(
              onPressed: () {
                action.onPressed?.call();
                if (action.autoPop) {
                  Navigator.of(context).pop(false);
                }
              },
              child: Text(action.label),
            );
          }

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 12),
              child: button,
            ),
          );
        }).toList(),
      );
    }

    // Multiple actions - stacked vertically
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: alertActions.map((action) {
        Widget button;
        if (action.isPrimary) {
          button = FilledButton(
            onPressed: () {
              action.onPressed?.call();
              if (action.autoPop) {
                Navigator.of(context).pop(true);
              }
            },
            style: action.isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  )
                : null,
            child: Text(action.label),
          );
        } else if (action.isDestructive) {
          button = OutlinedButton(
            onPressed: () {
              action.onPressed?.call();
              if (action.autoPop) {
                Navigator.of(context).pop();
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(action.label),
          );
        } else {
          button = TextButton(
            onPressed: () {
              action.onPressed?.call();
              if (action.autoPop) {
                Navigator.of(context).pop(false);
              }
            },
            child: Text(action.label),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: button,
        );
      }).toList(),
    );
  }
}
