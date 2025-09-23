import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_loading_indicator.dart';
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
          constraints: BoxConstraints(maxWidth: toast.maxWidth ?? 400),
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
    final gradient = toast.backgroundColor == null ? _getGradient() : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: _getShadowColor(theme).withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 12), spreadRadius: -5),
          BoxShadow(color: _getShadowColor(theme).withValues(alpha: 0.15), blurRadius: 15, offset: const Offset(0, 6), spreadRadius: -3),
        ],
      ),
      child: Material(
        color: gradient != null ? Colors.transparent : backgroundColor,
        borderRadius: toast.borderRadius ?? BorderRadius.circular(16),
        child: InkWell(
          onTap: toast.onTap,
          borderRadius: toast.borderRadius ?? BorderRadius.circular(16),
          child: Container(
            width: toast.width,
            constraints: BoxConstraints(maxWidth: toast.maxWidth ?? 420),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? backgroundColor : null,
              borderRadius: toast.borderRadius ?? BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: toast.padding ?? const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (toast.isLoading) ...[
                        _buildIconContainer(VooLoadingIndicator(color: textColor, size: iconSize), textColor),
                        const SizedBox(width: 14),
                      ] else if (toast.icon != null || toast.type != ToastType.custom) ...[
                        _buildIconContainer(VooToastIcon(type: toast.type, icon: toast.icon, size: iconSize, color: textColor), textColor),
                        const SizedBox(width: 14),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (toast.title != null) ...[
                              Text(
                                toast.title!,
                                style: toast.titleStyle ?? theme.textTheme.titleSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(toast.message, style: toast.textStyle ?? theme.textTheme.bodyMedium?.copyWith(color: textColor)),
                            if (toast.actions != null && toast.actions!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: toast.actions!
                                    .map(
                                      (action) => TextButton(
                                        onPressed: action.onPressed,
                                        style: TextButton.styleFrom(
                                          foregroundColor: action.textColor ?? textColor,
                                          backgroundColor: action.backgroundColor,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        ),
                                        child: Text(action.label),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (toast.showCloseButton) ...[
                        const SizedBox(width: 8),
                        VooToastCloseButton(onPressed: onDismiss, size: closeButtonSize, color: textColor),
                      ],
                    ],
                  ),
                ),
                if (toast.showProgressBar && toast.duration != Duration.zero) _buildEnhancedProgressBar(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(Widget icon, Color color) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Center(child: icon),
  );

  Widget _buildEnhancedProgressBar(Color color) => Container(
    height: progressBarHeight,
    decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.3)])),
    child: VooToastProgressBar(duration: toast.duration, height: progressBarHeight, color: color.withValues(alpha: 0.8)),
  );

  // Disable gradient when using theme colors to maintain consistency
  LinearGradient? _getGradient() => null;

  Color _getShadowColor(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (toast.type) {
      case ToastType.success:
        return colorScheme.primary;
      case ToastType.error:
        return colorScheme.error;
      case ToastType.warning:
        return colorScheme.tertiary;
      case ToastType.info:
        return colorScheme.secondary;
      case ToastType.custom:
        return colorScheme.shadow;
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (toast.type) {
      case ToastType.success:
        return colorScheme.primary;
      case ToastType.error:
        return colorScheme.error;
      case ToastType.warning:
        return colorScheme.tertiary;
      case ToastType.info:
        return colorScheme.secondary;
      case ToastType.custom:
        return colorScheme.surfaceContainer;
    }
  }

  Color _getTextColor(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (toast.type) {
      case ToastType.success:
        return colorScheme.onPrimary;
      case ToastType.error:
        return colorScheme.onError;
      case ToastType.warning:
        return colorScheme.onTertiary;
      case ToastType.info:
        return colorScheme.onSecondary;
      case ToastType.custom:
        return colorScheme.onSurface;
    }
  }
}
