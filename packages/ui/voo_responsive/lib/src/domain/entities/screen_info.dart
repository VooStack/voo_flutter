import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_responsive/src/domain/entities/breakpoint.dart';
import 'package:voo_responsive/src/domain/enums/device_type.dart';
import 'package:voo_responsive/src/domain/enums/orientation_type.dart';
import 'package:voo_responsive/src/domain/enums/screen_size.dart';

class ScreenInfo extends Equatable {
  final double width;
  final double height;
  final double pixelRatio;
  final OrientationType orientation;
  final DeviceType deviceType;
  final ScreenSize screenSize;
  final Breakpoint? currentBreakpoint;
  final EdgeInsets safeAreaPadding;
  final TextScaler textScaler;
  final Brightness brightness;
  final bool isTabletLayout;
  final bool isMobileLayout;
  final bool isDesktopLayout;

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.pixelRatio,
    required this.orientation,
    required this.deviceType,
    required this.screenSize,
    this.currentBreakpoint,
    required this.safeAreaPadding,
    required this.textScaler,
    required this.brightness,
    required this.isTabletLayout,
    required this.isMobileLayout,
    required this.isDesktopLayout,
  });

  factory ScreenInfo.fromContext(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation == Orientation.portrait ? OrientationType.portrait : OrientationType.landscape;

    final deviceType = _getDeviceType(size.width);
    final screenSize = _getScreenSize(size.width);

    return ScreenInfo(
      width: size.width,
      height: size.height,
      pixelRatio: mediaQuery.devicePixelRatio,
      orientation: orientation,
      deviceType: deviceType,
      screenSize: screenSize,
      safeAreaPadding: mediaQuery.padding,
      textScaler: mediaQuery.textScaler,
      brightness: mediaQuery.platformBrightness,
      isTabletLayout: deviceType == DeviceType.tablet,
      isMobileLayout: deviceType == DeviceType.mobile,
      isDesktopLayout: deviceType == DeviceType.desktop || deviceType == DeviceType.widescreen,
    );
  }

  static DeviceType _getDeviceType(double width) {
    if (width < 600) return DeviceType.mobile;
    if (width < 1024) return DeviceType.tablet;
    if (width < 1440) return DeviceType.desktop;
    return DeviceType.widescreen;
  }

  static ScreenSize _getScreenSize(double width) {
    if (width < 360) return ScreenSize.extraSmall;
    if (width < 600) return ScreenSize.small;
    if (width < 1024) return ScreenSize.medium;
    if (width < 1440) return ScreenSize.large;
    return ScreenSize.extraLarge;
  }

  double get aspectRatio => width / height;
  bool get isPortrait => orientation == OrientationType.portrait;
  bool get isLandscape => orientation == OrientationType.landscape;

  @override
  List<Object?> get props => [
    width,
    height,
    pixelRatio,
    orientation,
    deviceType,
    screenSize,
    currentBreakpoint,
    safeAreaPadding,
    textScaler,
    brightness,
    isTabletLayout,
    isMobileLayout,
    isDesktopLayout,
  ];
}
