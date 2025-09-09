import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:voo_toast/voo_toast.dart';

/// A preview widget for demonstrating VooToast components in design tools
/// and documentation. This widget provides a static preview of different
/// toast variations without requiring the full toast system setup.
class ToastPreview extends StatelessWidget {
  const ToastPreview({
    super.key,
    this.type = ToastType.info,
    this.title,
    this.message = 'This is a preview toast message',
    this.showIcon = true,
    this.showCloseButton = true,
    this.showProgressBar = false,
    this.showActions = false,
    this.customContent,
    this.width,
    this.maxWidth = 400,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation = 4,
    this.backgroundColor,
    this.textColor,
    this.iconSize = 24,
    this.closeButtonSize = 20,
    this.progressBarHeight = 3,
  });

  final ToastType type;
  final String? title;
  final String message;
  final bool showIcon;
  final bool showCloseButton;
  final bool showProgressBar;
  final bool showActions;
  final Widget? customContent;
  final double? width;
  final double maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Color? textColor;
  final double iconSize;
  final double closeButtonSize;
  final double progressBarHeight;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin ?? const EdgeInsets.all(16),
        child: _buildToastPreview(context),
      );

  Widget _buildToastPreview(BuildContext context) {
    if (customContent != null) {
      return _buildCustomToast(context);
    }
    return _buildStandardToast(context);
  }

  Widget _buildCustomToast(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? theme.colorScheme.surfaceContainer,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      elevation: elevation,
      child: Container(
        width: width,
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding ?? const EdgeInsets.all(16),
        child: customContent,
      ),
    );
  }

  Widget _buildStandardToast(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? _getBackgroundColor(theme);
    final txtColor = textColor ?? _getTextColor(theme);

    return Material(
      color: bgColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      elevation: elevation,
      child: Container(
        width: width,
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (showIcon) ...[
                    _buildIcon(txtColor),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null) ...[
                          Text(
                            title!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: txtColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: txtColor,
                          ),
                        ),
                        if (showActions) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: txtColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                ),
                                child: const Text('ACTION'),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: txtColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                ),
                                child: const Text('DISMISS'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showCloseButton) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        size: closeButtonSize,
                        color: txtColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: closeButtonSize + 8,
                        height: closeButtonSize + 8,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showProgressBar)
              Container(
                height: progressBarHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: txtColor.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    IconData iconData;
    switch (type) {
      case ToastType.success:
        iconData = Icons.check_circle;
        break;
      case ToastType.error:
        iconData = Icons.error;
        break;
      case ToastType.warning:
        iconData = Icons.warning;
        break;
      case ToastType.info:
        iconData = Icons.info;
        break;
      case ToastType.custom:
        iconData = Icons.notifications;
        break;
    }

    return Icon(
      iconData,
      size: iconSize,
      color: color,
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (type) {
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
    switch (type) {
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

/// A collection of pre-configured toast previews for common use cases
@Preview(
  name: 'Toast Previews',
)
Widget toastPreviewCollectionBuilder() => const ToastPreviewCollection();

class ToastPreviewCollection extends StatelessWidget {
  const ToastPreviewCollection({
    super.key,
    this.spacing = 16,
  });

  final double spacing;

  @override
  Widget build(BuildContext context) => VooToastOverlay(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Toast Previews & Tests',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing),
                const Text(
                  'Click buttons to show actual toasts:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: spacing),

                // Success Toast with button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Success Toast',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ToastPreview(
                            type: ToastType.success,
                            title: 'Success!',
                            message: 'Your changes have been saved successfully.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showSuccess(
                        title: 'Success!',
                        message: 'Your changes have been saved successfully.',
                        context: context,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Error Toast with button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error Toast',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ToastPreview(
                            type: ToastType.error,
                            title: 'Error',
                            message: 'Failed to save changes. Please try again.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showError(
                        title: 'Error',
                        message: 'Failed to save changes. Please try again.',
                        context: context,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Warning Toast with button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Warning Toast',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ToastPreview(
                            type: ToastType.warning,
                            message: 'Your session will expire in 5 minutes.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showWarning(
                        message: 'Your session will expire in 5 minutes.',
                        context: context,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Info Toast with Actions and button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Info Toast with Actions',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ToastPreview(
                            message: 'New update available. Install now?',
                            showActions: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showInfo(
                        message: 'New update available. Install now?',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'INSTALL',
                            onPressed: () => VooToast.showSuccess(
                              message: 'Update installed',
                              context: context,
                            ),
                          ),
                          ToastAction(
                            label: 'LATER',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Progress Toast with button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Toast with Progress Bar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ToastPreview(
                            message: 'Processing your request...',
                            showProgressBar: true,
                            showCloseButton: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showInfo(
                        message: 'Processing your request...',
                        context: context,
                        duration: const Duration(seconds: 5),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Custom Toast with button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Custom Toast',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          ToastPreview(
                            type: ToastType.custom,
                            customContent: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.pink],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.celebration, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'Congratulations! You won!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.purple, Colors.pink],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'Congratulations! You won!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Show'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 2),

                // Developer-Friendly Toast Examples
                const Text(
                  'Common Developer Use Cases',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing),

                // Network Status Toasts
                const Text(
                  'Network & Connection',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showError(
                        message: 'No internet connection',
                        context: context,
                        duration: Duration.zero,
                        actions: [
                          ToastAction(
                            label: 'RETRY',
                            onPressed: () => VooToast.showSuccess(
                              message: 'Connection restored',
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
                      child: const Text('No Internet'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        message: 'Connection restored',
                        context: context,
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                      child: const Text('Connected'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showWarning(
                        message: 'Slow network detected',
                        context: context,
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade600),
                      child: const Text('Slow Network'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // File Operations
                const Text(
                  'File & Data Operations',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        title: 'Upload Complete',
                        message: 'profile_pic.jpg (2.3 MB)',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'VIEW',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      child: const Text('File Uploaded'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        message: 'Downloading... 45%',
                        context: context,
                        duration: const Duration(seconds: 4),
                      ),
                      child: const Text('Downloading'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        message: 'Copied to clipboard',
                        context: context,
                        duration: const Duration(seconds: 2),
                      ),
                      child: const Text('Copied'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        message: 'Saved to drafts',
                        context: context,
                      ),
                      child: const Text('Draft Saved'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Authentication
                const Text(
                  'Authentication & Security',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showWarning(
                        title: 'Session Expired',
                        message: 'Please login again to continue',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'LOGIN',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Session Expired'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        message: '2FA code sent to your email',
                        context: context,
                      ),
                      child: const Text('2FA Sent'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showError(
                        title: 'Account Locked',
                        message: 'Too many failed attempts. Try again in 15 minutes.',
                        context: context,
                        duration: const Duration(seconds: 5),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Account Locked'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // E-commerce & Transactions
                const Text(
                  'E-commerce & Transactions',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        message: 'Item added to cart',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'VIEW CART',
                            onPressed: () {},
                          ),
                          ToastAction(
                            label: 'CHECKOUT',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Add to Cart'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showSuccess(
                        title: 'Payment Successful',
                        message: 'Order #12345 confirmed',
                        context: context,
                        duration: const Duration(seconds: 5),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                      child: const Text('Payment Success'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showError(
                        message: 'Out of stock',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'NOTIFY ME',
                            onPressed: () => VooToast.showSuccess(
                              message: "We'll notify you when available",
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Out of Stock'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Social & Notifications
                const Text(
                  'Social & Notifications',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        title: 'New Message',
                        message: 'John Doe: Hey, are you available?',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'REPLY',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      child: const Text('New Message'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showInfo(
                        message: '@johndoe mentioned you in a comment',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'VIEW',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      child: const Text('Mention'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Your post got 100 likes!'),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.pink.shade50,
                      ),
                      child: const Text('Likes'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Permissions
                const Text(
                  'Permissions & Access',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showError(
                        title: 'Camera Permission',
                        message: 'Required to scan QR codes',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'SETTINGS',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Camera Denied'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showWarning(
                        message: 'Location services disabled',
                        context: context,
                        actions: [
                          ToastAction(
                            label: 'ENABLE',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Location Off'),
                    ),
                  ],
                ),
                SizedBox(height: spacing),

                // Achievements & Gamification
                const Text(
                  'Achievements & Rewards',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events, color: Colors.white),
                              SizedBox(width: 12),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Achievement Unlocked!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'First Purchase Badge',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        duration: const Duration(seconds: 4),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      child: const Text('Achievement'),
                    ),
                    ElevatedButton(
                      onPressed: () => VooToast.showCustom(
                        context: context,
                        content: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars, color: Colors.yellow),
                              SizedBox(width: 8),
                              Text(
                                "Level Up! You're now Level 5",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      child: const Text('Level Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
