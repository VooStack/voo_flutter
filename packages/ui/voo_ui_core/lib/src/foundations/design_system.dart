import 'package:flutter/material.dart';

/// Design system data that can be customized
class VooDesignSystemData {
  final double spacingUnit;
  final double radiusUnit;
  final double borderWidth;
  final Duration animationDuration;
  final Duration animationDurationSlow;
  final Duration animationDurationFast;
  final Curve animationCurve;

  // Spacing values computed from spacingUnit
  double get spacingXs => spacingUnit * 0.5; // 4
  double get spacingSm => spacingUnit * 1; // 8
  double get spacingMd => spacingUnit * 1.5; // 12
  double get spacingLg => spacingUnit * 2; // 16
  double get spacingXl => spacingUnit * 3; // 24
  double get spacingXxl => spacingUnit * 4; // 32
  double get spacingXxxl => spacingUnit * 6; // 48

  // Radius values computed from radiusUnit
  double get radiusXs => radiusUnit * 0.5; // 2
  double get radiusSm => radiusUnit * 1; // 4
  double get radiusMd => radiusUnit * 2; // 8
  double get radiusLg => radiusUnit * 3; // 12
  double get radiusXl => radiusUnit * 4; // 16
  double get radiusXxl => radiusUnit * 6; // 24
  double get radiusFull => 999.0;

  // Component heights (customizable)
  final double inputHeight;
  final double buttonHeight;
  final double appBarHeight;
  final double filterBarHeight;
  final double listTileHeight;
  final double headerHeight;

  // Icon sizes
  double get iconSizeSm => 16.0;
  double get iconSizeMd => 20.0;
  double get iconSizeLg => 24.0;
  double get iconSizeXl => 32.0;
  double get iconSizeXxl => 48.0;

  const VooDesignSystemData({
    this.spacingUnit = 8.0,
    this.radiusUnit = 4.0,
    this.borderWidth = 1.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationDurationSlow = const Duration(milliseconds: 300),
    this.animationDurationFast = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.inputHeight = 48.0,
    this.buttonHeight = 44.0,
    this.appBarHeight = 56.0,
    this.filterBarHeight = 56.0,
    this.listTileHeight = 72.0,
    this.headerHeight = 80.0,
  });

  /// Custom constructor for more control over component heights
  const VooDesignSystemData.custom({
    this.spacingUnit = 8.0,
    this.radiusUnit = 4.0,
    this.borderWidth = 1.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationDurationSlow = const Duration(milliseconds: 300),
    this.animationDurationFast = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.inputHeight = 48.0,
    this.buttonHeight = 44.0,
    this.appBarHeight = 56.0,
    this.filterBarHeight = 56.0,
    this.listTileHeight = 72.0,
    this.headerHeight = 80.0,
  });

  /// Creates a copy with optional overrides
  VooDesignSystemData copyWith({
    double? spacingUnit,
    double? radiusUnit,
    double? borderWidth,
    Duration? animationDuration,
    Duration? animationDurationSlow,
    Duration? animationDurationFast,
    Curve? animationCurve,
    double? inputHeight,
    double? buttonHeight,
    double? appBarHeight,
    double? filterBarHeight,
    double? listTileHeight,
    double? headerHeight,
  }) =>
      VooDesignSystemData(
        spacingUnit: spacingUnit ?? this.spacingUnit,
        radiusUnit: radiusUnit ?? this.radiusUnit,
        borderWidth: borderWidth ?? this.borderWidth,
        animationDuration: animationDuration ?? this.animationDuration,
        animationDurationSlow: animationDurationSlow ?? this.animationDurationSlow,
        animationDurationFast: animationDurationFast ?? this.animationDurationFast,
        animationCurve: animationCurve ?? this.animationCurve,
        inputHeight: inputHeight ?? this.inputHeight,
        buttonHeight: buttonHeight ?? this.buttonHeight,
        appBarHeight: appBarHeight ?? this.appBarHeight,
        filterBarHeight: filterBarHeight ?? this.filterBarHeight,
        listTileHeight: listTileHeight ?? this.listTileHeight,
        headerHeight: headerHeight ?? this.headerHeight,
      );

  /// Default design system
  static const VooDesignSystemData defaultSystem = VooDesignSystemData();

  /// Compact design system with smaller spacing
  static const VooDesignSystemData compact = VooDesignSystemData(
    spacingUnit: 6.0,
    radiusUnit: 3.0,
  );

  /// Comfortable design system with larger spacing
  static const VooDesignSystemData comfortable = VooDesignSystemData(
    spacingUnit: 10.0,
    radiusUnit: 5.0,
  );
}

/// InheritedWidget that provides design system throughout the widget tree
class VooDesignSystem extends InheritedWidget {
  final VooDesignSystemData data;

  const VooDesignSystem({
    super.key,
    required this.data,
    required super.child,
  });

  /// Access the design system from context
  static VooDesignSystemData of(BuildContext context) {
    final system = context.dependOnInheritedWidgetOfExactType<VooDesignSystem>();
    return system?.data ?? VooDesignSystemData.defaultSystem;
  }

  /// Access the design system without listening to changes
  static VooDesignSystemData read(BuildContext context) {
    final system = context.getInheritedWidgetOfExactType<VooDesignSystem>();
    return system?.data ?? VooDesignSystemData.defaultSystem;
  }

  @override
  bool updateShouldNotify(VooDesignSystem oldWidget) => data != oldWidget.data;
}

/// Extension on BuildContext for easy access
extension VooDesignSystemExtension on BuildContext {
  VooDesignSystemData get vooDesign => VooDesignSystem.of(this);
  VooDesignSystemData get vooDesignRead => VooDesignSystem.read(this);
}
