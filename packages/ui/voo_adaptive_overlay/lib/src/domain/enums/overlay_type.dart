/// Defines the type of overlay presentation.
enum VooOverlayType {
  /// Bottom sheet that slides up from the bottom of the screen.
  /// Best for mobile devices in portrait orientation.
  bottomSheet,

  /// Centered modal dialog.
  /// Best for tablets and smaller desktop screens.
  modal,

  /// Side sheet that slides in from the right.
  /// Best for larger desktop screens.
  sideSheet,

  /// Fullscreen overlay that covers the entire screen.
  /// Used when content requires full attention or on very small screens.
  fullscreen,
}
