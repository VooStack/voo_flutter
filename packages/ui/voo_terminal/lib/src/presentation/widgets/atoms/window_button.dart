import 'package:flutter/material.dart';

/// A circular button used for window controls (close, minimize, maximize).
///
/// Displays a colored circular button with optional tap callback and tooltip.
class WindowButton extends StatelessWidget {
  /// The color of the button.
  final Color color;

  /// Callback when the button is tapped.
  final VoidCallback? onTap;

  /// Tooltip text shown on hover.
  final String tooltip;

  /// Size of the button.
  final double size;

  /// Creates a window button.
  const WindowButton({
    super.key,
    required this.color,
    this.onTap,
    required this.tooltip,
    this.size = 12.0,
  });

  /// Creates a close button (red).
  const WindowButton.close({
    super.key,
    this.onTap,
    this.size = 12.0,
  })  : color = const Color(0xFFFF5F56),
        tooltip = 'Close';

  /// Creates a minimize button (yellow).
  const WindowButton.minimize({
    super.key,
    this.onTap,
    this.size = 12.0,
  })  : color = const Color(0xFFFFBD2E),
        tooltip = 'Minimize';

  /// Creates a maximize button (green).
  const WindowButton.maximize({
    super.key,
    this.onTap,
    this.size = 12.0,
  })  : color = const Color(0xFF27C93F),
        tooltip = 'Maximize';

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: onTap != null ? color : color.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
