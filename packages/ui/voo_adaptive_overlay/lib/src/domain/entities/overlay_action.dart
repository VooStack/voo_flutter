import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Defines an action button for overlay dialogs.
///
/// Used to create standard action buttons like Confirm, Cancel, etc.
class VooOverlayAction extends Equatable {
  /// The label text for the action button.
  final String label;

  /// Callback when the action is pressed.
  final VoidCallback? onPressed;

  /// Whether this is the primary/highlighted action.
  final bool isPrimary;

  /// Whether this action is destructive (e.g., Delete).
  final bool isDestructive;

  /// Icon to show before the label.
  final IconData? icon;

  /// Whether to automatically pop the overlay after action.
  /// Default: true
  final bool autoPop;

  /// Custom style for the button.
  final ButtonStyle? style;

  const VooOverlayAction({required this.label, this.onPressed, this.isPrimary = false, this.isDestructive = false, this.icon, this.autoPop = true, this.style});

  /// Creates a cancel action that pops the overlay.
  factory VooOverlayAction.cancel({String label = 'Cancel', VoidCallback? onPressed}) => VooOverlayAction(label: label, onPressed: onPressed);

  /// Creates a confirm/OK action.
  factory VooOverlayAction.confirm({String label = 'Confirm', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, isPrimary: true, autoPop: autoPop);

  /// Creates an OK action.
  factory VooOverlayAction.ok({String label = 'OK', VoidCallback? onPressed}) => VooOverlayAction(label: label, onPressed: onPressed, isPrimary: true);

  /// Creates a destructive action (e.g., Delete).
  factory VooOverlayAction.destructive({required String label, VoidCallback? onPressed, IconData? icon}) =>
      VooOverlayAction(label: label, onPressed: onPressed, isDestructive: true, icon: icon);

  /// Creates a save action.
  factory VooOverlayAction.save({String label = 'Save', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, isPrimary: true, icon: Icons.save_outlined, autoPop: autoPop);

  /// Creates a close action.
  factory VooOverlayAction.close({String label = 'Close', VoidCallback? onPressed}) => VooOverlayAction(label: label, onPressed: onPressed);

  /// Creates a done action.
  factory VooOverlayAction.done({String label = 'Done', VoidCallback? onPressed}) =>
      VooOverlayAction(label: label, onPressed: onPressed, isPrimary: true, icon: Icons.check);

  /// Creates an edit action.
  factory VooOverlayAction.edit({String label = 'Edit', VoidCallback? onPressed, bool autoPop = false}) =>
      VooOverlayAction(label: label, onPressed: onPressed, icon: Icons.edit_outlined, autoPop: autoPop);

  /// Creates a share action.
  factory VooOverlayAction.share({String label = 'Share', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, icon: Icons.share_outlined, autoPop: autoPop);

  /// Creates a copy action.
  factory VooOverlayAction.copy({String label = 'Copy', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, icon: Icons.copy_outlined, autoPop: autoPop);

  /// Creates a retry action.
  factory VooOverlayAction.retry({String label = 'Retry', VoidCallback? onPressed, bool autoPop = false}) =>
      VooOverlayAction(label: label, onPressed: onPressed, isPrimary: true, icon: Icons.refresh, autoPop: autoPop);

  /// Creates a settings action.
  factory VooOverlayAction.settings({String label = 'Settings', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, icon: Icons.settings_outlined, autoPop: autoPop);

  /// Creates a learn more action.
  factory VooOverlayAction.learnMore({String label = 'Learn More', VoidCallback? onPressed, bool autoPop = true}) =>
      VooOverlayAction(label: label, onPressed: onPressed, icon: Icons.info_outline, autoPop: autoPop);

  /// Creates a custom action with icon.
  factory VooOverlayAction.withIcon({
    required String label,
    required IconData icon,
    VoidCallback? onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
    bool autoPop = true,
  }) => VooOverlayAction(label: label, onPressed: onPressed, isPrimary: isPrimary, isDestructive: isDestructive, icon: icon, autoPop: autoPop);

  VooOverlayAction copyWith({
    String? label,
    VoidCallback? onPressed,
    bool? isPrimary,
    bool? isDestructive,
    IconData? icon,
    bool? autoPop,
    ButtonStyle? style,
  }) => VooOverlayAction(
    label: label ?? this.label,
    onPressed: onPressed ?? this.onPressed,
    isPrimary: isPrimary ?? this.isPrimary,
    isDestructive: isDestructive ?? this.isDestructive,
    icon: icon ?? this.icon,
    autoPop: autoPop ?? this.autoPop,
    style: style ?? this.style,
  );

  @override
  List<Object?> get props => [label, isPrimary, isDestructive, icon, autoPop, style];
}
