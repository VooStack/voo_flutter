/// Defines the type of overlay presentation.
enum VooOverlayType {
  /// Bottom sheet that slides up from the bottom of the screen.
  /// Best for mobile devices in portrait orientation.
  bottomSheet,

  /// Centered modal dialog.
  /// Best for tablets and smaller desktop screens.
  modal,

  /// Side sheet that slides in from the side.
  /// Best for larger desktop screens.
  sideSheet,

  /// Fullscreen overlay that covers the entire screen.
  /// Used when content requires full attention or on very small screens.
  fullscreen,

  /// Drawer overlay that slides in from left or right.
  /// Great for navigation or settings panels.
  drawer,

  /// iOS-style action sheet with a list of actions.
  /// Best for presenting multiple action options.
  actionSheet,

  /// Small popup overlay positioned near an anchor.
  /// Best for contextual menus or tooltips.
  popup,

  /// Floating snackbar at the bottom.
  /// For brief messages with optional action.
  snackbar,

  /// Full-width banner at top or bottom of the screen.
  /// Great for important notices or promotions.
  banner,

  /// Informational tooltip positioned near an anchor element.
  /// Used for hints and explanatory text.
  tooltip,

  /// System-style alert dialog for critical messages.
  /// Requires explicit user acknowledgment.
  alert,
}

/// Extension methods for [VooOverlayType].
extension VooOverlayTypeX on VooOverlayType {
  /// Whether this overlay type slides in from a side.
  bool get isSlideIn => this == VooOverlayType.bottomSheet ||
      this == VooOverlayType.sideSheet ||
      this == VooOverlayType.drawer ||
      this == VooOverlayType.actionSheet ||
      this == VooOverlayType.banner;

  /// Whether this overlay type is centered on screen.
  bool get isCentered => this == VooOverlayType.modal ||
      this == VooOverlayType.popup ||
      this == VooOverlayType.alert;

  /// Whether this overlay type covers the full screen.
  bool get isFullCoverage => this == VooOverlayType.fullscreen;

  /// Whether this overlay type is a notification style.
  bool get isNotification => this == VooOverlayType.snackbar ||
      this == VooOverlayType.banner;

  /// Whether this overlay type should auto-dismiss.
  bool get shouldAutoDismiss => this == VooOverlayType.snackbar;

  /// Whether this overlay type is positioned relative to an anchor.
  bool get isAnchored => this == VooOverlayType.popup ||
      this == VooOverlayType.tooltip;

  /// Whether this overlay type requires user acknowledgment.
  bool get requiresAcknowledgment => this == VooOverlayType.alert;
}
