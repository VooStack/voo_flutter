import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_close_button.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_icon.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_progress_bar.dart';

class VooToastCard extends StatelessWidget {
  const VooToastCard({
    super.key,
    required this.toast,
    required this.onDismiss,
    this.iconSize = 24.0,
    this.closeButtonSize = 20.0,
    this.progressBarHeight = 3.0,
  });

  final Toast toast;
  final VoidCallback onDismiss;
  final double iconSize;
  final double closeButtonSize;
  final double progressBarHeight;

  @override
  Widget build(BuildContext context) {
    if (toast.customContent != null) {
      return _buildCustomToast(context);
    }
    return _buildStandardToast(context);
  }

  Widget _buildCustomToast(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: toast.backgroundColor ?? theme.colorScheme.surfaceContainer,
      borderRadius: toast.borderRadius ?? BorderRadius.circular(8),
      elevation: toast.elevation ?? 4.0,
      child: InkWell(
        onTap: toast.onTap,
        borderRadius: toast.borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: toast.width,
          constraints: BoxConstraints(
            maxWidth: toast.maxWidth ?? 400,
          ),
          padding: toast.padding ?? const EdgeInsets.all(16),
          child: toast.customContent,
        ),
      ),
    );
  }

  Widget _buildStandardToast(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = toast.backgroundColor ?? _getBackgroundColor(theme);
    final textColor = toast.textColor ?? _getTextColor(theme);
    
    return Material(
      color: backgroundColor,
      borderRadius: toast.borderRadius ?? BorderRadius.circular(8),
      elevation: toast.elevation ?? 4.0,
      child: InkWell(
        onTap: toast.onTap,
        borderRadius: toast.borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: toast.width,
          constraints: BoxConstraints(
            maxWidth: toast.maxWidth ?? 400,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: toast.padding ?? const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (toast.icon != null || toast.type != ToastType.custom) ...[
                      VooToastIcon(
                        type: toast.type,
                        icon: toast.icon,
                        size: iconSize,
                        color: textColor,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (toast.title != null) ...[
                            Text(
                              toast.title!,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            toast.message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textColor,
                            ),
                          ),
                          if (toast.actions != null && toast.actions!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: toast.actions!.map((action) {
                                return TextButton(
                                  onPressed: action.onPressed,
                                  style: TextButton.styleFrom(
                                    foregroundColor: action.textColor ?? textColor,
                                    backgroundColor: action.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                  ),
                                  child: Text(action.label),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (toast.showCloseButton) ...[
                      const SizedBox(width: 8),
                      VooToastCloseButton(
                        onPressed: onDismiss,
                        size: closeButtonSize,
                        color: textColor,
                      ),
                    ],
                  ],
                ),
              ),
              if (toast.showProgressBar && toast.duration != Duration.zero)
                VooToastProgressBar(
                  duration: toast.duration,
                  height: progressBarHeight,
                  color: textColor.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (toast.type) {
      case ToastType.success:
        return Colors.green.shade100;
      case ToastType.error:
        return Colors.red.shade100;
      case ToastType.warning:
        return Colors.orange.shade100;
      case ToastType.info:
        return Colors.blue.shade100;
      case ToastType.custom:
        return theme.colorScheme.surfaceContainer;
    }
  }

  Color _getTextColor(ThemeData theme) {
    switch (toast.type) {
      case ToastType.success:
        return Colors.green.shade900;
      case ToastType.error:
        return Colors.red.shade900;
      case ToastType.warning:
        return Colors.orange.shade900;
      case ToastType.info:
        return Colors.blue.shade900;
      case ToastType.custom:
        return theme.colorScheme.onSurface;
    }
  }
}