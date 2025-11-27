import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_behavior.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_breakpoints.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_constraints.dart';
import 'package:voo_adaptive_overlay/src/domain/entities/overlay_style_data.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_style.dart';
import 'package:voo_adaptive_overlay/src/domain/enums/overlay_type.dart';

/// Main configuration for adaptive overlays.
///
/// This class combines all configuration options for controlling
/// how overlays appear and behave.
class VooOverlayConfig extends Equatable {
  /// The visual style preset to use.
  /// Default: [VooOverlayStyle.material]
  final VooOverlayStyle style;

  /// Custom style data (only used when style is [VooOverlayStyle.custom]).
  final VooOverlayStyleData? customStyle;

  /// Behavior configuration for interactions.
  final VooOverlayBehavior behavior;

  /// Size constraints for the overlay.
  final VooOverlayConstraints constraints;

  /// Responsive breakpoints for determining overlay type.
  final VooOverlayBreakpoints breakpoints;

  /// Force a specific overlay type regardless of screen size.
  /// If null, the type is determined automatically.
  final VooOverlayType? forceType;

  /// Duration for enter/exit animations.
  final Duration? animationDuration;

  /// Curve for enter animation.
  final Curve? enterCurve;

  /// Curve for exit animation.
  final Curve? exitCurve;

  /// Route settings for the overlay.
  final RouteSettings? routeSettings;

  /// Whether to use safe area padding.
  /// Default: true
  final bool useSafeArea;

  /// Custom clip behavior for the overlay.
  final Clip clipBehavior;

  /// Whether to use root navigator.
  /// Default: true
  final bool useRootNavigator;

  /// Anchor for side sheet positioning.
  /// Default: right side
  final bool anchorRight;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  const VooOverlayConfig({
    this.style = VooOverlayStyle.material,
    this.customStyle,
    this.behavior = const VooOverlayBehavior(),
    this.constraints = const VooOverlayConstraints(),
    this.breakpoints = const VooOverlayBreakpoints(),
    this.forceType,
    this.animationDuration,
    this.enterCurve,
    this.exitCurve,
    this.routeSettings,
    this.useSafeArea = true,
    this.clipBehavior = Clip.antiAlias,
    this.useRootNavigator = true,
    this.anchorRight = true,
    this.semanticLabel,
  });

  /// Default configuration with Material style.
  static const VooOverlayConfig material = VooOverlayConfig();

  /// Configuration with Cupertino/iOS style.
  static const VooOverlayConfig cupertino = VooOverlayConfig(
    style: VooOverlayStyle.cupertino,
  );

  /// Configuration with glassmorphism style.
  static const VooOverlayConfig glass = VooOverlayConfig(
    style: VooOverlayStyle.glass,
  );

  /// Configuration with minimal style.
  static const VooOverlayConfig minimal = VooOverlayConfig(
    style: VooOverlayStyle.minimal,
  );

  /// Configuration that always shows a bottom sheet.
  static const VooOverlayConfig bottomSheet = VooOverlayConfig(
    forceType: VooOverlayType.bottomSheet,
    behavior: VooOverlayBehavior.bottomSheet,
    constraints: VooOverlayConstraints.bottomSheet,
  );

  /// Configuration that always shows a modal dialog.
  static const VooOverlayConfig modal = VooOverlayConfig(
    forceType: VooOverlayType.modal,
    behavior: VooOverlayBehavior.modal,
    constraints: VooOverlayConstraints.modal,
  );

  /// Configuration that always shows a side sheet.
  static const VooOverlayConfig sideSheet = VooOverlayConfig(
    forceType: VooOverlayType.sideSheet,
    behavior: VooOverlayBehavior.sideSheet,
    constraints: VooOverlayConstraints.sideSheet,
  );

  VooOverlayConfig copyWith({
    VooOverlayStyle? style,
    VooOverlayStyleData? customStyle,
    VooOverlayBehavior? behavior,
    VooOverlayConstraints? constraints,
    VooOverlayBreakpoints? breakpoints,
    VooOverlayType? forceType,
    Duration? animationDuration,
    Curve? enterCurve,
    Curve? exitCurve,
    RouteSettings? routeSettings,
    bool? useSafeArea,
    Clip? clipBehavior,
    bool? useRootNavigator,
    bool? anchorRight,
    String? semanticLabel,
  }) {
    return VooOverlayConfig(
      style: style ?? this.style,
      customStyle: customStyle ?? this.customStyle,
      behavior: behavior ?? this.behavior,
      constraints: constraints ?? this.constraints,
      breakpoints: breakpoints ?? this.breakpoints,
      forceType: forceType ?? this.forceType,
      animationDuration: animationDuration ?? this.animationDuration,
      enterCurve: enterCurve ?? this.enterCurve,
      exitCurve: exitCurve ?? this.exitCurve,
      routeSettings: routeSettings ?? this.routeSettings,
      useSafeArea: useSafeArea ?? this.useSafeArea,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      useRootNavigator: useRootNavigator ?? this.useRootNavigator,
      anchorRight: anchorRight ?? this.anchorRight,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }

  @override
  List<Object?> get props => [
        style,
        customStyle,
        behavior,
        constraints,
        breakpoints,
        forceType,
        animationDuration,
        enterCurve,
        exitCurve,
        routeSettings,
        useSafeArea,
        clipBehavior,
        useRootNavigator,
        anchorRight,
        semanticLabel,
      ];
}
