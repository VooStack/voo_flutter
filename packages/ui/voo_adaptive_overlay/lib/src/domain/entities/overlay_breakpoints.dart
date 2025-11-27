import 'package:equatable/equatable.dart';

/// Configuration for responsive breakpoints that determine
/// which overlay type to show based on screen width.
class VooOverlayBreakpoints extends Equatable {
  /// Maximum width to show bottom sheet (below this = bottom sheet).
  /// Default: 600px (Material compact breakpoint)
  final double bottomSheetMaxWidth;

  /// Maximum width to show modal dialog (below this = modal, above this = side sheet).
  /// Default: 1024px (Material expanded breakpoint)
  final double modalMaxWidth;

  /// Whether to prefer side sheet on desktop when orientation is landscape.
  /// Default: true
  final bool preferSideSheetOnDesktop;

  /// Whether to use fullscreen for very small screens.
  /// Default: true
  final bool useFullscreenForCompact;

  /// Width threshold below which fullscreen is used (if enabled).
  /// Default: 360px
  final double fullscreenThreshold;

  const VooOverlayBreakpoints({
    this.bottomSheetMaxWidth = 600,
    this.modalMaxWidth = 1024,
    this.preferSideSheetOnDesktop = true,
    this.useFullscreenForCompact = false,
    this.fullscreenThreshold = 360,
  });

  /// Default breakpoints matching Material Design guidelines.
  static const VooOverlayBreakpoints material = VooOverlayBreakpoints();

  /// Breakpoints that always prefer modals over side sheets.
  static const VooOverlayBreakpoints modalPreferred = VooOverlayBreakpoints(
    preferSideSheetOnDesktop: false,
  );

  /// Breakpoints that always prefer bottom sheets on mobile/tablet.
  static const VooOverlayBreakpoints bottomSheetPreferred = VooOverlayBreakpoints(
    bottomSheetMaxWidth: 1024,
  );

  VooOverlayBreakpoints copyWith({
    double? bottomSheetMaxWidth,
    double? modalMaxWidth,
    bool? preferSideSheetOnDesktop,
    bool? useFullscreenForCompact,
    double? fullscreenThreshold,
  }) {
    return VooOverlayBreakpoints(
      bottomSheetMaxWidth: bottomSheetMaxWidth ?? this.bottomSheetMaxWidth,
      modalMaxWidth: modalMaxWidth ?? this.modalMaxWidth,
      preferSideSheetOnDesktop: preferSideSheetOnDesktop ?? this.preferSideSheetOnDesktop,
      useFullscreenForCompact: useFullscreenForCompact ?? this.useFullscreenForCompact,
      fullscreenThreshold: fullscreenThreshold ?? this.fullscreenThreshold,
    );
  }

  @override
  List<Object?> get props => [
        bottomSheetMaxWidth,
        modalMaxWidth,
        preferSideSheetOnDesktop,
        useFullscreenForCompact,
        fullscreenThreshold,
      ];
}
