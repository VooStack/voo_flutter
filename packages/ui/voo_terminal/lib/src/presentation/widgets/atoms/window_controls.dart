import 'package:flutter/material.dart';

import 'package:voo_terminal/src/presentation/widgets/atoms/window_button.dart';

/// A row of window control buttons (close, minimize, maximize).
///
/// Displays macOS-style traffic light buttons for window management.
class WindowControls extends StatelessWidget {
  /// Callback when the close button is pressed.
  final VoidCallback? onClose;

  /// Callback when the minimize button is pressed.
  final VoidCallback? onMinimize;

  /// Callback when the maximize button is pressed.
  final VoidCallback? onMaximize;

  /// Spacing between buttons.
  final double spacing;

  /// Size of the buttons.
  final double buttonSize;

  /// Creates window controls.
  const WindowControls({
    super.key,
    this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.spacing = 8.0,
    this.buttonSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WindowButton.close(
          onTap: onClose,
          size: buttonSize,
        ),
        SizedBox(width: spacing),
        WindowButton.minimize(
          onTap: onMinimize,
          size: buttonSize,
        ),
        SizedBox(width: spacing),
        WindowButton.maximize(
          onTap: onMaximize,
          size: buttonSize,
        ),
      ],
    );
  }
}
