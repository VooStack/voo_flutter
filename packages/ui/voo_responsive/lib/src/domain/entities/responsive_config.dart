import 'package:equatable/equatable.dart';
import 'package:voo_responsive/src/domain/entities/breakpoint.dart';

class ResponsiveConfig extends Equatable {
  final List<Breakpoint> breakpoints;
  final bool enableAdaptiveLayout;
  final bool enableOrientationChanges;
  final bool enableDensityScaling;
  final double baseFontSize;
  final double baseSpacing;
  final Map<String, dynamic>? customSettings;

  const ResponsiveConfig({
    this.breakpoints = Breakpoint.defaults,
    this.enableAdaptiveLayout = true,
    this.enableOrientationChanges = true,
    this.enableDensityScaling = true,
    this.baseFontSize = 16.0,
    this.baseSpacing = 8.0,
    this.customSettings,
  });

  static const ResponsiveConfig defaultConfig = ResponsiveConfig();

  Breakpoint? getBreakpointForWidth(double width) {
    for (final breakpoint in breakpoints) {
      if (breakpoint.matches(width)) {
        return breakpoint;
      }
    }
    return null;
  }

  ResponsiveConfig copyWith({
    List<Breakpoint>? breakpoints,
    bool? enableAdaptiveLayout,
    bool? enableOrientationChanges,
    bool? enableDensityScaling,
    double? baseFontSize,
    double? baseSpacing,
    Map<String, dynamic>? customSettings,
  }) {
    return ResponsiveConfig(
      breakpoints: breakpoints ?? this.breakpoints,
      enableAdaptiveLayout: enableAdaptiveLayout ?? this.enableAdaptiveLayout,
      enableOrientationChanges: enableOrientationChanges ?? this.enableOrientationChanges,
      enableDensityScaling: enableDensityScaling ?? this.enableDensityScaling,
      baseFontSize: baseFontSize ?? this.baseFontSize,
      baseSpacing: baseSpacing ?? this.baseSpacing,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  @override
  List<Object?> get props => [breakpoints, enableAdaptiveLayout, enableOrientationChanges, enableDensityScaling, baseFontSize, baseSpacing, customSettings];
}
