import 'package:equatable/equatable.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/swipe_direction.dart';

/// Behavior configuration for overlay interactions.
class VooOverlayBehavior extends Equatable {
  /// Whether tapping outside the overlay dismisses it.
  /// Default: true
  final bool isDismissible;

  /// Whether the overlay can be dismissed by dragging/swiping.
  /// Default: true for bottom sheets, false for modals
  final bool enableDrag;

  /// Direction for swipe-to-dismiss gesture.
  /// Default: down for bottom sheets, left for side sheets
  final VooSwipeDirection swipeDirection;

  /// Whether pressing escape key dismisses the overlay.
  /// Default: true
  final bool dismissOnEscape;

  /// Whether pressing back button dismisses the overlay (Android).
  /// Default: true
  final bool dismissOnBack;

  /// Whether to use spring physics for drag animations.
  /// Default: true
  final bool useSpringPhysics;

  /// Whether to show a close button in the header.
  /// Default: true
  final bool showCloseButton;

  /// Whether to show a drag handle (for bottom sheets).
  /// Default: true for bottom sheets
  final bool showDragHandle;

  /// Whether the overlay should avoid the keyboard.
  /// Default: true
  final bool avoidKeyboard;

  /// Whether to maintain state when the overlay is obscured.
  /// Default: true
  final bool maintainState;

  const VooOverlayBehavior({
    this.isDismissible = true,
    this.enableDrag = true,
    this.swipeDirection = VooSwipeDirection.down,
    this.dismissOnEscape = true,
    this.dismissOnBack = true,
    this.useSpringPhysics = true,
    this.showCloseButton = true,
    this.showDragHandle = true,
    this.avoidKeyboard = true,
    this.maintainState = true,
  });

  /// Default behavior for bottom sheets.
  static const VooOverlayBehavior bottomSheet = VooOverlayBehavior();

  /// Default behavior for modal dialogs.
  static const VooOverlayBehavior modal = VooOverlayBehavior(enableDrag: false, swipeDirection: VooSwipeDirection.none, showDragHandle: false);

  /// Default behavior for side sheets.
  static const VooOverlayBehavior sideSheet = VooOverlayBehavior(swipeDirection: VooSwipeDirection.left, showDragHandle: false);

  /// Non-dismissible behavior for important dialogs.
  static const VooOverlayBehavior nonDismissible = VooOverlayBehavior(
    isDismissible: false,
    enableDrag: false,
    dismissOnEscape: false,
    dismissOnBack: false,
    showCloseButton: false,
  );

  VooOverlayBehavior copyWith({
    bool? isDismissible,
    bool? enableDrag,
    VooSwipeDirection? swipeDirection,
    bool? dismissOnEscape,
    bool? dismissOnBack,
    bool? useSpringPhysics,
    bool? showCloseButton,
    bool? showDragHandle,
    bool? avoidKeyboard,
    bool? maintainState,
  }) => VooOverlayBehavior(
    isDismissible: isDismissible ?? this.isDismissible,
    enableDrag: enableDrag ?? this.enableDrag,
    swipeDirection: swipeDirection ?? this.swipeDirection,
    dismissOnEscape: dismissOnEscape ?? this.dismissOnEscape,
    dismissOnBack: dismissOnBack ?? this.dismissOnBack,
    useSpringPhysics: useSpringPhysics ?? this.useSpringPhysics,
    showCloseButton: showCloseButton ?? this.showCloseButton,
    showDragHandle: showDragHandle ?? this.showDragHandle,
    avoidKeyboard: avoidKeyboard ?? this.avoidKeyboard,
    maintainState: maintainState ?? this.maintainState,
  );

  @override
  List<Object?> get props => [
    isDismissible,
    enableDrag,
    swipeDirection,
    dismissOnEscape,
    dismissOnBack,
    useSpringPhysics,
    showCloseButton,
    showDragHandle,
    avoidKeyboard,
    maintainState,
  ];
}
