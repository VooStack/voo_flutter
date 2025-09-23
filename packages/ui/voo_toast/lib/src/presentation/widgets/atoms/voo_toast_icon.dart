import 'package:flutter/material.dart';
import 'package:voo_toast/src/domain/enums/toast_type.dart';

class VooToastIcon extends StatelessWidget {
  const VooToastIcon({super.key, required this.type, this.icon, this.size = 24.0, this.color});

  final ToastType type;
  final Widget? icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (icon != null) return icon!;

    final theme = Theme.of(context);
    final defaultColor = _getDefaultColor(theme);

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
        return const SizedBox.shrink();
    }

    return Icon(iconData, size: size, color: color ?? defaultColor);
  }

  Color _getDefaultColor(ThemeData theme) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return theme.colorScheme.error;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return theme.colorScheme.primary;
      case ToastType.custom:
        return theme.colorScheme.onSurface;
    }
  }
}
