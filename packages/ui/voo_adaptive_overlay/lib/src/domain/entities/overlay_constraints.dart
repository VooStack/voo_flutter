import 'package:equatable/equatable.dart';

/// Size constraints for overlays.
///
/// Values less than or equal to 1 are treated as percentages of the screen size.
/// Values greater than 1 are treated as absolute pixel values.
class VooOverlayConstraints extends Equatable {
  /// Maximum width of the overlay.
  /// - If <= 1: treated as percentage (0.8 = 80% of screen width)
  /// - If > 1: treated as pixels
  /// Default: 560px for modals, 400px for side sheets
  final double? maxWidth;

  /// Maximum height of the overlay.
  /// - If <= 1: treated as percentage (0.9 = 90% of screen height)
  /// - If > 1: treated as pixels
  /// Default: 0.9 (90% of screen height)
  final double? maxHeight;

  /// Minimum width of the overlay (in pixels).
  /// Default: 280px
  final double minWidth;

  /// Minimum height of the overlay (in pixels).
  /// Default: 200px
  final double minHeight;

  /// Initial height for bottom sheets as a fraction of screen height.
  /// Default: 0.5 (50% of screen height)
  final double initialHeightFraction;

  /// Maximum snap point for draggable bottom sheets.
  /// Default: 0.95 (95% of screen height)
  final double maxSnapPoint;

  /// Minimum snap point for draggable bottom sheets.
  /// Default: 0.25 (25% of screen height)
  final double minSnapPoint;

  const VooOverlayConstraints({
    this.maxWidth,
    this.maxHeight,
    this.minWidth = 280,
    this.minHeight = 200,
    this.initialHeightFraction = 0.5,
    this.maxSnapPoint = 0.95,
    this.minSnapPoint = 0.25,
  });

  /// Default constraints for modal dialogs.
  static const VooOverlayConstraints modal = VooOverlayConstraints(
    maxWidth: 560,
    maxHeight: 0.9,
  );

  /// Default constraints for side sheets.
  static const VooOverlayConstraints sideSheet = VooOverlayConstraints(
    maxWidth: 400,
    maxHeight: 1.0,
  );

  /// Default constraints for bottom sheets.
  static const VooOverlayConstraints bottomSheet = VooOverlayConstraints(
    maxWidth: 1.0,
    maxHeight: 0.95,
  );

  /// Constraints for fullscreen overlays.
  static const VooOverlayConstraints fullscreen = VooOverlayConstraints(
    maxWidth: 1.0,
    maxHeight: 1.0,
  );

  VooOverlayConstraints copyWith({
    double? maxWidth,
    double? maxHeight,
    double? minWidth,
    double? minHeight,
    double? initialHeightFraction,
    double? maxSnapPoint,
    double? minSnapPoint,
  }) {
    return VooOverlayConstraints(
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      initialHeightFraction: initialHeightFraction ?? this.initialHeightFraction,
      maxSnapPoint: maxSnapPoint ?? this.maxSnapPoint,
      minSnapPoint: minSnapPoint ?? this.minSnapPoint,
    );
  }

  @override
  List<Object?> get props => [
        maxWidth,
        maxHeight,
        minWidth,
        minHeight,
        initialHeightFraction,
        maxSnapPoint,
        minSnapPoint,
      ];
}
