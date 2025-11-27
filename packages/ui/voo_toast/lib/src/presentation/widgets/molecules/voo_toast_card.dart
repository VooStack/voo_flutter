import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_responsive/voo_responsive.dart';
import 'package:voo_toast/src/domain/entities/toast.dart';
import 'package:voo_toast/src/domain/entities/toast_config.dart';
import 'package:voo_toast/src/domain/enums/toast_style.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';
import 'package:voo_toast/src/presentation/styles/base_toast_style.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_loading_indicator.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_close_button.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_icon.dart';
import 'package:voo_toast/src/presentation/widgets/atoms/voo_toast_progress_bar.dart';

/// A styled toast card widget that displays toast notifications.
///
/// This widget automatically applies the appropriate style based on the
/// [Toast.style] property or falls back to the [ToastConfig.defaultStyle].
class VooToastCard extends StatelessWidget {
  const VooToastCard({
    super.key,
    required this.toast,
    required this.onDismiss,
    required this.config,
    this.iconSize = 24.0,
    this.closeButtonSize = 20.0,
    this.progressBarHeight = 3.0,
  });

  final Toast toast;
  final VoidCallback onDismiss;
  final ToastConfig config;
  final double iconSize;
  final double closeButtonSize;
  final double progressBarHeight;

  @override
  Widget build(BuildContext context) {
    if (toast.customContent != null) {
      return _CustomToastContent(
        toast: toast,
        config: config,
      );
    }

    return _StyledToastContent(
      toast: toast,
      config: config,
      onDismiss: onDismiss,
      iconSize: iconSize,
      closeButtonSize: closeButtonSize,
      progressBarHeight: progressBarHeight,
    );
  }
}

/// Widget for rendering custom toast content.
class _CustomToastContent extends StatelessWidget {
  const _CustomToastContent({
    required this.toast,
    required this.config,
  });

  final Toast toast;
  final ToastConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Notification',
      child: Material(
        color: toast.backgroundColor ?? theme.colorScheme.surfaceContainer,
        borderRadius: toast.borderRadius ?? BorderRadius.circular(12),
        elevation: toast.elevation ?? 4.0,
        child: InkWell(
          onTap: toast.onTap,
          borderRadius: toast.borderRadius ?? BorderRadius.circular(12),
          child: Container(
            width: toast.width,
            constraints: BoxConstraints(maxWidth: toast.maxWidth ?? config.defaultMaxWidth),
            padding: toast.padding ?? const EdgeInsets.all(16),
            child: toast.customContent,
          ),
        ),
      ),
    );
  }
}

/// Widget for rendering styled toast content.
class _StyledToastContent extends StatelessWidget {
  const _StyledToastContent({
    required this.toast,
    required this.config,
    required this.onDismiss,
    required this.iconSize,
    required this.closeButtonSize,
    required this.progressBarHeight,
  });

  final Toast toast;
  final ToastConfig config;
  final VoidCallback onDismiss;
  final double iconSize;
  final double closeButtonSize;
  final double progressBarHeight;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = toast.style ?? config.defaultStyle;
    final customStyleData = toast.customStyleData ?? config.defaultCustomStyleData;
    final toastStyle = BaseToastStyle.fromPreset(effectiveStyle, customData: customStyleData);
    final isSnackbar = effectiveStyle.isSnackbar;

    final backgroundColor = toast.backgroundColor ?? toastStyle.getBackgroundColor(context, toast.type);
    final textColor = toast.textColor ?? toastStyle.getTextColor(context, toast.type);
    final iconColor = toastStyle.getIconColor(context, toast.type);
    final borderRadius = toast.borderRadius ?? toastStyle.getBorderRadius(context);
    final padding = toast.padding ?? toastStyle.getPadding(context);
    final boxShadow = toastStyle.getBoxShadow(context, toast.type);
    final border = toastStyle.getBorder(context, toast.type);
    final blurSigma = toastStyle.getBlurSigma();
    final gradient = toastStyle.getGradient(context, toast.type);
    final iconContainerColor = toastStyle.getIconContainerColor(context, toast.type);
    final iconContainerBorderColor = toastStyle.getIconContainerBorderColor(context, toast.type);

    // Responsive max width - snackbar uses full width on mobile
    final maxWidth = isSnackbar && ResponsiveHelper.isMobile(context)
        ? double.infinity
        : (toast.maxWidth ?? _getResponsiveMaxWidth(context));

    // Accessibility label
    final accessibilityLabel = _buildAccessibilityLabel();

    Widget content = Semantics(
      container: true,
      liveRegion: true,
      label: accessibilityLabel,
      child: Material(
        color: gradient != null ? Colors.transparent : backgroundColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: toast.onTap,
          borderRadius: borderRadius,
          child: Container(
            width: isSnackbar && ResponsiveHelper.isMobile(context) ? double.infinity : toast.width,
            constraints: maxWidth == double.infinity ? null : BoxConstraints(maxWidth: maxWidth),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? backgroundColor : null,
              borderRadius: borderRadius,
              border: border,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: padding,
                  child: Row(
                    children: [
                      if (toast.isLoading) ...[
                        if (isSnackbar)
                          VooLoadingIndicator(color: iconColor, size: iconSize)
                        else
                          _ToastIconContainer(
                            color: iconContainerColor,
                            borderColor: iconContainerBorderColor,
                            child: VooLoadingIndicator(color: iconColor, size: iconSize),
                          ),
                        const SizedBox(width: 14),
                      ] else if (toast.icon != null || toast.type != ToastType.custom) ...[
                        if (isSnackbar)
                          VooToastIcon(
                            type: toast.type,
                            icon: toast.icon,
                            size: iconSize,
                            color: iconColor,
                          )
                        else
                          _ToastIconContainer(
                            color: iconContainerColor,
                            borderColor: iconContainerBorderColor,
                            child: VooToastIcon(
                              type: toast.type,
                              icon: toast.icon,
                              size: iconSize,
                              color: iconColor,
                            ),
                          ),
                        SizedBox(width: isSnackbar ? 12.0 : 14.0),
                      ],
                      Expanded(
                        child: isSnackbar
                            ? _SnackbarTextContent(
                                toast: toast,
                                config: config,
                                textColor: textColor,
                              )
                            : _ToastTextContent(
                                toast: toast,
                                config: config,
                                textColor: textColor,
                              ),
                      ),
                      // For snackbar, show inline actions
                      if (isSnackbar && toast.actions != null && toast.actions!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _SnackbarInlineActions(
                          actions: toast.actions!,
                          textColor: textColor,
                        ),
                      ],
                      if (toast.showCloseButton) ...[
                        const SizedBox(width: 8),
                        Semantics(
                          button: true,
                          label: 'Dismiss notification',
                          child: VooToastCloseButton(
                            onPressed: onDismiss,
                            size: closeButtonSize,
                            color: textColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (toast.showProgressBar && toast.duration != Duration.zero)
                  _ToastProgressBar(
                    duration: toast.duration,
                    height: progressBarHeight,
                    color: textColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    // Apply blur effect for glass styles
    if (blurSigma > 0) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: content,
        ),
      );
    }

    // Apply shadow
    if (boxShadow.isNotEmpty) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          borderRadius: borderRadius,
        ),
        child: content,
      );
    }

    return content;
  }

  double _getResponsiveMaxWidth(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return MediaQuery.of(context).size.width - 32;
    } else if (ResponsiveHelper.isTablet(context)) {
      return 400;
    } else {
      return 420;
    }
  }

  String _buildAccessibilityLabel() {
    final typeLabel = switch (toast.type) {
      ToastType.success => 'Success',
      ToastType.error => 'Error',
      ToastType.warning => 'Warning',
      ToastType.info => 'Information',
      ToastType.custom => 'Notification',
    };

    final titlePart = toast.title != null ? '${toast.title}. ' : '';
    return '$typeLabel notification. $titlePart${toast.message}';
  }
}

/// Container widget for the toast icon with styling.
class _ToastIconContainer extends StatelessWidget {
  const _ToastIconContainer({
    required this.color,
    required this.borderColor,
    required this.child,
  });

  final Color color;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Center(child: child),
      );
}

/// Widget for the toast text content (title, message, actions).
class _ToastTextContent extends StatelessWidget {
  const _ToastTextContent({
    required this.toast,
    required this.config,
    required this.textColor,
  });

  final Toast toast;
  final ToastConfig config;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (toast.title != null) ...[
          Text(
            toast.title!,
            style: toast.titleStyle ??
                config.titleStyle ??
                theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          toast.message,
          style: toast.textStyle ??
              config.textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: textColor.withValues(alpha: 0.9),
              ),
        ),
        if (toast.actions != null && toast.actions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ToastActions(
            actions: toast.actions!,
            textColor: textColor,
          ),
        ],
      ],
    );
  }
}

/// Widget for snackbar text content (message only, no actions - they're inline).
class _SnackbarTextContent extends StatelessWidget {
  const _SnackbarTextContent({
    required this.toast,
    required this.config,
    required this.textColor,
  });

  final Toast toast;
  final ToastConfig config;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Snackbar typically shows message without title for compact display
    if (toast.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            toast.title!,
            style: toast.titleStyle ??
                config.titleStyle ??
                theme.textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            toast.message,
            style: toast.textStyle ??
                config.textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: textColor.withValues(alpha: 0.9),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Text(
      toast.message,
      style: toast.textStyle ??
          config.textStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Widget for snackbar inline action buttons (displayed in the same row).
class _SnackbarInlineActions extends StatelessWidget {
  const _SnackbarInlineActions({
    required this.actions,
    required this.textColor,
  });

  final List<ToastAction> actions;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions
          .take(2) // Limit to 2 actions for inline display
          .map(
            (action) => Semantics(
              button: true,
              label: action.label,
              child: TextButton(
                onPressed: action.onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: action.textColor ?? theme.colorScheme.inversePrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  action.label.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Widget for rendering toast action buttons.
class _ToastActions extends StatelessWidget {
  const _ToastActions({
    required this.actions,
    required this.textColor,
  });

  final List<ToastAction> actions;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions
            .map(
              (action) => Semantics(
                button: true,
                label: action.label,
                child: TextButton(
                  onPressed: action.onPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: action.textColor ?? textColor,
                    backgroundColor: action.backgroundColor ?? textColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: Text(
                    action.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

/// Widget for the progress bar at the bottom of the toast.
class _ToastProgressBar extends StatelessWidget {
  const _ToastProgressBar({
    required this.duration,
    required this.height,
    required this.color,
  });

  final Duration duration;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: VooToastProgressBar(
          duration: duration,
          height: height,
          color: color.withValues(alpha: 0.8),
        ),
      );
}
